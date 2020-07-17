--------------------------------------------------------------------------------
-- Mean subtract
-- Substracts the mean (stored in a circular buffer) from all the pixels in the
-- FIFO. This is the deviation
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rx.all;

entity mean_subtract_module is port(
    clk : in std_logic;
    rst : in std_logic;

    start : in std_logic;

    mean_fifo_rd_en : out std_logic;
    mean_fifo_dout  : in  std_logic_vector;
    mean_fifo_empty : in  std_logic;

    deviation       : out std_logic_vector;
    dev_ready : out std_logic
  );
end mean_subtract_module;

architecture behavioral of mean_subtract_module is

  type state_t is (IDLE, FIFO_LAT, READ, RAM_LAT, CALC);
  signal state : state_t;

  type valid_array is array (mean_sub_latency downto 0) of std_logic;
  signal valid : valid_array;

  signal sub_a : std_logic_vector(mean_sub_a_precision-1 downto 0);
  signal sub_b : std_logic_vector(mean_sub_b_precision-1 downto 0);
  signal sub_p : std_logic_vector(mean_sub_s_precision-1 downto 0);

  signal addr : natural range n_pixels-1 downto 0;

  signal buffer_ena   : std_logic;
  signal buffer_wea   : std_logic_vector(0 downto 0);
  signal buffer_addra : std_logic_vector(log_bands-1 downto 0);
  signal buffer_dina  : std_logic_vector(precision-1 downto 0);
  signal buffer_douta : std_logic_vector(precision-1 downto 0);

begin

  calc_proc : process (clk, rst)
    variable v : std_logic;
  begin
    if (rst = '1') then
      valid <= (others => '0');
      state <= IDLE;
    elsif rising_edge(clk) then
      v := '0';
      case (state) is
        when IDLE =>
          if (start = '1') then
            addr            <= 0;
            buffer_ena <= '1';
            mean_fifo_rd_en <= '1';
            state           <= FIFO_LAT;
          else
            buffer_ena <= '0';
            mean_fifo_rd_en <= '0';
          end if;
            buffer_wea      <= "0";
            sub_a <= (others => '0');
            sub_b <= (others => '0');

        when FIFO_LAT =>
          buffer_wea <= "1";
          state      <= READ;

        when READ =>
          if (addr /= n_bands-1) then
            addr <= addr +1;
          else
            state           <= RAM_LAT;
            mean_fifo_rd_en <= '0';
            buffer_wea      <= "0";
            addr            <= 0;
          end if;

        when RAM_LAT =>
          mean_fifo_rd_en <= '1';
          addr            <= addr +1;
          state           <= CALC;

        when CALC =>
          sub_a           <= std_logic_vector(resize(signed(mean_fifo_dout), mean_sub_a_precision));
          sub_b           <= std_logic_vector(resize(signed(buffer_douta), mean_sub_b_precision));
          mean_fifo_rd_en <= '1';
          v               := '1';

          if (addr /= n_bands-1) then
            addr <= addr +1;
          else
            addr <= 0;
          end if;

          if(mean_fifo_empty = '1')then
            state <= IDLE;
          end if;
      end case;

      valid     <= valid(valid'length-2 downto 0)&v;
      dev_ready <= valid(valid'length-1);
      deviation       <= sub_p;
    end if;
  end process calc_proc;

  subtracter_inst : mean_subtracter
    PORT MAP (
      CLK => clk,
      A   => sub_a,
      B   => sub_b,
      S   => sub_p
    );


  buffer_dina  <= mean_fifo_dout;
  buffer_addra <= std_logic_vector(to_unsigned(addr, buffer_addra'length));

  mean_buffer_instance : entity work.mean_buffer
    PORT MAP (
      clka  => clk,
      ena   => buffer_ena,
      wea   => buffer_wea,
      addra => buffer_addra,
      dina  => buffer_dina,
      douta => buffer_douta
    );

end behavioral;
