module counter(count, done, clk, slow_clk, ins_signal);
	output reg [12:0] count;
	output reg done;
	input  clk, slow_clk, ins_signal;
	
	// counter state machine
	reg current_count_state, next_count_state, slow_reg;
	localparam counting = 1'b1, waiting = 1'b0, MAXCOUNT = 13'd8191; 
		
	always @(*) begin
	if (slow_clk)
		slow_reg <= 1'b1;
	else if (current_count_state == counting)
		slow_reg <= 1'b0;
	end
	
		
	always @(*)
	begin: counter_state_table
		case(current_count_state)
			waiting: next_count_state = slow_reg ? counting : waiting;
			counting: next_count_state = (count == MAXCOUNT) ? waiting : counting;
			default: next_count_state = waiting;
		endcase
	end
	
	always @(posedge clk)
	begin
		if (!ins_signal)
			current_count_state <= waiting;
		else
			current_count_state <= next_count_state;
	end
	
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
