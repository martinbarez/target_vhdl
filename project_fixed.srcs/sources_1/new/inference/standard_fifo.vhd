library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use work.rx.all;

entity standard_fifo is
  generic (
    fifo_depth : natural;
    data_width : natural
  );
  port(
    clk   : in  std_logic;
    rst   : in  std_logic;
    din   : in  std_logic_vector(data_width-1 downto 0);
    wr_en : in  std_logic;
    rd_en : in  std_logic;
    dout  : out std_logic_vector(data_width-1 downto 0);
    full  : out std_logic;
    empty : out std_logic
  );
end standard_fifo;

architecture syn of standard_fifo is
begin

  STD_FIFO_1 : entity work.STD_FIFO
    generic map (
      DATA_WIDTH => data_width,
      FIFO_DEPTH => fifo_depth
    )
    port map (
      CLK     => clk,
      RST     => rst,
      WriteEn => wr_en,
      DataIn  => din,
      ReadEn  => rd_en,
      DataOut => dout,
      Empty   => empty,
      Full    => full
    );

end syn;