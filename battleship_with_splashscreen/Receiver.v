//Charlie Lin
//EECS 150
//Checkpoint 1 Receiver

//Module Receiver

module Receiver(Din, Clock, Rec_Reset, Rec_en, Dout, Timeout, OutValid);
	
	
	//////////////////////////////////////////
	//Inputs
	//////////////////////////////////////////
	input Din;
	input Rec_en;
	input Clock;
	input Rec_Reset;
	
	//////////////////////////////////////////
	//Outputs
	//////////////////////////////////////////

	output [29:0] Dout;
	output Timeout;
	output OutValid;
	//output [5:0] RegCount_Out;
	
	//////////////////////////////////////////
	//Intermediate Wires and Regs
	//////////////////////////////////////////
	
	wire[5:0] RegCount_Out;
	wire[7:0] Count_Out;
	wire[31:0] Shift_Out;
	wire Fall_Out;
	wire Rise_Out;
	wire ShiftEn;
	wire RiseEn;
	
	//////////////////////////////////////////
	//Instantiations
	//////////////////////////////////////////
	
	
	ShiftRegisterN64 ShiftReg(.PIn(32'h00000000), .DIn(Din), .POut(Shift_Out), .SOut(), .Load(1'b0), .Enable(ShiftEn), .Clock(Clock), .Reset(Rec_Reset));
	
	Counter		MainCount(.Clock(Clock), .Reset(Rec_Reset | Fall_Out), .Set(1'b0), .Load(1'b0), .Enable(1'b1), .In(8'h00), .Count(Count_Out));
					defparam		MainCount.width = 8;
					
	Counter		RegCount(.Clock(Clock), .Reset(Rec_Reset | OutValid), .Set(1'b0), .Load(1'b0), .Enable(Fall_Out), .In(6'h00), .Count(RegCount_Out));
					defparam		RegCount.width = 6;
	
	FallingEdgeDetector  FallDetector(.Clock(Clock), .Reset(Rec_Reset), .In(Din), .Out(Fall_Out));
	

	RisingEdgeDetector	RiseDetector(.Clock(Clock), .Reset(Rec_Reset), .In(RiseEn), .Out(Rise_Out));
	//////////////////////////////////////////
	//Assignments
	//////////////////////////////////////////
	assign Dout = {Shift_Out[31:24],Shift_Out[21:0]};
	assign Timeout = (Count_Out == 8'hC8);			//hex number is 200
	assign OutValid = Rise_Out;
	assign ShiftEn = (Count_Out==8'h046) & (RegCount_Out<=6'h20) ; //The hex numbers here are 70 and 32
	assign RiseEn = (6'h21==RegCount_Out) & Din;	//the hex number here is 33
	
endmodule
