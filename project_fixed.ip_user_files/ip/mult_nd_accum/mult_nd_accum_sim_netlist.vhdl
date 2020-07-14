-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Wed Jun 24 09:36:57 2020
-- Host        : fpga running 64-bit Ubuntu 18.04.4 LTS
-- Command     : write_vhdl -force -mode funcsim -rename_top mult_nd_accum -prefix
--               mult_nd_accum_ accumulator_sim_netlist.vhdl
-- Design      : accumulator
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a200tfbg676-2
-- --------------------------------------------------------------------------------
`protect begin_protected
`protect version = 1
`protect encrypt_agent = "XILINX"
`protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`protect key_block
mCTsLEbsPZ2vQwU8/7gCUSK/pChAk9a06Ca2pzXOPgWuyZNUN2/38IFSH3fobTOXCRoicKPjw/zS
U5JdUhkrLw==

`protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`protect key_block
GFPI7s4C1t7CtVyK1SFEMXCUuPDr0XM3dS0SXtjjql05Q6JUKrxMZaM7re8CPIaDa54K1WYrSiji
LOfE418BW3NruEHp6g4ffIGVmqD/6oXHlSP/+pZ+GD8J3ZZ9gHEnk9BLpUeWxtZunteh6jCktwBR
rDRNRE7evKc0RdE4Dzg=

`protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
sEab41ij0Mmj3TOzy5LUFbrA1DGo6sn7RpcTh4zIXnxchi7xaGXTH4JkUR4ERWmrZubZVNuDty3G
4TW7X1eXkIYL0g3rTl1BN/pYJcBojhcX71F3LLIf2z50xQX6C59oMYwkdcd0PKmDVIlUkuP55LXc
ILCABg2L8H6UmzHAHUiOb/o2/XfUUvzZHBTzPfY1N5j5wGyuLLxHjbTs22mz7su4SFA4cDz1ALYw
WqIXTEkTzRpnoV5wAq1v0Vljr91e3XWzZQtWtVlINSogSOqFkFryC5Sn6XgFKHe60XmBBtCyjXg/
RpESrybcLJXn3Sff/R8O4K5MV88ExUrcKlwcbw==

`protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
kVMOfbqeAFbRG9AMrD5M+safOIxNtaCf7vbQo4khE4OGfju8gRGpKeH/RBfeF976g2hwQ3yb68+C
IHXa4Ggqv86YT+lK0cUiptCFUEliyQqLgeutmo8QT+myFuhOCigkd3gO/Ts/HA9efV1h3pF/80pX
hqDlXlXuHo+cqoUwCS3vdZF3BKdibV6EHy4qF/qVnECMkrspJXIVcIRc9rRy1y+MbXqEbUCxtwrJ
rm0ZY0xzh+LekunkI6e2PVdvd0g/qtccEy7f06N3TOMMZaWTSw0x9HhMloWl2ouB1S+bvFs9Yagk
Tc5aSMQNzOW5qRZ1mF48mVKRrN1rrE5D2xD5JA==

`protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
U4bopG4wSqgAQnZxL2fp0S7FrDx75jbl15bXkH2mvALsB9XQUE3qdDMI92sWWRV/uzMbbqIMshjl
ZKIENZsOxjaoJ0hVcroFjOxph6nTzkmbbFkmudkJ8slcjH+xiD9RfeQFHMsXkBGLzC11PVdamyZ0
P7LdruCjryCHGCn70pBIZuh55AEoIPKbMJ9MaIkCgo37fZfwGMHUIfcvU4aDBBuf41xMf2m++S9u
RR2xaqwnsNdfcKXb+gT0yVDNqNasrMWc3PwHJvsNiY4RwM7ZSITnu8GWNRuKRlIjuYg7t9pIPzTe
eHl0DoLjHR6lVlHoVbpqWfaaUa6luuIc7u4PNQ==

`protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`protect key_block
sAs2oWs8lBD4xeSCwEijiqMelKmseqrG/zdMgpoP/wZ8fFRCLUax7WNKGlE6cPnL+y3jaA/+0fhV
ndzyEbMbXXM0aG4qQzxDsJw+4KnEUAFIV17eRWZk6dOo5MnkmDxgjZixEnxP2MzFUchitx7IleaH
iKm7b7mAy39oUY8fSx4=

`protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
eWM7fRAz99edtylcrw22vOsawXtWPeHz6UHdrRNJFlHrb+PoOiaxgGrcbYNHn9NMpDY2KUERUmu5
7u8qEumSCoU2dkcWNPpMNn9MGhIh1nzl4RJ01/o0OfiS5LtyOXkCQkzbuE2yNIPRfiygQYgD8Q+d
oGEZN/9d0Ds57Pkj3hNfGS1iNbu/7qlhcXQhcUh203/GNMxjzFCRCWCrG3EQCNAUSPsy+sebZDxg
X72jBoFo8D3NZ3K0TK/OR6j0cYLSAEvX3AUz7+0LifAWGDopG+i3152NkVbQICrPt5Wb1h01Eyfu
TVCmOrE3siGLwl6+yYH9uKwyU4tc9mQHm817lA==

`protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
oDZ/HLJGYC65wGItiCMl8rUIIcjy2vdrgFYPPFItMXWLV/RCwZ+IAOrpA0FarBzttgv8oSNmKzjB
mNYdICjl0hImxNi9hHbN83CfIYqybRISD/cmAcL4S+aHECMc8R+FMJz0l2qphfvF8mdgxnGjc8zc
y+aB/1Db4HQH4XHiUY9nsNK7nnkaV/RdE6XIclPHqukKyLX8Tq2w/kKoBWOoWSSkG4uOC4SeEJOs
u8U6ALcCaYIStFeSuXNGAZmJ47B22XlipvApuzKJqQNsbeg5KOvWKnof/xMzPFgiqYJalJox6y/i
wpZarOwj/eINR6KiLV0yzqadWxDE9ReUY5agEg==

`protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
RUANfArs0MhQ/otTaOFj6Z5SynzzpaVUGzGofBVj7IKH5XEmv5wKyFUmwzGiipux/2PjNYWpnRp0
1TG1RTQ6KOkU3jlraGyuhYQKTmE9bZAj2IXHFhI6EtKJ7OU1DqMDBJEEQ9GdqqeRTuL6Kw3vF0z0
IX0w/VF5HI//C/1D6moq47ELfw8JICMse2b09mlWSChMCL5UB4Ak5ptsCXXQmFMaDmedIPlkboUo
jhBi8KQkq96qByrhAdxLr0utlghQLSTW3AGz+N++fDx6HfY4qjHBeay8pPzZJ0xCrPQ48NriUTrl
H8InRkxzDj9s2yukqGCjFDFBF37J8s31ASsvuA==

`protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
LJXpWG/kvkFp5MwU1pocYxTFZ0tjmToyMoCr1RRpu+Xb3+2dnIsfWAU2H/bdPCNSGWM6qw00mg0G
1U7jslP0CAHowCvEK8qnc+YQ20V9ubiXPV3kU16xB+SYSeG01CXhX/n9Zm7o9mQIZgRpCybRkOAG
wXvLPs2fXMShpO0ycQqrTlFO26Z16tHBMLyueR/AiONAjYqN49ugu+clkZBFUW/ej7A+MD/2FBqM
NmT4wn1msz78EFp30sPCvYSq6DiqADssEAj3IySmaaKXYXB2tzuf0HMk1ah6BbgQUGRiW5twuKgu
UT9g79eoRgjdzO21ozfqDn4P9i5AVpvEvT5a9w==

