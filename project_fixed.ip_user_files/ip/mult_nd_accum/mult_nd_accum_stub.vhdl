-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Wed Jun 24 09:36:57 2020
-- Host        : fpga running 64-bit Ubuntu 18.04.4 LTS
-- Command     : write_vhdl -force -mode synth_stub -rename_top mult_nd_accum -prefix
--               mult_nd_accum_ accumulator_stub.vhdl
-- Design      : accumulator
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tfbg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mult_nd_accum is
  Port ( 
    B : in STD_LOGIC_VECTOR ( 47 downto 0 );
    CLK : in STD_LOGIC;
    BYPASS : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 47 downto 0 )
  );

end mult_nd_accum;

architecture stub of mult_nd_accum is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "B[47:0],CLK,BYPASS,Q[47:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "c_accum_v12_0_14,Vivado 2019.2";
begin
end;
