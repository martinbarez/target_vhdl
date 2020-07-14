// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Jun 29 11:22:23 2020
// Host        : fpga running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/fpga/project_fixed/project_fixed.runs/mean_subtracter_synth_1/mean_subtracter_sim_netlist.v
// Design      : mean_subtracter
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mean_subtracter,c_addsub_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_14,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mean_subtracter
   (A,
    B,
    CLK,
    S);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [23:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [23:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF s_intf:c_out_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 s_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME s_intf, LAYERED_METADATA undef" *) output [23:0]S;

  wire [23:0]A;
  wire [23:0]B;
  wire CLK;
  wire [23:0]S;
  wire NLW_U0_C_OUT_UNCONNECTED;

  (* C_ADD_MODE = "1" *) 
  (* C_AINIT_VAL = "0" *) 
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "24" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_BYPASS_LOW = "0" *) 
  (* C_B_CONSTANT = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "000000000000000000000000" *) 
  (* C_B_WIDTH = "24" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_BYPASS = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_C_IN = "0" *) 
  (* C_HAS_C_OUT = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "2" *) 
  (* C_OUT_WIDTH = "24" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mean_subtracter_c_addsub_v12_0_14 U0
       (.A(A),
        .ADD(1'b1),
        .B(B),
        .BYPASS(1'b0),
        .CE(1'b1),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_U0_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADD_MODE = "1" *) (* C_AINIT_VAL = "0" *) (* C_A_TYPE = "0" *) 
(* C_A_WIDTH = "24" *) (* C_BORROW_LOW = "1" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_CONSTANT = "0" *) (* C_B_TYPE = "0" *) (* C_B_VALUE = "000000000000000000000000" *) 
(* C_B_WIDTH = "24" *) (* C_CE_OVERRIDES_BYPASS = "1" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_C_OUT = "0" *) (* C_HAS_SCLR = "0" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "1" *) (* C_LATENCY = "2" *) 
(* C_OUT_WIDTH = "24" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_addsub_v12_0_14" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mean_subtracter_c_addsub_v12_0_14
   (A,
    B,
    CLK,
    ADD,
    C_IN,
    CE,
    BYPASS,
    SCLR,
    SSET,
    SINIT,
    C_OUT,
    S);
  input [23:0]A;
  input [23:0]B;
  input CLK;
  input ADD;
  input C_IN;
  input CE;
  input BYPASS;
  input SCLR;
  input SSET;
  input SINIT;
  output C_OUT;
  output [23:0]S;

  wire \<const0> ;
  wire [23:0]A;
  wire ADD;
  wire [23:0]B;
  wire CLK;
  wire [23:0]S;
  wire NLW_xst_addsub_C_OUT_UNCONNECTED;

  assign C_OUT = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_ADD_MODE = "1" *) 
  (* C_AINIT_VAL = "0" *) 
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "24" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_BYPASS_LOW = "0" *) 
  (* C_B_CONSTANT = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "000000000000000000000000" *) 
  (* C_B_WIDTH = "24" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_BYPASS = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_C_IN = "0" *) 
  (* C_HAS_C_OUT = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "2" *) 
  (* C_OUT_WIDTH = "24" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mean_subtracter_c_addsub_v12_0_14_viv xst_addsub
       (.A(A),
        .ADD(ADD),
        .B(B),
        .BYPASS(1'b0),
        .CE(1'b0),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_xst_addsub_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
dmmXCzwxW2FLu/vVGpJzoQ/uTl0t/oirVzDN8rGCQ/cshHIr5KZa8hMP1zjDcrW6js/9tSBuCaB1
Ioj63zjqZA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
N9Ijk+dhcsedFOz7GhClRR68iRquy2ZzjVLVhi5GByFuPpr/oGFn021AFcKE54GT1hqizIMvWGS0
qRbWSO/aiWGT8c930WMeayc4xm2b65tzi7UyXSjcZqyZqk5spgPewfSuL0LKD5R4+zccn3yeTyAR
Cpi6LZ2KmpRW5biXvss=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
M8NGALCMec7MmW5uPCxfU8HATjWU2XqyPU8phSDe3mtyor4pgfPtg5TJdKOytKhxa+fQwJxytwzI
KPxtYmaRH/KFiGrOvm7jO78NIlt31qN95S7sMYrLxORaZ4bbNMg4RfwEB0haV15qORczgxWEpvBX
6Qukl64ihp4NiBjXt4YYGoDiNMSczgOe3tLn7UWjfPQnsJ8aMxugelO5AciSBxAdohgLMRE3cu6p
gwakO6ytq1vAR8bqHLT8g/Kdsxn72SBHYdpkba0NfEvzzheOlZY7fNuWD48V6QefMjsX1taMkmQH
m38VdXlC6Ocia7H3zT8LvNLtxrpG8zyD+UI+sg==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
I1BukTJgP0oEpI/mdw6jwrYhUTr7MTzY5G/EvfuPKQfGzYRI1qLG+aEQeclA1P65+tkbstBEIIg8
ZhiouPVaom8KwKZHBX7eLpxvNBcYVFfnJb1ES5wdcph3sgGtaYKSpspp51oYPM6ZD7DmMGdoc/Wg
JVIUuIfRpo8AnEMfkayPkbwuB0VUKpz5BXS50B+5jvgK7cFe2gUp2ckThqzKUjViVB56Swsz+IQe
l7GvtTbuNcSwapfPtNHH0bWSQStfIzPZZm1A2IZ2WCYafRPkj7uibtKNgnKgIZs1197qomgXbb+b
fDx1iikgF8snJsPchukmgxkMSQtLntwbLs6H+w==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UNzBll4hVdQjkp7KJChMHZ9agdKjtTu8+3O75Phz7SpwUZ73Z533+9pCfaH7QI/cwqaVREb20HXT
ji2kU1DV7+Cwbshd08hvUBl23F60ITYS+3rluBLIFX3pzXhjjSu8HQpnxXppbCODvCiWrDLqRU/y
lcFf7B+yp5jK6vEY5xuh8is/oxSPNFwip6GSMqDnE45GU6kU+6n8FTk8pAZUNKnh3j0t6YzcwS3J
wYUhnJpEQYd7+0D/NPjEz0YFqzB8WCh70MxBRJzwdXpuRLiFzplysvw+eHjMPVeU/UPKJWuwWuwc
Bfxw0ThSXZit/SSD+BGhxjbEI9T6rh66FpqbTg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
F7AZy6dB5VKzcudhyRSKWKUbVrSs4vS9jtgDkM6KrVPs3ghP3AF2TeIDyl03EesBxeIQxHqq8thx
uVIGQN5wt92jkzGo61VyUoF2dYHY2dkK9PY4bicayI6rppCS18HnyCC5ODrTMKgOpoj+PEmghCZl
j8+i3NFWPAo6M/MAtVI=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NQpRHEO/CEh2TWVl2zAKLb4TTDP4G4mQHrGzJeErDNbJ2L2B4iz3unsCjzHkoDagHoU9jeHYNzw1
EdgeGwokAwsWnHc0V18iEu5CZPPLrncpORhuc7qe0zJvoIFW4tgNZuIjFZI6bkrWzgxNYlkitGJ7
wQxgR+6ZenldybAjVF7d1R8FQmrEKWQ9ztmGHKMd9PfWD1VsbOoxbNA1tkQ3Suq2M9HDzUONaPQq
yMnGxLE4+4xTZZFVVFZeizNxqQcM1Y6s2MEUyS89U6rdAH95x9zDN8PGrif1SUWhpoz33cYp/IL8
acGyIWDbmuS0X+xsLC8cWcrO/MxKDk8bj12S7g==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
W2ZLxVMM2bO/6hqe8KRsBOYby+akb1JiKHhCv9fhS2DK483JVHKKDFtV5ZylpQSPfpmWVI6nDnNm
XtxOYqhOdd9wAHIVXly/nJQ3BORIgR42ZfKk3tkiYQd75XwTJmWjvIda5LTjKISy58Rg+7/yc6kX
SAKkQWzcaHy0VIrsbeLAK7Rz2vPrBQAwZijqUO1uD9pTa1ID2lBqRKOaN/lex50cPJ7PNmyesOUe
aisZi7+ubKWoKmZJmdUy4nKUk4a0FLkIqdFpmX+Bu5UVgWOF47nrEwh3c1MVRxWa1uvngQGGl026
FTa0G+nc1Q9KslAvMQ+fMbz+FbnTF3u/A9gizA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
R2Kr5sta5naLKfcmjcehOUaAzP8LlgzPOPb4Gi+U5ARuPEpokT6brj6DXCsLIS3cr4D/szSzH9Ym
THJWc295OMm7v3KtzFR5ZaG2K8KfnjcEOPhCKNGqsaRT5TUUDIOMGIiuFcp4KC+U+MaX++xgxmYU
HQpCRDBmphZDdS5Fqa0J5ad2mHhzo0oGaVriDLKNy78lzWdaIwfyPfr8c9a2A2Ojjh5d2bPSASbz
InOyA+X8VMk4MC7UBLs0DU7/x1hWMw1Mu+KXKCt4d3/mp81hlCj05RwQ7CKsJDFwHi/yyx8Nhg7Z
SBMoGeSwLA02jwiiOuTyM/8FLgWYUL49Npg+Pw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Eq6qWU2yMHh+rEMuVxXCdsCv2TvkjlbaRBYlbS3+yQKl8VNoowVM8bPf8GM5vS0Y23DkhGfEogjm
sUmQ7hkA2DMDHpkNazK4tshsTxXYBP106O/reJS8Brhkqak89Y0/VunuZgkr0Bo3wCONsaNvTzqq
ARlMkhPAHGMG6CaGC8nzpvnDwFaqvsOY5V4sucHOUOjFTVFQTowRdTv4al4aMnpQmQtRbwr2Ru5i
Aq0tUT+ploJBsOcX1khoDTPUiEJeOFI2pskl7BGCk95JjjiyvrD3NRX0vV+dNuplUlws/8NpBnCs
A/Xm+Bw5a5I+eIeVsxblXDDPRaViFMjpdsPkYw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 12080)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
