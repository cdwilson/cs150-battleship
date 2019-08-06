//-----------------------------------------------------------------------
//	File:		$RCSfile: Const.V,v $
//	Version:	$Revision: 1.9 $
//	Desc:		Verilog Constants and Macros
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2003 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: Const.V,v $
//	Revision 1.9  2005/07/08 16:13:52  gdgib
//	Added MACROSAFE protection to macro definitions
//	Now works with Xilinx ProjNav 7.1
//	
//	Revision 1.8  2005/02/01 05:58:18  gdgib
//	Added log2f macro
//	Computes floor(log2(x)
//	
//	Revision 1.7  2004/12/02 03:36:50  gdgib
//	Added pow2 macro
//	Eat your heart out
//	
//	Revision 1.6  2004/06/29 20:34:25  Administrator
//	Added MACROSAFE checks
//	Must define the MODELSIM flag manually now
//	
//	Revision 1.5  2004/06/18 23:28:59  Administrator
//	Fixed log2 macro to deal with signed parameters
//	
//	Revision 1.4  2004/06/18 00:04:46  Administrator
//	Fixed the SYNTHESIS flags
//	Added min/max macros (Yay for Synplify Pro 7.5.1)
//	
//	Revision 1.3  2004/06/17 18:59:56  Administrator
//	Added Proper Headers
//	Updated Parameters and Constants
//	General Housekeeping
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Simulation Flag
//	Desc:		This little nebulous block will define the flags:
//				-SIMULATION	Simulating
//				-MODELSIM	Simulating using ModelSim
//				-XST		Synthesizing with XST
//				-SYNPLIFY	Synthesizing with Synplify
//				-SYNTHESIS	Synthesizing
//				-MACROSAFE	Safe to use macros (Synplify or ModelSim)
//
//	YOU SHOULD DEFINE THE "MODELSIM" FLAG FOR SIMULATION!!!!
//
//-----------------------------------------------------------------------
`ifdef synthesis                // if Synplify
	`define SYNPLIFY
	`define SYNTHESIS
	`define MACROSAFE
`else                           // if not Synplify
	`ifdef MODELSIM
		`define SIMULATION
		`define MACROSAFE
	`else
		`define XST
		// synthesis translate_off    // if XST then stop compiling
			`undef XST
			`define SIMULATION
			`define MODELSIM
		// synthesis translate_on     // if XST then resume compiling
		`ifdef XST
			`define SYNTHESIS
		`endif
	`endif
`endif
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Log2 Macro
//	Desc:		A macro to take the log base 2 of any number.
//			Useful for calculating bitwidths.
//-----------------------------------------------------------------------
`ifdef MACROSAFE
`define log2(x)		((((x) > 1) ? 1 : 0) + \
			(((x) > 2) ? 1 : 0) + \
			(((x) > 4) ? 1 : 0) + \
			(((x) > 8) ? 1 : 0) + \
			(((x) > 16) ? 1 : 0) + \
			(((x) > 32) ? 1 : 0) + \
			(((x) > 64) ? 1 : 0) + \
			(((x) > 128) ? 1 : 0) + \
			(((x) > 256) ? 1 : 0) + \
			(((x) > 512) ? 1 : 0) + \
			(((x) > 1024) ? 1 : 0) + \
			(((x) > 2048) ? 1 : 0) + \
			(((x) > 4096) ? 1 : 0) + \
			(((x) > 8192) ? 1 : 0) + \
			(((x) > 16384) ? 1 : 0) + \
			(((x) > 32768) ? 1 : 0) + \
			(((x) > 65536) ? 1 : 0) + \
			(((x) > 131072) ? 1 : 0) + \
			(((x) > 262144) ? 1 : 0) + \
			(((x) > 524288) ? 1 : 0) + \
			(((x) > 1048576) ? 1 : 0) + \
			(((x) > 2097152) ? 1 : 0) + \
			(((x) > 4194304) ? 1 : 0) + \
			(((x) > 8388608) ? 1 : 0) + \
			(((x) > 16777216) ? 1 : 0) + \
			(((x) > 33554432) ? 1 : 0) + \
			(((x) > 67108864) ? 1 : 0) + \
			(((x) > 134217728) ? 1 : 0) + \
			(((x) > 268435456) ? 1 : 0) + \
			(((x) > 536870912) ? 1 : 0) + \
			(((x) > 1073741824) ? 1 : 0))
