//-----------------------------------------------------------------------
//	File:		$RCSfile: N64.v,v $
//	Version:	$Revision: 1.1 $
//	Desc:		N64 Game Controller Interface
//	Authors:	Put your names here...
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: N64.v,v $
//	Revision 1.1  2004/09/23 00:27:38  SYSTEM
//	Created Checkpoint1
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		N64
//	Desc:		This module will continuously poll an N64
//			controller and report the state of its buttons
//			and the analog joystick.  Every time a new status
//			report is availible it will appear on DOut and
//			this module will signal OutValid.
//
//			The format of the DOut bus is as follows:
//			BitRange	Button
//			29		A
//			28		B
//			27		Z
//			26		Start
//			25:22		D-Pad
//				25		Up
//				24		Down
//				23		Left
//				22		Right
//			21		L
//			20		R
//			19:16		C-Arrows
//				19		Up
//				18		Down
//				17		Left
//				16		Right
//			15:0		Analog Joystick
//				15:8		Left/Center/Right (-/0/+)
//				7:0		Up/Center/Down (+/0/-)
//	Params:		clockfreq:	Frequency of the system clock
//-----------------------------------------------------------------------
module	N64(N64_DQ, Clock, Reset, DOut, OutValid, State, Send_done, Send_DOut, regcnt_out);
	//---------------------------------------------------------------
	//	Parameters
	//---------------------------------------------------------------
	parameter		clockfreq =		27000000;
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Inputs/Outputs
	//---------------------------------------------------------------
	inout N64_DQ;
	output[29:0] DOut;
	output OutValid;
	
	//TESTING OUTPUTS
	
	output [2:0] State;
	output Send_done;
	output Send_DOut;
	output [5:0] regcnt_out;
	
	
	input Clock;
	input Reset;
	
	
	//---------------------------------------------------------------
	//	Wires & Regs
	//---------------------------------------------------------------
	
	wire Rec_OutValid;
	wire FSMRecReset;
	wire Rec_Reset;
	wire Rec_Status;
	wire Rec_en;
	wire Timeout;
	
	wire Send_en;
	wire Send_Ctrl;
	wire Send_done;
	wire Send_DOut;
	
	//wire [2:0] State;
	//---------------------------------------------------------------
	//	Instantiations
	//---------------------------------------------------------------	
	
	Receiver Receiver(.Din(N64_DQ), .Clock(Clock), .Rec_Reset(Rec_Reset), .Rec_en(Rec_en), .Dout(DOut), .Timeout(Timeout), .OutValid(Rec_OutValid)/*, .RegCount_Out(regcnt_out)*/);
	
	ControlFSM ControlFSM(.Clock(Clock), .Reset(Reset), .Rec_Reset(FSMRecReset), .Rec_en(Rec_en), .Send_en(Send_en), .Send_Ctrl(Send_Ctrl), .Rec_Status(Rec_Status), .Send_done(Send_done), .Timeout(Timeout), .OutValid(Rec_OutValid), .State(State));
	
	Sender Sender(.Clock(Clock), .Reset(Reset), .Send_En(Send_en), .Code_Control(Send_Ctrl), .Dout(Send_DOut), .Send_Done(Send_done));
	
	assign Rec_Reset = FSMRecReset | Reset;
	assign OutValid = Rec_OutValid & Rec_Status;
	
	//Tristate vertex controller mwahahahaha
	assign N64_DQ = (Send_en & ~Send_DOut) ? 1'b0: 1'bz;
	
	
	
endmodule
//-----------------------------------------------------------------------