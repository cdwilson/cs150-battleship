//-----------------------------------------------------------------------------
// Copyright (c) 1999-2006 Xilinx Inc.  All rights reserved.
//-----------------------------------------------------------------------------
// Title      : ICON Core Synplicity Synplify Usage Example
// Project    : ChipScope
//-----------------------------------------------------------------------------
// File       : icon_synplicity_example.v
// Company    : Xilinx Inc.
// Created    : 2002/03/27
//-----------------------------------------------------------------------------
// Description: Example of how to instantiate the ICON core in a Verilog 
//              design for use with the Synplicity Synplify synthesis tool.
//-----------------------------------------------------------------------------

module icon_synplicity_example
  (
  );


  //-----------------------------------------------------------------
  //
  //  ICON core wire declarations
  //
  //-----------------------------------------------------------------
  wire [35:0] control0;


  //-----------------------------------------------------------------
  //
  //  ICON core instance
  //
  //-----------------------------------------------------------------
  icon i_icon
    (
      .control0(control0)
    );


endmodule


//-------------------------------------------------------------------
//
//  ICON core module declaration
//
//-------------------------------------------------------------------
module icon 
  (
      control0
  ) /* synthesis syn_black_box syn_noprune=1 */;
  output [35:0] control0;
endmodule

