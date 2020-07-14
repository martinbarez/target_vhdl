-- Controller/Arbitrer
-- this module reads the inputs from the cpu (from a bunch of fifos) and writes them
-- to internal ram, which gets arbitred between the different modules
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rx.all;

entity control is
  port(
    clk   : in  std_logic;
    rst   : in  std_logic;
    start : in  std_logic;
    ready : out std_logic;

    cov_fifo_rd_en : out std_logic;
    cov_fifo_dout  : in  std_logic_vector;
    cov_fifo_empty : in  std_logic;

    mean_fifo_rd_en : out std_logic;
    mean_fifo_dout  : in  std_logic_vector;
    mean_fifo_empty : in  std_logic;

    res_fifo_din   : out std_logic_vector;
    res_fifo_wr_en : out std_logic
  );
end control;

architecture behavioral of control is

  type state_t is (IDLE, READ, WRITE_LAST, INV_START, INV_CALC, DIFF_START, DIFF_CALC, MUL_START, MUL_CALC, RES_READ);
  signal state : state_t;

  signal fifo_read_last_cycle : boolean;

  signal read_counter, write_counter : natural range n_bands-1 downto 0;
  signal write_first                 : boolean;

  type arbitrer_t is (INTERNAL, INVERSE, MAT_MULT);
  signal arb_cov_ram, arb_inv_ram : arbitrer_t;

  signal start_inv, start_mul, start_diff : std_logic;
  signal ready_inv, ready_mul             : std_logic;

  -- Memories
  signal cov_wea, cov_wea_int, cov_wea_inv       : std_logic_vector(0 downto 0);
  signal cov_addra, cov_addra_int, cov_addra_inv : std_logic_vector(log_bands-1 downto 0);
  signal cov_dina, cov_dina_int, cov_dina_inv    : std_logic_vector(n_bands*ram_precision-1 downto 0);

  signal cov_enb                                 : std_logic;
  signal cov_addrb, cov_addrb_int, cov_addrb_inv : std_logic_vector(log_bands-1 downto 0);
  signal cov_doutb                               : std_logic_vector(n_bands*ram_precision-1 downto 0);

  signal inv_wea, inv_wea_inv, inv_wea_mul       : std_logic_vector(0 downto 0);
  signal inv_addra, inv_addra_inv, inv_addra_mul : std_logic_vector(log_bands-1 downto 0);
  signal inv_dina, inv_dina_inv, inv_dina_mul    : std_logic_vector(n_bands*ram_precision-1 downto 0);

  signal inv_enb                                 : std_logic;
  signal inv_addrb, inv_addrb_inv, inv_addrb_mul : std_logic_vector(log_bands-1 downto 0);
  signal inv_doutb                               : std_logic_vector(n_bands*ram_precision-1 downto 0);

  signal diff       : std_logic_vector(mean_sub_s_precision-1 downto 0);
  signal diff_ready : std_logic;

  signal sorter_switch, sorter_valid0, sorter_valid1, sorter_valid2 : std_logic;
  signal sorter_value0, sorter_value1, sorter_value2                : std_logic_vector(sorter_precision-1 downto 0);
  signal sorter_coord0, sorter_coord1, sorter_coord2                : std_logic_vector(log_pixels-1 downto 0);
  signal res                                                        : std_logic_vector(log_pixels-1 downto 0);
  signal res_valid, res_valid2                                      : std_logic;


