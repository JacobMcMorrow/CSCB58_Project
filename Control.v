module control(
	output reg ld_ins1, // load instrument 1-4
	output reg ld_ins2,
	output reg ld_ins3,
	output reg ld_ins4,
	output reg ld_bpm,
	output reg play, // enable signal
	output reg [3:0] timing, // timing is the beat we are on
	input clk,
	input slow_clk,
	input reset,
	input go
	);
	
	reg [6:0] current_state, next_state, curr_loop_state, next_loop_state;
	
	localparam S_LOAD_INS1 = 7'b000_0000,
		S_LOAD_INS1_WAIT = 7'b000_0001,
		S_LOAD_INS2 = 7'b000_0011,
		S_LOAD_INS2_WAIT = 7'b000_0111,
		S_LOAD_INS3 = 7'b000_1111,
		S_LOAD_INS3_WAIT = 7'b001_1111,
		S_LOAD_INS4 = 7'b011_1111,
		S_LOAD_INS4_WAIT = 7'b111_1111,
		S_LOAD_BPM = 7'b111_1110,
		S_LOAD_BPM_WAIT = 7'b111_1100,
		S_PLAY = 7'b111_1000,
		//
		S_LOOP_WAIT = 7'b000_0000,
		S_QUARTER_NOTE1 = 7'b000_0001,
		S_EIGHTH_NOTE1 = 7'b000_0011,
		S_QUARTER_NOTE2 = 7'b000_0110,
		S_EIGHTH_NOTE2 = 7'b000_1100,
		S_QUARTER_NOTE3 = 7'b001_1000,
		S_EIGHTH_NOTE3 = 7'b011_0000,
		S_QUARTER_NOTE4 = 7'b110_0000,
		S_EIGHTH_NOTE4 = 7'b100_0001;
		
	always @(*)
	begin: state_table
		case (current_state)
			// load bpm - note: will have to check to see if we are loading 0
			S_LOAD_BPM: next_state = go ? S_LOAD_BPM_WAIT : S_LOAD_BPM;
			S_LOAD_BPM_WAIT: next_state = go ? S_LOAD_BPM_WAIT : S_LOAD_INS1;
			// load instrument 1
			S_LOAD_INS1: next_state = go ? S_LOAD_INS1_WAIT : S_LOAD_INS1;
			S_LOAD_INS1_WAIT: next_state = go ? S_LOAD_INS1_WAIT : S_LOAD_INS2;
			// load instrument 2
			S_LOAD_INS2: next_state = go ? S_LOAD_INS2_WAIT : S_LOAD_INS2;
			S_LOAD_INS2_WAIT: next_state = go ? S_LOAD_INS2_WAIT : S_LOAD_INS3;
			// load instrument 3
			S_LOAD_INS3: next_state = go ? S_LOAD_INS3_WAIT : S_LOAD_INS3;
			S_LOAD_INS3_WAIT: next_state = go ? S_LOAD_INS3_WAIT : S_LOAD_INS4;
			// load instrument 4
			S_LOAD_INS4: next_state = go ? S_LOAD_INS4_WAIT : S_LOAD_INS4;
			S_LOAD_INS4_WAIT: next_state = go ? S_LOAD_INS4_WAIT : S_PLAY;
			// loop through the 8 beats indefinitely
			S_PLAY: next_state = S_PLAY;
			default: next_state = S_LOAD_BPM;
		endcase
	end
	
	always @(*)
	begin: load_state_signals
		ld_ins1 <= 1'b0;
		ld_ins2 <= 1'b0;
		ld_ins3 <= 1'b0;
		ld_ins4 <= 1'b0;
		ld_bpm <= 1'b0;
		play <= 1'b0;
		case (current_state)
			S_LOAD_INS1: ld_ins1 <= 1'b1;
			S_LOAD_INS2: ld_ins2 <= 1'b1;
			S_LOAD_INS3: ld_ins3 <= 1'b1;
			S_LOAD_INS4: ld_ins4 <= 1'b1;
			S_LOAD_BPM: ld_bpm <= 1'b1;
			S_PLAY: play <= 1'b1;
			default: play <= 1'b0;
		endcase
	end
	
	always @(*)
	begin: loop_state
		case (curr_loop_state)
			S_LOOP_WAIT: next_loop_state = play ? S_QUARTER_NOTE1 : S_LOOP_WAIT;
			S_QUARTER_NOTE1: next_loop_state = S_EIGHTH_NOTE1;
			S_EIGHTH_NOTE1: next_loop_state = S_QUARTER_NOTE2;
			S_QUARTER_NOTE2: next_loop_state = S_EIGHTH_NOTE2;
			S_EIGHTH_NOTE2: next_loop_state = S_QUARTER_NOTE3;
			S_QUARTER_NOTE3: next_loop_state = S_EIGHTH_NOTE3;
			S_EIGHTH_NOTE3: next_loop_state = S_QUARTER_NOTE4;
			S_QUARTER_NOTE4: next_loop_state = S_EIGHTH_NOTE4;
			S_EIGHTH_NOTE4: next_loop_state = S_QUARTER_NOTE1;
			default: next_loop_state = S_LOOP_WAIT;
		endcase
	end
	
	always @(*)
	begin: loop_state_signals
		timing <= 4'd0;
		case (curr_loop_state)
			S_LOOP_WAIT: begin
				timing <= 4'd0;
			end
			S_QUARTER_NOTE1: begin
				timing <= 4'd1;
			end
			S_EIGHTH_NOTE1: begin
				timing <= 4'd2;
			end
			S_QUARTER_NOTE2: begin
				timing <= 4'd3;
			end
			S_EIGHTH_NOTE2: begin
				timing <= 4'd4;
			end
			S_QUARTER_NOTE3: begin
				timing <= 4'd5;
			end
			S_EIGHTH_NOTE3: begin
				timing <= 4'd6;
			end
			S_QUARTER_NOTE4: begin
				timing <= 4'd7;
			end
			S_EIGHTH_NOTE4: begin
				timing <= 4'd8;
			end
			default: timing <= 4'd0;
		endcase
	end
	
	always @(posedge clk)
	begin: load_state_transitions
		if (!reset)
		begin
			current_state <= S_LOAD_BPM;
		end
		else
			current_state <= next_state;
	end
	
	always @(posedge slow_clk)
	begin: loop_state_transitions
		if (!play || !reset)
			curr_loop_state <= S_LOOP_WAIT;
		else
			curr_loop_state <= next_loop_state;
	end
	
endmodule
