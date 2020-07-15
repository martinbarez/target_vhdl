--------------------------------------------------------------------------------
-- Final
-- the last operation
-- mutiplies the whole inverse matrix with the same vector two tmes to get rx
-- NOTE: this module is REALLY timing dependent, signals are connected directly
--    between modules but these may not work for all implementations.
--    (latency values are in the package)
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rx.all;
entity matrix_mult is
  port(
    clk   : in  std_logic;
    rst   : in  std_logic;
    start : in  std_logic;
    ready : out std_logic;

    diff : in std_logic_vector;

    inv_addrb : out std_logic_vector;
    inv_doutb : in  std_logic_vector;

    sorter_switch : out std_logic;
    sorter_value  : out std_logic_vector;
    sorter_valid  : out std_logic;
    sorter_coord  : out std_logic_vector
  );
end matrix_mult;
architecture behavioral of matrix_mult is

  signal delay_fifo_rd_en : std_logic;
  signal delay_fifo_dout  : std_logic_vector(precision-1 downto 0);
  signal delay_fifo_empty : std_logic;
  signal delay_fifo_wr_en : std_logic;
  signal delay_fifo_din   : std_logic_vector(precision-1 downto 0);
  signal delay_fifo_full  : std_logic;


  type valid_array is array (20 downto 0) of std_logic;
  signal first_valid : valid_array;

  signal first_mult_a : mult_st_mul_a_array;
  signal first_mult_b : std_logic_vector(mult_st_mul_b_precision-1 downto 0);
  signal first_mult_p : mult_st_mul_p_array;

  signal first_accum_in       : mult_st_accum_in_array;
  signal first_accum_last_in  : std_logic;
  signal first_accum_out      : mult_st_accum_out_array;
  signal first_accum_last_out : std_logic;

  signal second_mult_a : std_logic_vector(mult_nd_mul_a_precision-1 downto 0);
  signal second_mult_b : std_logic_vector(mult_nd_mul_b_precision-1 downto 0);
  signal second_mult_p : std_logic_vector(mult_nd_mul_p_precision-1 downto 0);

  signal second_accum_in       : std_logic_vector(mult_nd_accum_in_precision-1 downto 0);
  signal second_accum_last_in  : std_logic;
  signal second_accum_out      : std_logic_vector(mult_nd_accum_out_precision-1 downto 0);
  signal second_accum_last_out : std_logic;


  type first_state_t is (IDLE, CALC, LAST);
  signal first_state : first_state_t;

  type second_state_t is (IDLE, CALC, LAST, REP);
  signal second_state : second_state_t;

  type write_state_t is (IDLE, PREP, WRITING);
  signal write_state : write_state_t;

  signal inter_res    : mult_st_accum_out_array;
  signal write_finish : std_logic;

  -- counter for the first mac
  signal inv_address : natural range n_bands-1 downto 0;

  signal first_dev_counter  : natural range n_pixels downto 0; --not -1
  signal second_dev_counter : natural range n_bands*n_pixels-1 downto 0;

  signal diff_delay1, diff_delay2, diff_delay3 : std_logic_vector(diff'length-1 downto 0);

  signal coord : natural range n_pixels-1 downto 0;

begin

  first_mac : process (clk, rst)
    variable v : std_logic;
  begin
    if (rst = '1') then
      first_state <= IDLE;
    elsif rising_edge(clk) then
      case (first_state) is
        when IDLE =>
          if (start = '1') then
            first_dev_counter <= 0;
            inv_address       <= 0;
            delay_fifo_wr_en  <= '1';
            first_state       <= CALC;
            ready             <= '0';
            v                 := '1';
          else
            ready <= write_finish;
            v     := '0';
          end if;

        when CALC =>

          if (inv_address = n_bands-1)then
            inv_address       <= 0;
            first_dev_counter <= first_dev_counter +1;
            v                 := '1';
          else
            inv_address <= inv_address +1;
            v           := '0';
          end if;

          if (first_dev_counter = n_pixels)then
            delay_fifo_wr_en <= '0';
            first_state      <= LAST;
          end if;

        when LAST => --flush last results

          if (inv_address = n_bands-1) then
            first_state <= IDLE;
            v           := '1';
          else
            inv_address <= inv_address +1;
            v           := '0';
          end if;
      end case;
      diff_delay1         <= diff;
      diff_delay2         <= diff_delay1;
      diff_delay3         <= diff_delay2;
      first_valid         <= first_valid(first_valid'length-2 downto 0)&v;
      first_accum_last_in <= first_valid(mult_st_multiplier_latency);
    end if;
  end process first_mac;


  second_mac : process (clk, rst)
  begin
    if (rst = '1') then
      second_state     <= IDLE;
      delay_fifo_rd_en <= '0';
      inter_res(0)     <= (others => '0');
    elsif rising_edge(clk) then
      case (second_state) is
        when IDLE =>
          if (first_valid(mult_st_multiplier_latency+mult_st_accumulator_latency) = '1' and first_dev_counter = 0) then
            delay_fifo_rd_en <= '1';
          else
            delay_fifo_rd_en <= '0';
          end if;
          if (first_valid(mult_st_multiplier_latency+mult_st_accumulator_latency) = '1' and first_dev_counter = 1) then
            delay_fifo_rd_en   <= '1';
            second_dev_counter <= 1;
            inter_res          <= first_accum_out;
            second_state       <= CALC;
          end if;

        when CALC =>
          if (first_valid(mult_st_multiplier_latency+mult_st_accumulator_latency) = '1') then
            inter_res <= first_accum_out;
          else
            inter_res(0 to n_bands-2) <= inter_res(1 to n_bands-1);
            inter_res(n_bands-1)      <= (others => '-');
          end if;
          if (second_dev_counter = n_bands*n_pixels-1) then
            second_dev_counter <= 0;
            second_state       <= LAST;
          else
            second_dev_counter <= second_dev_counter +1;
          end if;

        when LAST =>
          if(second_dev_counter = n_bands-1) then
            second_state <= IDLE;
          else
            second_state <= REP;
          end if;

        when REP =>
          second_dev_counter <= second_dev_counter +1;
          if (second_dev_counter = n_bands-2) then
            second_state <= LAST;
          end if;
      end case;
    end if;
  end process second_mac;


  write_proc : process (clk, rst)
  begin
    if (rst = '1') then
      sorter_valid <= '0';
    elsif rising_edge(clk) then
      case (write_state) is
        when IDLE =>
          coord         <= n_pixels-1;
          write_finish  <= '1';
          sorter_switch <= '0';
          if (first_valid(14) = '1' and first_dev_counter = 1) then
            write_state <= PREP;
          end if;

        when PREP =>
          write_state   <= WRITING;
          write_finish  <= '0';
          sorter_switch <= '1';

        when WRITING =>
          sorter_switch <= '0';
          sorter_valid  <= '0';
          if (first_valid(14) = '1') then
            sorter_value <= second_accum_out;
            sorter_valid <= '1';
            if (coord = n_pixels-1) then
              coord <= 0;
            else
              coord <= coord +1;
            end if;
          end if;
          if (second_dev_counter = 8) then
              write_state   <= IDLE;
            end if;
      end case;
    end if;
  end process write_proc;

  sorter_coord <= std_logic_vector(to_unsigned(coord, sorter_coord'length));

  first : for i in 0 to n_bands-1 generate
    first_mult_a <= ram_to_mult_mul(inv_doutb);
    first_mult_b <= diff_delay3;
    first_multiplier : mult_st_multiplier
      PORT MAP (
        CLK => clk,
        A   => first_mult_a(i),
        B   => first_mult_b,
        P   => first_mult_p(i)
      );

    first_accum_in(i) <= first_mult_p(i);

    first_accumulator : mult_st_accum
      PORT MAP (
        CLK    => clk,
        B      => first_accum_in(i),
        Q      => first_accum_out(i),
        BYPASS => first_accum_last_in
      );
  end generate first;

  second_mult_a        <= delay_fifo_dout;
  second_mult_b        <= inter_res(0);
  second_accum_in      <= second_mult_p;
  second_accum_last_in <= first_valid(13);


  second_multiplier : mult_nd_multiplier
    PORT MAP (
      CLK => clk,
      A   => second_mult_a,
      B   => second_mult_b,
      P   => second_mult_p
    );
  second_accumulator : mult_nd_accum
    PORT MAP (
      CLK    => clk,
      B      => second_accum_in,
      Q      => second_accum_out,
      BYPASS => second_accum_last_in
    );

  delay_fifo_din <= diff_delay2;

  delay_fifo : entity work.standard_fifo
    generic map (
      data_width => precision,
      fifo_depth => n_bands+n_bands*n_pixels
    )
    PORT MAP (
      clk   => clk,
      rst   => rst,
      din   => delay_fifo_din,
      wr_en => delay_fifo_wr_en,
      rd_en => delay_fifo_rd_en,
      dout  => delay_fifo_dout,
      full  => open,
      empty => open
    );

  inv_addrb <= std_logic_vector(to_unsigned(inv_address, inv_addrb'length));

end behavioral;