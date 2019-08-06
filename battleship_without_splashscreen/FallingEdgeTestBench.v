//-----------------------------------------------------------------------
//	File:		$RCSfile: Lab1Testbench.v,v $
//	Version:	$Revision: 1.1 $
//	Desc:		Testbench for Lab1
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2003-2005 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: FallingEdgeTestBench.v,v $
//	Revision 1.1  2005/01/17 22:47:40  gdgib
//	Finished modifications from Fall 2004
//	Fully Tested
//	
//	Revision 1.4  2004/07/08 18:39:31  Administrator
//	Fixed formatting typos
//	
//	Revision 1.3  2004/07/02 23:44:11  Administrator
//	Added ActiveCycles macro to support timing simulation
//	
//	Revision 1.2  2004/07/02 20:32:18  Administrator
//	Changed module name to match filename
//	
//	Revision 1.1  2004/07/02 03:05:15  Administrator
//	Initial Import
//	Not tested
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Defines and Constants
//-----------------------------------------------------------------------
`timescale		1 ns/1 ps		// Display things in ns, compute them in ps
`define HalfCycle	18.518			// Half of the clock cycle time in nanoseconds
`define Cycle		(`HalfCycle * 2)	// Didn't you learn to multiply?
`define ActiveCycles	65536			// Change this to hold the buttons down for longer!
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		FallingEdgeTestBench
//	CUT:		FPGA_TOP2, Checkpoint1
//-----------------------------------------------------------------------
module FallingEdgeTestBench;
	//---------------------------------------------------------------
	//	Wires and Regs
	//---------------------------------------------------------------
	reg			Clock, Reset;

	reg			In;
	wire			Out;

	//---------------------------------------------------------------
	//	Clock Source
	//		This section will generate a clock signal,
	//		turning it on and off according the HalfCycle
	//		time, in this case it will generate a 27MHz clock
	//		THIS COULD NEVER BE SYNTHESIZED
	//---------------------------------------------------------------
	initial Clock =		1'b0;		// We need to start at 1'b0, otherwise clock will always be 1'bx
	always #(`HalfCycle) Clock =	~Clock;	// Every half clock cycle, invert the clock
	//---------------------------------------------------------------

	//--------------------------------------------------------------
	// CUT: FallingEdgeDetector
	//--------------------------------------------------------------
	
	FallingEdgeDetector FallingEdgeDetector( .Clock(Clock), .Reset(Reset), .In(In),	.Out(Out));

	//---------------------------------------------------------------
	//	Test Stimulus
	//		This initial block will periodically set new
	//		values for the inputs to the CUT.  By changing
	//		the values we can pretend that the circuit is on
	//		a CaLinx2 board and you are pressing the buttons.
	//		THIS COULD NEVER BE SYNTHESIZED
	//---------------------------------------------------------------
	initial begin
		In =			1'b0;	// Set the input value
		
		Reset =		1'b1;	// We're not currently pressing the reset button (active low)
		#(`Cycle * 20);			// Let 20 clock cycles go by...
						// This is important for the post place and route simulation
		Reset =		1'b0;	// Press the reset button (active low)
		
		In = 1'b1;
		#(`Cycle);
		#(`Cycle);
		In = 1'b0;
		#(`Cycle);
		#(`Cycle);
		In = 1'b1;
		#(`Cycle);
		#(`Cycle);
		#(`Cycle);
		In = 1'b0;
		#(`Cycle);
		#(`Cycle);
		
		
	end
	//---------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------