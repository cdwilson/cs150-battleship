`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    20:41:23 01/27/06
// Design Name:    
// Module Name:    SpiFifo
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module SpiFifo(DataIn, WEn, REn,
               SrcAddrIn, DestAddrIn,
               EndSession, DiscardSession,
					DataOut, SrcAddrOut, DestAddrOut,
					NewData, Full,
					Clock, Reset);
	 input [7:0] DataIn, SrcAddrIn, DestAddrIn;
	 input WEn, REn,
          EndSession, DiscardSession,
			 Clock, Reset;
    output [31:0] DataOut;
	 output [7:0] SrcAddrOut, DestAddrOut;
	 output NewData, Full;

	 wire [4:0] pointerWrite, pointerWriteTemp, pointerOut;
    wire [2:0] pointerRead;

	 reg [7:0] dataRam[31:0], srcAddrRam[7:0], destAddrRam[7:0];
									
	 assign NewData = pointerWrite[4:2] != pointerRead;
	 assign Full = pointerWriteTemp == pointerOut - 1;
	 assign pointerOut = {pointerRead - 1, 2'b0};
	 assign DataOut = {dataRam[pointerOut], dataRam[pointerOut + 1],
			             dataRam[pointerOut + 2], dataRam[pointerOut + 3]};
	 assign SrcAddrOut = srcAddrRam[pointerRead - 1];	 						
	 assign DestAddrOut = destAddrRam[pointerRead - 1];	 

	 Register regWrite(.Clock(Clock), .Reset(Reset),
	                   .Set(1'b0), .Enable(EndSession),
				          .In(pointerWriteTemp), .Out(pointerWrite));
    defparam regWrite.width = 5;

	 Counter counterRead(.Clock(Clock), .Reset(Reset),
	                     .Set(1'b0), .Load(1'b0),
				            .Enable(REn), .In(3'b0),
				            .Count(pointerRead)),
				counterWrite(.Clock(Clock), .Reset(Reset),
	                      .Set(1'b0), .Load(DiscardSession),
				             .Enable(WEn & ~Full), .In(pointerWrite),
				             .Count(pointerWriteTemp));
    defparam counterRead.width = 3,
	          counterWrite.width = 5;

    always @ (posedge Clock)
	    if (WEn & ~Full) begin	
		    dataRam[pointerWriteTemp] = DataIn;
			 srcAddrRam[pointerWriteTemp[4:2]] = SrcAddrIn;
			 destAddrRam[pointerWriteTemp[4:2]] = DestAddrIn;
       end
		
endmodule
