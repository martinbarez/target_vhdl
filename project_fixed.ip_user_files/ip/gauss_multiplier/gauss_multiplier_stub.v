// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Mon Jul  6 15:18:23 2020
// Host        : fpga running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/fpga/project_fixed/project_fixed.runs/gauss_multiplier_synth_1/gauss_multiplier_stub.v
// Design      : gauss_multiplier
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *)
module gauss_multiplier(CLK, A, B, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[41:0],B[34:0],P[100:0]" */;
  input CLK;
  input [41:0]A;
  input [34:0]B;
  output [100:0]P;
endmodule
