module De2Drums(
	input [8:0] SW,
	input CLOCK_50,
	input [3:0] KEY,
	output [8:0] LEDR
	);
	
	// for testing, set go to 1 and reset to store bpm
	bpm_on bpm_1( // quarter notes
		.en(LEDR[0]),
		.clk(CLOCK_50),
		.reset(KEY[1]),
		.go(SW[8]), // using SW[8] as en for testing, this will change
		.bpm(SW[7:0])
		);
		
	bpm_off bpm_2( //eighth notes
		.en(LEDR[1]),
		.clk(CLOCK_50),
		.reset(KEY[1]),
		.go(SW[8]),
		.bpm(SW[7:0])
		);

endmodule