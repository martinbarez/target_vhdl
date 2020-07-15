library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rx.all;

entity sorter is
  port (
    clk : in std_logic;
    rst : in std_logic;

    switch : in std_logic;

    value : in std_logic_vector;
    valid : in std_logic;
    coord : in std_logic_vector;

    res       : out std_logic_vector;
    res_valid : out std_logic
  );
end sorter;

architecture behavioral of sorter is

  type state_t is (IDLE, INITIALIZE, READ);
  signal state : state_t;

  signal storage_ena, storage_enb     : std_logic;
  signal storage_wea                  : std_logic_vector(0 downto 0);
  signal storage_addra, storage_addrb : std_logic_vector(log_bands-1 downto 0);
  signal storage_dina, storage_doutb  : std_logic_vector(log_pixels+sorter_precision-1 downto 0);

  signal read_addr, write_addr : natural range n_bands-1 downto 0;

  signal swap : std_logic_vector(storage_dina'length-1 downto 0);

begin

  sort_proc : process (clk, rst)
    variable compare  : std_logic_vector(storage_dina'length-1 downto 0);
    variable switched : boolean;
  begin
    if (rst = '1') then
      state <= IDLE;
    elsif rising_edge(clk) then
      case (state) is
        when IDLE =>
          storage_wea <= "0";
          res_valid   <= '0';
          if (switch = '1') then
            write_addr   <= 0;
            storage_wea  <= "1";
            storage_dina <= (others => '0');
            switched     := false;
            state        <= INITIALIZE;
            read_addr    <= 1;
            storage_ena  <= '1';
            storage_enb  <= '1';
          end if;

        when INITIALIZE =>
          if (write_addr /= n_bands-1) then
            write_addr <= write_addr +1;
          else
            write_addr <= n_bands-1;
            state      <= READ;
          end if;

        when READ =>
          if (valid = '1') then
            compare := coord&value;
          else
            compare := swap;
          end if;
          if (compare(sorter_precision-1 downto 0) >= storage_doutb(sorter_precision-1 downto 0)) then
            storage_wea  <= "1";
            storage_dina <= compare;
            swap         <= storage_doutb;
            res          <= compare(storage_doutb'length-1 downto storage_doutb'length-log_pixels);
          else
            storage_wea <= "0";
            swap        <= compare;
            res         <= storage_doutb(storage_doutb'length-1 downto storage_doutb'length-log_pixels);
          end if;

          if (read_addr /= n_bands-1) then
            read_addr <= read_addr +1;
          else
            read_addr <= 0;
          end if;
          if (write_addr /= n_bands-1) then
            write_addr <= write_addr +1;
          else
            write_addr <= 0;
          end if;

          if (unsigned(coord) = n_pixels-1) then
            res_valid <= '1';
            if (read_addr = n_bands-1) then
              state <= IDLE;
            end if;
          end if;
      end case;
    end if;
  end process sort_proc;

  storage_addra <= std_logic_vector(to_unsigned(write_addr, storage_addra'length));
  storage_addrb <= std_logic_vector(to_unsigned(read_addr, storage_addra'length));

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
