module audio(
	// DE2 audio device outputs
	AUD_XCK,
	AUD_DACDAT,
	I2C_SCLK,
	// 50MHz clock
	CLOCK_50,
	// DE2 audio device input
	AUD_ADCDAT,
	// DE2 key buttons
	KEY,
	// Ouput from the mixer module
	mix_down,
	// DE2 audio bidirectional I/O
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,
	I2C_SDAT
	);

	input CLOCK_50;
	input AUD_ADCDAT;
	input [3:0] KEY;
	input [31:0] mix_down;

	output AUD_XCK;
	output AUD_DACDAT;
	output I2C_SCLK;

	inout AUD_BCLK;
	inout AUD_ADCLRCK;
	inout AUD_DACLRCK;
	inout I2C_SDAT;

	wire [31:0] left_channel_audio_in;
	wire [31:0] right_channel_audio_in;
	wire audio_in_available;
	wire read_audio_in;
	wire audio_out_allowed;
	wire write_audio_out;

	/*
		 Assign permission to read audio in to true if there is audio input
		 available and whether permission to send audio output is set to true
		 Assign permission to write audio out to true if there is audio output
		 available and whether permission to send audio output is set to true
	*/
	assign read_audio_in = audio_in_available & audio_out_allowed;
	assign write_audio_out = audio_in_available & audio_out_allowed;

	/*
		 Instantiate the provided audio controller module to interface with the
		 DE2 ADC/DAC chipset, I/O ports, and audio codec

		 Module and backend courtesy of:

		 Modified to meet the data flow of this project
	*/
	Audio_Controller Audio_Controller(
		.CLOCK_50(CLOCK_50),
		// Send project's universal reset key
		.reset(~KEY[1]),
		.clear_audio_in_memory(),
		.read_audio_in(read_audio_in),
		.clear_audio_out_memory(),
		// Set audio to be played out of the DE2's left audio channel as mixer
		// module output
		.left_channel_audio_out(mix_down),
		// Set audio to be played out of the DE2's right audio channel as mixer
		// module output
		.right_channel_audio_out(mix_down),
		.write_audio_out(write_audio_out),
		.AUD_ADCDAT(AUD_ADCDAT),
		.audio_in_available(audio_in_available),
		.left_channel_audio_in(left_channel_audio_in),
		.right_channel_audio_in(right_channel_audio_in),
		.audio_out_allowed(audio_out_allowed),
		.AUD_XCK(AUD_XCK),
		.AUD_DACDAT(AUD_DACDAT),
		.AUD_BCLK(AUD_BCLK),
		.AUD_ADCLRCK(AUD_ADCLRCK),
		.AUD_DACLRCK(AUD_DACLRCK)
		);

	/*
		 Instantiate the provided audio video configuration module to configure
		 audio video data and clock in accorance with requirements of an audio
		 project

		 Module courtesy of:

		 Modified to meet the dataflow of this project
	*/
	avconf #(.USE_MIC_INPUT(1)) avc(
    .I2C_SCLK(I2C_SCLK),
		.I2C_SDAT(I2C_SDAT),
		.CLOCK_50(CLOCK_50),
		// Send project's universal reset key
		.reset(~KEY[1])
		);

endmodule
