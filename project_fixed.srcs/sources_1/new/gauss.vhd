--------------------------------------------------------------------------------
-- Gauss-Jordan Inverter
-- Has its own renaming table, but does some tricks to rename, so there a few caveats:
--  - The first value (at 0, 0) cannot be 0
--  - Swapping rows with a distance greater than the pipeline produce wrong results
--  - (the pipeling in floating point is around 50 cycles long, in fixed around 80)
-- Also to note that this module has a bunch of signals to store addresses and similar
-- data during one cycle. Although this impacts the size in fabric, I do not want to
-- deal with long clock cycles.
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

  -- Fix Xilinx division
  constant div_pre : natural := 1;
  constant div_pos : natural := 0;
  -- The names were too long
  constant div_lat : natural := div_pre+gauss_div_latency+div_pos;
  constant mul_lat : natural := gauss_mul_latency;
  constant sub_lat : natural := gauss_sub_latency;

  signal tempj_din, tempj_dout    : std_logic_vector(ram_precision*n_bands-1 downto 0);
  signal tempj_wr_en, tempj_rd_en : std_logic;

  signal dividend                    : std_logic_vector(dividend_precision-1 downto 0); -- the one I set (real one)
  signal divisor                     : std_logic_vector(divisor_precision-1 downto 0);  -- the one I set (real one)
  signal dividend_core, divisor_core : std_logic_vector(47 downto 0);                   -- the modified one that enters the core
  signal quotient_core               : std_logic_vector(79 downto 0);                   -- the one that comes from the core
  signal quotient                    : std_logic_vector(quotient_precision-1 downto 0); -- shifted and everything
  signal div_valid, div_ready        : std_logic;


  type mul_internal_array is array (0 to n_bands-1) of std_logic_vector(100 downto 0);

  signal mul_cov_a, mul_inv_a : gauss_mul_a_array;
  signal mul_cov_b, mul_inv_b : gauss_mul_b_array;
  signal mul_cov_p, mul_inv_p : gauss_mul_p_array; -- the ones I use
  signal sub_cov_a, sub_inv_a : gauss_sub_a_array;
  signal sub_cov_b, sub_inv_b : gauss_sub_b_array;
  signal sub_cov_s, sub_inv_s : gauss_sub_s_array;

  signal mul_cov_p_core, mul_inv_p_core : mul_internal_array; -- the ones that come out from the core


  type state_t is (IDLE, PRE_INIT, INITIALIZE, PRE_FORW, FORWARDS, PRE_BACK, BACKWARDS, PRE_DIAG, DIAGONAL);
  signal state : state_t;

  signal counter_i                              : natural range n_bands-1 downto 0;
  signal i_ready, i_ready_delay, i_ready_delay2 : std_logic;
  signal row_i_cov, row_i_inv                   : ram_array; -- memory for current i

  -- Controls for next cycle
  signal counter_read_cov, counter_read_inv : natural range n_bands-1 downto 0;
  signal counter_write                      : natural range n_bands-1 downto 0;
  signal write_control                      : std_logic;

  -- To control the core without counters
  type control_array_t is array (0 to 127) of std_logic;
  signal valid             : control_array_t;
  signal invert_div_result : control_array_t;

  -- Renaming table
  type address_table is array (0 to n_bands-1) of natural range n_bands-1 downto 0;
  signal rename                                         : address_table;
  signal stall, stall_delay, stall_delay2, stall_delay3 : std_logic;

  -- Some trash from the subtracters
  signal trash : std_logic_vector(5 downto 0);

