module counter(count, done, clk, slow_clk, ins_signal);
	// 13-bit number corresponding to a ROM address
	output reg [12:0] count;
	// Signal to indicate counting finished
	output reg done;
	// 50MHz clock, bpm clock, and signal indicating instrument is playing
	input  clk, slow_clk, ins_signal;
	
	// counter state machine
	reg current_count_state, next_count_state, slow_reg;
	// MAXCOUNT is the last address in each sample
	localparam counting = 1'b1, waiting = 1'b0, MAXCOUNT = 13'd8191; 

	// Set slow register to 0 while counting
	always @(*) begin
	if (slow_clk)
		slow_reg <= 1'b1;
	else if (current_count_state == counting)
		slow_reg <= 1'b0;
	end

	/*
		 While in the waiting state, if we have received a slow clock signal, start
		 counting. Otherwise continue waiting

		 If we are in the counting state and reach MAXCOUNT, set the next state to
		 waiting, otherwise continue counting
	*/
	always @(*)
	begin: counter_state_table
		case(current_count_state)
			waiting: next_count_state = slow_reg ? counting : waiting;
			counting: next_count_state = (count == MAXCOUNT) ? waiting : counting;
			default: next_count_state = waiting;
		endcase
	end

	// Set state to wait while there is no instrument playing
	always @(posedge clk)
	begin
		if (!ins_signal)
			current_count_state <= waiting;
		else
			current_count_state <= next_count_state;
	end

	/*
		 If we are currently in the waiting state, ensure we have a count of zero
		 and set done to 1 to signal counting is complete

		 If we are counting there are two possible conditions, either we reached the
		 maximum count, or have not. In the case we have counted to MAXCOUNT, we set
		 done to 1 and stop counting. Otherwise, ensure we do not send an
		 affirmative done signal, set done to 0 and increment count
	*/
	always @(posedge clk)
	begin
		if (current_count_state == waiting) begin
			count <= 13'b0;
			done <= 1'b1;
		end
		else if (current_count_state == counting) begin
			if (count == MAXCOUNT)
				done <= 1'b1;
			else begin
				count <= count + 13'b1;
				done <= 1'b0;
			end
		end
	end


endmodule
