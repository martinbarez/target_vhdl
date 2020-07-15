library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package rx is

--------------------------------------------------------------------------------
-- LATENCY VALUES
--------------------------------------------------------------------------------
  -- Gauss-Jordan Inverse
  constant gauss_div_latency : natural := 77;
  constant gauss_mul_latency : natural := 6;
  constant gauss_sub_latency : natural := 2;

  -- Deviation
  constant mean_sub_latency : natural := 2;

  -- RX-Step
  constant mult_st_multiplier_latency  : natural := 5;
  constant mult_st_accumulator_latency : natural := 2;
  constant mult_nd_multiplier_latency  : natural := 5;
  constant mult_nd_accumulator_latency : natural := 2;


--------------------------------------------------------------------------------
-- SIZE CONSTANTS
--------------------------------------------------------------------------------
  --constant n_bands    : natural range 0 to 256  := 8;
  --constant n_pixels   : natural range 0 to 5000 := 32;
  --constant log_bands  : natural := 3;
  --constant log_pixels : natural := 5;

  constant n_bands    : natural range 0 to 256  := 55;
  constant n_pixels   : natural range 0 to 5000 := 10*10;
  constant log_bands  : natural                 := 6;
  constant log_pixels : natural                 := 7;

  --constant n_bands    : natural range 0 to 256  := 169;
  --constant n_pixels   : natural range 0 to 5000 := 64*64;
  --constant log_bands  : natural := 8;
  --constant log_pixels : natural := 12;


--------------------------------------------------------------------------------
-- SHIFTING CONSTANTS
--------------------------------------------------------------------------------
  --register to fill with zeros when shifting
  constant fill      : std_logic_vector(63 downto 0) := (others => '0');

  -- the covariance and the 1 for the inverse get shifted left
  constant read_cov : natural := 20;
  constant read_inv : natural := 29;

  -- the dividend gets shifted left on these steps
  constant forw : natural := 24;
  constant back : natural := 17;
  constant diag : natural := 24;

  -- the 1 for the division gets shifted left, the mult result right
  constant write_up : natural := 24;
  constant write_dw : natural := 3;

  constant st_mult : natural := 0;
  constant st_accum : natural := 0;
  constant nd_mult : natural := 0;


--------------------------------------------------------------------------------
-- PRECISION CONSTANTS
--------------------------------------------------------------------------------
  constant precision        : natural := 24; --precision for the cpu
  constant ram_precision    : natural := 42;
  constant sorter_precision : natural := 48;

  -- Gaussian Inverse
  constant dividend_precision : natural := ram_precision;
  constant divisor_precision  : natural := ram_precision;
  constant quotient_precision : natural := 35;
  constant gauss_mul_a_precision : natural := ram_precision;
  constant gauss_mul_b_precision : natural := quotient_precision;
  constant gauss_mul_p_precision : natural := 48;
  constant gauss_sub_a_precision : natural := ram_precision;
  constant gauss_sub_b_precision : natural := gauss_mul_p_precision;
  constant gauss_sub_s_precision : natural := ram_precision;

  -- Deviation
  constant mean_sub_a_precision : natural := precision;
  constant mean_sub_b_precision : natural := precision;
  constant mean_sub_s_precision : natural := 24;

  -- RX-Step
  constant mult_st_mul_a_precision     : natural := ram_precision;
  constant mult_st_mul_b_precision     : natural := mean_sub_s_precision;
  constant mult_st_mul_p_precision     : natural := 48;
  constant mult_st_accum_in_precision  : natural := mult_st_mul_p_precision;
  constant mult_st_accum_out_precision : natural := 48;

  constant mult_nd_mul_a_precision     : natural := mean_sub_s_precision;
  constant mult_nd_mul_b_precision     : natural := mult_st_accum_out_precision;
  constant mult_nd_mul_p_precision     : natural := 48;
  constant mult_nd_accum_in_precision  : natural := mult_nd_mul_p_precision;
  constant mult_nd_accum_out_precision : natural := sorter_precision;


--------------------------------------------------------------------------------
-- DATA CONSTANTS (they depend from other constants)
--------------------------------------------------------------------------------
  constant one_load     : std_logic_vector(ram_precision-1 downto 0)         := (read_inv => '1', others => '0');
  constant one_div      : std_logic_vector(ram_precision-1 downto 0)         := (write_up => '1', others => '0');
  constant zero         : std_logic_vector(gauss_sub_s_precision-1 downto 0) := (others              => '0');                --used to detect zeroes in the inverse
  constant zero_control : std_logic_vector(precision-1 downto 0)             := (others              => '0');                --used to detect zeroes in control