begin

  counter_proc : process (clk, rst)
    variable v : std_logic;
  begin
    if (rst = '1') then
      state <= IDLE;
    elsif rising_edge(clk) then
      v := '0'; -- goes high only when we read valid data from the covariance
      case (state) is
        when IDLE =>
          if (start = '1') then
            ready <= '0';
            state <= PRE_INIT;
          else
            ready         <= '1';
          end if;
          
          valid <= (others => '0');
          
          write_control <= '0';
          tempj_wr_en   <= '0';
          tempj_rd_en   <= '0';
          div_valid     <= '0';
          i_ready       <= '0';

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
            -- if not stalled, we can process data
            if (stall = '0') then
              counter_read_cov <= counter_read_cov +1;
              v                := '1';
            end if;

          -- if its the last iteration
          elsif (counter_i = n_bands-1) then
            state <= PRE_BACK;

          -- if a new i was written, jump to next iteration
          elsif (counter_write /= counter_i and valid(div_lat+mul_lat) = '0') then
            i_ready          <= '1';
            counter_read_cov <= counter_i +1;
            counter_i        <= counter_i +1;
          end if;

          -- write cov reads on the fifo and start the division
          tempj_wr_en <= valid(1);
          div_valid   <= valid(1+div_pre);

          -- start reading the rows for sub
          if (valid(div_lat+mul_lat) = '1') then
            counter_read_inv <= counter_read_inv +1;
            tempj_rd_en      <= '1';
          else
            counter_read_inv <= counter_i +1;
            tempj_rd_en      <= '0';
          end if;
          -- start reading the covariance from the fifo

          -- start counting to write
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
          div_valid   <= valid(1+div_pre);

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

          div_valid <= valid(1+div_pre) or valid(2+div_pre);

          if(valid(2+div_pos) = '1') then
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

      valid                                  <= v & valid(0 to valid'length-2);
      invert_div_result(1 to valid'length-1) <= invert_div_result(0 to valid'length-2);
    end if;
  end process counter_proc;


  -- Load the current i row in its signal
  capture_i_proc : process (clk)
  begin
    if rising_edge(clk) then
      i_ready_delay  <= i_ready;
      i_ready_delay2 <= i_ready_delay;
      stall_delay    <= stall;
      stall_delay2   <= stall_delay;
      stall_delay3   <= stall_delay2;

      -- The delay from reading is the same, but when stalling we have to swap them
      if (i_ready_delay2 = '1' or stall_delay2 = '1') then
        row_i_inv <= ram_to_array(inv_doutb);
      end if;
      if (i_ready_delay2 = '1' or stall_delay3 = '1') then
        row_i_cov <= ram_to_array(cov_doutb);
      end if;
    end if;
  end process capture_i_proc;


  -- Control writes with another clock
  write_proc : process (clk)
  begin
    if rising_edge(clk) then
      if (write_control = '0') then
        cov_wea <= "0";
        inv_wea <= "0";
      else
        -- Write only on the inverse, and from the multipliers
        if (state = DIAGONAL) then
          cov_wea  <= "0";
          inv_wea  <= "1";
          inv_dina <= gauss_mul_to_ram(mul_inv_p);

        -- Load only the inverse
        elsif (state = INITIALIZE or state = PRE_FORW) then
          cov_wea  <= "0";
          inv_wea  <= "1";
          inv_dina <= (others => '0');
          -- this line is to place the 1 in the correct position, no bit shifting
          inv_dina(ram_precision*(n_bands-counter_write)-1 downto ram_precision*(n_bands-1-counter_write)) <= one_load;

        -- Normal operation
        else
          cov_wea  <= "1";
          inv_wea  <= "1";
          cov_dina <= gauss_sub_to_ram(sub_cov_s);
          inv_dina <= gauss_sub_to_ram(sub_inv_s);
        end if;
      end if;
    end if;
  end process write_proc;


  -- Address renaming (simpler than it looks)
  addr_proc : process (clk)
  begin
    if rising_edge(clk) then
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

    end if;
  end process addr_proc;


  -- Stall controller and writing on the address table
  stall_proc : process (clk)
  begin
    if rising_edge(clk) then
      case (state) is
        when IDLE =>
          stall <= '0';

        -- init renaming table
        when PRE_INIT =>
          stall <= '0';
          init_rename : for i in 0 to n_bands-1 loop
            rename(i) <= i;
          end loop init_rename;

        -- rename registers
        when FORWARDS =>
          -- not writing anything
          if (stall = '0' and write_control = '0') then
            null; -- no need to do anything

          -- writing, so have to check
          elsif (stall = '0' and write_control = '1') then
            if (counter_write = counter_i+1) then       -- on next line
              if (sub_cov_s(counter_write) = zero) then -- check value
                stall <= '1';
              end if;
            end if;

          -- if stalled and writing new lines
          elsif (stall = '1' and write_control = '1') then
            -- check if we can swap
            if (sub_cov_s(counter_i) /= zero) then
              rename(counter_i)     <= counter_write;
              rename(counter_write) <= counter_i;
              stall                 <= '0';
            end if;

          -- if stalled but no new lines
          elsif (stall = '1' and write_control = '0') then
            null; -- have to mark this inversion as failed

          else
            null; -- all cases should be covered
          end if;

        -- reorder write addresses after everything has been read and is IN the pipeline
        -- better in backwards since its pipeline is longer than diagonal
        when BACKWARDS =>
          if (counter_read_inv >= 0 and counter_read_inv <= n_bands-1) then
            rename(counter_read_inv) <= counter_read_inv;
          end if;

        when others =>
          null;
      end case;
    end if;
  end process stall_proc;


  -- Load data in the cores and DSPs
  operator_proc : process (state, counter_i, cov_doutb, row_i_cov, row_i_inv, quotient, tempj_dout, mul_cov_p, inv_doutb, mul_inv_p)
  begin
    if (state = DIAGONAL) then
      dividend <= one_div; -- A custom 1 to perform the correct shifted division
    elsif(state = IDLE) then
      dividend <= (others => '0'); -- Avoid errors in the Xilinx core loading a 0
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


  -- Control division signs
  -- There is a bug in Xilinxs division core. Although I have really constrained when it occurs,
  -- the solution here is a bit broader. I do not want it to happen in fabric under any case
  divisor_proc : process (clk)
  begin
    if (rising_edge(clk)) then

      if (signed(dividend) < 0) then
        dividend_core <= std_logic_vector(resize(signed(not(dividend))+1, dividend_core'length));
      else
        dividend_core <= std_logic_vector(resize(signed(dividend), dividend_core'length));
      end if;
      if (signed(divisor) < 0) then
        divisor_core <= std_logic_vector(resize(signed(not(divisor))+1, divisor_core'length));
      else
        divisor_core <= std_logic_vector(resize(signed(divisor), divisor_core'length));
      end if;

      if (signed(dividend) > 0 and signed(divisor) > 0) then
        invert_div_result(0) <= '0';
      elsif (signed(dividend) < 0 and signed(divisor) > 0) then
        invert_div_result(0) <= '1';
      elsif (signed(dividend) > 0 and signed(divisor) < 0) then
        invert_div_result(0) <= '1';
      else --(signed(dividend) < 0 and signed(divisor) < 0) then
        invert_div_result(0) <= '0';
      end if;

    end if;
  end process divisor_proc;


  -- Shift results between division and multiplications to keep the highest resolution possible
  shift_proc : process (quotient_core, mul_cov_p_core, mul_inv_p_core, invert_div_result)
    variable quotient_sign_removed : std_logic_vector(78 downto 0);
    variable quotient_shifted      : std_logic_vector(quotient_precision-1 downto 0);
  begin

    quotient_sign_removed := quotient_core(quotient_core'length-1 downto 31)&quotient_core(29 downto 0);

    for I in 0 to n_bands-1 loop
      case (state) is
        when FORWARDS =>
          quotient_shifted := quotient_sign_removed(quotient_precision+30-forw-1 downto 30-forw);
          mul_cov_p(I)     <= mul_cov_p_core(I)(gauss_mul_p_precision+forw-1 downto forw);
          mul_inv_p(I)     <= mul_inv_p_core(I)(gauss_mul_p_precision+forw-1 downto forw);

        when BACKWARDS =>
          quotient_shifted := quotient_sign_removed(quotient_precision+30-back-1 downto 30-back);
          mul_cov_p(I)     <= mul_cov_p_core(I)(gauss_mul_p_precision+back-1 downto back);
          mul_inv_p(I)     <= mul_inv_p_core(I)(gauss_mul_p_precision+back-1 downto back);

        when DIAGONAL =>
          quotient_shifted := quotient_sign_removed(quotient_precision+30-diag-1 downto 30-diag);
          mul_cov_p(I)     <= mul_cov_p_core(I)(gauss_mul_p_precision+diag-1 downto diag);
          mul_inv_p(I)     <= mul_inv_p_core(I)(gauss_mul_p_precision+diag-1 downto diag);

        when others =>
          quotient_shifted := (others => '-');
          mul_cov_p(I)     <= (others => '-');
          mul_inv_p(I)     <= (others => '-');
      end case;
    end loop;

    if (invert_div_result(div_lat-div_pre) = '0') then
      quotient <= quotient_shifted;
    else
      quotient <= std_logic_vector(signed(not(quotient_shifted))+1);
    end if;

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
      aclk                   => clk,
      s_axis_divisor_tvalid  => div_valid,
      s_axis_divisor_tdata   => divisor_core,
      s_axis_dividend_tvalid => div_valid,
      s_axis_dividend_tdata  => dividend_core,
      m_axis_dout_tvalid     => div_ready,
      m_axis_dout_tdata      => quotient_core
    );

  operations_array : for i in 0 to n_bands-1 generate
    multiplier_inst : gauss_multiplier
      PORT MAP (
        CLK => clk,
        A   => mul_cov_a(i),
        B   => mul_cov_b(i),
        P   => mul_cov_p_core(i)
      );

    multiplier_inv_inst : gauss_multiplier
      PORT MAP (
        CLK => clk,
        A   => mul_inv_a(i),
        B   => mul_inv_b(i),
        P   => mul_inv_p_core(i)
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