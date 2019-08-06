
module ReceiveFSM(Clock, Reset,
						SrcAddr, DestAddr,
						Rx_en, 
						InRequest,
						BadData, Full, FIFO, FIFOP,
						WEn, EndSession, DiscardSession,
						Command,
						InValid,
						Rx_done,
						State
						);

	//---------------------------------------------------------------
	//	Input / Output
	//---------------------------------------------------------------
	//System Inputs
	input					Clock, Reset;
	
	//Source and Destination from Game engine
	input		[7:0]		SrcAddr, DestAddr;
	
	//SPIControlFSM control signals
	input					Rx_en;
		
	//Input from SPI
	input					InRequest;

	//Data flags
	input					BadData, Full, FIFO, FIFOP;
	
	//Outputs for SPIFIFO
	output				WEn, EndSession, DiscardSession;
	
	//Outputs for SPI
	output	[7:0]		Command;
	output				InValid;
	
	//Control for SPIControlFSM
	output				Rx_done;
	
	//Chipscope debugging
	output	[4:0]		State;
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Wires
	//---------------------------------------------------------------
	wire FlushRxFIFO;
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Regs
	//---------------------------------------------------------------
	reg		[4:0]		CurrentState, NextState;
	reg					WEn, EndSession, DiscardSession;
	reg		[7:0]		Command;
	reg					InValid;
	reg					Rx_done;
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Parameters
	//---------------------------------------------------------------
	parameter STATE_Init				= 5'd0;
	parameter STATE_Rx0				= 5'd1;
	parameter STATE_Rx1				= 5'd2;
	parameter STATE_Rx2				= 5'd3;
	parameter STATE_Rx3				= 5'd4;
	parameter STATE_Rx4				= 5'd5;
	parameter STATE_Rx5W				= 5'd6;
	parameter STATE_Rx5				= 5'd7;
	parameter STATE_Rx6W				= 5'd8;
	parameter STATE_Rx6				= 5'd9;
	parameter STATE_Rx7W				= 5'd10;
	parameter STATE_Rx7				= 5'd11;
	parameter STATE_Rx8W				= 5'd12;
	parameter STATE_Rx8				= 5'd13;
	parameter STATE_Rx9				= 5'd14;
	parameter STATE_CheckValid1	= 5'd15;
	parameter STATE_CheckValid2	= 5'd16;
	parameter STATE_EndSession		= 5'd17;
	parameter STATE_FlushD			= 5'd18;
	parameter STATE_Flush0			= 5'd19;
	parameter STATE_Flush1			= 5'd20;
	parameter STATE_Flush2			= 5'd21;
	parameter STATE_Flush3			= 5'd22;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	FSM
	//---------------------------------------------------------------
	//for chipscope debugging
	assign State = CurrentState;
	
	//chris! Assign every combination that requires a flush of the rx fifo here
	//one is: (~FIFO & FIFOP) | BadData (what about Full?)
	assign FlushRxFIFO = ((~FIFO & FIFOP) | BadData | Full);
	
	always @ ( posedge Clock ) begin
		if (Reset)
			CurrentState <= STATE_Init;
		else
			CurrentState <= NextState;
	end
	
	always @ ( * ) begin
		NextState = CurrentState;
		
		//SPI Outputs
		Command = 8'h00;
		InValid = 1'b0; 
		
		//SPIFIFO Outputs
		WEn = 1'b0; 
		EndSession = 1'b0;  
		DiscardSession = 1'b0; 

		//SPIControlFSM Outputs
		Rx_done = 1'b0; 
		
		case(CurrentState)
			STATE_Init: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (Rx_en & InRequest)
					NextState = STATE_Rx0;
				//Outputs
			end
			
			STATE_Rx0: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_Rx1;
				//Outputs
				InValid = 1'b1;
				Command = 8'h7f;
			end
			
			STATE_Rx1: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_Rx2;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_Rx2: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_Rx3;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_Rx3: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_Rx4;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_Rx4: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_Rx5W;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_Rx5W: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else //transition on next clock cycle
					NextState = STATE_Rx5;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
				WEn = 1'b1;
			end
			
			STATE_Rx5: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_Rx6W;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_Rx6W: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else //transition on next clock cycle
					NextState = STATE_Rx6;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
				WEn = 1'b1;
			end
			
			STATE_Rx6: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_Rx7W;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_Rx7W: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else //transition on next clock cycle
					NextState = STATE_Rx7;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
				WEn = 1'b1;
			end
			
			STATE_Rx7: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_Rx8W;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_Rx8W: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else //transition on next clock cycle
					NextState = STATE_Rx8;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
				WEn = 1'b1;
			end
			
			STATE_Rx8: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_Rx9;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_Rx9: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else if (InRequest)
					NextState = STATE_CheckValid1;
				//Outputs
				InValid = 1'b1;
				Command = 8'h00;
			end
			
			STATE_CheckValid1: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else
					NextState = STATE_CheckValid2;
				//Outputs
			end
			
			STATE_CheckValid2: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else
					NextState = STATE_EndSession;
				//Outputs
			end
			
			STATE_EndSession: begin
				//State Transition
				if (FlushRxFIFO) 
					NextState = STATE_FlushD;
				else
					NextState = STATE_Init;
				//Outputs
				EndSession = 1'b1;
				Rx_done = 1'b1;
			end
			
			STATE_FlushD: begin
				//State Transition
				if (InRequest) 
					NextState = STATE_Flush1;
				else
					NextState = STATE_Flush0;
				//Outputs
				DiscardSession = 1'b1;
			end
			
			STATE_Flush0: begin
				//State Transition
				//chris! will inrequest still be going when i issue a sflushrx, i think i could use that...
				if (InRequest)
					NextState = STATE_Flush1;
				//Outputs
			end
			
			STATE_Flush1: begin
				//State Transition
				//chris! will inrequest still be going when i issue a sflushrx, i think i could use that...
				if (InRequest)
					NextState = STATE_Flush2;
				//Outputs
				InValid = 1'b1;
				Command = 8'h08;
			end
			
			STATE_Flush2: begin
				//State Transition
				//chris! i'm not sure about using invalid for this, check to see if it works
				//another option is to stay in this state for 1 cycle and then transition, but
				//i don't know how long the outputs should stay valid for.
				if (InRequest)
					NextState = STATE_Flush3;
				//Outputs
				InValid = 1'b1;
				Command = 8'h08;
			end
			
			STATE_Flush3: begin
				//State Transition
					NextState = STATE_Init;
				//Outputs
				Rx_done = 1'b1;
			end
			
			default: begin
			end
		endcase
	end

	//---------------------------------------------------------------	

endmodule
