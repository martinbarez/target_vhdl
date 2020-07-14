// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Wed Jun 24 09:36:57 2020
// Host        : fpga running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode funcsim -rename_top mult_nd_accum -prefix
//               mult_nd_accum_ accumulator_sim_netlist.v
// Design      : accumulator
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "accumulator,c_accum_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_accum_v12_0_14,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mult_nd_accum
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
  mult_nd_accum_c_accum_v12_0_14 U0
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
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* downgradeipidentifiedwarnings = "yes" *) 
module mult_nd_accum_c_accum_v12_0_14
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
  mult_nd_accum_c_accum_v12_0_14_viv i_synth
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
XIMGdCsACs5Cd9pIxW+4zeBXYjlgbQ7jWc0USt2shytGjacR+mc/1VnlSvN5JW8uFD2E/O1fJ/HB
91fX22caO4F/y6lc1uCe+qi4bkmcEQqNnRND4aKMj/pXXZeQ8xfJceDN9cGKYyVN6DzTbdBm1WW9
toVPGeSd4MQHyieecNch2GudPoI7lCKxwYDMJvWZGAXbfh9BJVUPDdHaV2wh/R0g+xuMoCUX/3Vn
Fjn6ONtpK/tqtkX23eBlyZ+165UX27+kTh0cSjpcbftVh7/2nNvHVzoXA67dWMJzyXjN8HuC1gFO
thzdLwCWZ9xXbuZkQI3vREDp+j+MW5tk2A0kOQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
aAU5pGQNrGrboxG0cuLb51HyqFERL9X6rPwzeWBsz7kqRmR5g659vXrUjN54Ta47v6z7/uR3khPh
ETFq69wSVAoMyUojT01UUD2yqVNvhZjZiOAgaCcQ3c2zteOd16B2EWQ6//SPKrymoFKNPK4jXC6+
IzMgLJWIM9irerNrAkeereSZViryz+FzfsfQSeVaQZ8bFEjokGzD56XafEbfukF8uFOXJ2KKJj32
0W+StxEFlTgAh59QPk9UyzOlAmN8528Kr9+ODoeN9Znl8Hq19+1UbBiFExtMpwQGeYW6KywanBaW
68X2jo+MBK5Co9ul7H/hKaozEjhULGmPkJ+1lQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 10160)
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
