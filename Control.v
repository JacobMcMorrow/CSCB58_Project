module control(
	output reg ld_ins1, // load instrument 1-4
	output reg ld_ins2,
	output reg ld_ins3,
	output reg ld_ins4,
	output reg ld_bpm,
	output reg play, // enable signal
	output reg [2:0] timing, // timing is the beat we are on
	input clk,
	input reset,
	input go
	);
	
	reg [5:0] current_state, next_state;
	
	localparam S_LOAD_INS1 = 5'd0,
		S_LOAD_INS1_WAIT = 5'd1,
		S_LOAD_INS2 = 5'd2,
		S_LOAD_INS2_WAIT = 5'd3,
		S_LOAD_INS3 = 5'd4,
		S_LOAD_INS3_WAIT = 5'd5,
		S_LOAD_INS4 = 5'd6,
		S_LOAD_INS4_WAIT = 5'd7,
		S_LOAD_BPM = 5'd8,
		S_LOAD_BPM_WAIT = 5'd9,
		S_QUARTER_NOTE1 = 5'd10,
		S_EIGHTH_NOTE1 = 5'd11,
		S_QUARTER_NOTE2 = 5'd12,
		S_EIGHTH_NOTE2 = 5'd13,
		S_QUARTER_NOTE3 = 5'd14,
		S_EIGHTH_NOTE3 = 5'd15,
		S_QUARTER_NOTE4 = 5'd16,
		S_EIGHTH_NOTE4 = 5'd17;
		
	always @(*)
	begin: state_table
		case (current_state)
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
			S_LOAD_INS4_WAIT: next_state = go ? S_LOAD_INS4_WAIT : S_LOAD_BPM;
			// load bpm - note: will have to check to see if we are loading 0
			S_LOAD_BPM: next_state = go ? S_LOAD_BPM_WAIT : S_LOAD_BPM;
			S_LOAD_BPM_WAIT: next_state = go ? S_LOAD_BPM_WAIT : S_QUARTER_NOTE1;
			// loop through the 8 beats indefinitely
			S_QUARTER_NOTE1: next_state = S_EIGHTH_NOTE1;
			S_EIGHTH_NOTE1: next_state = S_QUARTER_NOTE2;
			S_QUARTER_NOTE2: next_state = S_EIGHTH_NOTE2;
			S_EIGHTH_NOTE2: next_state = S_QUARTER_NOTE3;
			S_QUARTER_NOTE3: next_state = S_EIGHTH_NOTE3;
			S_EIGHTH_NOTE3: next_state = S_QUARTER_NOTE4;
			S_QUARTER_NOTE4: next_state = S_EIGHTH_NOTE4;
			S_EIGHTH_NOTE4: next_state = S_QUARTER_NOTE1;
			default: next_state = S_LOAD_INS1;
		endcase
	end
	
	always @(*)
	begin: enable_signals
		ld_ins1 = 1'b0;
		ld_ins2 = 1'b0;
		ld_ins3 = 1'b0;
		ld_ins4 = 1'b0;
		play = 1'b0;
		timing = 3'b0;
		case (current_state)
			S_LOAD_INS1: ld_ins1 = 1'b1;
			S_LOAD_INS2: ld_ins2 = 1'b1;
			S_LOAD_INS3: ld_ins3 = 1'b1;
			S_LOAD_INS4: ld_ins4 = 1'b1;
			S_LOAD_BPM: ld_bpm = 1'b1;
			S_QUARTER_NOTE1: begin
				timing = 3'd0;
				play = 1'b1;
			end
			S_EIGHTH_NOTE1: begin
				timing = 3'd1;
				play = 1'b1;
			end
			S_QUARTER_NOTE2: begin
				timing = 3'd2;
				play = 1'b1;
			end
			S_EIGHTH_NOTE2: begin
				timing = 3'd3;
				play = 1'b1;
			end
			S_QUARTER_NOTE3: begin
				timing = 3'd4;
				play = 1'b1;
			end
			S_EIGHTH_NOTE3: begin
				timing = 3'd5;
				play = 1'b1;
			end
			S_QUARTER_NOTE4: begin
				timing = 3'd6;
				play = 1'b1;
			end
			S_EIGHTH_NOTE4: begin
				timing = 3'd7;
				play = 1'b1;
			end
			default: play = 1'b0;
		endcase
	end
	
	always @(posedge clk)
	begin: state_transitions
		if (!reset)
			current_state <= S_LOAD_INS1;
		else
			current_state <= next_state;
	end
endmodule