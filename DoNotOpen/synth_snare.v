module synth_snare(out, reset, clk);
	output [] out;
	input reset, clk;

	wire [11:0] pulse_180_out, pulse_330_out;
	wire sine_sync, tri_sync, pulse_180_msb, pulse_330_msb;

	// Oscilator section
	// Sine 180Hz
	wave pulse180(
		.tone_freq(16'b0),
		.pulse_width(),
		.main_clk(clk),
		.sample_clk(),
		.reset(reset),
		.test(),
		.out(pulse_180_out),
		.accumulator_msb(pulse_180_msb),
		.sync_trigger_out(sine_sync),
		.en_noise(1'b0),
		.en_pulse(1'b1),
		,en_triangle(1'b0)
		);

	// Sine 330Hz
	wave pulse330(
		.tone_freq(16'b0),
		.pulse_width(),
		.main_clk(clk),
		.sample_clk(),
		.reset(reset),
		.test(),
		.out(pulse_330_out),
		.accumulator_msb(),
		.sync_trigget_out(),
		.en_noise(1'b0),
		.en_pulse(1'b1),
		,en_triangle(1'b0)
		);

	// Sine mixer
	synth_mixer sine_mixer(clk(clk), .a(), .b());

	// Triangle 111Hz
wave tri_shifted(
		.tone_freq(16'b0),
		.pulse_width(),
		.main_clk(clk),
		.sample_clk(),
		.reset(reset),
		.test(),
		.out(),
		.accumulator_msb(),
		.sync_trigget_out(),
		.en_noise(1'b0),
		.en_pulse(1'b1),
		,en_triangle(1'b1)
	);

	wave tri_shifted_(
		.tone_freq(16'b0),
		.pulse_width(),
		.main_clk(clk),
		.sample_clk(),
		.reset(reset),
		.test(),
		.out(),
		.accumulator_msb(),
		.sync_trigget_out(),
		.en_noise(1'b0),
		.en_pulse(1'b0),
		,en_triangle(1'b1)
	);

	// Freq shift triangle
	synth_mixer tri_mixer(clk(clk), .a(), .b());


	// Triangle mixer

	// Noise section
	// Noise generator

	// Low pass filer

	// Band pass filter
	
	// Out mixer
	

endmodule