--------------------------------------------------------------------------------
-- TYPE DEFINITIONS
--------------------------------------------------------------------------------
  type ram_array is array (0 to n_bands-1) of std_logic_vector(ram_precision-1 downto 0);
  type gauss_mul_a_array is array (0 to n_bands-1) of std_logic_vector(gauss_mul_a_precision-1 downto 0);
  type gauss_mul_b_array is array (0 to n_bands-1) of std_logic_vector(gauss_mul_b_precision-1 downto 0);
  type gauss_mul_p_array is array (0 to n_bands-1) of std_logic_vector(gauss_mul_p_precision-1 downto 0);
  type gauss_sub_a_array is array (0 to n_bands-1) of std_logic_vector(gauss_sub_a_precision-1 downto 0);
  type gauss_sub_b_array is array (0 to n_bands-1) of std_logic_vector(gauss_sub_b_precision-1 downto 0);
  type gauss_sub_s_array is array (0 to n_bands-1) of std_logic_vector(gauss_sub_s_precision-1 downto 0);

  type mult_st_mul_a_array is array (0 to n_bands-1) of std_logic_vector(mult_st_mul_a_precision-1 downto 0);
  type mult_st_mul_p_array is array (0 to n_bands-1) of std_logic_vector(mult_st_mul_p_precision-1 downto 0);
  type mult_st_accum_in_array is array (0 to n_bands-1) of std_logic_vector(mult_st_accum_in_precision-1 downto 0);
  type mult_st_accum_out_array is array (0 to n_bands-1) of std_logic_vector(mult_st_accum_out_precision-1 downto 0);

  -- fills with zeros to the right
  function precision_to_ram (
      s : in std_logic_vector
    ) return std_logic_vector;

  function ram_to_array (
      s : in std_logic_vector
    ) return ram_array;

  -- removes some precision
  function gauss_mul_to_ram (
      s : in gauss_mul_p_array
    ) return std_logic_vector;

  function gauss_sub_to_ram (
      s : in gauss_sub_s_array
    ) return std_logic_vector;

  function ram_to_gauss_mul (
      s : in ram_array
    ) return gauss_mul_a_array;

  function ram_to_gauss_sub (
      s : in std_logic_vector
    ) return gauss_sub_a_array;

  function gauss_mul_to_gauss_sub (
      s : in gauss_mul_p_array
    ) return gauss_sub_b_array;

  function ram_to_mult_mul (
      s : in std_logic_vector
    ) return mult_st_mul_a_array;
    
    
  COMPONENT divider
    PORT (
      aclk                   : IN  STD_LOGIC;
      s_axis_dividend_tvalid : IN  STD_LOGIC;
      s_axis_dividend_tdata  : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
      s_axis_divisor_tvalid  : IN  STD_LOGIC;
      s_axis_divisor_tdata   : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
      m_axis_dout_tvalid     : OUT STD_LOGIC;
      m_axis_dout_tdata      : OUT STD_LOGIC_VECTOR(79 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT gauss_multiplier
    PORT (
      CLK : IN  STD_LOGIC;
      A   : IN  STD_LOGIC_VECTOR(gauss_mul_a_precision-1 DOWNTO 0);
      B   : IN  STD_LOGIC_VECTOR(gauss_mul_b_precision-1 DOWNTO 0);
      P   : OUT STD_LOGIC_VECTOR(100 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT gauss_subtracter
    PORT (
      CLK : IN  STD_LOGIC;
      A   : IN  STD_LOGIC_VECTOR(gauss_sub_a_precision-1 DOWNTO 0);
      B   : IN  STD_LOGIC_VECTOR(gauss_sub_b_precision-1 DOWNTO 0);
      S   : OUT STD_LOGIC_VECTOR(48-1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT mean_subtracter
    PORT (
      CLK : IN  STD_LOGIC;
      A   : IN  STD_LOGIC_VECTOR(mean_sub_a_precision-1 DOWNTO 0);
      B   : IN  STD_LOGIC_VECTOR(mean_sub_b_precision-1 DOWNTO 0);
      S   : OUT STD_LOGIC_VECTOR(mean_sub_s_precision-1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT mult_st_accum
    PORT (
      CLK    : IN  STD_LOGIC;
      B      : IN  STD_LOGIC_VECTOR(mult_st_accum_in_precision-1 DOWNTO 0);
      Q      : OUT STD_LOGIC_VECTOR(mult_st_accum_out_precision-1 DOWNTO 0);
      BYPASS : IN  STD_LOGIC
    );
  END COMPONENT;

  COMPONENT mult_st_multiplier
    PORT (
      CLK : IN  STD_LOGIC;
      A   : IN  STD_LOGIC_VECTOR(mult_st_mul_a_precision-1 DOWNTO 0);
      B   : IN  STD_LOGIC_VECTOR(mult_st_mul_b_precision-1 DOWNTO 0);
      P   : OUT STD_LOGIC_VECTOR(mult_st_mul_p_precision-1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT mult_nd_accum
    PORT (
      CLK    : IN  STD_LOGIC;
      B      : IN  STD_LOGIC_VECTOR(mult_nd_accum_in_precision-1 DOWNTO 0);
      Q      : OUT STD_LOGIC_VECTOR(mult_nd_accum_out_precision-1 DOWNTO 0);
      BYPASS : IN  STD_LOGIC
    );
  END COMPONENT;

  COMPONENT mult_nd_multiplier
    PORT (
      CLK : IN  STD_LOGIC;
      A   : IN  STD_LOGIC_VECTOR(mult_nd_mul_a_precision-1 DOWNTO 0);
      B   : IN  STD_LOGIC_VECTOR(mult_nd_mul_b_precision-1 DOWNTO 0);
      P   : OUT STD_LOGIC_VECTOR(mult_nd_mul_p_precision-1 DOWNTO 0)
    );
  END COMPONENT;

end rx;


package body rx is

  function precision_to_ram (
      s : in std_logic_vector
    ) return std_logic_vector is
    variable v : std_logic_vector(ram_precision*n_bands-1 downto 0);
  begin
    assert(s'length = precision*n_bands) report "wrong length" severity FAILURE;
    for I in 0 to n_bands-1 loop
      v(I*ram_precision+ram_precision-1 downto I*ram_precision) := std_logic_vector(resize(signed(s(I*precision+precision-1 downto I*precision)), ram_precision-read_cov))&fill(read_cov-1 downto 0);
    end loop;
    return v;
  end function precision_to_ram;

  function ram_to_array (
      s : in std_logic_vector
    ) return ram_array is
    variable v : ram_array;
  begin
    assert(s'length = ram_precision*n_bands) report "wrong length" severity FAILURE;
    for I in 0 to n_bands-1 loop
      v(n_bands-I-1) := s(I*ram_precision+ram_precision-1 downto I*ram_precision);
    end loop;
    return v;
  end function ram_to_array;

  function gauss_mul_to_ram (
      s : in gauss_mul_p_array
    ) return std_logic_vector is
    variable v : std_logic_vector(ram_precision*n_bands-1 downto 0);
  begin
    for I in 0 to n_bands-1 loop
      v(I*ram_precision+ram_precision-1 downto I*ram_precision) := std_logic_vector(resize(signed(s(n_bands-I-1)(gauss_mul_p_precision-1 downto write_dw)), ram_precision));
    end loop;
    return v;
  end function gauss_mul_to_ram;

  function gauss_sub_to_ram (
      s : in gauss_sub_s_array
    ) return std_logic_vector is
    variable v : std_logic_vector(ram_precision*n_bands-1 downto 0);
  begin
    for I in 0 to n_bands-1 loop
      v(I*ram_precision+ram_precision-1 downto I*ram_precision) := std_logic_vector(resize(signed(s(n_bands-I-1)), ram_precision));
    end loop;
    return v;
  end function gauss_sub_to_ram;

  function ram_to_gauss_mul (
      s : in ram_array
    ) return gauss_mul_a_array is
    variable v : gauss_mul_a_array;
  begin
    for I in 0 to n_bands-1 loop
      v(I) := std_logic_vector(resize(signed(s(I)), gauss_mul_a_precision));
    end loop;
    return v;
  end function ram_to_gauss_mul;

  function ram_to_gauss_sub (
      s : in std_logic_vector
    ) return gauss_sub_a_array is
    variable v : gauss_sub_a_array;
  begin
    assert(ram_precision = gauss_sub_a_precision) report "wrong length" severity FAILURE;
    for I in 0 to n_bands-1 loop
      v(n_bands-I-1) := s(I*ram_precision+ram_precision-1 downto I*ram_precision);
    end loop;
    return v;
  end function ram_to_gauss_sub;

  function gauss_mul_to_gauss_sub (
      s : in gauss_mul_p_array
    ) return gauss_sub_b_array is
    variable v : gauss_sub_b_array;
  begin
    assert(gauss_sub_b_precision = gauss_mul_p_precision) report "wrong length" severity FAILURE;
    for I in 0 to n_bands-1 loop
      v(I) := s(I);
    end loop;
    return v;
  end function gauss_mul_to_gauss_sub;

  function ram_to_mult_mul (
      s : in std_logic_vector
    ) return mult_st_mul_a_array is
    variable v : mult_st_mul_a_array;
  begin
    assert(s'length = ram_precision*n_bands) report "wrong length" severity FAILURE;
    for I in 0 to n_bands-1 loop
      v(n_bands-I-1) := std_logic_vector(resize(signed(s(I*ram_precision+ram_precision-1 downto I*ram_precision)), mult_st_mul_a_precision));
    end loop;
    return v;
  end function ram_to_mult_mul;

end package body rx;