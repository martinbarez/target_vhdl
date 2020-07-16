--------------------------------------------------------------------------------
-- RX-Step
-- The RX-Step is a matrix multiplication. Data comes from the deviation module,
-- gets multiplied, accumulated and send to the sorter
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

    deviation : in std_logic_vector;

    inv_addrb : out std_logic_vector;
    inv_doutb : in  std_logic_vector;

    sorter_start : out std_logic;
    sorter_value : out std_logic_vector;
    sorter_valid : out std_logic;
    sorter_coord : out std_logic_vector
  );
end matrix_mult;
architecture behavioral of matrix_mult is
  constant st_mul : natural := mult_st_multiplier_latency;
  constant st_acc : natural := mult_st_accumulator_latency;
  constant nd_mul : natural := mult_nd_multiplier_latency;
  constant nd_acc : natural := mult_nd_accumulator_latency;

  signal delay_fifo_rd_en : std_logic;
  signal delay_fifo_dout  : std_logic_vector(precision-1 downto 0);
  signal delay_fifo_wr_en : std_logic;
  signal delay_fifo_din   : std_logic_vector(precision-1 downto 0);

  type valid_array is array (20+n_bands downto 0) of std_logic;
  signal valid : valid_array;

  signal first_mult_a : mult_st_mul_a_array;
  signal first_mult_b : std_logic_vector(mult_st_mul_b_precision-1 downto 0);
  signal first_mult_p : mult_st_mul_p_array;

  signal first_accum_in  : mult_st_accum_in_array;
  signal first_load      : std_logic;
  signal first_accum_out : mult_st_accum_out_array;

  signal second_mult_a : std_logic_vector(mult_nd_mul_a_precision-1 downto 0);
  signal second_mult_b : std_logic_vector(mult_nd_mul_b_precision-1 downto 0);
  signal second_mult_p : std_logic_vector(mult_nd_mul_p_precision-1 downto 0);

  signal second_accum_in  : std_logic_vector(mult_nd_accum_in_precision-1 downto 0);
  signal second_load      : std_logic;
  signal second_accum_out : std_logic_vector(mult_nd_accum_out_precision-1 downto 0);


  type first_state_t is (IDLE, CALC);
  signal first_state : first_state_t;

  type second_state_t is (IDLE, CALC);
  signal second_state : second_state_t;

  type write_state_t is (IDLE, WRITING);
  signal write_state : write_state_t;

  -- Keep the result of the first multiplication
  signal inter_res    : mult_st_accum_out_array;
  signal write_finish : std_logic;

  -- counter for the first mac
  signal inv_address : natural range n_bands-1 downto 0;

  signal first_dev_counter  : natural range n_pixels downto 0; --no -1
  signal second_dev_counter : natural range n_pixels downto 0;

  signal deviation_delay1, deviation_delay2, deviation_delay3 : std_logic_vector(deviation'length-1 downto 0);


begin

  first_mac : process (clk, rst)
    variable v : std_logic;
  begin
    if (rst = '1') then
      first_state <= IDLE;
      valid       <= (others => '0');
    elsif rising_edge(clk) then
      v := '0';
      case (first_state) is
        when IDLE =>
          delay_fifo_wr_en <= '0';
          if (start = '1') then
            first_dev_counter <= 0;
            inv_address       <= 0;
            delay_fifo_wr_en  <= '1';
            first_state       <= CALC;
            ready             <= '0';
            v                 := '1';
          elsif (write_state = IDLE) then
            ready <= '1';
          else
            ready <= '0';
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
            first_state      <= IDLE;
          end if;

      end case;
      valid <= valid(valid'length-2 downto 0)&v;
    end if;
  end process first_mac;


  second_mac : process (clk, rst)
  begin
    if (rst = '1') then
      second_state <= IDLE;
    elsif rising_edge(clk) then
      case (second_state) is
        when IDLE =>
          delay_fifo_rd_en <= '0';
          if (valid(st_mul+st_acc) = '1') then
            delay_fifo_rd_en   <= '1';
          end if;
          if (valid(st_mul+st_acc+n_bands) = '1') then
            --delay_fifo_rd_en   <= '1';
            second_dev_counter <= 0;
            second_state       <= CALC;
          end if;

        when CALC =>
          if (valid(st_mul+st_acc+n_bands) = '1') then
            second_dev_counter <= second_dev_counter +1;
            inter_res <= first_accum_out;
          else
            inter_res(0 to n_bands-2) <= inter_res(1 to n_bands-1);
            inter_res(n_bands-1)      <= (others => '-');
          end if;
          if (second_dev_counter = n_pixels) then
            second_state       <= IDLE;
          end if;
      end case;
    end if;
  end process second_mac;


  write_proc : process (clk, rst)
    variable coord : natural range n_pixels-1 downto 0;
  begin
    if (rst = '1') then
      write_state <= IDLE;
    elsif rising_edge(clk) then
      case (write_state) is
        when IDLE =>
          coord        := n_pixels-1;
          write_finish <= '1';
          sorter_start <= '0';
          sorter_valid <= '0';
          if (valid(st_mul+st_acc+nd_mul+nd_acc+n_bands) = '1') then
            write_state  <= WRITING;
            write_finish <= '0';
            sorter_start <= '1';
          end if;

        when WRITING =>
          sorter_start <= '0';
          sorter_valid <= '0';
          if (valid(st_mul+st_acc+nd_mul+nd_acc+n_bands) = '1') then
            sorter_value <= second_accum_out;
            sorter_valid <= '1';
            if (coord = n_pixels-1) then
              coord := 0;
            elsif (coord = n_pixels-2) then
              coord := coord +1;
              write_state <= IDLE;
            else
              coord := coord +1;
            end if;
          end if;
      end case;
    end if;
    sorter_coord <= std_logic_vector(to_unsigned(coord, sorter_coord'length));
  end process write_proc;


  -- To read the inverse
  inv_addrb <= std_logic_vector(to_unsigned(inv_address, inv_addrb'length));

  deviation_delay : process (clk)
  begin
    if rising_edge(clk) then
      deviation_delay1 <= deviation;
      deviation_delay2 <= deviation_delay1;
      deviation_delay3 <= deviation_delay2;
    end if;
  end process deviation_delay;


  first_mult_a <= ram_to_mult_mul(inv_doutb);
  first_mult_b <= deviation_delay3;
  first : for i in 0 to n_bands-1 generate
    first_multiplier : mult_st_multiplier
      PORT MAP (
        CLK => clk,
        A   => first_mult_a(i),
        B   => first_mult_b,
        P   => first_mult_p(i)
      );

    first_accum_in(i) <= first_mult_p(i);
    first_load        <= valid(mult_st_multiplier_latency+1);
    first_accumulator : mult_st_accum
      PORT MAP (
        CLK    => clk,
        B      => first_accum_in(i),
        Q      => first_accum_out(i),
        BYPASS => first_load
      );
  end generate first;

  second_mult_a <= delay_fifo_dout;
  second_mult_b <= inter_res(0);
  second_multiplier : mult_nd_multiplier
    PORT MAP (
      CLK => clk,
      A   => second_mult_a,
      B   => second_mult_b,
      P   => second_mult_p
    );

  second_accum_in <= second_mult_p;
  second_load     <= valid(st_mul+st_acc+st_mul+1+n_bands);
  second_accumulator : mult_nd_accum
    PORT MAP (
      CLK    => clk,
      B      => second_accum_in,
      Q      => second_accum_out,
      BYPASS => second_load
    );


  -- The delay FIFO serves to keep a copy of the deviation data, since its used two times
  delay_fifo_din <= deviation_delay2;
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


end behavioral;