`protect data_method = "AES128-CBC"
`protect encoding = (enctype = "BASE64", line_length = 76, bytes = 17616)
`protect data_block
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
RHqjE8w0Rb6GJl31mdq22Q==
`protect end_protected
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mult_nd_accum_c_accum_v12_0_14 is
  port (
    B : in STD_LOGIC_VECTOR ( 47 downto 0 );
    CLK : in STD_LOGIC;
    ADD : in STD_LOGIC;
    C_IN : in STD_LOGIC;
    CE : in STD_LOGIC;
    BYPASS : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    SSET : in STD_LOGIC;
    SINIT : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 47 downto 0 )
  );
  attribute C_ADD_MODE : integer;
  attribute C_ADD_MODE of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_AINIT_VAL : string;
  attribute C_AINIT_VAL of mult_nd_accum_c_accum_v12_0_14 : entity is "0";
  attribute C_BYPASS_LOW : integer;
  attribute C_BYPASS_LOW of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_B_TYPE : integer;
  attribute C_B_TYPE of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_B_WIDTH : integer;
  attribute C_B_WIDTH of mult_nd_accum_c_accum_v12_0_14 : entity is 48;
  attribute C_CE_OVERRIDES_SCLR : integer;
  attribute C_CE_OVERRIDES_SCLR of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_HAS_BYPASS : integer;
  attribute C_HAS_BYPASS of mult_nd_accum_c_accum_v12_0_14 : entity is 1;
  attribute C_HAS_CE : integer;
  attribute C_HAS_CE of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_HAS_C_IN : integer;
  attribute C_HAS_C_IN of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_HAS_SCLR : integer;
  attribute C_HAS_SCLR of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_HAS_SINIT : integer;
  attribute C_HAS_SINIT of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_HAS_SSET : integer;
  attribute C_HAS_SSET of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_IMPLEMENTATION : integer;
  attribute C_IMPLEMENTATION of mult_nd_accum_c_accum_v12_0_14 : entity is 1;
  attribute C_LATENCY : integer;
  attribute C_LATENCY of mult_nd_accum_c_accum_v12_0_14 : entity is 2;
  attribute C_OUT_WIDTH : integer;
  attribute C_OUT_WIDTH of mult_nd_accum_c_accum_v12_0_14 : entity is 48;
  attribute C_SCALE : integer;
  attribute C_SCALE of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_SCLR_OVERRIDES_SSET : integer;
  attribute C_SCLR_OVERRIDES_SSET of mult_nd_accum_c_accum_v12_0_14 : entity is 1;
  attribute C_SINIT_VAL : string;
  attribute C_SINIT_VAL of mult_nd_accum_c_accum_v12_0_14 : entity is "0";
  attribute C_VERBOSITY : integer;
  attribute C_VERBOSITY of mult_nd_accum_c_accum_v12_0_14 : entity is 0;
  attribute C_XDEVICEFAMILY : string;
  attribute C_XDEVICEFAMILY of mult_nd_accum_c_accum_v12_0_14 : entity is "artix7";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of mult_nd_accum_c_accum_v12_0_14 : entity is "yes";
end mult_nd_accum_c_accum_v12_0_14;

architecture STRUCTURE of mult_nd_accum_c_accum_v12_0_14 is
  attribute C_ADD_MODE of i_synth : label is 0;
  attribute C_AINIT_VAL of i_synth : label is "0";
  attribute C_BYPASS_LOW of i_synth : label is 0;
  attribute C_B_TYPE of i_synth : label is 0;
  attribute C_B_WIDTH of i_synth : label is 48;
  attribute C_CE_OVERRIDES_SCLR of i_synth : label is 0;
  attribute C_HAS_BYPASS of i_synth : label is 1;
  attribute C_HAS_CE of i_synth : label is 0;
  attribute C_HAS_C_IN of i_synth : label is 0;
  attribute C_HAS_SCLR of i_synth : label is 0;
  attribute C_HAS_SINIT of i_synth : label is 0;
  attribute C_HAS_SSET of i_synth : label is 0;
  attribute C_IMPLEMENTATION of i_synth : label is 1;
  attribute C_LATENCY of i_synth : label is 2;
  attribute C_OUT_WIDTH of i_synth : label is 48;
  attribute C_SCALE of i_synth : label is 0;
  attribute C_SCLR_OVERRIDES_SSET of i_synth : label is 1;
  attribute C_SINIT_VAL of i_synth : label is "0";
  attribute C_VERBOSITY of i_synth : label is 0;
  attribute C_XDEVICEFAMILY of i_synth : label is "artix7";
  attribute downgradeipidentifiedwarnings of i_synth : label is "yes";
