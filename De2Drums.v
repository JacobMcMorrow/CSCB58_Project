module De2Drums(
	input [8:0] SW,
	input CLOCK_50,
	input [3:0] KEY,
	output [8:0] LEDR,
	output [6:0] HEX0
	);
	
	// for testing, set go to 1 and reset to store bpm
	wire bpm3_en, slowed_clock, test_clock;
	assign LEDR[2] = bpm3_en;

	/*
	bpm_on bpm_1( // quarter notes - these are currently disjoint from datapath for testing purposes
		.en(bpm1_en),
		.clk(CLOCK_50),
		.reset(KEY[1]),
		.go(SW[8]), // using SW[8] as en for testing, this will change
		.bpm(SW[7:0])
		);
		
	bpm_off bpm_2( //eighth notes
		.en(bpm2_en),
		.clk(CLOCK_50),
		.reset(KEY[1]),
		.go(SW[8]),
		.bpm(SW[7:0])
		);
		*/
		
	bpm_test bpm_3( // currently this is connected with control and datapath for testing purposes
		.bpm_out(bpm3_en),
		.clk(CLOCK_50),
		.load_bpm(load_bpm),
		.reset(KEY[1]),
		.go(play),
		.bpm(SW[7:0])
		);
		
	control(
		.ld_ins1(ld_ins1),
		.ld_ins2(ld_ins2),
		.ld_ins3(ld_ins3),
		.ld_ins4(ld_ins4),
		.ld_bpm(ld_bpm),
		.play(play),
		.timing(timing),
		.clk(CLOCK_50), // try test clock
		.slow_clk(bpm3_en),
		.reset(KEY[1]),
		.go(~KEY[2]) // KEY[3] to move between states, this will change
		);
		
	datapath(
		.ins1_out(LEDR[5]),
		.ins2_out(LEDR[6]),
		.ins3_out(LEDR[7]),
		.ins4_out(LEDR[8]),
		.bpm_out(bpm_out),
		.ld_ins1(ld_ins1),
		.ld_ins2(ld_ins2),
		.ld_ins3(ld_ins3),
		.ld_ins4(ld_ins4),
		.ld_bpm(ld_bpm),
		.clk(CLOCK_50),
		.slow_clk(bpm3_en), // try test clock
		.timing(timing),
		.sel(SW[7:0]),
		.reset(KEY[1]),
		.play(play)
		);
	
	// for testing only to see what instrument we are inputting
	reg [3:0] hex0_in;
	hex_display hex_0(hex0_in, HEX0);
	
	always @(ld_ins1, ld_ins2, ld_ins3, ld_ins4, ld_bpm)
	begin
		if (ld_ins1 == 1'b1)
			hex0_in <= 4'h1;
		else if (ld_ins2 == 1'b1)
			hex0_in <= 4'h2;
		else if (ld_ins3 == 1'b1)
			hex0_in <= 4'h3;
		else if (ld_ins4 == 1'b1)
			hex0_in <= 4'h4;
		else if (ld_bpm == 1'b1)
			hex0_in <= 4'h5;
		else
			hex0_in <= 4'h0;
	end

endmodule
