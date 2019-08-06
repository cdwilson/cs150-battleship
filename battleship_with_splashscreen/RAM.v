//-----------------------------------------------------------------------
//	File:		$RCSfile: RAM.V,v $
//	Version:	$Revision: 1.0 $
//	Desc:		A RAM module
//	Author:		Philip Godoy
//	Copyright:	Copyright 2006 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: RAM.V,v $
//	Revision 1.0  2006/02/18 21:29:56  Administrator
//	Added parameters
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:	RAM
//	Desc:		A RAM (random access memory).
//	Params:		width:	Sets the bitwidth of the words in the RAM
//					depth:	Sets the depth (# of words) in the RAM
//	Ex:		Are you kidding me?
//-----------------------------------------------------------------------
`timescale 1ns / 1ps
`include "Const.v"		// need this for "log2" function

module RAM(Clock, WE, WAddr, WData, RAddr, RData);

	parameter	depth = 256;
	parameter	width = 10;
	
	`ifdef MACROSAFE
	localparam	depthbits = `log2(depth);
	`endif

	 input						Clock;
	 input						WE;
    input [depthbits-1:0] 	WAddr, RAddr;
    input [width-1:0] 		WData;
	 output [width-1:0]		RData;

// Declare Memory
reg	[width-1:0]				RAM[0:depth-1];
//reg	[depthbits-1:0]		rIndex;

// Read from RAM (sync)
assign RData = RAM[RAddr];
//assign	RData =	RAM[rIndex];
					  
// Write to RAM (sync)
always @ (posedge Clock) begin
	if (WE)
		RAM[WAddr] <= WData;
	//rIndex <= RAddr;
end

endmodule
