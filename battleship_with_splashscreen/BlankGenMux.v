//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:02:18 10/20/2006 
// Design Name: 
// Module Name:    BlankGenMux 
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
module BlankGenMux(Clock, Reset, VBlank, HMux, Data, DOut, EvenOdd);
   
	//Inputs
	input Clock;
	input Reset;
	
	input EvenOdd;
	input VBlank;
   //input EAV;
	//input SAV;
	//input HBlank;
	//input HActive;
	//input [1:0] HMux;
   input [3:0] HMux;
	input [31:0] Data;
   
	//Outputs
	output [31:0] DOut;
	
	//Regs and Wires
	reg [31:0] DOut;
	//wire [31:0] DOut;
	
	//reg VBlankD;
	//reg [1:0] HMuxD;
	//wire[31:0] BlankData = 32'hd291d210;
	wire[31:0] BlankData = 32'h10801080;
	wire[31:0] Header;
	wire HeadFlag;
	wire E3, E2, E1, E0;	
	
	assign HeadFlag = HMux[3] ? 1'b1 : 1'b0;
	assign E3 = VBlank^HeadFlag;
	assign E2 = EvenOdd^HeadFlag;
	assign E1 = EvenOdd^VBlank;
	assign E0 = EvenOdd^VBlank^HeadFlag;

	assign Header = {1'b1, EvenOdd, VBlank, HeadFlag, E3, E2, E1, E0, 24'h0000FF}; 
	/*
	Delay		Delay1(.Clock(Clock), .Reset(Reset), .Data(VBlank), .DOut(VBlankD));
	Delay		Delay2(.Clock(Clock), .Reset(Reset), .Data(HMux), .DOut(HMuxD));
		defparam Delay2.width=2;*/
		
	//Parameters
	parameter EAVM = 4'b1000;
	parameter SAVM = 4'b0100;
	parameter BlankM = 4'b0010;
	parameter ActiveM = 4'b0001;
	
	//wire [31:0] blanker;
	//assign blanker = HMux[1] ? BlankData : Header;
	//assign DOut = (HMux[0]&~VBlank) ? Data : blanker;
	

	always @ ( * ) begin
		
		case(HMux)
		
			ActiveM: begin
				if(~VBlank)
					DOut = Data;
				else
					DOut = BlankData;
			end
			
			BlankM: begin
				DOut = BlankData;
			end
			
			EAVM: begin
				DOut = Header;
			end
			
			SAVM: begin
				DOut = Header;
			end
			
			default: begin
				DOut = BlankData;
			end
		
		endcase
		
	end
	
	
endmodule
