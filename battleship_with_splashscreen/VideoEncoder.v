//-----------------------------------------------------------------------
//	File:		$RCSfile: VideoEncoder.v,v $
//	Version:	$Revision: 1.1 $
//	Desc:		ITU656/601 Video Encoder
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2003 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: VideoEncoder.v,v $
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
//	Module:		VideoEncoder
//	Desc:		This module will request pixel pairs from a host
//			once every four clock cycles during the active
//			video period.
//
//			The interface allows for synchronous read in that
//			it will expect data on the cycle after it makes
//			the request.
//
//			Pixels will be requested across each line and
//			then down across first the odd frame then
//			similarly across the even frame.  Note that line
//			adresses will be every-other-one due to this
//			interlacing.
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
module	VideoEncoder(	//-----------------------------------------------
			//	Video Encoder I/O
			//-----------------------------------------------
			VE_P,		// Video data to the ADV7194
			VE_SCLK,	// I2C Clock
			VE_SDA,		// I2C Data
			VE_PAL_NTSC,	// PAL/NTSC Video Standard Select
			VE_RESET_B_,	// Reset out to ADV7194
			VE_HSYNC_B_,	// Unused
			VE_VSYNC_B_,	// Unused
			VE_BLANK_B_,	// Unused
			VE_SCRESET,	// Unused
			VE_CLKIN,	// Clock out to ADV7194
			//-----------------------------------------------

			//-----------------------------------------------
			//	System Inputs
			//-----------------------------------------------
			Clock,
			Reset,
			//-----------------------------------------------

			//-----------------------------------------------
			//	Video Data Host Interface
			//-----------------------------------------------
			DIn,
			InRequest,
			InRequestLine,
			InRequestPair,
			//-----------------------------------------------
			
			//I2CDone,
			
			HCount,
			VCount,
	
			ShiftIn,
			ShiftOut,
	
			Clipped,
	
			VBlank,
			EvenOdd,
			HMux,
			I2CDone,
			VBlankCount
			//CntCtrl,
			//HFSMOut,
			//VBlankCount,
			//Vtrigger
		);
	//---------------------------------------------------------------
	//	Parameters
	//		These could theoretically change if we changed
	//		the video format.  We don't expect you to plan
	//		for that.  You may assume these are CONSTANTS!
	//---------------------------------------------------------------
	parameter		totallines =		525,	// Total number of video lines
				activelines =		487,	// Number of active video lines
				f0topblank =		14,	// Number of blank lines at the top of Field0
				hblanksamples =		138,	// Number of blank samples per line
				activesamples =		720;	// Number of active samples per line
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Constants
	//		Since the above constants are a little tricky to
	//		actually use, these values are provided to make
	//		your life easier.  You will probably want to
	//		do comparisons against these values.
	//---------------------------------------------------------------
	`ifdef MACROSAFE
	localparam		oddlines =		totallines >> 1,			// Total lines in odd field
				evenlines =		totallines - oddlines,			// Total lines in even field
				evenactive =		activelines >> 1,			// Active lines in even field
				oddactive =		activelines - evenactive,		// Active lines in odd field
				oddtopblank =		f0topblank,				// Blank lines at the top of the odd field
				eventopblank =		f0topblank + 1,				// Blank lines at the top of even field
				oddbottomblank =	oddlines - oddactive - oddtopblank,	// Blank lines at the bottom of odd field
				evenbottomblank =	evenlines - evenactive - eventopblank,	// Blank lines at the bottom of even field
				hblankbytes =		(hblanksamples * 2) - 8,		// Blank bytes per line (Notice subtract for EAV/SAV)
				activebytes =		(activesamples * 2),			// Active bytes per line;
				vcbits =		`log2(oddactive),			// Vertical Counter Bits
				hcbits =		`log2(activebytes);			// Horizontal Counter Bits
	`endif
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Debugging Prinouts
	//		These are for your convenience, only.  You might
	//		want to check that the right values are printed
	//		when you simulate this module.
	//---------------------------------------------------------------
	`ifdef MODELSIM
	initial begin
		$display("%m : VideoEncoder");
		$display("    totallines =      %d", totallines);
		$display("    activelines =     %d", activelines);
		$display("    f0topblank =      %d", f0topblank);
		$display("    hblanksamples =   %d", hblanksamples);
		$display("    activesamples =   %d", activesamples);
		$display("    oddlines =        %d", oddlines);
		$display("    evenlines =       %d", evenlines);
		$display("    evenactive =      %d", evenactive);
		$display("    oddactive =       %d", oddactive);
		$display("    oddtopblank =     %d", oddtopblank);
		$display("    eventopblank =    %d", eventopblank);
		$display("    oddbottomblank =  %d", oddbottomblank);
		$display("    evenbottomblank = %d", evenbottomblank);
		$display("    hblankbytes =     %d", hblankbytes);
		$display("    activebytes =     %d", activebytes);
		$display("    vcbits =          %d", vcbits);
		$display("    hcbits =          %d", hcbits);
	end
	`endif
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Video Encoder I/O
	//		I/O connections to the ADV7194 Video Encoder chip
	//---------------------------------------------------------------
	output	[9:0]		VE_P;
	inout			VE_SCLK, VE_SDA;
	output			VE_PAL_NTSC;
	output			VE_RESET_B_;
	output			VE_HSYNC_B_, VE_VSYNC_B_, VE_BLANK_B_;
	output			VE_SCRESET;
	output			VE_CLKIN;
	
	/*CHIPSCOPE MOFO*/

	output			I2CDone;
	output[10:0]	HCount;
	output[9:0]		VCount;
	
	output[31:0]	ShiftIn;
	output[7:0]		ShiftOut;
	
	output[31:0]	Clipped;
	
	output			VBlank;
	output			EvenOdd;

	output[3:0]		HMux;
	output[5:0]		VBlankCount;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	System Inputs
	//		System level clock and reset.  Always 27MHz.
	//---------------------------------------------------------------
	input			Clock, Reset;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Video Data Host Interface
	//		Interface to support access to SRAM.  Can be
	//		adapated to connect to SDRAM or anything else.
	//---------------------------------------------------------------
	input	[31:0]		DIn;
	output			InRequest;
	// Notice this doesn't have a -1, that lowest bit should the field, the [vcbits:1] should be the line within it
	output	[vcbits:0]	InRequestLine;
	output	[hcbits-3:0]	InRequestPair;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	I2C Operation Encodings (DO NOT CHANGE)
	//		Don't worry too much about this section, and
	//		be sure not to change it.
	//---------------------------------------------------------------
	localparam		OP_NOP =		2'b00,
				OP_Read =		2'b01,
				OP_Write =		2'b10,
				OP_Restart =		2'b11;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Wires and Regs
	//---------------------------------------------------------------
	wire	[2:0]		I2COpCount;				// DO NOT CHANGE
	reg	[1:0]		I2COpCode;				// DO NOT CHANGE
	reg	[7:0]		I2CTXData;				// DO NOT CHANGE
	wire				I2CRequest;			// DO NOT CHANGE
	wire				I2CDone;
	//input				I2CDone;

	wire [31:0]		Clipped;
	wire [31:0]		ShiftIn;
	wire [7:0]		ShiftOut;
	wire [9:0]		VCount;
	wire [10:0]		HCount;
	//wire [1:0]		HFSMOut;
	wire [1:0]		ShiftCount;
	wire 				VBlank;
	//wire				Vtrigger;
	//wire				HIs1440;
	//wire				CntCtrl;
	wire				EvenOdd;
	//wire [2:0]		HState;
	//wire [2:0]		VState;
	//wire				VBlankCountEn;
	wire [5:0]		VBlankCount;
	wire				EAV;
	wire				SAV;
	wire				HActive;
	wire				HBlank;
	wire [3:0]		HMux;

	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Assigns and Decodes
	//		Here are a set of assigns which are all very
	//		simple.  Most of them are setting the constant
	//		inputs to the ADV7194 video encoder
	//---------------------------------------------------------------
	assign	VE_PAL_NTSC =			1'b0;			// DO NOT CHANGE
	assign	VE_RESET_B_ =			~Reset;			// DO NOT CHANGE
	assign	VE_HSYNC_B_ =			1'b1;			// DO NOT CHANGE
	assign	VE_VSYNC_B_ =			1'b1;			// DO NOT CHANGE
	assign	VE_BLANK_B_ =			1'b1;			// DO NOT CHANGE
	assign	VE_SCRESET =			1'b0;			// DO NOT CHANGE
	assign	VE_CLKIN =			Clock;			// DO NOT CHANGE

	// You will need to use I2CDone to know when the ADV7194 has been
	//	fully configured.  You shouldn't try to send anything out
	//	to the ADV7194 until this signal goes high.
	assign	I2CDone =			I2COpCount[2];		// DO NOT CHANGE
	//assign VE_P = {ShiftOut, 2'b00};
	assign HMux[3] = EAV;
	assign HMux[2] = SAV;
	assign HMux[1] = HBlank;
	assign HMux[0] = HActive;
	//assign HIs1440 = (HCount == 11'd1439);
	//assign Vtrigger = HIs1440;
	//assign InRequestPair = HCount[10:2];

	//---------------------------------------------------------------

	
	//---------------------------------------------------------------
	//	I2C Operation Counter (DO NOT CHANGE)
	//---------------------------------------------------------------
	Counter #(3)	I2CCnt(	.Clock(		Clock),
				.Reset(		Reset),
				.Set(		1'b0),
				.Load(		1'b0),
				.Enable(	I2CRequest & ~I2CDone),
				.In(		3'h0),
				.Count(		I2COpCount));
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	I2C Bus Master (DO NOT CHANGE)
	//---------------------------------------------------------------
	I2CMaster	I2C(	.SDA(		VE_SDA),
				.SCL(		VE_SCLK),
				.InOpCode(	I2COpCode),
				.DIn(		I2CTXData),
				.DOut(		),
				.InRequest(	I2CRequest),
				.InAck(		),
				.OutValid(	),
				.Clock(		Clock),
				.Reset(		Reset));
	defparam	I2C.clockfreq =		27000000;
	defparam	I2C.i2crate =		400000;
	defparam	I2C.OP_NOP =		OP_NOP;
	defparam	I2C.OP_Read =		OP_Read;
	defparam	I2C.OP_Write =		OP_Write;
	defparam	I2C.OP_Restart =	OP_Restart;
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	I2C Operation Generator (DO NOT CHANGE)
	//---------------------------------------------------------------
	always @ ( * ) begin
		case (I2COpCount)
			3'h0: {I2COpCode, I2CTXData} =				{OP_NOP, 8'hxx};
			3'h1: {I2COpCode, I2CTXData} =				{OP_Write, 8'h54};
			3'h2: {I2COpCode, I2CTXData} =				{OP_Write, 8'h02};
			3'h3: {I2COpCode, I2CTXData} =				{OP_Write, 8'h60};
			default: {I2COpCode, I2CTXData} =			{OP_NOP, 8'hxx};
		endcase
	end
	//---------------------------------------------------------------


	//---------------------------------------------------------------
	//	Checkpoint2
	//---------------------------------------------------------------

	/*Device Instantiations*/
	EncoderControl			Control(.Clock(Clock), .Reset(~I2CDone | Reset), .EAV(EAV), .SAV(SAV), .HBlank(HBlank), .HActive(HActive), .EvenOdd(EvenOdd), .VBlank(VBlank), .InRequest(InRequest), .InRequestLine(InRequestLine), .InRequestPair(InRequestPair), .HCount(HCount), .VCount(VCount), .Lineout(), .VBlankCount(VBlankCount));
	
	
	//HCount					HCounter(.Clock(Clock), .Reset(Reset), .HEn(I2CDone), .HCount(HCount));
	
	//RisingEdgeDetector	RiseDetect(.Clock(Clock), .Reset(Reset), .In(HIs1440), .Out(Vtrigger));
	
	//VCount					VCounter(.Clock(Clock), .Reset(Reset), .VEn(Vtrigger), .VCount(VCount), .HCount(HCount));
	
	//HFSM						HFSM(.Clock(Clock), .Reset(Reset), .HCount(HCount), .I2CDone(I2CDone), .HMuxControl(HFSMOut), .CntCtrl(CntCtrl), .State(HState));
	//VFSM						VFSM(.Clock(Clock), .Reset(Reset), .I2Cdone(I2CDone), .Line(VCount), .BlankGen(VBlank), .Even_Odd(EvenOdd), .State(VState));
	
	//AddressLogic			AddressLogic(.Clock(Clock), .Reset(Reset), .VBlank(VBlank), .CntCtrl(CntCtrl), .HCtrl(HFSMOut), .EvenOdd(EvenOdd), .InRequest(InRequest), .InRequestLine(InRequestLine), .Vtrigger(Vtrigger), .HCount(HCount));
	
	DataClip					DataClip(.Data(DIn), .DOut(Clipped));
	
	BlankGenMux				BlankGenMux(.Clock(Clock), .Reset(Reset | ~I2CDone), .VBlank(VBlank), .HMux(HMux), .Data(Clipped), .DOut(ShiftIn), .EvenOdd(EvenOdd));

	ShiftRegister			ShiftRegister(.PIn({ShiftIn[7:0], ShiftIn[15:8], ShiftIn[23:16], ShiftIn[31:24]}), .SIn(8'h0), .POut(), .SOut(ShiftOut), .Load((ShiftCount == 2'b00) & I2CDone), .Enable(I2CDone), .Clock(Clock), .Reset(Reset));
								defparam ShiftRegister.swidth = 8;
								
	IORegister				IOReg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(I2CDone), .In({ShiftOut,2'b00}), .Out(VE_P));
								defparam IOReg.width = 10;
	Counter					RegCount(.Clock(Clock), .Reset(~I2CDone | (ShiftCount == 2'b11)), .Set(1'b0), .Load(1'b0), .Enable(I2CDone), .In(2'b00), .Count(ShiftCount));
								defparam RegCount.width = 2;
	
	//Counter					VBlankCount(.Clock(Clock), .Reset(~I2CDone | VCount == 10'h000), .Set(1'b0), .Load(1'b0), .Enable(Vtrigger & VBlank), .In(6'h00), .Count(VBlankCount));
	//							defparam VBlankCount.width = 6;
	
	//RisingEdgeDetector	RiseDetect(.Clock(Clock), .Reset(Reset), .In(VBlank), .Out(VBlankCountEn));
	//Counter					PairCount(.Clock(Clock), .Reset(~I2CDone | ~CntCtrl), .Set(1'b0), .Load(1'b0), .Enable(InRequest & CntCtrl), .In(9'h000), .Count(InRequestPair));
	//							defparam PairCount.width = 9;
	// We recommend that you add more verilog into this area...

	//---------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------