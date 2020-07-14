library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use work.rx.all;

entity mean_buffer is
  generic (
    addr_width : natural := log_bands;
    data_width : natural := precision
  );
  port(
    clka  : in  std_logic;
    ena   : in  std_logic;
    wea   : in  std_logic_vector(0 downto 0);
    addra : in  std_logic_vector(addr_width-1 downto 0);
    dina  : in  std_logic_vector(data_width-1 downto 0);
    douta : out std_logic_vector(data_width-1 downto 0)
  );
end mean_buffer;

architecture syn of mean_buffer is
begin

  rams_sp_nc_1 : entity work.rams_sp_nc
    generic map (
      addr_width => addr_width,
      data_width => data_width
    )
    port map (
      clk  => clka,
      we   => wea(0),
      en   => ena,
      addr => addra,
      di   => dina,
      do   => douta
    );

end syn;