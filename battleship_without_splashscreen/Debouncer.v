//-----------------------------------------------------------------------
//	File:		$RCSfile: Debouncer.v,v $
//	Version:	$Revision: 1.6 $
//	Desc:		Hysteresis Debouncer, Used to clean up signals
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2003 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: Debouncer.v,v $
//	Revision 1.6  2004/08/10 18:30:20  Administrator
//	Fixed swidth->simwidth typo
//	
//	Revision 1.5  2004/07/30 21:15:20  Administrator
//	Reformatted
//	
//	Revision 1.4  2004/06/25 23:11:45  Administrator
//	Added enable signal (for slow clocking)
//	
//	Revision 1.3  2004/06/18 23:28:46  Administrator
//	Fixed minor typo (swidth -> simwidth)
//	
//	Revision 1.2  2004/06/17 18:59:56  Administrator
//	Added Proper Headers
//	Updated Parameters and Constants
//	General Housekeeping
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Includes
//-----------------------------------------------------------------------
`include "Const.v"
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		Debouncer
//	Desc:		A hysteresis loop based debouncer.  This module
//			will ensure that a noisy signal is at least
//			somewhat clean before passing it back out.  It
//			provides the digital equivalent of inertia...
//	Params:		width:		This is the width of the counter
//					core of the debouncer.  It will
//					require 2^width cycles for the
//					output to change, assuming no
//					bouncing
//			simwidth:	This is the value used instead of
//					width for simulation.
//-----------------------------------------------------------------------
module	Debouncer(In, Out, Clock, Reset, Enable, Half);
	//---------------------------------------------------------------
	//	Parameters
	//---------------------------------------------------------------
	parameter		width =			16,
				simwidth =		4;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	System Inputs
	//---------------------------------------------------------------
	input			Clock, Reset, Enable;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Noisy Input/Clean Output
	//---------------------------------------------------------------
	input			In;
	output			Out;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Half Hysteresis Signal
	//		Used to prevent related debouncer signals from
	//		being asserted.
	//---------------------------------------------------------------
	output			Half;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Registers
	//---------------------------------------------------------------
	reg			Out;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Count Register
	//		Note the differing bitwidths based on whether
	//		this is a simulation.
	//---------------------------------------------------------------
`ifdef SIMULATION
	reg	[simwidth-1:0]	Count;
	assign	Half =				Count[simwidth-1];
`else
	reg	[width-1:0]	Count;
	assign	Half =				Count[width-1];
`endif
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Simulation of Startup in Valid State
	//---------------------------------------------------------------
	// synthesis translate_off
	initial Count = 0;
	// synthesis translate_on
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Limited Up/Down Counter
	//---------------------------------------------------------------
	always @ (posedge Clock) begin
		if (Reset) Count <=						0;
		else if (Enable) begin
			if (In && (~&Count)) Count <=				Count + 1;
			else if (~In && |Count) Count <=			Count - 1;
		end
	end
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Hysteresis/Limit Detector
	//---------------------------------------------------------------
	always @ (posedge Clock) begin
		if (Reset) Out <=						In;
		else if (Enable) begin
			if (&Count) Out <=					1;
			else if (~|Count) Out <=				0;
		end
	end
	//---------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------