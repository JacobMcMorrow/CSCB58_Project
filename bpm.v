module bpm_on( // quarter notes
	output reg en,
	input clk,
	input go,
	input reset,
	input [7:0] bpm
	);
	// currently to use, set go to 1 and then hit reset to set bpm
	
	reg [7:0] beat;
	initial beat = 7'd60; // avoid dividing by 0

	reg [19:0] count; // 833,333 cycles per min
	reg [19:0] slow_ratio; // 20 bit reg to slow the clock down to 1 bpm
	initial slow_ratio = 19'd13888; // corresponds to 60 bpm
	
	// 50,000,000 cycles per sec
	// 833,333.33 cycles per min
	
	// clock will tick constantly
	always @(posedge clk)
	begin
		if (reset) // set new bpm and clock when we reset
		begin
			beat <= bpm;
			slow_ratio <= clk/beat;
			count <= slow_ratio - 19'b1;
		end
		else
		begin // count down otherwise
			if (count == 19'b0)
				count <= slow_ratio - 19'b1;
			else
				count <= count - 19'b1;
		end
	end
	
	// en signal only if we also have go signal
	always @(*)
	begin
		if (count == 19'b0 && go)
			en <= 1;
		else
			en <= 0;
	end
	
endmodule

module bpm_off( // eighth notes
	output reg en,
	input clk,
	input go,
	input reset,
	input [7:0] bpm
	);
	// currently to use, set go to 1 and then hit reset to set bpm
	
	reg [7:0] beat;
	initial beat = 7'd60; // avoid dividing by 0

	reg [20:0] count; // 833,333 cycles per min
	reg [20:0] slow_ratio; // 20 bit reg to slow the clock down to 1 bpm
	initial slow_ratio = 20'd13888; // corresponds to 60 bpm
	
	// 50,000,000 cycles per sec
	// 833,333.33 cycles per min
	
	// clock will tick constantly
	always @(posedge clk)
	begin
		if (reset) // set new bpm and clock when we reset
		begin
			beat <= bpm;
			slow_ratio <= clk/beat;
			count <= (slow_ratio * 3)/2 - 20'b1; // if this doesn't work, add half
		end
		else
		begin // count down otherwise
			if (count == 20'b0)
				count <= slow_ratio - 20'b1;
			else
				count <= count - 20'b1;
		end
	end
	
	// en signal only if we also have go signal
	always @(*)
	begin
		if (count == 20'b0 && go)
			en <= 1;
		else
			en <= 0;
	end
	
endmodule