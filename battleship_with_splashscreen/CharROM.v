//-----------------------------------------------------------------------
//	File:		$RCSfile: CharROM.V,v $
//	Version:	$Revision: 1.0 $
//	Desc:		ROM for dot matrix representation of ASCII characters
//	Author:		Philip Godoy
//	Copyright:	Copyright 2006 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: CharROM.V,v $
//	Revision 1.0  2006/03/24 12:29:56  Administrator
//	Cleaned up code; Added parameters
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		CharROM
//	Desc:		Dot matrix representation of characters
//	Params:		see below...
//-----------------------------------------------------------------------
`timescale 1ns / 1ps
`include "Const.v"

module	CharROM(
			// ROM Read Interface
			DotMatrix,
			CharCode
		);
	
	//	Parameters / Constants
	localparam	charcodebits = 8,
					hdots = 		8,	// must be power of 2!!!
					vdots = 		8;	// must be power of 2!!!
	localparam  numdots = hdots*vdots;

	//	Input/Output Port Declarations
	output	[numdots-1:0]		DotMatrix;
	input	[charcodebits-1:0]	CharCode;

	// Wires and Regs
	reg	[numdots-1:0]		DOutRaw;
	
	//---------------------------------------------------------------
	//	Char-Dot Generator (based on ASCII character mapping)
	//---------------------------------------------------------------

	always @ ( * ) begin

		case (CharCode)

			// alternating dots
			8'h01:	DOutRaw = {	
								8'b10101010,
								8'b01010101,
								8'b10101010,
								8'b01010101,
								8'b10101010,
								8'b01010101,
								8'b10101010,
								8'b01010101	};


			// up horiz line (for borders)
			8'h0a:	DOutRaw = {	
								8'b00000000,
								8'b00000000,
								8'b11111111,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000	};

			// down horiz line (for borders)
			8'h0b:	DOutRaw = {	
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b11111111,
								8'b00000000,
								8'b00000000	};

			// left vert line (for borders)
			8'h0c:	DOutRaw = {	
								8'b00100000,
								8'b00100000,
								8'b00100000,
								8'b00100000,
								8'b00100000,
								8'b00100000,
								8'b00100000,
								8'b00100000	};

			// right vert line (for borders)
			8'h0d:	DOutRaw = {	
								8'b00000100,
								8'b00000100,								
								8'b00000100,
								8'b00000100,
								8'b00000100,
								8'b00000100,
								8'b00000100,
								8'b00000100	};
			//	middle line
			8'h0e:	DOutRaw = {	
								8'b00000000,
								8'b00000000,								
								8'b00000000,
								8'b11111111,
								8'b11111111,
								8'b00000000,
								8'b00000000,
								8'b00000000	};
			8'h0f:   DOutRaw = {	
								8'b00000_000,
								8'b00011_000,								
								8'b00111_000,
								8'b01111_000,
								8'b11111_000,
								8'b01111_000,
								8'b00111_000,
								8'b00011_000	};
			8'h10:   DOutRaw = {	
								8'b00000000,
								8'b11000000,								
								8'b11100000,
								8'b11110000,
								8'b11111000,
								8'b11110000,
								8'b11100000,
								8'b11000000	};
			// space
			8'h20:	DOutRaw = {	
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000	};

			// exclamation pt (!)
			8'h21:	DOutRaw = {	
								8'b00000_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00000_000,
								8'b00000_000,
								8'b00100_000	};

			// double quote (")
			8'h22:	DOutRaw = {	
								8'b00000_000,
								8'b01010_000,
								8'b01010_000,
								8'b01010_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000	};

			// pound sign (#)
			8'h23:	DOutRaw = {	
								8'b00000_000,
								8'b01010_000,
								8'b01010_000,
								8'b11111_000,
								8'b01010_000,
								8'b11111_000,
								8'b01010_000,
								8'b01010_000	};

			// ampersand (&)
			8'h26:	DOutRaw = {	
								8'b00000_000,
								8'b01100_000,
								8'b10010_000,
								8'b10100_000,
								8'b01000_000,
								8'b10101_000,
								8'b10010_000,
								8'b01101_000	};

			// apostrophe (')
			8'h27:	DOutRaw = {	
								8'b00000_000,
								8'b01100_000,
								8'b00100_000,
								8'b01000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000	};

			// left paren, '('
			8'h28:	DOutRaw = {	
								8'b00000_000,
								8'b00010_000,
								8'b00100_000,
								8'b01000_000,
								8'b01000_000,
								8'b01000_000,
								8'b00100_000,
								8'b00010_000	};

			// right paren, ')'
			8'h29:	DOutRaw = {	
								8'b00000_000,
								8'b01000_000,
								8'b00100_000,
								8'b00010_000,
								8'b00010_000,
								8'b00010_000,
								8'b00100_000,
								8'b01000_000	};
			
			// comma (,)
			8'h2c:	DOutRaw = {	
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b01100_000,
								8'b00100_000,
								8'b01000_000	};

			// dash (-)
			8'h2d:	DOutRaw = {	
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b11111_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000	};

			// period (.)
			8'h2e:	DOutRaw = {	
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b01100_000,
								8'b01100_000	};

			// forward slash (/)
			8'h2f:	DOutRaw = {	
								8'b00000_000,
								8'b00000_000,
								8'b00001_000,
								8'b00010_000,
								8'b00100_000,
								8'b01000_000,
								8'b10000_000,
								8'b00000_000	};

			// zero (0)
			8'h30:	DOutRaw = {	
								8'b00000_000, 
								8'b01110_000,
								8'b10001_000,
								8'b10011_000,
								8'b10101_000,
								8'b11001_000,
								8'b10001_000,
								8'b01110_000	};
			// one
			8'h31:	DOutRaw = {	
								8'b00000_000,
								8'b00100_000,
								8'b01100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b01110_000	};

			// two
			8'h32:	DOutRaw = {	
								8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b00001_000,
								8'b00010_000,
								8'b00100_000,
								8'b01000_000,
								8'b11111_000	};

			// three
			8'h33:	DOutRaw = {	
								8'b00000_000,
								8'b11111_000,
								8'b00010_000,
								8'b00100_000,
								8'b00010_000,
								8'b00001_000,
								8'b10001_000,
								8'b01110_000	};

			// four
			8'h34:	DOutRaw = {	
								8'b00000_000,
								8'b00010_000,
								8'b00110_000,
								8'b01010_000,
								8'b10010_000,
								8'b11111_000,
								8'b00010_000,
								8'b00010_000	};

			// five
			8'h35:	DOutRaw = {	
								8'b00000_000,
								8'b11111_000,
								8'b10000_000,
								8'b11110_000,
								8'b00001_000,
								8'b00001_000,
								8'b10001_000,
								8'b01110_000	};

			// six
			8'h36:	DOutRaw = {	
								8'b00000_000,
								8'b00110_000,
								8'b01000_000,
								8'b10000_000,
								8'b11110_000,
								8'b10001_000,
								8'b10001_000,
								8'b01110_000	};

			// seven
			8'h37:	DOutRaw = {	
								8'b00000_000,
								8'b11111_000,
								8'b10001_000,
								8'b00001_000,
								8'b00010_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000	};

			// eight
			8'h38:	DOutRaw = {	
								8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b10001_000,
								8'b01110_000,
								8'b10001_000,
								8'b10001_000,
								8'b01110_000	};

			// nine
			8'h39:	DOutRaw = {	
								8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b10001_000,
								8'b01111_000,
								8'b00001_000,
								8'b00010_000,
								8'b01100_000	};

			// colon (:)
			8'h3a:	DOutRaw = {	
								8'b00000_000,
								8'b00000_000,
								8'b01100_000,
								8'b01100_000,
								8'b00000_000,
								8'b01100_000,
								8'b01100_000,
								8'b00000_000	};

			// colon (:)
			8'h3a:	DOutRaw = {	
								8'b00000_000,
								8'b00000_000,
								8'b01100_000,
								8'b01100_000,
								8'b00000_000,
								8'b01100_000,
								8'b01100_000,
								8'b00000_000	};

			// colon (;)
			8'h3b:	DOutRaw = {	
								8'b00000_000,
								8'b00000_000,
								8'b01100_000,
								8'b01100_000,
								8'b00000_000,
								8'b01100_000,
								8'b00100_000,
								8'b01000_000	};

			// A
			8'h41:	DOutRaw = {	
								8'b00000_000,
								8'b00100_000,
								8'b01010_000,
								8'b10001_000,
								8'b10001_000,
								8'b11111_000,
								8'b10001_000,
								8'b10001_000	};

			// B
			8'h42:	DOutRaw = {	
								8'b00000_000,
								8'b11110_000,
								8'b10001_000,
								8'b10001_000,
								8'b11110_000,
								8'b10001_000,
								8'b10001_000,
								8'b11110_000	};

			// C
			8'h43:	DOutRaw = {	
								8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b10000_000,
								8'b10000_000,
								8'b10000_000,
								8'b10001_000,
								8'b01110_000	};

			// D
			8'h44:	DOutRaw = {	8'b00000_000,
								8'b11100_000,
								8'b10010_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10010_000,
								8'b11100_000	};
				
			// E
			8'h45:	DOutRaw = {	8'b00000_000,
								8'b11111_000,
								8'b10000_000,
								8'b10000_000,
								8'b11110_000,
								8'b10000_000,
								8'b10000_000,
								8'b11111_000	};

			// F
			8'h46:	DOutRaw = {	8'b00000_000,
								8'b11111_000,
								8'b10000_000,
								8'b10000_000,
								8'b11110_000,
								8'b10000_000,
								8'b10000_000,
								8'b10000_000	};

			// G
			8'h47:	DOutRaw = {	8'b00000_000,
								8'b11110_000,
								8'b10001_000,
								8'b10000_000,
								8'b10111_000,
								8'b10001_000,
								8'b10001_000,
								8'b01111_000	};

			// H
			8'h48:	DOutRaw = {	8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b11111_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000	};

			// I
			8'h49:	DOutRaw = {	8'b00000_000,
								8'b01110_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b01110_000	};

			// J
			8'h4A:	DOutRaw = {	8'b00000_000,
								8'b00111_000,
								8'b00010_000,
								8'b00010_000,
								8'b00010_000,
								8'b00010_000,
								8'b10010_000,
								8'b01100_000	};

			// K
			8'h4B:	DOutRaw = {	8'b00000_000,
								8'b10001_000,
								8'b10010_000,
								8'b10100_000,
								8'b11000_000,
								8'b10100_000,
								8'b10010_000,
								8'b10001_000	};

			// L
			8'h4C:	DOutRaw = {	8'b00000_000,
								8'b10000_000,
								8'b10000_000,
								8'b10000_000,
								8'b10000_000,
								8'b10000_000,
								8'b10000_000,
								8'b11111_000	};

			// M
			8'h4D:	DOutRaw = {	8'b00000_000,
								8'b10001_000,
								8'b11011_000,
								8'b10101_000,
								8'b10101_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000	};

			// N
			8'h4E:	DOutRaw = {	8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b11001_000,
								8'b10101_000,
								8'b10011_000,
								8'b10001_000,
								8'b10001_000	};

			// O
			8'h4F:	DOutRaw = {	8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b01110_000	};

			// P
			8'h50:	DOutRaw = {	8'b00000_000,
								8'b11110_000,
								8'b10001_000,
								8'b10001_000,
								8'b11110_000,
								8'b10000_000,
								8'b10000_000,
								8'b10000_000	};

			// Q
			8'h51:	DOutRaw = {	8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10101_000,
								8'b10010_000,
								8'b01101_000	};
			
			// R
			8'h52:	DOutRaw = {	8'b00000_000,
								8'b11110_000,
								8'b10001_000,
								8'b10001_000,
								8'b11110_000,
								8'b10100_000,
								8'b10010_000,
								8'b10001_000	};

			// S	
			8'h53:	DOutRaw = {	8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b10000_000,
								8'b01110_000,
								8'b00001_000,
								8'b10001_000,
								8'b01110_000	};

			// T
			8'h54:	DOutRaw = {	8'b00000_000,
								8'b11111_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000	};

			// U	
			8'h55:	DOutRaw = {	8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b01110_000	};

			// V
			8'h56:	DOutRaw = {	8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b01010_000,
								8'b00100_000	};

			// W	
			8'h57:	DOutRaw = {	8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10101_000,
								8'b10101_000,
								8'b10101_000,
								8'b01010_000	};
				
			// X
			8'h58:	DOutRaw = {	8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b01010_000,
								8'b00100_000,
								8'b01010_000,
								8'b10001_000,
								8'b10001_000	};

			// Y
			8'h59:	DOutRaw = {	8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b01010_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000	};

			// Z
			8'h5A:	DOutRaw = {	8'b00000_000,
								8'b11111_000,
								8'b00001_000,
								8'b00010_000,
								8'b00100_000,
								8'b01000_000,
								8'b10000_000,
								8'b11111_000	};

			// [
			8'h5b:	DOutRaw = {	8'b00000_000,
								8'b01110_000,
								8'b01000_000,
								8'b01000_000,
								8'b01000_000,
								8'b01000_000,
								8'b01000_000,
								8'b01110_000	};

			// backslash (\)
			8'h5c:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b10000_000,
								8'b01000_000,
								8'b00100_000,
								8'b00010_000,
								8'b00001_000,
								8'b01000_000	};

			// ]
			8'h5d:	DOutRaw = {	8'b00000_000,
								8'b01110_000,
								8'b00010_000,
								8'b00010_000,
								8'b00010_000,
								8'b00010_000,
								8'b00010_000,
								8'b01110_000	};

			// underscore (_)
			8'h5f:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b11111_000	};

			// a
			8'h61:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b01110_000,
								8'b00001_000,
								8'b01111_000,
								8'b10001_000,
								8'b01111_000	};

			// b
			8'h62:	DOutRaw = {	8'b00000_000,
								8'b10000_000,
								8'b10000_000,
								8'b10110_000,
								8'b11001_000,
								8'b10001_000,
								8'b10001_000,
								8'b11110_000	};

			// c
			8'h63:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b01110_000,
								8'b10000_000,
								8'b10000_000,
								8'b10001_000,
								8'b01110_000	};

			// d
			8'h64:	DOutRaw = {	8'b00000_000,
								8'b00001_000,
								8'b00001_000,
								8'b01101_000,
								8'b10011_000,
								8'b10001_000,
								8'b10001_000,
								8'b01111_000	};

			// e
			8'h65:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b11111_000,
								8'b10000_000,
								8'b01110_000	};

			// f
			8'h66:	DOutRaw = {	8'b00000_000,
								8'b00110_000,
								8'b01001_000,
								8'b01000_000,
								8'b11100_000,
								8'b01000_000,
								8'b01000_000,
								8'b01000_000	};

			// g
			8'h67:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b01111_000,
								8'b10001_000,
								8'b01111_000,
								8'b00001_000,
								8'b01110_000	};

			// h
			8'h68:	DOutRaw = {	8'b00000_000,
								8'b10000_000,
								8'b10000_000,
								8'b10110_000,
								8'b11001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000	};

			// i
			8'h69:	DOutRaw = {	8'b00000_000,
								8'b00100_000,
								8'b00000_000,
								8'b00100_000,
								8'b01100_000,
								8'b00100_000,
								8'b00100_000,
								8'b01110_000	};

			// j
			8'h6a:	DOutRaw = {	8'b00000_000,
								8'b00010_000,
								8'b00000_000,
								8'b00110_000,
								8'b00010_000,
								8'b00010_000,
								8'b10010_000,
								8'b01100_000	};

			// k
			8'h6b:	DOutRaw = {	8'b00000_000,
								8'b10000_000,
								8'b10000_000,
								8'b10010_000,
								8'b10100_000,
								8'b11000_000,
								8'b10100_000,
								8'b10010_000	};

			// l
			8'h6c:	DOutRaw = {	8'b00000_000,
								8'b01100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b00100_000,
								8'b01110_000	};

			// m
			8'h6d:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b11010_000,
								8'b10101_000,
								8'b10101_000,
								8'b10101_000,
								8'b10101_000	};

			// n
			8'h6e:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b10110_000,
								8'b11001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000	};

			// o
			8'h6f:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b01110_000	};

			// p
			8'h70:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b11110_000,
								8'b10001_000,
								8'b11110_000,
								8'b10000_000,
								8'b10000_000	};

			// q
			8'h71:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b01101_000,
								8'b10011_000,
								8'b01111_000,
								8'b00001_000,
								8'b00001_000	};

			// r
			8'h72:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b10110_000,
								8'b11001_000,
								8'b10000_000,
								8'b10000_000,
								8'b10000_000	};

			// s
			8'h73:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b01110_000,
								8'b10000_000,
								8'b01110_000,
								8'b00001_000,
								8'b11110_000	};

			// t
			8'h74:	DOutRaw = {	8'b00000_000,
								8'b01000_000,
								8'b01000_000,
								8'b11100_000,
								8'b01000_000,
								8'b01000_000,
								8'b01001_000,
								8'b00110_000	};

			// u
			8'h75:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b10011_000,
								8'b01101_000	};

			// v
			8'h76:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b10001_000,
								8'b01010_000,
								8'b00100_000	};

			// w
			8'h77:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b10101_000,
								8'b10101_000,
								8'b01010_000	};

			// x
			8'h78:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b10001_000,
								8'b01010_000,
								8'b00100_000,
								8'b01010_000,
								8'b10001_000	};

			// y
			8'h79:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b10001_000,
								8'b10001_000,
								8'b01111_000,
								8'b00001_000,
								8'b01110_000	};

			// z
			8'h7a:	DOutRaw = {	8'b00000_000,
								8'b00000_000,
								8'b00000_000,
								8'b11111_000,
								8'b00010_000,
								8'b00100_000,
								8'b01000_000,
								8'b11111_000	};

			// ?
			8'h3F:	  DOutRaw = {	8'b00000_000,
								8'b01110_000,
								8'b10001_000,
								8'b00001_000,
								8'b00010_000,
								8'b00100_000,
								8'b00000_000,
								8'b00100_000	};

			// box
			8'hDF:	DOutRaw = {	8'b00011000,
										8'b00111111,
										8'b01100000,
										8'b11111111,
										8'b11111111,
										8'b01100000,
										8'b00111111,
										8'b00011000	};
			
			
			// box
			8'hEF:	DOutRaw = {	8'b00011000,
										8'b11111100,
										8'b00000110,
										8'b11111111,
										8'b11111111,
										8'b00000110,
										8'b11111100,
										8'b00011000	};
			
			// box
			8'hFF:	DOutRaw = {	8'b00000000,
								8'b01111110,
								8'b01111110,
								8'b01111110,
								8'b01111110,
								8'b01111110,
								8'b01111110,
								8'b00000000	};

			// default char (space)
			default:	DOutRaw = {	8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000,
								8'b00000000	};


		endcase

	end

	// Reverse
	assign DotMatrix = {DOutRaw[0],DOutRaw[1],DOutRaw[2],DOutRaw[3],DOutRaw[4],DOutRaw[5],DOutRaw[6],DOutRaw[7],
				DOutRaw[8],DOutRaw[9],DOutRaw[10],DOutRaw[11],DOutRaw[12],DOutRaw[13],DOutRaw[14],DOutRaw[15],
				DOutRaw[16],DOutRaw[17],DOutRaw[18],DOutRaw[19],DOutRaw[20],DOutRaw[21],DOutRaw[22],DOutRaw[23],
				DOutRaw[24],DOutRaw[25],DOutRaw[26],DOutRaw[27],DOutRaw[28],DOutRaw[29],DOutRaw[30],DOutRaw[31],
				DOutRaw[32],DOutRaw[33],DOutRaw[34],DOutRaw[35],DOutRaw[36],DOutRaw[37],DOutRaw[38],DOutRaw[39],
				DOutRaw[40],DOutRaw[41],DOutRaw[42],DOutRaw[43],DOutRaw[44],DOutRaw[45],DOutRaw[46],DOutRaw[47],
				DOutRaw[48],DOutRaw[49],DOutRaw[50],DOutRaw[51],DOutRaw[52],DOutRaw[53],DOutRaw[54],DOutRaw[55],
				DOutRaw[56],DOutRaw[57],DOutRaw[58],DOutRaw[59],DOutRaw[60],DOutRaw[61],DOutRaw[62],DOutRaw[63]	};

endmodule