begin
i_synth: entity work.mult_nd_accum_c_accum_v12_0_14_viv
     port map (
      ADD => '0',
      B(47 downto 0) => B(47 downto 0),
      BYPASS => BYPASS,
      CE => '0',
      CLK => CLK,
      C_IN => '0',
      Q(47 downto 0) => Q(47 downto 0),
      SCLR => '0',
      SINIT => '0',
      SSET => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mult_nd_accum is
  port (
    B : in STD_LOGIC_VECTOR ( 47 downto 0 );
    CLK : in STD_LOGIC;
    BYPASS : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 47 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of mult_nd_accum : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of mult_nd_accum : entity is "accumulator,c_accum_v12_0_14,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of mult_nd_accum : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of mult_nd_accum : entity is "c_accum_v12_0_14,Vivado 2019.2";
end mult_nd_accum;

architecture STRUCTURE of mult_nd_accum is
  attribute C_ADD_MODE : integer;
  attribute C_ADD_MODE of U0 : label is 0;
  attribute C_AINIT_VAL : string;
  attribute C_AINIT_VAL of U0 : label is "0";
  attribute C_BYPASS_LOW : integer;
  attribute C_BYPASS_LOW of U0 : label is 0;
  attribute C_B_TYPE : integer;
  attribute C_B_TYPE of U0 : label is 0;
  attribute C_B_WIDTH : integer;
  attribute C_B_WIDTH of U0 : label is 48;
  attribute C_CE_OVERRIDES_SCLR : integer;
  attribute C_CE_OVERRIDES_SCLR of U0 : label is 0;
  attribute C_HAS_BYPASS : integer;
  attribute C_HAS_BYPASS of U0 : label is 1;
  attribute C_HAS_CE : integer;
  attribute C_HAS_CE of U0 : label is 0;
  attribute C_HAS_C_IN : integer;
  attribute C_HAS_C_IN of U0 : label is 0;
  attribute C_HAS_SCLR : integer;
  attribute C_HAS_SCLR of U0 : label is 0;
  attribute C_HAS_SINIT : integer;
  attribute C_HAS_SINIT of U0 : label is 0;
  attribute C_HAS_SSET : integer;
  attribute C_HAS_SSET of U0 : label is 0;
  attribute C_IMPLEMENTATION : integer;
  attribute C_IMPLEMENTATION of U0 : label is 1;
  attribute C_LATENCY : integer;
  attribute C_LATENCY of U0 : label is 2;
  attribute C_OUT_WIDTH : integer;
  attribute C_OUT_WIDTH of U0 : label is 48;
  attribute C_SCALE : integer;
  attribute C_SCALE of U0 : label is 0;
  attribute C_SCLR_OVERRIDES_SSET : integer;
  attribute C_SCLR_OVERRIDES_SSET of U0 : label is 1;
  attribute C_SINIT_VAL : string;
  attribute C_SINIT_VAL of U0 : label is "0";
  attribute C_VERBOSITY : integer;
  attribute C_VERBOSITY of U0 : label is 0;
  attribute C_XDEVICEFAMILY : string;
  attribute C_XDEVICEFAMILY of U0 : label is "artix7";
  attribute downgradeipidentifiedwarnings of U0 : label is "yes";
  attribute x_interface_info : string;
  attribute x_interface_info of BYPASS : signal is "xilinx.com:signal:data:1.0 bypass_intf DATA";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of BYPASS : signal is "XIL_INTERFACENAME bypass_intf, LAYERED_METADATA undef";
  attribute x_interface_info of CLK : signal is "xilinx.com:signal:clock:1.0 clk_intf CLK";
  attribute x_interface_parameter of CLK : signal is "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF q_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0";
  attribute x_interface_info of B : signal is "xilinx.com:signal:data:1.0 b_intf DATA";
  attribute x_interface_parameter of B : signal is "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef";
  attribute x_interface_info of Q : signal is "xilinx.com:signal:data:1.0 q_intf DATA";
  attribute x_interface_parameter of Q : signal is "XIL_INTERFACENAME q_intf, LAYERED_METADATA undef";
begin
U0: entity work.mult_nd_accum_c_accum_v12_0_14
     port map (
      ADD => '1',
      B(47 downto 0) => B(47 downto 0),
      BYPASS => BYPASS,
      CE => '1',
      CLK => CLK,
      C_IN => '0',
      Q(47 downto 0) => Q(47 downto 0),
      SCLR => '0',
      SINIT => '0',
      SSET => '0'
    );
end STRUCTURE;
