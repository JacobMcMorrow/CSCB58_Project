module bpm_test( // 2 en signals per beat. Quarter and eighth notes will alternate
	output reg bpm_out,
	input clk,
	input load_bpm,
	input play,
	input reset,
	input [7:0] bpm // this may need 1 more bit
	);
	// currently to use, set go to 1 and then hit reset to set bpm
	
	reg [8:0] beat;
	initial beat = 8'd120; // avoid dividing by 0

	reg [28:0] count; // 833,333 cycles per min
	reg [28:0] slow_ratio; // 20 bit reg to slow the clock down to 1 bpm
	initial slow_ratio = 20'd833333;
	
	// 50,000,000 cycles per sec
	// 833,333.33 cycles per min
	
	// clock will tick constantly
	always @(posedge clk)
	begin
		if (!reset) // set new bpm and clock when we reset
		begin
			beat <= 8'd120;
			slow_ratio <= 28'd50_000_000;
			count <= 28'd50_000_000;
		end
		else if (load_bpm)
		begin
			beat <= bpm << 1;
			slow_ratio <= 28'd50_000_000; // hard coding bpm to testing
			count <= slow_ratio;
		end
		else
		begin // count down otherwise
			if (count == 28'b0)
				count <= slow_ratio;
			else
				count <= count - 28'b1;
		end
	end
	
	// en signal only if we also have go signal
	always @(*)
	begin
		if (count == 28'b0 && play)
			bpm_out <= 1;
		else
			bpm_out <= 0;
	end
	
endmodule
/*
50,000,000 cycles per sec
60 bpm / 60 = 1 beat per sec


*/
