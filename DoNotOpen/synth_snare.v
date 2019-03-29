module synth_snare(out, reset, clk);
	output [11:0] out;
	input reset, clk;

	wire [11:0] pulse_180_out, pulse_330_out, tri_286_out, tri_335_out, noise_out;
	wire [11:0] sine_180_out, sine_330_out, tri_out, sine_out;
	wire sync;
	wire pulse_180_msb, pulse_330_msb, tri_286_msb, tri_335_msb;
	wire smpl_clk

	// Add a clock divider
	clock_divider clock_divider(.cin(clk), .out(smpl_clk));

	// Oscilator section
	// Sine 180Hz
	wave pulse180(
		.tone_freq(16'd30199),
		.pulse_width(12'd90),
		.main_clk(clk),
		.sample_clk(smpl_clk),
		.reset(reset),
		.test(1'b0),
		.out(pulse_180_out),
		.accumulator_msb(pulse_180_msb),
		.sync_trigger_out(sync),
		.en_sync(1'b1),
		.sync_source(sync),
		.en_shift(1'b0),
		.shift_freq(16'b0),
		.en_noise(1'b0),
		.en_pulse(1'b1),
		,en_triangle(1'b0)
		);

	// Sine 180Hz lowpass between 180Hz and 900Hz
	filter sine_180_lowpass(
		.clk(clk),
		.in(pulse_180_out),
		.out_highpass(),
		.out_lowpass(sine_180_out),
		.out_bandpass(),
		.out_notch(),
		.F(18'd00000.4),
		.Q1(18'd0)
		);

	// Sine 330Hz
	wave pulse330(
		.tone_freq(16'd55365),
		.pulse_width(12'd165),
		.main_clk(clk),
		.sample_clk(smpl_clk),
		.reset(reset),
		.test(1'b0),
		.out(pulse_330_out),
		.accumulator_msb(pulse_330_msb),
		.sync_trigger_out(sync),
		.en_sync(1'b1),
		.sync_source(sync),
		.en_shift(1'b0),
		.shift_freq(16'b0),
		.en_noise(1'b0),
		.en_pulse(1'b1),
		,en_triangle(1'b0)
		);

	// Sine 330Hz lowpass between 330Hz and 1650Hz
	filter sine_330_lowpass(
		.clk(clk),
		.in(pulse_330_out),
		.out_highpass(),
		.out_lowpass(sine_330_out),
		.out_bandpass(),
		.out_notch(),
		.F(18'd00000.62),
		.Q1(18'd0)
		);

	// Sine mixer
	synth_mixer sine_mixer(
		.clk(clk),
		.a(sine_180_out),
		.b(sine_330_out),
		.dout(sine_out)
		);

	// Snare envelope

	// Triangle 111Hz shifted to 286Hz and 335Hz
	wave tri_shifted_286(
		.tone_freq(16'd18623),
		.pulse_width(12'd0),
		.main_clk(clk),
		.sample_clk(smpl_clk),
		.reset(reset),
		.test(1'b0),
		.out(tri_286_out),
		.accumulator_msb(tri_286_msb),
		.sync_trigger_out(sync),
		.en_sync(1'b1),
		.sync_source(sync),
		.en_shift(1'b1),
		.shift_freq(16'd29360),
		.en_noise(1'b0),
		.en_pulse(1'b1),
		,en_triangle(1'b1)
		);

	wave tri_shifted_335(
		.tone_freq(16'd18623),
		.pulse_width(12'd0),
		.main_clk(clk),
		.sample_clk(smpl_clk),
		.reset(reset),
		.test(1'b0),
		.out(tri_335_out),
		.accumulator_msb(tri_335_msb),
		.sync_trigger_out(sync),
		.en_sync(1'b1),
		.sync_source(sync),
		.en_shift(1'b1),
		.shift_freq(16'd37581),
		.en_noise(1'b0),
		.en_pulse(1'b0),
		,en_triangle(1'b1)
		);

	// Triangle envelope

	// Triangle mixer
	synth_mixer tri_mixer(
		.clk(clk),
		.a(tri_286_out),
		.b(tri_335_out),
		.dout(tri_out)
		);

	// Noise section
	// Noise generator
	noise noise(.clk(clk), .reset(reset), .dout(noise_out));

	// Add if time
	// Band pass filter

	// Noise envelope

	// Out mixer
	synth_mixer out_mixer(
		.clk(clk),
		.a(sine_out),
		.b(tri_out),
		.c(noise_out),
		.dout(out)
		);

endmodule
