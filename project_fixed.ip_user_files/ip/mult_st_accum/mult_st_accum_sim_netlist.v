// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Jul  6 14:53:50 2020
// Host        : fpga running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/fpga/project_fixed/project_fixed.runs/mult_st_accum_synth_1/mult_st_accum_sim_netlist.v
// Design      : mult_st_accum
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_st_accum,c_accum_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_accum_v12_0_14,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mult_st_accum
   (B,
    CLK,
    BYPASS,
    Q);
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [47:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF q_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 bypass_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME bypass_intf, LAYERED_METADATA undef" *) input BYPASS;
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME q_intf, LAYERED_METADATA undef" *) output [47:0]Q;

  wire [47:0]B;
  wire BYPASS;
  wire CLK;
  wire [47:0]Q;

  (* C_ADD_MODE = "0" *) 
  (* C_AINIT_VAL = "0" *) 
  (* C_BYPASS_LOW = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_WIDTH = "48" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_BYPASS = "1" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_C_IN = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "2" *) 
  (* C_OUT_WIDTH = "48" *) 
  (* C_SCALE = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_st_accum_c_accum_v12_0_14 U0
       (.ADD(1'b1),
        .B(B),
        .BYPASS(BYPASS),
        .CE(1'b1),
        .CLK(CLK),
        .C_IN(1'b0),
        .Q(Q),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADD_MODE = "0" *) (* C_AINIT_VAL = "0" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_TYPE = "0" *) (* C_B_WIDTH = "48" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "1" *) (* C_HAS_CE = "0" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_SCLR = "0" *) (* C_HAS_SINIT = "0" *) (* C_HAS_SSET = "0" *) 
(* C_IMPLEMENTATION = "1" *) (* C_LATENCY = "2" *) (* C_OUT_WIDTH = "48" *) 
(* C_SCALE = "0" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_accum_v12_0_14" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mult_st_accum_c_accum_v12_0_14
   (B,
    CLK,
    ADD,
    C_IN,
    CE,
    BYPASS,
    SCLR,
    SSET,
    SINIT,
    Q);
  input [47:0]B;
  input CLK;
  input ADD;
  input C_IN;
  input CE;
  input BYPASS;
  input SCLR;
  input SSET;
  input SINIT;
  output [47:0]Q;

  wire [47:0]B;
  wire BYPASS;
  wire CLK;
  wire [47:0]Q;

  (* C_ADD_MODE = "0" *) 
  (* C_AINIT_VAL = "0" *) 
  (* C_BYPASS_LOW = "0" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_WIDTH = "48" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_BYPASS = "1" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_C_IN = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "2" *) 
  (* C_OUT_WIDTH = "48" *) 
  (* C_SCALE = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_st_accum_c_accum_v12_0_14_viv i_synth
       (.ADD(1'b0),
        .B(B),
        .BYPASS(BYPASS),
        .CE(1'b0),
        .CLK(CLK),
        .C_IN(1'b0),
        .Q(Q),
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
VRjbrumI5QwwG4NPsV5wx/UTP36b1G+35WFbg4l8078kBcdvnEt1CMonxlNPUOLUbVgETl/spmxz
lB7lvlXXmA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oC/u7anfrbTCqY/e2tfho/ocvSPJdGHP9gHmvgBjowzyw/CDN55ht9v6JREG1x3Ul56KUQ4ZrI3r
IPKmIPfQJGH5d0nOlkq0+xQZfXEjIgbtTCpm6EFxmAA/11OGX8HDJTrl117qGbrJl+4PiMXKu0l7
ZpG66TKdAAxRqOtEAcs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ow+CiOFBeMDdBvVETHqMVzibZzhnkv9ahWGlXMHQ+MiOlst7SuEDI22SJ66sHa5NbwjCIsby/Dhg
FbnBUcmCqKtm6WjO2F3LWpVPuZrBxWu8ozKOziSfbSH99QNsrAIDifUwqcinNjprTNISNGCozAmv
RiLwzKbSQ6B5r+pC1eE+eIXJHAoRuUY8Dp2f7ihRg5deTNrdP9BTiMn+YOh9vhFEgyw5CafJdpF+
d3nyeXqhrhQrLAll5DlQScqalr0knuZ4zNM4mywTRYhDlP6OUCZkdyiH5IORwPMs5isx95zQpXvM
WLHl5mVOcO9kDhNyICFZojy2eBCIdGxqIY8m1g==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HN9fM9be06hjgyvP4d3MBCDJAKuXMpjV8RA6a4ElZkr8Df8GjN7DIp9CskkB/Hvs57s62hpGPA+w
BsHApTS20kYQnq88Pzc3W3KcJjYuF1jWIwMOwHnLs5jfNVfbdW8ip7oBQYakWpDb1dBOLSSYSDsO
ruBJJRZMvWYhrbTvFpo7CYBavCPJsNVzEbC3SIHmFwj/wkNKn0kIfRYTGUWXGMMOAlBLtbbDOay6
t8MsEY1xbtDlpcL/xkFt3RtTwdBgNFD09G1+igCVURJZNriD04noXRjWmCwhM7SM5zhHJWx4PQR9
khLmUS50dJu4osYT0jmnmc1iHReJNvjIoQzydw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
O4nQscBPLUk/ICBj46Uw4+E/M+4g69rKWllLPrgtTT40dNLn3IwHRzJnc0ZHo+rx1vjvc19E+/5s
2ETbFYHU+QSmsHRX+Hwc3MeRrPj3CFDsBugTT3K6zi0JnrWtPBVYX/r2/eKyB6ya+Rpvivqn86jc
L1Hhe7e5VshL+rutXEzuDLeWRfbYRhk2+pjAtfLT0zvoWV90xEXyJQtgG1ehVndZ7bZ9UZ+TA5KH
iSA1hIj9h6w3ClO2FZ3rajLUSNkM6lEQPKVU9UT343q5FNOp7fOctGU+uSDE1Jpl8NCXRdUKbvT1
VoDak5YGfItyq8Wpt8Jfbp83c/5BTu77oXfwlw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
UZa+tri2XEScH4pHDNWaKoATLq+q1pbn0NSDzoDPJ9959zq2nhXMRnt1rNSmSWuFn1eTqeQ2ZkZR
nY8qG3AG65PcnVaklptchBDxwq64vrkVUrC2+8I9Eat4k7sMEKXmfLvzzsFX9EWk7m3oYKeqVBQP
HRjM5qmxUGBX5JRb58k=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XBXBNsCJVuD5OuVgwUgRIAugKirHV34YNyO8qMgOJ+EGoKDJ30Zad/dtlPIsLWhDMrrqg9MkmkRq
WkQT540PPJ1W/E41iNj9KeCUDHs/sjjVxXJHVus2gJwXtomY9d/Q2Z9R9YcsK1iQ3CKC641zB4r3
+Zp0Bx7+BRInWtPvgdUOZHJUDO8bz9VC0GoYzC7dOEkq3P4hNOTKNsUhe2ACyWesyYI90KCPNyaV
HvIdwm2e3pO8lwB0PGjB77NT5qQRszibcOgMQ0sw5BP4p8Fxr+V/IvFELocGlJdGIHZDDG9Cghwj
eqWqocWuEdoY5saE5j0Y9VQZHnQmbLcZlPLgOw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
IWTvsZ5gsEqGA2h5e592JNgK+oHdzLJMgMZDPhdFQLBoDUCyBnAEOllIq7FX0lYekPOXcyJoMGKJ
w+mGrRGglesfpYtY+agRUF9GGGf+6GCeoCKyPZwIb/7NO9SHALwhjrbtf+ksQRchXEa09SpNKY1w
nPVyXpamp/cMDNxYipg2PNajnlQUFqtSzaMNe5TL/L0GfcPk1qBkButd6cUnLbuUVUnq5yUFihkZ
0I9pUf4Z1PkkS875RXPsWDh4/QXbTg45LOwPC6kAOhU27U1Naie3poZJQhopNCiaRdarpLB+2BOj
0fdeTaANIWDFkT3WFxon3KMBq//t2+qTJnurAQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YCXKQRqXMbLp1OjaKCQ9SCA5S8c9N3mIgnsK+dGXw3vmB5oBM/1PAk6VHw5AOyL0G6V/Cr3rAaIW
HiRxJai0A157ZqXacFVrVssE9/jLdDqFHJA8fNLHphZC086+RLB9WJVN6tx2mioZSqPaQ9TflS/O
b/07shE3fA54dnNizbC2UzV9I5wY3DXjqtJP0I8tuWscxUnKWkpzFM6rG4suH1Ln/CDiIiDEzLNc
ezd5VNsb5WhLzvkOKqighViW3sOw6pbPguFyQUXs9gl7E2YJ6YnT1kbJE8WFSS4LMOspFDyjmwLJ
UxMARCMEvUFu/04IV6SbchE3cxKYwA7IyrNAzQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DnIRmUWMX0QxnEYLiIrfDXWq7GDHODwh9Za0UMKNXYO4UthzekTRab2bMZtw+Dc1+ZPHwr379e4W
n3qejgqCVdzdZaC3i82sqKYJJ0w8CwoLbfLGsxGNMfz3+bd3rTx982VNz6HozUQOQUdZGIRpsL3n
ikBWPgdmeyzKKRAEveaw5aH0U1DUKImikslWF74OhOuuEGyatYI4X0NhgNIHv0aDmpHDt7fy1sWg
CdcJQUNrFHXL5CcRO5UZVcAH9l8KcpkV2TjpVi47hHRosG+OoXgjlkU3c+cC1umQHG6TEM2xIPc/
xI9xzaBoaGy3keY55hwHV0spLTFjFxYhZA9HiA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 10144)
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
