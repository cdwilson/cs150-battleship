//-----------------------------------------------------------------------------
// Copyright (c) 1999-2006 Xilinx Inc.  All rights reserved.
//-----------------------------------------------------------------------------
// Title      : ILA Core Synplicity Synplify Usage Example
// Project    : ChipScope
//-----------------------------------------------------------------------------
// File       : ila_synplicity_example.v
// Company    : Xilinx Inc.
// Created    : 2002/03/27
//-----------------------------------------------------------------------------
// Description: Example of how to instantiate the ILA core in a Verilog 
//              design for use with the Synplicity Synplify synthesis tool.
//-----------------------------------------------------------------------------

module ila_synplicity_example
  (
  );


  //-----------------------------------------------------------------
  //
  //  ILA Core wire declarations
  //
  //-----------------------------------------------------------------
  wire [35:0] control;
  wire clk;
  wire [129:0] trig0;


  //-----------------------------------------------------------------
  //
  //  ILA core instance
  //
  //-----------------------------------------------------------------
  ila i_ila
    (
      .control(control),
      .clk(clk),
      .trig0(trig0)
    );


endmodule


//-------------------------------------------------------------------
//
//  ILA core module declaration
//
//-------------------------------------------------------------------
module ila
  (
    control,
    clk,
    trig0
  ) /* synthesis syn_black_box syn_noprune=1 */;
  input [35:0] control;
  input clk;
  input [129:0] trig0;
endmodule

