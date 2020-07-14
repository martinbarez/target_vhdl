library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.rx.all;

-----------------------------------------------------------

entity inverse_tb is

end entity inverse_tb;

-----------------------------------------------------------

architecture testbench of inverse_tb is

  -- Testbench DUT generics


  -- Testbench DUT ports
  signal clk     : std_logic;
  signal rst     : std_logic;
  signal start   : std_logic;
  signal ready   : std_logic;

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
    wait until rst = '0';
    wait until ready ='1';
    start <= '1';
    wait until CLK = '1';
    start <= '0';
    wait until ready = '1';

    report "finish" severity FAILURE;

  end process stimulus;
  -----------------------------------------------------------
  -- Entity Under Test
  -----------------------------------------------------------
--  DUT : entity work.control
--    port map (
--      clk     => clk,
--      rst     => rst,
--      start   => start,
--      ready   => ready
--    );

end architecture testbench;