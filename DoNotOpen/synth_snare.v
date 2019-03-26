module synth_snare();

	// Oscilator section
	// Sine 180Hz
	wave sine180(
		.tone_freq(),
		.pulse_width(),
		.main_clk(),
		.sample_clk(),
		.reset(),
		.test(),
		.en_noise(),
		,en_triangle(),
		.en_sine()
		);

	// Sine 330Hz
	wave sine330(
		.tone_freq(),
		.pulse_width(),
		.main_clk(),
		.sample_clk(),
		.reset(),
		.test(),
		.en_noise(),
		,en_triangle(),
		.en_sine()
		);

	// Sine mixer

	// Triangle 111Hz

	// Freq shift triangle 

	// Triangle mixer

	// Noise section
	// Noise generator

	// Low pass filer

	// Band pass filter
	
	// Out mixer
	

endmodule
