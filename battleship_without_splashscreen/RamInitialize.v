module RamInitialize(Clock, Reset, WEnable, WData, WRow, WCol);
	
	input Clock;
	input Reset;
	
	output WEnable;
	output [9:0] WData;
	output [3:0] WRow;
	output [3:0] WCol;
	
	
	reg 		WEnable;
	reg[9:0] WData;
	reg[3:0]	WRow;
	reg[3:0]	WCol;
	reg En;
	
	reg [3:0]	CurState;
	reg [3:0]	NextState;
	
	wire[7:0] Addr;
	
	parameter STATE_Init0 = 4'h0;
	parameter STATE_Init1 = 4'h1;
	parameter STATE_Init2 = 4'h2;
	parameter STATE_Init3 = 4'h3;
	parameter STATE_Init4 = 4'h4;
	parameter STATE_Init5 = 4'h5;
	parameter STATE_Init6 = 4'h6;
	parameter STATE_Init7 = 4'h7;
	parameter STATE_Init8 = 4'h8;
	parameter STATE_Init9 = 4'h9;
	parameter STATE_Init10 = 4'hA;
	parameter STATE_Init11 = 4'hB;
	parameter STATE_Init12 = 4'hC;
	parameter STATE_Init13 = 4'hD;
	parameter STATE_Init14 = 4'hE;
	parameter STATE_Init15 = 4'hF;
	
	Counter 	Count(.Clock(Clock), .Reset(Reset), .Set(1'b0), .Load(1'b0), .Enable(En), .In(8'h00), .Count(Addr));
				defparam Count.width = 8;
	
	
	always @(posedge Clock) begin
		if(Reset)
			CurState <= STATE_Init0;
		else
			CurState <= NextState;
			
	end
	
	
	always @ ( * ) begin
		WData = 10'h000;
		WEnable = 1'b0;
		En = 1'b0;
		NextState = CurState;
		
		case(CurState)
			STATE_Init0: begin
				WEnable = 1'b1;
				
			end
			
			STATE_Init1: begin
				if(Addr == 8'd1)
					NextState = STATE_Init2;
				
				
				WEnable = 1'b1;
				WRow = Addr[7:4];
				WCol = Addr[3:0];
				WData = 10'b0000100010;
				
				En = 1'b1;
			end
			
			STATE_Init2: begin
				if(Addr == 8'd16)
					NextState = STATE_Init3;
				En = 1'b1;
			end
			
			STATE_Init3: begin
				if(Addr == 8'd17)
					NextState = STATE_Init4;
				
				WEnable = 1'b1;
				WRow = Addr[7:4];
				WCol = Addr[3:0];
				WData = 10'b0000000010;
				En = 1'b1;
			end
			
			STATE_Init4: begin
				if(Addr == 8'd18)
					NextState = STATE_Init5;
				
				WEnable = 1'b1;
				WRow = Addr[7:4];
				WCol = Addr[3:0];
				WData = 10'b0000000110;
				En = 1'b1;
				
			end
				
			STATE_Init5: begin
				if(Addr == 8'd20)
					NextState = STATE_Init6;
					
				En = 1'b1;
			end
			
			STATE_Init6: begin
				if(Addr == 8'd21)
					NextState = STATE_Init7;
					
				WEnable = 1'b1;
				WRow = Addr[7:4];
				WCol = Addr[3:0];
				WData = 10'b0000000010;
				En = 1'b1;
			end
			
			STATE_Init7: begin
				if(Addr == 8'd22)
					NextState = STATE_Init8;
					
				WEnable = 1'b1;
				WRow = Addr[7:4];
				WCol = Addr[3:0];
				WData = 10'b0000000100;
				En = 1'b1;
			end
			
			STATE_Init8: begin
				if(Addr == 8'd23)
					NextState = STATE_Init9;
				
				WEnable = 1'b1;
				WRow = Addr[7:4];
				WCol = Addr[3:0];
				WData = 10'b0000000110;
				En = 1'b1;
			end
			
			STATE_Init9: begin
				if(Addr == 8'd32)
					NextState = STATE_Init10;
				
				En = 1'b1;
			end
			
			//BEGIN STAR DESTROYER
			STATE_Init10: begin
				//if(Addr == 8'd33)
				NextState = STATE_Init11;
					
				WEnable = 1'b1;
				WRow = 4'h2;
				WCol = 4'h0;
				//WRow = Addr[7:4];
				//WCol = Addr[3:0];
				WData = 10'b0000001110;
				En = 1'b1;
			end
			
			STATE_Init11: begin
				//if(Addr == 8'd34)
				NextState = STATE_Init12;
					
				WEnable = 1'b1;
				WRow = 4'h2;
				WCol = 4'h1;
				//WRow = Addr[7:4];
				//WCol = Addr[3:0];
				WData = 10'b0000010000;
				En = 1'b1;
			end
			
			STATE_Init12: begin
				//if(Addr == 8'd35)
				NextState = STATE_Init13;
					
				WEnable = 1'b1;
				WRow = 4'h2;
				WCol = 4'h2;
				//WRow = Addr[7:4];
				//WCol = Addr[3:0];
				WData = 10'b0000010010;
				En = 1'b1;
			end
			
			STATE_Init13: begin
				//if(Addr == 8'd36)
				NextState = STATE_Init14;
					
				WEnable = 1'b1;
				WRow = 4'h2;
				WCol = 4'h3;
				//WRow = Addr[7:4];
				//WCol = Addr[3:0];
				WData = 10'b0000010100;
				En = 1'b1;
			end
			
			STATE_Init14: begin
				//if(Addr == 8'd37)
					NextState = STATE_Init15;
					
				WEnable = 1'b1;
				WRow = 4'h2;
				WCol = 4'h4;
				//WRow = Addr[7:4];
				//WCol = Addr[3:0];
				WData = 10'b0000010110;
				En = 1'b1;
			end
			
			STATE_Init15: begin

			end
		endcase
	
	end


endmodule