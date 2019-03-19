module counter_clap(count, clk, en, go);
	output [16:0] count;
	input  clk, en, go;

	reg [16:0] cnt;
	reg state, next_state, cnt_enable;

	// define parameters
	// max count
	parameter MAXCOUNT = 16'd66080;
	// counting state
	parameter COUNT = 0;
	// pause state
	parameter PAUSE = 1;

	// double check the begin block set up for always
	// check if counting or paused
	always @(posedge clk) begin
		if (go) begin
			state <= COUNT;
			cnt <= 16'b0;
		end
		else begin
			state <= PAUSE;
			cnt <= cnt + cnt_enable;
		end
	end

	// counting block
	always @(state, cnt, en, go) begin
		cnt_enable = 0;
		case(state)
			// there's got to be a way to clean this up
			COUNT:
				if (cnt == MAXCOUNT) begin
					next_state = PAUSE;
					cnt_enable = 0;
				end
				else begin
					next_state = COUNT;
					cnt_enable = en;
				end
			PAUSE: begin
				cnt_enable = 0;
				next_state = go ? COUNT : PAUSE;
			end
		endcase
	end

endmodule
