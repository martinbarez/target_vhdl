library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rx.all;

entity sorter_cell is
  port (
    clk           : in std_logic;
    rst           : in std_logic;
    storage_ena   : in std_logic;
    storage_enb   : in std_logic;
    storage_addra : in std_logic_vector;
    storage_addrb : in std_logic_vector;

    clear : in  std_logic;
    read  : in  std_logic;
    head  : in  std_logic_vector;
    round : in  std_logic;
    tail  : out std_logic_vector
  );
end sorter_cell;

architecture behavioral of sorter_cell is

  signal storage_wea                 : std_logic_vector(0 downto 0);
  signal storage_dina, storage_doutb : std_logic_vector(sorter_precision+log_pixels-1 downto 0);


begin
  cell : process (clk, rst)
    variable compare : std_logic_vector(sorter_precision+log_pixels-1 downto 0);
    variable swap    : std_logic_vector(sorter_precision+log_pixels-1 downto 0);
  begin
    if (rst = '1') then

    elsif rising_edge(clk) then
      if (clear = '1' or read = '1') then
        compare := (others => '0');
      elsif (round = '1') then
        compare := head;
      else
        compare := swap;
      end if;
      if (clear = '1') then
        storage_wea <= "1";
        swap        := (others => '0');
      elsif (read = '1') then
        storage_wea <= "1";
        swap        := storage_doutb;
      elsif (compare(head'length-1 downto log_pixels) > storage_doutb(head'length-1 downto log_pixels)) then
        storage_wea <= "1";
        swap        := storage_doutb;
      else
        storage_wea <= "0";
        swap        := compare;
      end if;
      storage_dina <= compare;
      tail         <= swap;
    end if;
  end process cell;

  storage : entity work.sorter_ram
    PORT MAP (
      clka  => clk,
      ena   => storage_ena,
      wea   => storage_wea,
      addra => storage_addra,
      dina  => storage_dina,
      clkb  => clk,
      enb   => storage_enb,
      addrb => storage_addrb,
      doutb => storage_doutb
    );

end behavioral;
