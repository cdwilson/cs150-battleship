//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:01:14 10/20/2006 
// Design Name: 
// Module Name:    DataClip 
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
module DataClip(Data, DOut);
   input [31:0] Data;
	output [31:0] DOut;
	 
	wire[31:0] DOut;
	/*
	wire[7:0] temp1;
	wire[7:0] temp2;
	wire[7:0] temp3;
	wire[7:0] temp4;
	wire[31:0] unite;
	*/
	
	LowClip Clip1(.Data(Data[31:24]), .DOut(DOut[31:24]));
	LowClip Clip2(.Data(Data[23:16]), .DOut(DOut[23:16]));
	LowClip Clip3(.Data(Data[15:8]), .DOut(DOut[15:8]));
	LowClip Clip4(.Data(Data[7:0]), .DOut(DOut[7:0]));
	
	/*
	assign temp1 = ((Data[31:24] < 8'h10) ? 8'h10 : Data[31:24]);
	assign temp2 = ((Data[23:16] < 8'h10) ? 8'h10 : Data[23:16]);
	assign temp3 = ((Data[15:8] < 8'h10) ? 8'h10 : Data[15:8]);
	assign temp4 = ((Data[7:0] < 8'h10) ? 8'h10 : Data[7:0]);
	assign unite = {temp1, temp2, temp3, temp3};
	assign DOut = unite & 32'hF0F0F0F0;*/
endmodule
