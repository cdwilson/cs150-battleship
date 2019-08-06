//////////////////////////////////////////////////////////////////////////////////
//Charlie Lin
//EECS150
//
//Rising Edge Detector Module
//////////////////////////////////////////////////////////////////////////////////
module RisingEdgeDetector(Clock, Reset, In, Out);
	input Clock;
   input Reset;
   input In;
	
	output Out;
	
	reg[1:0] A;		//A[0] will be old input, A[1] will take new
	
	assign Out = ~A[0] & A[1];
	always@(posedge Clock) begin
		if(Reset) begin
			A[0] <= 1'b0;
			A[1] <= 1'b0;
		end
		else begin
			A[0] <= A[1];
			A[1] <= In;
		end
	end

endmodule