begin

  control : process (clk, rst)
  begin
    if (rst = '1') then
      state          <= IDLE;
      start_inv      <= '0';
      start_diff     <= '0';
      start_mul      <= '0';
      cov_fifo_rd_en <= '0';
      res_fifo_wr_en <= '0';
    elsif rising_edge(clk) then
      case (state) is
        when IDLE =>
          ready     <= '1';
          start_inv <= '0';
          if (start = '1') then
            ready                <= '0';
            arb_cov_ram          <= INTERNAL;
            write_counter        <= 0; --change to 1 if fifo is fwft
            write_first          <= false;
            fifo_read_last_cycle <= false;
            cov_enb              <= '1';
            inv_enb              <= '1';
            state                <= READ;
          end if;

        when READ =>
          if (cov_fifo_empty = '0') then
            cov_fifo_rd_en       <= '1';
            fifo_read_last_cycle <= true;
          else
            cov_fifo_rd_en       <= '0';
            fifo_read_last_cycle <= false;
          end if;

          cov_dina_int <= precision_to_ram(cov_fifo_dout);
          cov_wea_int  <= "1";

          if (fifo_read_last_cycle) then
            if ((not write_first) and cov_fifo_dout(precision-1 downto 0) /= zero_control) then
              cov_addra_int <= (others => '0');
              write_counter <= write_counter;
              write_first   <= true;
            else
              cov_addra_int <= std_logic_vector(to_unsigned(write_counter, cov_addra_int'length));
              write_counter <= write_counter +1;
            end if;
          end if;

          if (write_counter = n_bands-1 and fifo_read_last_cycle) then
            state <= WRITE_LAST;
          end if;

        when WRITE_LAST =>
          start_inv   <= '1';
          cov_wea_int <= "0";
          arb_cov_ram <= INVERSE;
          arb_inv_ram <= INVERSE;
          state       <= INV_START;

        when INV_START =>
          start_inv <= '0';
          state     <= INV_CALC;

        when INV_CALC =>
          if (ready_inv = '1') then
            start_diff <= '1';
            state      <= DIFF_START;
          end if;

        when DIFF_START =>
          start_diff <= '0';
          state      <= DIFF_CALC;

        when DIFF_CALC =>
          if (diff_ready = '1') then
            start_mul   <= '1';
            arb_inv_ram <= MAT_MULT;
            state       <= MUL_START;
          end if;

        when MUL_START =>
          start_mul <= '0';
          state     <= MUL_CALC;

        when MUL_CALC =>
          if (ready_mul = '1') then
            state   <= RES_READ;
            cov_enb <= '0';
            inv_enb <= '0';
          end if;

        when RES_READ =>
          res_fifo_wr_en <= res_valid;
          res_fifo_din   <= res;
          res_valid2     <= res_valid;
          if (res_valid = '0' and res_valid2 = '1') then
            state <= IDLE;
          end if;
      end case;
    end if;
  end process control;

  arbitrerproc : process (clk, rst, arb_cov_ram, arb_inv_ram,
      cov_wea_int, cov_addra_int, cov_dina_int, cov_addrb_int,
      cov_wea_inv, cov_addra_inv, cov_dina_inv, cov_addrb_inv,
      inv_wea_inv, inv_addra_inv, inv_dina_inv, inv_addrb_inv,
      inv_wea_mul, inv_addra_mul, inv_dina_mul, inv_addrb_mul)
  begin
    case (arb_cov_ram) is
      --read covariance from cpu to ram
      when INTERNAL =>
        cov_wea   <= cov_wea_int;
        cov_addra <= cov_addra_int;
        cov_dina  <= cov_dina_int;
        cov_addrb <= cov_addrb_int;
      --let inverter use covariance ram
      when others =>
        cov_wea   <= cov_wea_inv;
        cov_addra <= cov_addra_inv;
        cov_dina  <= cov_dina_inv;
        cov_addrb <= cov_addrb_inv;
    end case;
    case (arb_inv_ram) is
      --let inverter compute inverse
      when INVERSE =>
        inv_wea   <= inv_wea_inv;
        inv_addra <= inv_addra_inv;
        inv_dina  <= inv_dina_inv;
        inv_addrb <= inv_addrb_inv;
      --let matrix multiplier read inverse
      when others =>
        inv_wea   <= inv_wea_mul;
        inv_addra <= inv_addra_mul;
        inv_dina  <= inv_dina_mul;
        inv_addrb <= inv_addrb_mul;
    end case;
  end process arbitrerproc;


  gauss_instance : entity work.gauss_module
    port map (
      clk   => clk,
      rst   => rst,
      start => start_inv,
      ready => ready_inv,

      cov_wea   => cov_wea_inv,
      cov_addra => cov_addra_inv,
      cov_dina  => cov_dina_inv,

      cov_addrb => cov_addrb_inv,
      cov_doutb => cov_doutb,

      inv_wea   => inv_wea_inv,
      inv_addra => inv_addra_inv,
      inv_dina  => inv_dina_inv,

      inv_addrb => inv_addrb_inv,
      inv_doutb => inv_doutb
    );

  covariance : entity work.covariance_ram
    PORT MAP (
      clka => clk,
      clkb => clk,
      ena  => cov_wea(0),

      wea   => cov_wea,
      addra => cov_addra,
      dina  => cov_dina,

      enb   => cov_enb,
      addrb => cov_addrb,
      doutb => cov_doutb
    );

  inverse_ram : entity work.covariance_ram
    PORT MAP (
      clka => clk,
      clkb => clk,
      ena  => inv_wea(0),

      wea   => inv_wea,
      addra => inv_addra,
      dina  => inv_dina,

      enb   => inv_enb,
      addrb => inv_addrb,
      doutb => inv_doutb
    );

  mean_subtract_instance : entity work.mean_subtract_module
    port map (
      clk   => clk,
      rst   => rst,
      start => start_diff,

      mean_fifo_rd_en => mean_fifo_rd_en,
      mean_fifo_dout  => mean_fifo_dout,
      mean_fifo_empty => mean_fifo_empty,

      diff       => diff,
      diff_ready => diff_ready
    );


  matrix_mult_module : entity work.matrix_mult
    port map (
      clk => clk,
      rst => rst,

      start => start_mul,
      ready => ready_mul,

      diff => diff,

      inv_addrb => inv_addrb_mul,
      inv_doutb => inv_doutb,

      sorter_switch => sorter_switch,
      sorter_value  => sorter_value0,
      sorter_valid  => sorter_valid0,
      sorter_coord  => sorter_coord0
    );

  sorter_delay : process (clk)
  begin
    if rising_edge(clk) then
      sorter_value1 <= sorter_value0;
      sorter_valid1 <= sorter_valid0;
      sorter_coord1 <= sorter_coord0;

      sorter_value2 <= sorter_value1;
      sorter_valid2 <= sorter_valid1;
      sorter_coord2 <= sorter_coord1;
    end if;
  end process sorter_delay;

  sorter_instance : entity work.sorter
    port map (
      clk => clk,
      rst => rst,

      switch => sorter_switch,

      value => sorter_value2,
      valid => sorter_valid2,
      coord => sorter_coord2,

      res       => res,
      res_valid => res_valid
    );


end behavioral;
