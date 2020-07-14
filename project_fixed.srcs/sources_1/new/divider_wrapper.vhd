library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rx.all;

entity divider_wrapper is
  port (
    clk            : in  std_logic;
    dividend_valid : in  std_logic;
    dividend       : in  std_logic_vector(dividend_precision-1 downto 0);
    divisor_valid  : in  std_logic;
    divisor        : in  std_logic_vector(divisor_precision-1 downto 0);
    quotient_valid : out std_logic;
    quotient       : out std_logic_vector(quotient_precision-1 downto 0)
  );
end divider_wrapper;

architecture behavioral of divider_wrapper is

  COMPONENT divider
    PORT (
      aclk                   : IN  STD_LOGIC;
      s_axis_dividend_tvalid : IN  STD_LOGIC;
      s_axis_dividend_tdata  : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_divisor_tvalid  : IN  STD_LOGIC;
      s_axis_divisor_tdata   : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
      m_axis_dout_tvalid     : OUT STD_LOGIC;
      m_axis_dout_tdata      : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
  END COMPONENT;

  signal dividend_valid_internal : std_logic;
  signal dividend_internal       : std_logic_vector(63 downto 0);
  signal divisor_valid_internal  : std_logic;
  signal divisor_internal        : std_logic_vector(47 downto 0);
  signal div_dout_valid_internal : std_logic;
  signal div_dout_internal       : std_logic_vector(63 downto 0);
begin

  divisor_valid_internal  <= divisor_valid;
  divisor_internal        <= std_logic_vector(resize(signed(divisor), divisor_internal'length));
  dividend_valid_internal <= dividend_valid;
  dividend_internal       <= std_logic_vector(resize(signed(dividend), dividend_internal'length-20))&fill(20-1 downto 0);

  quotient_valid <= div_dout_valid_internal;
  quotient       <= div_dout_internal(quotient_precision+2-1 downto 2);

  divider_inst : divider
    port map (
      aclk                   => clk,
      s_axis_divisor_tvalid  => divisor_valid_internal,
      s_axis_divisor_tdata   => divisor_internal,
      s_axis_dividend_tvalid => dividend_valid_internal,
      s_axis_dividend_tdata  => dividend_internal,
      m_axis_dout_tvalid     => div_dout_valid_internal,
      m_axis_dout_tdata      => div_dout_internal
    );
end behavioral;
