//-----------------------------------------------------------------------
//	File:		   SPI.v
//	Version:	   1.0
//	Desc:		   SPI skeleton file for use with provided
//                         SPI.edn blackbox.
//	Author:		David T. Lin
//	Copyright:	Copyright 2006 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------


module SPI(InValid, In, InRequest, Clock, Reset, SI, SClk, CS_, SO, NewData, Out);
    input InValid, Clock, Reset, SO;
    input [7:0] In;
    output InRequest, SClk, CS_, NewData, SI;
	 output [7:0] Out;
endmodule
