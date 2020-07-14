--------------------------------------------------------------------------------
-- A template for a simple dual port block ram, with two clock signals
-- but they should use the same buffer because thats how the blockgen in 
-- vivado works and I want to maintain compatibility
-- Adapted from the templates from ug901
-- WRITE FIRST
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity simple_dual_two_clocks_wf is
  generic (
    addr_width : natural;
    data_width : natural
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
end simple_dual_two_clocks_wf;

architecture syn of simple_dual_two_clocks_wf is
  type ram_type is array (2**addr_width-1 downto 0) of std_logic_vector(data_width-1 downto 0);
  shared variable RAM : ram_type;
begin
  process(clka, clkb)
  begin
    assert (clka = clkb) report "using different clocks" severity FAILURE;
    if clka'event and clka = '1' then
      if ena = '1' then
        if wea = "1" then
          RAM(conv_integer(addra)) := dina;
        end if;
      end if;
      if enb = '1' then
        doutb <= RAM(conv_integer(addrb));
      end if;
    end if;
  end process;

end syn;