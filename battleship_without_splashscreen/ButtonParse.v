//-----------------------------------------------------------------------
//	File:		$RCSfile: ButtonParse.V,v $
//	Version:	$Revision: 1.7 $
//	Desc:		Button Parser to clean up bouncy "human" inputs
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2003 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: ButtonParse.V,v $
//	Revision 1.7  2004/09/17 05:38:00  Administrator
//	Added edgeenable
//	
//	Revision 1.6  2004/07/30 21:15:20  Administrator
//	Reformatted
//	
//	Revision 1.5  2004/06/25 23:11:45  Administrator
//	Added enable signal (for slow clocking)
//	
//	Revision 1.4  2004/06/24 04:19:23  Administrator
//	Fixed begin/end match problems
//	
//	Revision 1.3  2004/06/23 22:44:20  Administrator
//	Added edgetype parameter
//	Added related parameter to allow this module to
//	function as a series of completely seperate button
//	parsers if so desired.
//	
//	Revision 1.2  2004/06/17 18:59:56  Administrator
//	Added Proper Headers
//	Updated Parameters and Constants
//	General Housekeeping
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		ButtonParse
//	Desc:		This is a highly parameterized module which can
//			be used to clean up groups of related buttons
//			used for human input.
//			This module essentially connects an edge detector
//			after a debouncer, one per-bit in the input bus.
//			However, by using a "Half" bus from the
//			debouncers this module can be used to decode
//			presses from combinations of buttons as long as
//			the original buttons and the derived "buttons"
//			are all fed in as seperate input bits.
//			The output from this module is one-hot when the
//			related parameter is 1.
//	Params:		width:		This sets the bitwidth of the
//					input and output busses.  Note
//					that the signals are assumed to
//					be related as described above.
//			edgewidth:	The total number of bits the
//					edge detectors should look at
//			edgeupwidth:	The number of edge bits which
//					must be high to signal an edge
//			debwidth:	This is the width of the counter
//					core of the debouncer.  It will
//					require 2^width cycles for the
//					output to change, assuming no
//					bouncing
//			debsimwidth:	This is the value used instead of
//					debwidth for simulation.
//			edgetype:	number	type
//					0	posedge
//					1	negedge
//					2	both
//					3	neither
//			related:	Binary flag specifying if the
//					input signals are related buttons
//					(when 1) or if they should be
//					treated seperately (when 0)
//			enableedge:	Forcibly enable the edge
//					detectors (Debouncers still use
//					Enable input)
//-----------------------------------------------------------------------
module ButtonParse(In, Out, Clock, Reset, Enable);
	//---------------------------------------------------------------
	//	Parameters
	//---------------------------------------------------------------
	parameter		width =			1,
				edgewidth =		3,
				edgeupwidth =		2,
				debwidth =		16,
				debsimwidth =		4,
				edgetype =		0,
				related =		1,
				enableedge =		0;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Button Group Interface
	//		Note that the buttons on the input bus are
	//		assumed to be related in that no two outputs
	//		will ever be asserted at the same time.
	//---------------------------------------------------------------
	input	[width-1:0]	In;
	output	[width-1:0]	Out;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	System Inputs
	//---------------------------------------------------------------
	input			Clock, Reset, Enable;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Intermediate Wires
	//		Debounced provides the debounced versions of the
	//		inputs, Half is used to ensure the output is one-
	//		-hot, even at human perception times...
	//---------------------------------------------------------------
	wire	[width-1:0]	Debounced;
	wire	[width-1:0]	Half;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Generated Instantiations
	//		Actually instantiate a debouncer and edge
	//		detector for each bit.  Notice the "Half" signal
	//		and how the constants will be optimized.
	//---------------------------------------------------------------
	genvar			i;
	generate for (i = 0; i < width; i = i + 1) begin:BP
			Debouncer	#(	.width(			debwidth),
						.simwidth(		debsimwidth))
					D(	.In(			In[i] & (related ? ~|(Half & ~(1 << i)) : 1'b1)),
						.Out(			Debounced[i]),
						.Clock(			Clock),
						.Reset(			Reset),
						.Enable(		Enable),
						.Half(			Half[i]));
			if (edgetype != 3) begin
				EdgeDetect	#(	.width(		edgewidth),
							.upwidth(	edgeupwidth),
							.type(		edgetype))
						ED(	.In(		Debounced[i]),
							.Out(		Out[i]),
							.Clock(		Clock),
							.Reset(		Reset),
							.Enable(	enableedge ? 1'b1 : Enable));
			end
			else begin
				assign	Out[i] =			Debounced[i];
			end
		end
	endgenerate
	//---------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------