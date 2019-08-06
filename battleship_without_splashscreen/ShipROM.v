//-----------------------------------------------------------------------
//	File:		$RCSfile: ShipROM.v,v $
//	Version:	$Revision: 1.0 $
//	Desc:		ROM for dot matrix representation of Ship parts
//	Author:		David Chen
//	Copyright:	Copyright 2006 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: ShipROM.v,v $
//	Revision 1.0  2006/03/24 12:29:56  Administrator
//	Cleaned up code; Added parameters
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		ShipROM
//	Desc:		Dot matrix representation of ships
//	Params:		see below...
//-----------------------------------------------------------------------
`timescale 1ns / 1ps

//-----------------------------------------------------------------------
//    NOTE: This ShipROM assumes a specific data representation. You are
//          NOT required to use this module and, if you do, you are free
//          to modify it however you see fit.
//-----------------------------------------------------------------------

module ShipROM(Data, DotMatrix);
	input [9:0]		Data;

	//-----------------------------------------------------------------
	//    Ship representation:
	//
	//    +--------------------+---------------+-----+
	//    |     Ship Index     |     Type*     | Hit |
	//    +--------------------+---------------+-----+
	//
	//    * Where type is one of:
	//       blank, left tail, right tail, up tail, down tail,
	//       horizontal tail, vertical tail, or unknown
	//-----------------------------------------------------------------

	output [63:0]	DotMatrix;
	wire   [63:0]  DotMatrix;
	reg [63:0]		DotMatrixRaw;
	
	//-----------------------------------------------------------------
	//    Dot matrix representation of ship parts
	//-----------------------------------------------------------------
	always @( * ) begin
		case (Data[5:1])
		// No ship
		5'b00000:
		DotMatrixRaw = {8'b11111111,
							 8'b10000001,
							 8'b10000001,
							 8'b10000001,
							 8'b10000001,
							 8'b10000001,
							 8'b10000001,
							 8'b11111111};
		
		//TIE Left Horizontal
		5'b00001:
		DotMatrixRaw = {8'b00110000,
							 8'b01100011,
							 8'b11000111,
							 8'b11111110,
							 8'b11111110,
							 8'b11000111,
							 8'b01100011,
							 8'b00110000};


		//TIE Center Horizontal
		5'b00010:
		DotMatrixRaw = {8'b00000000,
							 8'b11000011,
							 8'b11100111,
							 8'b01111110,
							 8'b01111110,
							 8'b11100111,
							 8'b11000011,
							 8'b00000000};
							 
		//TIE Right Horizontal
		5'b00011:
		DotMatrixRaw = {8'b00001100,
							 8'b11000110,
							 8'b11100011,
							 8'b01111111,
							 8'b01111111,
							 8'b11100011,
							 8'b11000110,
							 8'b00001100};
									 
		//TIE Left Vertical
		5'b00100:	
		DotMatrixRaw = {	8'b00111100,
								8'b01111110,
								8'b11011011,
								8'b10011001,
								8'b00011000,
								8'b00111100,
								8'b01111110,
								8'b01100110};
		
		//TIE Center Vertical
		5'b00101:
		DotMatrixRaw = {8'b01100110,
							8'b01111110,
							8'b00111100,
							8'b00011000,
							8'b00011000,
							8'b00111100,
							8'b01111110,
							8'b01100110};

		//TIE Right Vertical
		5'b00110:	
		DotMatrixRaw = {8'b01100110,
							8'b01111110,
							8'b00111100,
							8'b00011000,
							8'b10011001,
							8'b11011011,
							8'b01111110,
							8'b00111100};
		
		
		//STAR1 Horizontal		
		5'b00111:
		DotMatrixRaw = {8'b00111100,
							 8'b01111100,
							 8'b01111001,
							 8'b01111111,
							 8'b10111111,
							 8'b11111111,
							 8'b01111111,
							 8'b00011111};
							 
		//STAR2 Horizontal
		5'b01000:
		DotMatrixRaw = {8'b00000000,
							 8'b00000000,
							 8'b11111111,
							 8'b11111111,
							 8'b11111111,
							 8'b00000000,
							 8'b11111111,
							 8'b11111111};
		
		//STAR3 Horizontal
		5'b01001:
		DotMatrixRaw = {8'b00000000,
							 8'b00000000,
							 8'b11100000,
							 8'b11111111,
							 8'b11111111,
							 8'b00000000,
							 8'b11111111,
							 8'b11110000};		
		//STAR4 Horizontal
		5'b01010:
		DotMatrixRaw = {8'b00000000,
							 8'b00000000,
							 8'b00000000,
							 8'b11111111,
							 8'b11111111,
							 8'b11111111,
							 8'b11100000,
							 8'b00000000};
		//STAR5 Horizontal
		5'b01011:
		DotMatrixRaw = {8'b00000000,
							 8'b00000000,
							 8'b00000000,
							 8'b11111110,
							 8'b11111110,
							 8'b00000000,
							 8'b00000000,
							 8'b00000000};
		//STAR1 Vertical		
		5'b01100: 	
		DotMatrixRaw = {	
								8'b00110000,
								8'b01101110,
								8'b11111111,
								8'b11111111,
								8'b11111111,
								8'b11111011,
								8'b11111000,
								8'b11111100};
		
		//STAR2 Vertical
		5'b01101: 	
		DotMatrixRaw = {	8'b11011100,
								8'b11011100,
								8'b11011100,
								8'b11011100,
								8'b11011100,
								8'b11011100,
								8'b11011100,
								8'b11011100};
		
		//STAR3 Vertical
		5'b01110: 	
		DotMatrixRaw = {	8'b11011100,
								8'b11011100,
								8'b11011100,
								8'b11011000,
								8'b01011000,
								8'b01011000,
								8'b01011000,
								8'b01011000};
		
		//STAR4 Vertical
		5'b01111: 	
		DotMatrixRaw = {	8'b01111000,
								8'b01111000,
								8'b01111000,
								8'b00111000,
								8'b00111000,
								8'b00111000,
								8'b00111000,
								8'b00111000};
		
		//STAR5 Vertical
		5'b10000: 	
		DotMatrixRaw = {	8'b00011000,
								8'b00011000,
								8'b00011000,
								8'b00011000,
								8'b00011000,
								8'b00011000,
								8'b00011000,
								8'b00000000};

		//Cursor
		5'b10001:
		DotMatrixRaw = {8'b01111110,
							 8'b11000011,
							 8'b10100101,
							 8'b10011001,
							 8'b10011001,
							 8'b10100101,
							 8'b11000011,
							 8'b01111110};
							 
		//Miss/Hit
		5'b10010:
		DotMatrixRaw = {8'b11111111,
							 8'b10000001,
							 8'b10000001,
							 8'b10011001,
							 8'b10011001,
							 8'b10000001,
							 8'b10000001,
							 8'b11111111};
		
		
		default:
		DotMatrixRaw = {8'b00000000,
							 8'b00000000,
							 8'b00000000,
							 8'b00000000,
							 8'b00000000,
							 8'b00000000,
							 8'b00000000,
							 8'b00000000};
		endcase
	end
	
	assign DotMatrix = {DotMatrixRaw[0],DotMatrixRaw[1],DotMatrixRaw[2],DotMatrixRaw[3],DotMatrixRaw[4],DotMatrixRaw[5],DotMatrixRaw[6],DotMatrixRaw[7],
				DotMatrixRaw[8],DotMatrixRaw[9],DotMatrixRaw[10],DotMatrixRaw[11],DotMatrixRaw[12],DotMatrixRaw[13],DotMatrixRaw[14],DotMatrixRaw[15],
				DotMatrixRaw[16],DotMatrixRaw[17],DotMatrixRaw[18],DotMatrixRaw[19],DotMatrixRaw[20],DotMatrixRaw[21],DotMatrixRaw[22],DotMatrixRaw[23],
				DotMatrixRaw[24],DotMatrixRaw[25],DotMatrixRaw[26],DotMatrixRaw[27],DotMatrixRaw[28],DotMatrixRaw[29],DotMatrixRaw[30],DotMatrixRaw[31],
				DotMatrixRaw[32],DotMatrixRaw[33],DotMatrixRaw[34],DotMatrixRaw[35],DotMatrixRaw[36],DotMatrixRaw[37],DotMatrixRaw[38],DotMatrixRaw[39],
				DotMatrixRaw[40],DotMatrixRaw[41],DotMatrixRaw[42],DotMatrixRaw[43],DotMatrixRaw[44],DotMatrixRaw[45],DotMatrixRaw[46],DotMatrixRaw[47],
				DotMatrixRaw[48],DotMatrixRaw[49],DotMatrixRaw[50],DotMatrixRaw[51],DotMatrixRaw[52],DotMatrixRaw[53],DotMatrixRaw[54],DotMatrixRaw[55],
				DotMatrixRaw[56],DotMatrixRaw[57],DotMatrixRaw[58],DotMatrixRaw[59],DotMatrixRaw[60],DotMatrixRaw[61],DotMatrixRaw[62],DotMatrixRaw[63]	};
endmodule
