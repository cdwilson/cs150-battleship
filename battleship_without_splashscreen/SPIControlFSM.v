
module SPIControlFSM(Clock, Reset,
							Start, Channel,
							Init_done, Tx_done, Rx_done, ChannelChange_done,						
							FIFO, FIFOP, SFD, CCA, 
							Tx_en, Rx_en, Ch_en,
							Ready, State);

	//---------------------------------------------------------------
	//	Input / Output Declarations
	//---------------------------------------------------------------
	
	//System Inputs
	input					Clock, Reset;
	
	//Wireless Data Transmission
	output				Ready;
	input					Start;
	
	//Channel Signals
	input		[3:0]		Channel;
	input					ChannelChange_done;
	output				Ch_en;
	
	//From Initialize FSM
	input					Init_done;
	
	//Tx / Rx Status Signals
	input					Tx_done;
	input					Rx_done;
	
	//Single Bit Input Control Signals
	input					FIFO;
	input					FIFOP;
	input					SFD;
	input					CCA;
	
	//Tx / Rx Control Signals
	output				Tx_en;
	output				Rx_en;
	
	//Chipscope debugging
	output	[2:0]		State;
	
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Wires
	//---------------------------------------------------------------
	wire 					ChannelChange;
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Regs
	//---------------------------------------------------------------
	reg		[2:0]		CurrentState, NextState;
	reg					Ready, Tx_en, Rx_en, Ch_en;
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Parameters
	//---------------------------------------------------------------
	parameter STATE_Init			= 3'b000;
	parameter STATE_Ready 		= 3'b001;
	parameter STATE_Tx 			= 3'b010;
	parameter STATE_Rx 			= 3'b011;
	parameter STATE_Channel		= 3'b100;
	//---------------------------------------------------------------	

	//---------------------------------------------------------------
	//	Instantiations
	//---------------------------------------------------------------
	TrackChannelFSM CCFSM(.Clock(Clock), 
									.Reset(Reset), 
									.Channel(Channel), 
									.ChannelChange_done(ChannelChange_done), 
									.ChannelChange(ChannelChange), 
									.State()); //for chipcon debug
	//---------------------------------------------------------------
	
	
	//---------------------------------------------------------------
	//	FSM
	//---------------------------------------------------------------
	
	//for chipscope debugging
	assign State = CurrentState;
	
	initial begin
		CurrentState 	= STATE_Init;
		NextState 		= CurrentState;
	end
	
	always @ ( posedge Clock ) begin
		if (Reset)
			CurrentState <= STATE_Init;
		else
			CurrentState <= NextState;
	end
	
	always @ ( * ) begin
		NextState = CurrentState;
		Ready = 1'b0;
		Tx_en = 1'b0;
		Rx_en = 1'b0;
		Ch_en = 1'b0;
		
		case(CurrentState)
			STATE_Init: begin
				//State Transition
				if (Init_done) 
					NextState = STATE_Ready;
				//Outputs
			end
			
			STATE_Ready: begin
				//State Transition
				if (ChannelChange)
					NextState = STATE_Channel;
				else if (Start)
					NextState = STATE_Tx;
				else if (FIFO & FIFOP)
					NextState = STATE_Rx;
				//Outputs
				//If there was a channel change, we don't want this to be
				//high during the one clock cycle we are back in the ready
				//state, before transitioning to the Channel state.
				//Therefore, if ChangeChannel is high, we want Ready low.
				//ask charlie if we really want this to do this?
				Ready = (1'b1 & ~ChannelChange);
			end
			
			STATE_Tx: begin
				//State Transition
				if (Tx_done) 
					NextState = STATE_Ready;
				//Outputs
				Tx_en = 1'b1;
			end
			
			STATE_Rx: begin
				//State Transition
				if (Rx_done) 
					NextState = STATE_Ready;
				//Outputs
				Rx_en = 1'b1;
			end
			
			STATE_Channel: begin
				//State Transition
				if (ChannelChange_done) 
					NextState = STATE_Ready;
				//Outputs
				Ch_en = 1'b1;
			end

			default: begin
			end
		endcase
	end

	//---------------------------------------------------------------	
	
	
endmodule
