//Charlie Lin
//EECS150

//-----------------------------------------------------------------------
//	Module:		ShiftRegister
//	Behavior: Takes new input at DIn and places at Out[31]
// The other digits then get shifted so that Out[0] will always be the 
// input that's oldest
//-----------------------------------------------------------------------
module ShiftRegisterN64(PIn, DIn, POut, SOut, Load, Enable, Clock, Reset);
	//---------------------------------------------------------------
	//	Parameters
	//---------------------------------------------------------------
	parameter		width =		32;	// The parallel width
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	I/O
	//---------------------------------------------------------------
	input		DIn;
	input 	[width-1:0]	PIn;
	output	[width-1:0]	POut;
	output	SOut;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Control Inputs
	//---------------------------------------------------------------
	input			Load, Enable, Clock, Reset;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Registers
	//---------------------------------------------------------------
	reg	[width-1:0]	POut;
	reg	SOut;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Behavioral Shift Register Core
	//---------------------------------------------------------------
	always @ (posedge Clock) begin
		if (Reset) POut <=		{width{1'b0}};
		else if (Load) POut <=		PIn;
		else if (Enable) POut <=	{POut[width-2:0], DIn};
		
		SOut <= POut[width-1];
	end
	//---------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------