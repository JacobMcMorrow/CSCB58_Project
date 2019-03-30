module De2Drums(
	input [7:0] SW,
	input CLOCK_50,
	input [3:0] KEY,
	input AUD_ADCDAT,
	//output [8:0] LEDR,
	output [6:0] HEX0, 
	output [6:0] HEX1,
	//output [6:0] HEX4,
	//output [6:0] HEX5,
	//output [6:0] HEX6,
	//output [6:0] HEX7,
	output [4:0] LEDR,
	output AUD_XCK,
	output AUD_DACDAT,
	output I2C_SCLK,
	output VGA_CLK,
	output VGA_HS,
	output VGA_VS,
	output VGA_BLANK_N,
	output VGA_SYNC_N,
	output [9:0] VGA_R,
	output [9:0] VGA_G,
	output [9:0] VGA_B,
	inout AUD_BCLK,
	inout AUD_ADCLRCK,
	inout AUD_DACLRCK,
	inout I2C_SDAT
	);
	
	wire bpm_en, slowed_clock, sample_clk;
	wire [7:0] ins1, ins2, ins3, ins4, set_bpm;
	wire [3:0] timing;
	wire ld_ins1, ld_ins2, ld_ins3, ld_ins4, ld_bpm, play;
	// sample outputs
	wire [7:0] snare_out, kick_out, hat_out, clap_out;
	// mixer output
	wire [31:0] mix_down;

	// sample timings
	wire ins1_out, ins2_out, ins3_out, ins4_out;

	// variable bpm/clock module
	bpm bpm1(
		.bpm_out(bpm_en),
		.clk(CLOCK_50),
		.load_bpm(ld_bpm),
		.reset(KEY[1]),
		.play(play),
		.bpm(set_bpm)
		);
	
	// control path for our audio timing and instrument loading states
	control c1(
		.ld_ins1(ld_ins1),
		.ld_ins2(ld_ins2),
		.ld_ins3(ld_ins3),
		.ld_ins4(ld_ins4),
		.ld_bpm(ld_bpm),
		.play(play),
		.timing(timing),
		.clk(CLOCK_50),
		.slow_clk(bpm_en),
		.reset(KEY[1]),
		.go(~KEY[2])
		);
	
	// data path for audio timing and instrument loading
	datapath d1(
		.ins1_out(ins1_out),
		.ins2_out(ins2_out),
		.ins3_out(ins3_out),
		.ins4_out(ins4_out),
		.set_bpm(set_bpm),
		.ins1(ins1),
		.ins2(ins2),
		.ins3(ins3),
		.ins4(ins4),
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
	
	// vga display module
	vga_signals v1(
		.clk(CLOCK_50),						//	On Board 50 MHz
		.play(play),
		.reset(KEY[1]),
		.ins1(ins1),
		.ins2(ins2),
		.ins3(ins3),
		.ins4(ins4),
		.timing(timing),
		// These outputs will be passed directly to top module's output
		.VGA_CLK(VGA_CLK),   						//	VGA Clock
		.VGA_HS(VGA_HS),								//	VGA H_SYNC
		.VGA_VS(VGA_VS),								//	VGA V_SYNC
		.VGA_BLANK_N(VGA_BLANK_N),					//	VGA BLANK
		.VGA_SYNC_N(VGA_SYNC_N),					//	VGA SYNC
		.VGA_R(VGA_R),   								//	VGA Red[9:0]
		.VGA_G(VGA_G),	 								//	VGA Green[9:0]
		.VGA_B(VGA_B)   								//	VGA Blue[9:0]
	);
	
	reg [3:0] hex0_in;
	hex_display hex_0(hex0_in, HEX0);
	
	// display our load states on hex 0
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
	
	// display our beat number on hex 1
	reg [3:0] hex1_in;
	hex_display hex_1(hex1_in, HEX1);
	
	always @(timing)
	begin
		if (timing == 4'b0001)
			hex1_in = 4'h1;
		else if (timing == 4'b0010)
			hex1_in = 4'h2;
		else if (timing == 4'b0011)
			hex1_in = 4'h3;
		else if (timing == 4'b0100)
			hex1_in = 4'h4;
		else if (timing == 4'b0101)
			hex1_in = 4'h5;
		else if (timing == 4'b0110)
			hex1_in = 4'h6;
		else if (timing == 4'b0111)
			hex1_in = 4'h7;
		else if (timing == 4'b1000)
			hex1_in = 4'h8;
		else
			hex1_in = 4'h0;
	end
	
	/*
	// test mix down
	hex_display hex_4(kick_out, HEX4);
	hex_display hex_5(snare_out, HEX5);
	hex_display hex_6(hat_out, HEX6);
	hex_display hex_7(clap_out, HEX7);
	*/
	
	// rate divided clock for the audio - runs at 48kHz
	sample_clock sample_clock(
		.sample_clk(sample_clk),
		.clk(CLOCK_50)
		);

	// instantiate drum modules
	sample kick(
		.out(kick_out),
		.clk(CLOCK_50),
		.sample_clk(sample_clk),
		.slow_clk(bpm_en),
		.play(play),
		.ins_signal(ins1_out),
		.sel(2'b00)
		);

	sample snare(
		.out(snare_out),
		.clk(CLOCK_50),
		.sample_clk(sample_clk),
		.slow_clk(bpm_en),
		.play(play),
		.ins_signal(ins2_out),
		.sel(2'b01)
		);

	sample hat(
		.out(hat_out),
		.clk(CLOCK_50),
		.sample_clk(sample_clk),
		.slow_clk(bpm_en),
		.play(play),
		.ins_signal(ins3_out),
		.sel(2'b10)
		);

	sample clap(
		.out(clap_out),
		.clk(CLOCK_50),
		.sample_clk(sample_clk),
		.slow_clk(bpm_en),
		.play(play),
		.ins_signal(ins4_out),
		.sel(2'b11)
		);
	
	// instantiate mixer
	mixer mixer(
		.mix_down(mix_down),
		.audio0(snare_out),
		.audio1(kick_out),
		.audio2(hat_out),
		.audio3(clap_out),
		.clk(CLOCK_50)
		);
	
	// instantiate audio
  	audio audio(
		.AUD_XCK(AUD_XCK),
		.AUD_DACDAT(AUD_DACDAT),
		.I2C_SCLK(I2C_SCLK),
		.CLOCK_50(CLOCK_50),
		.KEY(KEY),
		.mix_down(mix_down),
		.AUD_BCLK(AUD_BCLK),
		.AUD_ADCLRCK(AUD_ADCLRCK),
		.AUD_DACLRCK(AUD_DACLRCK),
		.I2C_SDAT(I2C_SDAT)
	);

endmodule
