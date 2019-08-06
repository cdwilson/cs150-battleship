//-----------------------------------------------------------------------
//	File:		$RCSfile: bin2HexLED.v,v $
//	Version:	$Revision: 1.3 $
//	Desc:		Binary to 7segment LED converter module
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2003 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: bin2HexLED.v,v $
//	Revision 1.3  2004/07/02 00:14:02  Administrator
//	Fixed minor typos
//	
//	Revision 1.2  2004/06/17 18:59:56  Administrator
//	Added Proper Headers
//	Updated Parameters and Constants
//	General Housekeeping
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		Bin2HexLED
//	Desc:		This module is a pretty simple behavioural ROM
//			which can be used to convert 4-bit binary into
//			7segment driver signals.
//	Output Format:	[6:0] = {gfedcba}
//				   a
//				  ---
//				f|   |b
//				  ---
//				e| g |c
//				  ---
//				   d
//-----------------------------------------------------------------------
module Bin2HexLED(Bin, SegLED);
	//---------------------------------------------------------------
	//	I/O
	//---------------------------------------------------------------
	input	[3:0]		Bin;
	output	[6:0]		SegLED;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Regs
	//---------------------------------------------------------------
	reg	[6:0]		SegLED;
	//---------------------------------------------------------------
  
	//---------------------------------------------------------------
	//	Converter ROM
	//---------------------------------------------------------------
	always @ (Bin) begin
		case (Bin)
			4'h0: SegLED <= 7'b0111111;
			4'h1: SegLED <= 7'b0000110;
			4'h2: SegLED <= 7'b1011011;
			4'h3: SegLED <= 7'b1001111;
			4'h4: SegLED <= 7'b1100110;
			4'h5: SegLED <= 7'b1101101;
			4'h6: SegLED <= 7'b1111101;
			4'h7: SegLED <= 7'b0000111;
			4'h8: SegLED <= 7'b1111111;
			4'h9: SegLED <= 7'b1100111;
			4'hA: SegLED <= 7'b1110111;
			4'hB: SegLED <= 7'b1111100;
			4'hC: SegLED <= 7'b1011000;
			4'hD: SegLED <= 7'b1011110;
			4'hE: SegLED <= 7'b1111001;
			4'hF: SegLED <= 7'b1110001;
		endcase
	end
	//---------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------