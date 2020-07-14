// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Jun 29 11:21:18 2020
// Host        : fpga running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/fpga/project_fixed/project_fixed.runs/gauss_subtracter_synth_1/gauss_subtracter_sim_netlist.v
// Design      : gauss_subtracter
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "gauss_subtracter,c_addsub_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_14,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module gauss_subtracter
   (A,
    B,
    CLK,
    S);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [41:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [47:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF s_intf:c_out_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 s_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME s_intf, LAYERED_METADATA undef" *) output [47:0]S;

  wire [41:0]A;
  wire [47:0]B;
  wire CLK;
  wire [47:0]S;
  wire NLW_U0_C_OUT_UNCONNECTED;

  (* C_ADD_MODE = "1" *) 
  (* C_AINIT_VAL = "0" *) 
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "42" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_BYPASS_LOW = "0" *) 
  (* C_B_CONSTANT = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "000000000000000000000000000000000000000000000000" *) 
  (* C_B_WIDTH = "48" *) 
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
  (* C_OUT_WIDTH = "48" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  gauss_subtracter_c_addsub_v12_0_14 U0
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
(* C_A_WIDTH = "42" *) (* C_BORROW_LOW = "1" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_CONSTANT = "0" *) (* C_B_TYPE = "0" *) (* C_B_VALUE = "000000000000000000000000000000000000000000000000" *) 
(* C_B_WIDTH = "48" *) (* C_CE_OVERRIDES_BYPASS = "1" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_C_OUT = "0" *) (* C_HAS_SCLR = "0" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "1" *) (* C_LATENCY = "2" *) 
(* C_OUT_WIDTH = "48" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_addsub_v12_0_14" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module gauss_subtracter_c_addsub_v12_0_14
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
  input [41:0]A;
  input [47:0]B;
  input CLK;
  input ADD;
  input C_IN;
  input CE;
  input BYPASS;
  input SCLR;
  input SSET;
  input SINIT;
  output C_OUT;
  output [47:0]S;

  wire \<const0> ;
  wire [41:0]A;
  wire ADD;
  wire [47:0]B;
  wire CLK;
  wire [47:0]S;
  wire NLW_xst_addsub_C_OUT_UNCONNECTED;

  assign C_OUT = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_ADD_MODE = "1" *) 
  (* C_AINIT_VAL = "0" *) 
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "42" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_BYPASS_LOW = "0" *) 
  (* C_B_CONSTANT = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "000000000000000000000000000000000000000000000000" *) 
  (* C_B_WIDTH = "48" *) 
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
  (* C_OUT_WIDTH = "48" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  gauss_subtracter_c_addsub_v12_0_14_viv xst_addsub
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
b1LD0wQG2TvngF7zCUkCOQh8SQoQWS9PqycgTNCKbbumh+JZxY953SDerSr65nwn387A9Du5s2mP
YhRDXx/aPEKu7LgxU42e3W6AToaMfcmeVpLtoeyjtJHL5nwsQbO7LqpOeMs196jKtEK88kVLQOQG
oXjEUwAHhKuqLImgzG23fOp5ABbuKIAtinqvQgSf1ogKPFfeqcL6q4j3z1y1D/Vmd3pVIdmRd+//
zzmbG5oJjfCGxa9x20+ZqfWlPSUx0zBx4dPcVAOWtIdwMDCqr8WZxA9dHOS/TE6l5SJWAS4YcIy0
6jt3JlBGKvQbmuFm9vqO8daJr+7Djl2XqfsB8A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
q7v2Vy/c05HPhMHMPh+aA+Qc+lsBlFXG1GtqUxA8RvTLWVwFCVElr8FFFZChknLCHBxz9jCy8VaU
BBl/F0KEyKlNNOdMDZoHGy8J9f89PNWyNxz6syIvKz6Ar5yIBpKEWJ4VFdw7Zm+MjrXH1T2MQww7
kjrjdsuFiOTtMjC5os+HUIndZALVbLni4tY+IRV/QppjsGmsv/MHaPwiyyh2uFvOyLMuJF+u+NLx
ABQrD0aH4ppCIrbOsxrnoG4CU0zVmaO0YeapA4fOaAChuER+D0S07zcHsAqzI4e/FwE0t1MhSpOO
7IteqF3BiSDo6fEr3DlKlK4dMjs86FVbJ4o8yQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 10848)
`pragma protect data_block
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
RF44Zn1jo0zyI6u0ubNI12X5
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
