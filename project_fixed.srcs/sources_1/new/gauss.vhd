--------------------------------------------------------------------------------
-- Inverse
-- While building the upper triangular matrix, we have to check for 0's on the
-- diagonal. We can stall the calculation, but only the amount of stages of the
-- pipeline (with floating point arith it's around 50 rows, with fixed point 70).
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rx.all;

entity gauss_module is
  port(
    clk   : in  std_logic;
    rst   : in  std_logic;
    start : in  std_logic;
    ready : out std_logic;


    -- Memories
    cov_addra : out std_logic_vector;
    cov_dina  : out std_logic_vector;
    cov_wea   : out std_logic_vector;

    cov_addrb : out std_logic_vector;
    cov_doutb : in  std_logic_vector;

    inv_addra : out std_logic_vector;
    inv_dina  : out std_logic_vector;
    inv_wea   : out std_logic_vector;

    inv_addrb : out std_logic_vector;
    inv_doutb : in  std_logic_vector
  );
end gauss_module;
architecture behavioral of gauss_module is

  constant div_lat : natural := gauss_div_latency;
  constant mul_lat : natural := gauss_mul_latency;
  constant sub_lat : natural := gauss_sub_latency;

  signal tempj_din, tempj_dout    : std_logic_vector(ram_precision*n_bands-1 downto 0);
  signal tempj_wr_en, tempj_rd_en : std_logic;

  signal dividend             : std_logic_vector(dividend_precision-1 DOWNTO 0);
  signal divisor              : std_logic_vector(divisor_precision-1 DOWNTO 0);
  signal dividend_internal, divisor_internal : std_logic_vector(47 downto 0);
  signal quotient             : std_logic_vector(quotient_precision-1 DOWNTO 0);
  signal div_valid, div_ready : std_logic;

  signal mul_cov_a, mul_inv_a : gauss_mul_a_array;
  signal mul_cov_b, mul_inv_b : gauss_mul_b_array;
  signal mul_cov_p, mul_inv_p : gauss_mul_p_array;
  signal sub_cov_a, sub_inv_a : gauss_sub_a_array;
  signal sub_cov_b, sub_inv_b : gauss_sub_b_array;
  signal sub_cov_s, sub_inv_s : gauss_sub_s_array;

  type op_array is array (0 to n_bands-1) of std_logic;

  type mul_internal_array is array (0 to n_bands-1) of std_logic_vector(100 downto 0);
  signal mul_cov_p_internal, mul_inv_p_internal : mul_internal_array;
  signal quotient_internal                      : std_logic_vector(79 downto 0);
  signal quotient_sign_removed                  : std_logic_vector(78 downto 0);


  type state_t is (IDLE, PRE_INIT, INITIALIZE, PRE_FORW, FORWARDS, PRE_BACK, BACKWARDS, PRE_DIAG, DIAGONAL);
  signal state : state_t;

  signal counter_i                              : natural range n_bands-1 downto 0;
  signal i_ready, i_ready_delay, i_ready_delay2 : std_logic;
  signal row_i_cov, row_i_inv                   : ram_array; --memory for current i

  signal counter_read_cov, counter_read_inv : natural range n_bands-1 downto 0;
  signal counter_write                      : natural range n_bands-1 downto 0;
  signal write_control                      : std_logic;

  type control_array_t is array (0 to 127) of std_logic;
  signal valid : control_array_t;
  signal invert_div_result : control_array_t;

  type address_table is array (0 to n_bands-1) of natural range n_bands-1 downto 0;
  signal rename                                         : address_table;
  signal stall, stall_delay, stall_delay2, stall_delay3 : std_logic;

  signal trash : std_logic_vector(5 downto 0);

begin

  operator_proc : process (state, sub_cov_s, counter_i, cov_doutb, row_i_cov, row_i_inv, quotient, div_ready, tempj_dout, mul_cov_p, inv_doutb, mul_inv_p)
  begin
    if (state = DIAGONAL) then
      dividend <= one_div;
    elsif(state = IDLE) then
      dividend <= (others => '0');
    else
      dividend <= ram_to_array(cov_doutb)(counter_i);
    end if;

    tempj_din <= cov_doutb;

    divisor <= row_i_cov(counter_i);

    mul_cov_a <= ram_to_gauss_mul(row_i_cov);
    mul_cov_b <= (others => quotient);
    mul_inv_a <= ram_to_gauss_mul(row_i_inv);
    mul_inv_b <= (others => quotient);

    sub_cov_a <= ram_to_gauss_sub(tempj_dout);
    sub_cov_b <= gauss_mul_to_gauss_sub(mul_cov_p);
    sub_inv_a <= ram_to_gauss_sub(inv_doutb);
    sub_inv_b <= gauss_mul_to_gauss_sub(mul_inv_p);
  end process operator_proc;

  capture_i_proc : process (clk, rst)
  begin
    if (rst = '1') then
      row_i_cov <= (others => (others => '0'));
    elsif rising_edge(clk) then
      i_ready_delay  <= i_ready;
      i_ready_delay2 <= i_ready_delay;
      stall_delay    <= stall;
      stall_delay2   <= stall_delay;
      stall_delay3   <= stall_delay2;

      if (i_ready_delay2 = '1' or stall_delay2 = '1') then
        row_i_inv <= ram_to_array(inv_doutb);
      end if;
      if (i_ready_delay2 = '1' or stall_delay3 = '1') then
        row_i_cov <= ram_to_array(cov_doutb);
      end if;
    end if;
  end process capture_i_proc;

  write_proc : process (clk, rst)
  begin
    if (rst = '1') then
      cov_wea <= "0";
      inv_wea <= "0";
    elsif rising_edge(clk) then
      if (write_control = '0') then
        cov_wea <= "0";
        inv_wea <= "0";
      else
        if (state = DIAGONAL) then
          cov_wea  <= "0";
          inv_wea  <= "1";
          inv_dina <= gauss_mul_to_ram(mul_inv_p);
        elsif (state = INITIALIZE or state = PRE_FORW) then
          cov_wea  <= "0";
          inv_wea  <= "1";
          inv_dina <= (others => '0');
          -- this line is to place the 1 in the correct position, no bit shifting
          inv_dina(ram_precision*(n_bands-counter_write)-1 downto ram_precision*(n_bands-1-counter_write)) <= one_load;
        else
          cov_wea  <= "1";
          inv_wea  <= "1";
          cov_dina <= gauss_sub_to_ram(sub_cov_s);
          inv_dina <= gauss_sub_to_ram(sub_inv_s);

        end if;
      end if;
    end if;
  end process write_proc;

  addr_proc : process (clk, rst, state)
  begin
    if (rst = '1') then
    elsif rising_edge(clk) then
      --rename writes
      cov_addra <= std_logic_vector(to_unsigned(rename(counter_write), cov_addra'length));
      inv_addra <= std_logic_vector(to_unsigned(rename(counter_write), inv_addra'length));

      --rename reads
      cov_addrb <= std_logic_vector(to_unsigned(rename(counter_read_cov), cov_addrb'length));
      if (stall = '0') then
        --this is so it can simulate, since ranges are not contained in simulation
        if (counter_read_inv >= 0 and counter_read_inv <= n_bands-1) then
          inv_addrb <= std_logic_vector(to_unsigned(rename(counter_read_inv), inv_addrb'length));
        else
          inv_addrb <= (others => 'U');
        end if;

      elsif (stall = '1') then --we read the substituting line
        inv_addrb <= std_logic_vector(to_unsigned(rename(counter_write), inv_addrb'length));
      end if;

      case (state) is
        --init renaming table
        when PRE_INIT =>
          stall <= '0';
          init_rename : for i in 0 to n_bands-1 loop
            rename(i) <= i;
          end loop init_rename;

        --rename registers
        when FORWARDS =>
          --not writing anything
          if (stall = '0' and write_control = '0') then
            null; --no need to do anything

          --writing, so have to check
          elsif (stall = '0' and write_control = '1') then
            if (counter_write = counter_i+1) then       --only on next line
              if (sub_cov_s(counter_write) = zero) then --check value
                stall <= '1';
              end if;
            end if;

          --if stalled and writing new lines
          elsif (stall = '1' and write_control = '1') then
            --check if we can swap
            if (sub_cov_s(counter_i) /= zero) then
              rename(counter_i)     <= counter_write;
              rename(counter_write) <= counter_i;
              stall                 <= '0';
            end if;

          --if stalled but no new lines
          elsif (stall = '1' and write_control = '0') then
            null; --have to mark this inversion as erroneous

          else
            null;
          end if;

        --reorder write addresses after everything has been read and is in the pipeline
        when BACKWARDS =>
          if (counter_read_inv >= 0 and counter_read_inv <= n_bands-1) then
            rename(counter_read_inv) <= counter_read_inv;
          end if;

        when others =>
          null;
      end case;
    end if;
  end process addr_proc;

  counter_proc : process (clk, rst)
    variable v : std_logic;
  begin
    if (rst = '1') then
      state         <= IDLE;
      valid         <= (others => '0');
      write_control <= '0';
    elsif rising_edge(clk) then
      v := '0'; --only when cov changes
      case (state) is
        when IDLE =>
          if (start = '1') then
            ready <= '0';
            state <= PRE_INIT;
          else
            write_control <= '0';
            ready         <= '1';
          end if;

        when PRE_INIT =>
          counter_i        <= 0;
          counter_write    <= 0;
          counter_read_cov <= 0;
          counter_read_inv <= 0;

          i_ready       <= '0';
          div_valid     <= '0';
          tempj_wr_en   <= '0';
          tempj_rd_en   <= '0';
          write_control <= '1';

          state <= INITIALIZE;

        when INITIALIZE =>
          if (counter_i /= n_bands-1) then
            counter_i     <= counter_i +1;
            counter_write <= counter_write +1;
          else
            state <= PRE_FORW;
          end if;

        when PRE_FORW =>
          counter_i        <= 0;
          counter_write    <= 0;
          counter_read_cov <= 0;
          counter_read_inv <= 0;

          i_ready       <= '1';
          div_valid     <= '0';
          tempj_wr_en   <= '0';
          tempj_rd_en   <= '0';
          write_control <= '0';

          state <= FORWARDS;

        when FORWARDS =>
          -- i row has been read from last state
          i_ready <= '0';

          -- count inputs and mark them as valid
          if (counter_read_cov /= n_bands-1) then
            --if not stalled, we can process data
            if (stall = '0') then
              counter_read_cov <= counter_read_cov +1;
              v                := '1';
            end if;

          --if its the last iteration
          elsif (counter_i = n_bands-1) then
            state <= PRE_BACK;

          --if a new i was written, jump to next iteration
          elsif (counter_write /= counter_i and valid(div_lat+mul_lat) = '0') then
            i_ready          <= '1';
            counter_read_cov <= counter_i +1;
            counter_i        <= counter_i +1;
          end if;

          --write cov reads on the fifo and start the division
          tempj_wr_en <= valid(1);
          div_valid   <= valid(1);

          -- start reading the rows for sub
          if (valid(div_lat+mul_lat) = '1') then
            counter_read_inv <= counter_read_inv +1;
            tempj_rd_en      <= '1';
          else
            counter_read_inv <= counter_i +1;
            tempj_rd_en      <= '0';
          end if;
          -- start reading the covariance from the fifo

          --start counting to write
          if (valid(div_lat+mul_lat+sub_lat+1) = '1') then
            counter_write <= counter_write +1;
            write_control <= '1';
          else
            counter_write <= counter_i;
            write_control <= '0';
          end if;

        when PRE_BACK =>
          counter_i        <= n_bands-1;
          counter_write    <= n_bands-1;
          counter_read_cov <= n_bands-1;
          counter_read_inv <= n_bands-1;

          i_ready       <= '1';
          div_valid     <= '0';
          tempj_wr_en   <= '0';
          tempj_rd_en   <= '0';
          write_control <= '0';

          state <= BACKWARDS;

        when BACKWARDS =>
          i_ready <= '0';

          if (counter_read_cov /= 0) then
            counter_read_cov <= counter_read_cov -1;
            v                := '1';

          elsif (counter_i = 0) then
            state <= PRE_DIAG;

          elsif (counter_write /= counter_i and valid(div_lat+mul_lat) = '0') then
            i_ready          <= '1';
            counter_i        <= counter_i -1;
            counter_read_cov <= counter_i -1;
          end if;

          tempj_wr_en <= valid(1);
          div_valid   <= valid(1);

          if (valid(div_lat+mul_lat) = '1') then
            counter_read_inv <= counter_read_inv -1;
            tempj_rd_en      <= '1';
          else
            counter_read_inv <= counter_i -1;
            tempj_rd_en      <= '0';
          end if;

          if (valid(div_lat+mul_lat+sub_lat+1) = '1') then
            counter_write <= counter_write -1;
            write_control <= '1';
          else
            counter_write <= counter_i;
            write_control <= '0';
          end if;

        when PRE_DIAG =>
          counter_i        <= 0;
          counter_write    <= 0;
          counter_read_cov <= 0;
          counter_read_inv <= 0;

          i_ready       <= '0';
          div_valid     <= '0';
          tempj_wr_en   <= '0';
          tempj_rd_en   <= '0';
          write_control <= '0';

          state <= DIAGONAL;

        when DIAGONAL =>
          i_ready <= '1';

          if(counter_read_cov /= n_bands-1) then
            counter_read_cov <= counter_read_cov +1;
            v                := '1';
          end if;

          div_valid <= valid(1) or valid(2);

          if(valid(2) = '1') then
            counter_i <= counter_i +1;
          end if;

          if (valid(div_lat-1) = '1') then
            counter_read_inv <= counter_read_inv +1;
          end if;

          write_control <= valid(div_lat+mul_lat+1) or valid(div_lat+mul_lat+2);

          if(valid(div_lat+mul_lat+2) = '1')then
            counter_write <= counter_write +1;
          end if;

          if (valid(div_lat+mul_lat+2) = '0' and valid(div_lat+mul_lat+3) = '1') then
            state <= IDLE;
          end if;
      end case;

      valid <= v & valid(0 to valid'length-2);
      invert_div_result(1 to valid'length-1) <= invert_div_result(0 to valid'length-2);
    end if;
  end process counter_proc;


  divisor_proc : process (clk, div_valid, divisor, dividend, quotient_internal)
  begin
    if (div_valid = '1') then
    if (signed(dividend) < 0 and signed(divisor) > 0)
    and (signed(not(dividend))+1 > signed(divisor)) then --aboslute value is higher
      dividend_internal <= std_logic_vector(resize(signed(not(dividend))+1, dividend_internal'length));
      invert_div_result(0) <= '1';
    else
      dividend_internal <= std_logic_vector(resize(signed(dividend), dividend_internal'length));
      invert_div_result(0) <= '0';
    end if;
      divisor_internal <= std_logic_vector(resize(signed(divisor), divisor_internal'length));
    else
    invert_div_result(0) <= '0';
    dividend_internal <= (others => '-');
    divisor_internal <= (others => '-');
    end if;
  
    -- if the result is less than 0, only the fraction gets the sign bit, so we need some logic
    if (div_ready = '0' or (quotient_internal(quotient_internal'length-1) = '1' and quotient_internal(30) = '0')) then
      quotient_sign_removed <= (others => '-');
      
    elsif (quotient_internal(quotient_internal'length-1) = '0' and quotient_internal(30) = '0') then
      quotient_sign_removed <= quotient_internal(quotient_internal'length-1 downto 31)&quotient_internal(29 downto 0);

    elsif (quotient_internal(quotient_internal'length-1) = '0' and quotient_internal(30) = '1') then
      quotient_sign_removed <= (others => '1');
      quotient_sign_removed(29 downto 0) <= quotient_internal(29 downto 0);

    elsif (quotient_internal(quotient_internal'length-1) = '1' and quotient_internal(30) = '1') then
      quotient_sign_removed <= quotient_internal(quotient_internal'length-1 downto 31)&quotient_internal(29 downto 0);
      --if (unsigned(not(quotient_internal(quotient_internal'length-1 downto 31))) = 0) then --all are '1'
      --  quotient_sign_removed <= quotient_internal(quotient_internal'length-2 downto 31)&'0'&quotient_internal(29 downto 0);
      --else
      --  quotient_sign_removed <= quotient_internal(quotient_internal'length-2 downto 31)&'1'&quotient_internal(29 downto 0);
      --end if;
    end if;
  end process divisor_proc;
    
    
  shift_proc : process (clk, state, quotient_sign_removed, mul_cov_p_internal, mul_inv_p_internal)
  begin
    for I in 0 to n_bands-1 loop
      case (state) is
        when FORWARDS =>
          if (invert_div_result(gauss_div_latency) = '0') then
          quotient     <= quotient_sign_removed(quotient_precision+30-forw-1 downto 30-forw);
          else
          quotient     <= std_logic_vector(signed(not(quotient_sign_removed(quotient_precision+30-forw-1 downto 30-forw)))+1);
          end if;
          mul_cov_p(I) <= mul_cov_p_internal(I)(gauss_mul_p_precision+forw-1 downto forw);
          mul_inv_p(I) <= mul_inv_p_internal(I)(gauss_mul_p_precision+forw-1 downto forw);

        when BACKWARDS =>
          if (invert_div_result(gauss_div_latency) = '0') then
          quotient     <= quotient_sign_removed(quotient_precision+30-back-1 downto 30-back);
          else
          quotient     <= std_logic_vector(signed(not(quotient_sign_removed(quotient_precision+30-back-1 downto 30-back)))+1);
          end if;
          mul_cov_p(I) <= mul_cov_p_internal(I)(gauss_mul_p_precision+back-1 downto back);
          mul_inv_p(I) <= mul_inv_p_internal(I)(gauss_mul_p_precision+back-1 downto back);

        when DIAGONAL =>
          if (invert_div_result(gauss_div_latency) = '0') then
          quotient     <= quotient_sign_removed(quotient_precision+30-diag-1 downto 30-diag);
          else
          quotient     <= std_logic_vector(signed(not(quotient_sign_removed(quotient_precision+30-diag-1 downto 30-diag)))+1);
          end if;
          mul_cov_p(I) <= mul_cov_p_internal(I)(gauss_mul_p_precision+diag-1 downto diag);
          mul_inv_p(I) <= mul_inv_p_internal(I)(gauss_mul_p_precision+diag-1 downto diag);

        when others =>
          quotient     <= (others => '-');
          mul_cov_p(I) <= (others => '-');
          mul_inv_p(I) <= (others => '-');

      end case;
    end loop;
  end process shift_proc;


  temp_covj : entity work.standard_fifo
    generic map (
      data_width => n_bands*ram_precision,
      fifo_depth => n_bands
    )
    PORT MAP (
      clk   => clk,
      rst   => rst,
      din   => tempj_din,
      wr_en => tempj_wr_en,
      rd_en => tempj_rd_en,
      dout  => tempj_dout,
      full  => open,
      empty => open
    );

  divider_inst : divider
    port map (
      aclk                                => clk,
      s_axis_divisor_tvalid               => div_valid,
      s_axis_divisor_tdata   => divisor_internal,
      s_axis_dividend_tvalid              => div_valid,
      s_axis_dividend_tdata  => dividend_internal,
      m_axis_dout_tvalid                  => div_ready,
      m_axis_dout_tdata                   => quotient_internal
    );

  operations_array : for i in 0 to n_bands-1 generate
    multiplier_inst : gauss_multiplier
      PORT MAP (
        CLK => clk,
        A   => mul_cov_a(i),
        B   => mul_cov_b(i),
        P   => mul_cov_p_internal(i)
      );

    multiplier_inv_inst : gauss_multiplier
      PORT MAP (
        CLK => clk,
        A   => mul_inv_a(i),
        B   => mul_inv_b(i),
        P   => mul_inv_p_internal(i)
      );

    subtracter_inst : gauss_subtracter
      PORT MAP (
        CLK                                => clk,
        A                                  => sub_cov_a(i),
        B                                  => sub_cov_b(i),
        S(47 downto gauss_sub_s_precision) => trash,
        S(gauss_sub_s_precision-1 downto 0) => sub_cov_s(i)
      );

    subtracter_inv_inst : gauss_subtracter
      PORT MAP (
        CLK                                => clk,
        A                                  => sub_inv_a(i),
        B                                  => sub_inv_b(i),
        S(47 downto gauss_sub_s_precision) => trash,
        S(gauss_sub_s_precision-1 downto 0) => sub_inv_s(i)
      );
  end generate operations_array;

end behavioral;