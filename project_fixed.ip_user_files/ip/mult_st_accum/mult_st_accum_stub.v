// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Jul  6 14:53:50 2020
// Host        : fpga running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/fpga/project_fixed/project_fixed.runs/mult_st_accum_synth_1/mult_st_accum_stub.v
// Design      : mult_st_accum
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_accum_v12_0_14,Vivado 2019.2" *)
module mult_st_accum(B, CLK, BYPASS, Q)
/* synthesis syn_black_box black_box_pad_pin="B[47:0],CLK,BYPASS,Q[47:0]" */;
  input [47:0]B;
  input CLK;
  input BYPASS;
  output [47:0]Q;
endmodule