`endif
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Log2 Floor Macro
//	Desc:		A macro to take the floor of the log base 2 of
//			any number.
//-----------------------------------------------------------------------
`ifdef MACROSAFE
`define log2f(x)	((((x) >= 2) ? 1 : 0) + \
			(((x) >= 4) ? 1 : 0) + \
			(((x) >= 8) ? 1 : 0) + \
			(((x) >= 16) ? 1 : 0) + \
			(((x) >= 32) ? 1 : 0) + \
			(((x) >= 64) ? 1 : 0) + \
			(((x) >= 128) ? 1 : 0) + \
			(((x) >= 256) ? 1 : 0) + \
			(((x) >= 512) ? 1 : 0) + \
			(((x) >= 1024) ? 1 : 0) + \
			(((x) >= 2048) ? 1 : 0) + \
			(((x) >= 4096) ? 1 : 0) + \
			(((x) >= 8192) ? 1 : 0) + \
			(((x) >= 16384) ? 1 : 0) + \
			(((x) >= 32768) ? 1 : 0) + \
			(((x) >= 65536) ? 1 : 0) + \
			(((x) >= 131072) ? 1 : 0) + \
			(((x) >= 262144) ? 1 : 0) + \
			(((x) >= 524288) ? 1 : 0) + \
			(((x) >= 1048576) ? 1 : 0) + \
			(((x) >= 2097152) ? 1 : 0) + \
			(((x) >= 4194304) ? 1 : 0) + \
			(((x) >= 8388608) ? 1 : 0) + \
			(((x) >= 16777216) ? 1 : 0) + \
			(((x) >= 33554432) ? 1 : 0) + \
			(((x) >= 67108864) ? 1 : 0) + \
			(((x) >= 134217728) ? 1 : 0) + \
			(((x) >= 268435456) ? 1 : 0) + \
			(((x) >= 536870912) ? 1 : 0) + \
			(((x) >= 1073741824) ? 1 : 0))
`endif
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Pow2 Macro
//	Desc:		A macro to take the 2 to the power of any number
//			Useful for calculating bitwidths.
//-----------------------------------------------------------------------
`ifdef MACROSAFE
`define pow2(x)		((((x) >= 1) ? 2 : 1) * \
			(((x) >= 2) ? 2 : 1) * \
			(((x) >= 3) ? 2 : 1) * \
			(((x) >= 4) ? 2 : 1) * \
			(((x) >= 5) ? 2 : 1) * \
			(((x) >= 6) ? 2 : 1) * \
			(((x) >= 7) ? 2 : 1) * \
			(((x) >= 8) ? 2 : 1) * \
			(((x) >= 9) ? 2 : 1) * \
			(((x) >= 10) ? 2 : 1) * \
			(((x) >= 11) ? 2 : 1) * \
			(((x) >= 12) ? 2 : 1) * \
			(((x) >= 13) ? 2 : 1) * \
			(((x) >= 14) ? 2 : 1) * \
			(((x) >= 15) ? 2 : 1) * \
			(((x) >= 16) ? 2 : 1) * \
			(((x) >= 17) ? 2 : 1) * \
			(((x) >= 18) ? 2 : 1) * \
			(((x) >= 19) ? 2 : 1) * \
			(((x) >= 20) ? 2 : 1) * \
			(((x) >= 21) ? 2 : 1) * \
			(((x) >= 22) ? 2 : 1) * \
			(((x) >= 23) ? 2 : 1) * \
			(((x) >= 24) ? 2 : 1) * \
			(((x) >= 25) ? 2 : 1) * \
			(((x) >= 26) ? 2 : 1) * \
			(((x) >= 27) ? 2 : 1) * \
			(((x) >= 28) ? 2 : 1) * \
			(((x) >= 29) ? 2 : 1) * \
			(((x) >= 30) ? 2 : 1) * \
			(((x) >= 31) ? 2 : 1))
`endif
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Max/Min Macros
//	Desc:		Standard binary max/min macros
//-----------------------------------------------------------------------
`ifdef MACROSAFE
`define max(x,y)	((x) > (y) ? (x) : (y))
`define min(x,y)	((x) < (y) ? (x) : (y))
`endif
//-----------------------------------------------------------------------