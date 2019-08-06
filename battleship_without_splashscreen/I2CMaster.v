//-----------------------------------------------------------------------
//	File:		$RCSfile: I2CMaster.v,v $
//	Version:	$Revision: 1.12 $
//	Desc:		I2C Bus Master
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2003 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: I2CMaster.v,v $
//	Revision 1.12  2004/08/18 15:52:32  Administrator
//	Fixed comment
//	
//	Revision 1.11  2004/07/30 20:24:21  SYSTEM
//	Changed OpCode to InOpCode
//	
//	Revision 1.10  2004/07/30 02:31:09  Administrator
//	Reformatted
//	Added Comments
//	Untested
//	
//	Revision 1.9  2004/07/30 01:22:26  SYSTEM
//	Moved pullups to modules
//	
//	Revision 1.8  2004/07/26 23:29:32  Administrator
//	Added more comments
//	
//	Revision 1.7  2004/07/26 23:16:06  Administrator
//	Fixed clock stretching
//	Tested start, write, restart, read, stop cycle
//	Tested at 400kHz/1kHz
//	Fully Working
//	
//	Revision 1.6  2004/07/26 17:49:29  Administrator
//	Preparing for rewrite to support clock stretching
//	
//	Revision 1.5  2004/07/23 23:45:59  Administrator
//	Working on clock stretching
//	Still not working
//	
//	Revision 1.4  2004/07/23 21:18:51  Administrator
//	Fixed Minor Typo
//	
//	Revision 1.3  2004/07/23 03:05:30  Administrator
//	Fixed InAck/Read Bug
//	Fixed testbench support for variable parameters
//	
//	Revision 1.2  2004/07/23 01:31:43  Administrator
//	Simulated Start/Write/Stop Cycle
//	Fully Working
//	Make sure to check pull-ups on board
//	
//	Revision 1.1  2004/07/22 23:35:17  Administrator
//	Initial Import
//	Working on I2CMaster, not finished
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Includes
//-----------------------------------------------------------------------
`include "Const.v"
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		I2CMaster
//	Desc:		This module is meant to be an I2C Bus Master.
//			When not busy it will "InRequest" a new operation.
//			A new transmit, receive or restart, when
//			signaled on the OpCode input will cause this
//			module to execute that transfer (or send a
//			restart signal) and signal an "InAck" if it
//			completes successfully.  Data read from an I2C
//			slave will be reported along with the "InAck" and
//			"OutValid" for the read that returned that data.
//	Params:		clockfreq:	The frequency of the system clock
//			i2crate:	Data rate to be used on the I2C
//					bus (100k default, 400k fast)
//-----------------------------------------------------------------------
module	I2CMaster(SDA, SCL, Clock, Reset, InOpCode, DIn, InRequest, InAck, DOut, OutValid);
	//---------------------------------------------------------------
	//	Parameters
	//---------------------------------------------------------------
	parameter		clockfreq =		27000000,
				i2crate =		400000;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	OpCodes
	//---------------------------------------------------------------
	parameter		OP_NOP =		2'b00,
				OP_Read =		2'b01,
				OP_Write =		2'b10,
				OP_Restart =		2'b11;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Constants
	//---------------------------------------------------------------
	`ifdef MACROSAFE
	localparam		cycles =		(clockfreq / i2crate) + 1,
				cyclebits =		`log2(cycles);
	`endif
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	I2C Bus
	//---------------------------------------------------------------
	inout			SDA, SCL; /* synthesis xc_pullup = 1 */
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	System Inputs
	//---------------------------------------------------------------
	input			Clock, Reset;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Input Host Interface
	//---------------------------------------------------------------
	input	[1:0]		InOpCode;
	input	[7:0]		DIn;
	output			InRequest, InAck;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Output Host Interface
	//---------------------------------------------------------------
	output	[7:0]		DOut;
	output			OutValid;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	State Encodings
	//---------------------------------------------------------------
	localparam		STATE_NOP =		3'b000,
				STATE_Start =		3'b001,
				STATE_Write =		3'b010,
				STATE_CheckInAck =	3'b011,
				STATE_Read =		3'b100,
				STATE_SendInAck =	3'b101,
				STATE_Stop =		3'b110,
				STATE_Restart =		3'b111,
				STATE_X =		3'bxxx;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Wires and Regs
	//---------------------------------------------------------------
	wire	[2:0]		SCLLast;
	wire	[1:0]		CurrentOpCode;

	wire			SData, SDataEnable;

	wire			LongOp, StartStopOp, DisableSCLOp, LoadOp, DoneOp, GetNextOp;
	wire			SDAOutShift, SDAStartStopShift, SDAInShift, SDAShift, BitCount, BitReset;

	wire			CycleCountReset, CycleCountEnable;
	wire	[cyclebits-1:0]	CycleCount;
	wire	[2:0]		Bit;

	reg	[2:0]		CurrentState, NextState, LastState;
	reg	[7:0]		SDataSequence;
	reg			SDataEnableNext, InRequest, InAck, OutValid;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Assigns and Decodes
	//---------------------------------------------------------------
	assign	SCL =				(CycleCount[cyclebits-1] | DisableSCLOp) ? 1'bz : 1'b0;
	assign	SDA =				SDataEnable ? SData : 1'bz;

	assign	LongOp =			(CurrentState == STATE_Read) | (CurrentState == STATE_Write);
	assign	StartStopOp =			(LastState == STATE_Start) | (LastState == STATE_Stop) | (LastState == STATE_Restart);
	assign	DisableSCLOp =			(CurrentState == STATE_NOP) | (CurrentState == STATE_Start);
	assign	LoadOp =			&Bit & (~|CycleCount[cyclebits-1:cyclebits-2]) & (&CycleCount[cyclebits-3:0]);
	assign	DoneOp =			&Bit & SCLLast[0] & ~SCLLast[1];
	assign	GetNextOp =			&Bit & SCLLast[1] & ~SCLLast[2];

	assign	SDAOutShift =			(~|CycleCount[cyclebits-1:cyclebits-2]) & (&CycleCount[cyclebits-3:0]);
	assign	SDAStartStopShift =		(LastState == STATE_Restart) & (&Bit) & CycleCount[cyclebits-1] & ~CycleCount[cyclebits-2] & (&CycleCount[cyclebits-3:0]);
	assign	SDAInShift =			(SCL & ~SCLLast[0]);
	assign	SDAShift =			SDataEnable ? (SDAOutShift | SDAStartStopShift) : SDAInShift;
	assign	BitCount =			(SDataEnable ? SDAOutShift : SDAInShift) | LoadOp;
	assign	BitReset =			(LoadOp & (CurrentState == STATE_Read)) | (BitCount & ~LongOp);

	assign	CycleCountReset =		~SCL & SCLLast & CycleCount[cyclebits-1];
	assign	CycleCountEnable =		SCL | ~CycleCount[cyclebits-1];
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Pullups
	//---------------------------------------------------------------
	// synthesis translate_off
	pullup		pscl(SCL);
	pullup		psda(SDA);
	// synthesis translate_on
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Last Value/Delay Registers
	//---------------------------------------------------------------
	ShiftRegister #(3,1) SRegSCL(.PIn(3'b111), .SIn(SCL & CycleCount[cyclebits-1]), .POut(SCLLast), .SOut(), .Load(Reset), .Enable(1'b1), .Clock(Clock), .Reset(1'b0));
	Register #(1) RegSDE(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(LoadOp), .In(SDataEnableNext), .Out(SDataEnable));
	Register #(2) OpReg(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Enable(GetNextOp), .In(InOpCode), .Out(CurrentOpCode));
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Serial Data Shift Register
	//---------------------------------------------------------------
	ShiftRegister	SDASh(	.PIn(		SDataSequence),
				.SIn(		SDA),
				.POut(		DOut),
				.SOut(		SData),
				.Load(		LoadOp),
				.Enable(	SDAShift),
				.Clock(		Clock),
				.Reset(		Reset));
	defparam	SDASh.pwidth =		8;
	defparam	SDASh.swidth =		1;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Cycle Counter
	//---------------------------------------------------------------
	Counter		CCnt(	.Clock(		Clock),
				.Reset(		Reset | CycleCountReset),
				.Set(		1'b0),
				.Load(		1'b0),
				.Enable(	CycleCountEnable),
				.In(		{cyclebits{1'bx}}),
				.Count(		CycleCount));
	defparam	CCnt.width =		cyclebits;
	Counter		BCnt(	.Clock(		Clock),
				.Reset(		1'b0),
				.Set(		Reset | BitReset),
				.Load(		1'b0),
				.Enable(	BitCount),
				.In(		3'bxxx),
				.Count(		Bit));
	defparam	BCnt.width =		3;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Current State Register
	//---------------------------------------------------------------
	always @ (posedge Clock) begin
		if (Reset) begin
			CurrentState <=						STATE_NOP;
			LastState <=						STATE_NOP;
		end
		else if (GetNextOp) begin
			CurrentState <=						NextState;
			LastState <=						CurrentState;
		end
	end
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Next State Logic
	//---------------------------------------------------------------
	always @ (*) begin
		NextState =							CurrentState;
		SDataSequence =							8'hxx;
		SDataEnableNext =						1'b0;
		InRequest =							1'b0;
		InAck =								1'b0;
		OutValid =							1'b0;

		case (CurrentState)
			STATE_NOP: begin
				InRequest =					DoneOp;
				InAck =						DoneOp;
				if (InOpCode != OP_NOP) NextState =		STATE_Start;
			end
			STATE_Start: begin
				SDataSequence =					{2'b00, 6'bxxxxxx};
				SDataEnableNext =				1'b1;
				case (CurrentOpCode)
					OP_Write: NextState =			STATE_Write;
					OP_Read: NextState =			STATE_Read;
					default: begin
						NextState =			STATE_NOP;
						InRequest =			DoneOp;
						InAck =				DoneOp;
					end
				endcase
			end
			STATE_Write: begin
				SDataSequence =					DIn;
				SDataEnableNext =				1'b1;
				NextState =					STATE_CheckInAck;
			end
			STATE_CheckInAck: begin
				InRequest =					DoneOp;
				InAck =						DoneOp & DOut[0];
				case (InOpCode)
					OP_NOP: NextState =			STATE_Stop;
					OP_Read: NextState =			STATE_Read;
					OP_Write: NextState =			STATE_Write;
					OP_Restart: NextState =			STATE_Restart;
				endcase
			end
			STATE_Read: begin
				NextState =					STATE_SendInAck;
				OutValid =					DoneOp;
			end
			STATE_SendInAck: begin
				SDataSequence =					{(InOpCode == OP_Read), 7'bxxxxxxx};
				SDataEnableNext =				1'b1;

				InRequest =					DoneOp;
				InAck =						DoneOp;
				case (InOpCode)
					OP_NOP: NextState =			STATE_Stop;
					OP_Read: NextState =			STATE_Read;
					OP_Write: NextState =			STATE_Write;
					OP_Restart: NextState =			STATE_Restart;
				endcase
			end
			STATE_Stop: begin
				SDataSequence =					{2'b01, 6'bxxxxxx};
				SDataEnableNext =				1'b1;
				NextState =					STATE_NOP;
			end
			STATE_Restart: begin
				SDataSequence =					{2'b10, 6'bxxxxxx};
				SDataEnableNext =				1'b1;

				InRequest =					DoneOp;
				InAck =						DoneOp;
				case (InOpCode)
					OP_NOP: NextState =			STATE_Stop;
					OP_Read: NextState =			STATE_Read;
					OP_Write: NextState =			STATE_Write;
					OP_Restart: NextState =			STATE_Restart;
				endcase
			end
			default: begin
				NextState =					STATE_X;
				SDataSequence =					8'hxx;
				SDataEnableNext =				1'bx;
				InRequest =					1'bx;
				InAck =						1'bx;
			end
		endcase
	end
	//---------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------