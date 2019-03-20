module De2Drums(
	input [7:0] SW,
	input CLOCK_50,
	input [3:0] KEY,
	output [8:0] LEDR,
	output [6:0] HEX0, 
	output [6:0] HEX1,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7
	);
	
	// for testing, set go to 1 and reset to store bpm
	wire bpm_en, slowed_clock;
	wire [7:0] ins1, ins2, ins3, ins4, set_bpm;
	wire [2:0] timing;
	wire ld_ins1, ld_ins2, ld_ins3, ld_ins4, ld_bpm, play;
	// sample outputs
	wire [7:0] snare_out, kick_out, hat_out, clap_out;
	// mixer output
	wire [31:0] mix_down;

	// sample timings
	wire ins1_out, ins2_out, ins3_out, ins4_out;

	bpm_test bpm_3( // currently this is connected with control and datapath for testing purposes
		.bpm_out(bpm_en),
		.clk(CLOCK_50),
		.load_bpm(ld_bpm),
		.reset(KEY[1]),
		.play(play),
		.bpm(set_bpm)
		);
		
	control control(
		.ld_ins1(ld_ins1),
		.ld_ins2(ld_ins2),
		.ld_ins3(ld_ins3),
		.ld_ins4(ld_ins4),
		.ld_bpm(ld_bpm),
		.play(play),
		.timing(timing),
		.clk(CLOCK_50), // try test clock
		.slow_clk(bpm_en),
		.reset(KEY[1]),
		.go(~KEY[2]) // KEY[3] to move between states, this will change
		);
		
	datapath datapath(
		.ins1_out(ins1_out),
		.ins2_out(ins2_out),
		.ins3_out(ins3_out),
		.ins4_out(ins4_out),
		 // .ins1_out(LEDR[5]),
		 // .ins2_out(LEDR[6]),
		 // .ins3_out(LEDR[7]),
		 // .ins4_out(LEDR[8]),
		.set_bpm(set_bpm),
		.ins1(ins1), // testing
		.ins2(ins2), // testing
		.ins3(ins3), // testing
		.ins4(ins4), // testing
		.ld_ins1(ld_ins1),
		.ld_ins2(ld_ins2),
		.ld_ins3(ld_ins3),
		.ld_ins4(ld_ins4),
		.ld_bpm(ld_bpm),
		.clk(CLOCK_50),
		.slow_clk(bpm_en), // try test clock
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
			hex0_in <= 4'h2;
		else if (ld_ins2 == 1'b1)
			hex0_in <= 4'h3;
		else if (ld_ins3 == 1'b1)
			hex0_in <= 4'h4;
		else if (ld_ins4 == 1'b1)
			hex0_in <= 4'h5;
		else if (ld_bpm == 1'b1)
			hex0_in <= 4'h1;
		else
			hex0_in <= 4'h0;
	end
	
	// for timing testing
	reg [3:0] hex1_in;
	hex_display hex_1(hex1_in, HEX1);
	
	always @(timing)
	begin
		if (timing == 3'b000)
			hex1_in = 4'h1;
		else if (timing == 3'b001)
			hex1_in = 4'h2;
		else if (timing == 3'b010)
			hex1_in = 4'h3;
		else if (timing == 3'b011)
			hex1_in = 4'h4;
		else if (timing == 3'b100)
			hex1_in = 4'h5;
		else if (timing == 3'b101)
			hex1_in = 4'h6;
		else if (timing == 3'b110)
			hex1_in = 4'h7;
		else if (timing == 3'b111)
			hex1_in = 4'h8;
		else
			hex1_in = 4'h0;
	end
	
	// debugging for ins 1-4
	hex_display hex_4(ins1, HEX4);
	hex_display hex_5(ins2, HEX5);
	hex_display hex_6(ins3, HEX6);
	hex_display hex_7(ins4, HEX7);

	// instantiate drum modules
	snare snare(
		.out(snare_out),
		.clk(CLOCK_50),
		.en(play),
		.go(ins1_out)
		);
	kick kick(
		.out(kick_out),
		.clk(CLOCK_50),
		.en(play),
		.go(ins2_out)
		);
	hat hat(
		.out(hat_out),
		.clk(CLOCK_50),
		.en(play),
		.go(ins3_out)
		);
	clap clap(
		.out(clap_out),
		.clk(CLOCK_50),
		.en(play),
		.go(ins4_out)
		);
	
	// instantiate mixer
	mixer mixer(
		.mix_down(mix_down),
		.audio0(snare_out),
		.audio1(kick_out),
		.audio2(hat_out),
		.audio3(clap_out)
		);
	
	// instantiate audio
	audio audio(
		.CLOCK_50(CLOCK_50),
		.mix_down(mix_down)
		);

endmodule
