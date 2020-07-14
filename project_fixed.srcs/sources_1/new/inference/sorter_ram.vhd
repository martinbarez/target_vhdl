library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use work.rx.all;

entity sorter_ram is
  generic (
    addr_width : natural := log_bands;
    data_width : natural := sorter_precision+log_pixels
  );
  port(
    clka  : in  std_logic;
    ena   : in  std_logic;
    wea   : in  std_logic_vector(0 downto 0);
    addra : in  std_logic_vector(addr_width-1 downto 0);
    dina  : in  std_logic_vector(data_width-1 downto 0);
    clkb  : in  std_logic;
    enb   : in  std_logic;
    addrb : in  std_logic_vector(addr_width-1 downto 0);
    doutb : out std_logic_vector(data_width-1 downto 0)
  );
end sorter_ram;

architecture syn of sorter_ram is
begin

  simple_dual_two_clocks_rf_1 : entity work.simple_dual_two_clocks_rf
    generic map (
      addr_width => addr_width,
      data_width => data_width
    )
    port map (
      clka  => clka,
      ena   => ena,
      wea   => wea,
      addra => addra,
      dina  => dina,
      clkb  => clkb,
      enb   => enb,
      addrb => addrb,
      doutb => doutb
    );

end syn;