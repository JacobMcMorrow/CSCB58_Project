module counter_snare(count, clk, en, go);
	output [14:0] count;
	input  clk, en, go;

	reg [14:0] count;
	reg state, next_state, cnt_enable;

	// define parameters
	// max count
	parameter MAXCOUNT = 15'd16481;
	// counting state
	parameter COUNT = 1'b0;
	// pause state
	parameter PAUSE = 1'b1;

	// double check the begin block set up for always
	// check if counting or paused
	always @(posedge clk) begin
		if (go) begin
			current_state <= COUNT;
			count <= 15'b0;
		end
		else begin
			state <= next_state;
			count <= count + cnt_enable;
		end
	end

	// counting block
	always @(state, count, en, go) begin
		cnt_enable <= 0;
		case(state)
			// there's got to be a way to clean this up
			COUNT:
				if (count == MAXCOUNT) begin
					next_state <= PAUSE;
					cnt_enable <= 0;
				end
				else begin
					next_state <= COUNT;
					cnt_enable <= en;
				end
			PAUSE: begin
				next_state <= go ? COUNT : PAUSE;
				cnt_enable <= 0;
			end
		endcase
	end

endmodule
