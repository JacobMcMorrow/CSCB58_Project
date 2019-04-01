module bpm( // 2 en signals per beat. Quarter and eighth notes will alternate
	output reg bpm_out,
	input clk,
	input load_bpm,
	input play,
	input reset,
	input [7:0] bpm // this may need 1 more bit
	);
	
	reg [8:0] beat;
	initial beat = 8'd120; // avoid dividing by 0

	reg [32:0] count; // rate divided clock
	reg [32:0] max_count;
	initial count = 32'd50_000_000; // start at 60 bpm
	initial max_count = 32'd50_000_000;
	
	// count at 50,000,000 cooresponds to 60 bpm
	
	// variable bpm counter - this is the first variable to be loaded so the circuit has plenty of time
	// to do the division
	always @(posedge clk)
	begin
		if (!reset) // set new bpm and clock when we reset
		begin
			beat <= 8'd120;
			max_count <= 32'd50_000_000;
			count <= 32'd50_000_000; // default 60 bpm
		end
		else if (load_bpm) // if we get a signal to load bpm
		begin
			if (bpm == 8'b0)
				beat <= 8'd120; // default to 60 bpm if user chooses 0
			else
				beat <= bpm << 1; // bpm x2 to get eighth notes
			max_count <= 32'd3_000_000_000/beat;
			count <= max_count;
		end
		else
		begin // count down otherwise
			if (count == 32'b0)
				count <= max_count;
			else
				count <= count - 32'b1;
		end
	end

	// slow clock is always ticking based on variable bpm
	always @(*)
	begin
		if (count == 32'b0)
			bpm_out <= 1;
		else
			bpm_out <= 0;
	end
	
endmodule
