library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.rx.all;

-----------------------------------------------------------

entity matrix_mult_tb is

end entity matrix_mult_tb;

-----------------------------------------------------------

architecture testbench of matrix_mult_tb is

  -- Testbench DUT generics


  -- Testbench DUT ports
  signal clk   : std_logic;
  signal rst   : std_logic;
  signal start : std_logic;
  signal ready : std_logic;

  SIGNAL res_fifo_din   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL res_fifo_wr_en : STD_LOGIC;
  SIGNAL rd_en          : STD_LOGIC;
  SIGNAL dout           : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL full           : STD_LOGIC;
  SIGNAL empty          : STD_LOGIC;

  -- Other constants
  constant C_CLK_PERIOD : real := 10.0e-9; -- NS

begin
  -----------------------------------------------------------
  -- Clocks and Reset
  -----------------------------------------------------------
  CLK_GEN : process
  begin
    clk <= '1';
    wait for C_CLK_PERIOD / 2.0 * (1 SEC);
    clk <= '0';
    wait for C_CLK_PERIOD / 2.0 * (1 SEC);
  end process CLK_GEN;

  RESET_GEN : process
  begin
    rst <= '1',
      '0' after 20.0*C_CLK_PERIOD * (1 SEC);
    wait;
  end process RESET_GEN;

  -----------------------------------------------------------
  -- Testbench Stimulus
  -----------------------------------------------------------
  stimulus : process
    variable t : real;
  begin

    start <= '0';
    rd_en <= '0';
    wait until rst = '0';
    wait until ready ='1';
    start <= '1';
    wait until CLK = '1';
    start <= '0';
    wait until ready = '1';

    rd_en <= '1';
    wait until CLK = '1';
    wait until CLK = '1';
    assert (dout = x"40df711e") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"414efde3") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"41258296") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40d6f8a4") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"414e9693") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40e1e675") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"409b6a3d") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40d7af09") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40f1483c") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40de636c") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40d1e383") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"41114433") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40e1546e") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"407fdd24") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40ee1eba") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"410d8cbd") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"41206a25") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40f91446") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"41013fa7") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"41084df2") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"4132bce1") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"41494a2f") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"4038bb50") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40e9bb39") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"406ac335") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"41244919") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40699cc5") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40c1844b") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40b91ea3") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40a7bd2d") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"41462641") report "error" severity ERROR;
    wait until CLK = '1';
    assert (dout = x"40d33bed") report "error" severity ERROR;

    report "finish" severity FAILURE;

  end process stimulus;
  -----------------------------------------------------------
  -- Entity Under Test
  -----------------------------------------------------------
--  DUT : entity work.matrix_mult
--    port map (
--      clk            => clk,
--      rst            => rst,
--      start          => start,
--      ready          => ready,
--      res_fifo_din   => res_fifo_din,
--      res_fifo_wr_en => res_fifo_wr_en
--    );


end architecture testbench;