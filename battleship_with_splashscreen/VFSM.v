//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:53:27 10/19/2006 
// Design Name: 
// Module Name:    VFSM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VFSM(Clock, Reset, I2Cdone, Line, BlankGen, Even_Odd, State);
   //Inputs
	input Clock;
   input Reset;
	input I2Cdone;
   input [9:0] Line;
    
	//Outputs
	output BlankGen;
   output Even_Odd;
	output [2:0] State;
	 
	 
	//Regs and Wires
	reg[2:0] CurState;
	reg[2:0] NextState;
	reg BlankGen;
	reg Even_Odd;
	 
	assign State = CurState;

	parameter	STATE_Init = 3'h0;
	parameter	STATE_Blank_Odd = 3'h1;
	parameter	STATE_Active_Odd = 3'h2;
	parameter	STATE_Blank_Odd2 =	3'h3;
	parameter	STATE_Blank_Even2 =	3'h4;
	parameter	STATE_Active_Even = 3'h5;
	parameter	STATE_Blank_Even = 3'h6;
	
	always @(posedge Clock)	begin
		if(Reset)
			CurState <= STATE_Init;
		else
			CurState <= NextState;
	end
	
	always @ ( Line or CurState or I2Cdone ) begin
		NextState = CurState;
		BlankGen = 1'b0;
		Even_Odd = 1'b0;
		
		case(CurState)
			STATE_Init:	begin
				if(I2Cdone)
					NextState = STATE_Blank_Odd;
				
				//Outputs
				BlankGen = 1'b1;
			end
			
			STATE_Blank_Odd: begin
				if(Line == 10'd14)
					NextState = STATE_Active_Odd;
					
				//Outputs
				BlankGen = 1'b1;
			end
			
			STATE_Active_Odd: begin
				if(Line == 10'd258)
					NextState = STATE_Blank_Odd2;
					
			end
			
			STATE_Blank_Odd2: begin
				if(Line == 10'd262)
					NextState = STATE_Blank_Even2;
					
				//Outputs
				BlankGen = 1'b1;
			end
			
			STATE_Blank_Even2: begin
				if(Line == 10'd277)
					NextState = STATE_Active_Even;
					
				//Outputs
				BlankGen = 1'b1;
				Even_Odd = 1'b1;
			end
			
			STATE_Active_Even: begin
				if(Line == 10'd520)
					NextState = STATE_Blank_Even;
				
				//Outputs
				 Even_Odd = 1'b1;
			end
			
			STATE_Blank_Even: begin
				if(Line == 10'd0)
					NextState = STATE_Blank_Odd;
	
				//Outputs
				BlankGen = 1'b1;
				Even_Odd = 1'b1;
			end
			
			default: begin
			end
		endcase
	end

endmodule
