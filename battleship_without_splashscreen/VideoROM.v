//-----------------------------------------------------------------------
//	File:		$RCSfile: VideoROM.v,v $
//	Version:	$Revision: 1.2 $
//	Desc:		ITU656/601 Video Test ROM
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2003 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: VideoROM.v,v $
//	Revision 1.2  2004/10/05 20:00:16  Administrator
//	Fixed module name bug
//	
//	Revision 1.1  2004/10/05 19:56:01  SYSTEM
//	Initial Import
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Includes
//-----------------------------------------------------------------------
`include "Const.v"
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		VideoROM
//	Desc:		This module generates a series of solid color
//			bars as a test pattern.
//	Params:		totallines:	The total number of video lines
//					to output.
//			activelines:	The total number of active video
//					lines to output
//			f0topblank:	The number of vertical blanking
//					lines to insert above the active
//					portion of the 0 (Odd) field.
//			hblanksamples:	The number of samples (16bit
//					words) per line which are
//					blanking.  Includes SAV/EAV
//			activesamples:	The number of active video samples
//					per line.
//-----------------------------------------------------------------------
module	VideoROM(	//-----------------------------------------------
			//	System Inputs
			//-----------------------------------------------
			Clock,
			Reset,
			//-----------------------------------------------

			//-----------------------------------------------
			//	Video Data Host Interface
			//-----------------------------------------------
			DOut,
			OutRequest,
			OutRequestLine,
			OutRequestPair
			//-----------------------------------------------
		);
	//---------------------------------------------------------------
	//	Parameters
	//		These could theoretically change if we changed
	//		the video format.  We don't expect you to plan
	//		for that.  You may assume these are CONSTANTS!
	//---------------------------------------------------------------
	parameter		totallines =		525,	// Total number of video lines
				activelines =		507,	// Number of active video lines
				f0topblank =		6,	// Number of blank lines at the top of Field0
				hblanksamples =		138,	// Number of blank samples per line
				activesamples =		720;	// Number of active samples per line
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Constants
	//---------------------------------------------------------------
	`ifdef MACROSAFE
	localparam		oddlines =		totallines >> 1,
				evenlines =		totallines - oddlines,
				evenactive =		activelines >> 1,
				oddactive =		activelines - evenactive,
				oddtopblank =		f0topblank,
				eventopblank =		f0topblank + 1,
				oddbottomblank =	oddlines - oddactive - oddtopblank,
				evenbottomblank =	evenlines - evenactive - eventopblank,
				hblankbytes =		(hblanksamples * 2) - 8,
				activebytes =		(activesamples * 2),
				vcbits =		`log2(oddactive),
				hcbits =		`log2(activebytes);
	`endif
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	System Inputs
	//---------------------------------------------------------------
	input			Clock, Reset;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Video Data Host Interface
	//---------------------------------------------------------------
	output	[31:0]		DOut;
	input			OutRequest;
	input	[vcbits:0]	OutRequestLine;
	input	[hcbits-3:0]	OutRequestPair;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Regs
	//---------------------------------------------------------------
	reg	[31:0]		DOutRaw;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Test Video Generator
	//---------------------------------------------------------------
	always @ ( * ) begin
		if ((OutRequestLine < 9'h024) || (OutRequestLine > 9'h1C3)) DOutRaw =	32'h286e28ef;
		else if (OutRequestLine < 9'h0FD) begin
			if (OutRequestPair < 9'h024) DOutRaw =			32'h286e28ef;
			else if (OutRequestPair < 9'h048) DOutRaw =		32'heb80eb80;
			else if (OutRequestPair < 9'h06C) DOutRaw =		32'h51ef515a;
			else if (OutRequestPair < 9'h090) DOutRaw =		32'h90229036;
			else if (OutRequestPair < 9'h0B4) DOutRaw =		32'h286e28ef;
			else if (OutRequestPair < 9'h0D8) DOutRaw =		32'hd291d210;
			else if (OutRequestPair < 9'h0FC) DOutRaw =		32'ha910a9a5;
			else if (OutRequestPair < 9'h120) DOutRaw =		32'h6add6ac9;
			else if (OutRequestPair < 9'h144) DOutRaw =		32'h10801080;
			else DOutRaw =						32'h286e28ef;
		end
		else begin
			if (OutRequestPair < 9'h024) DOutRaw =				32'h286e28ef;
			else if (OutRequestPair < 9'h048) DOutRaw =		32'h10801080;
			else if (OutRequestPair < 9'h06C) DOutRaw =		32'heb80eb80;
			else if (OutRequestPair < 9'h090) DOutRaw =		32'h51ef515a;
			else if (OutRequestPair < 9'h0B4) DOutRaw =		32'h90229036;
			else if (OutRequestPair < 9'h0D8) DOutRaw =		32'h286e28ef;
			else if (OutRequestPair < 9'h0FC) DOutRaw =		32'hd291d210;
			else if (OutRequestPair < 9'h120) DOutRaw =		32'ha910a9a5;
			else if (OutRequestPair < 9'h144) DOutRaw =		32'h6add6ac9;
			else DOutRaw =						32'h286e28ef;
		end
	end
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Output Register
	//---------------------------------------------------------------
	Register	DOReg(	.Clock(		Clock),
				.Reset(		Reset),
				.Set(		1'b0),
				.Enable(	OutRequest),
				.In(		DOutRaw),
				.Out(		DOut));
	defparam	DOReg.width =		32;
	//---------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------