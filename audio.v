module audio(
	AUD_XCK,
	AUD_DACDAT,
	I2C_SCLK,
	CLOCK_50,
	AUD_ADCDAT,
	KEY,
  SW,
	mix_down, // Output from the mixer module
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,
	I2C_SDAT
	);

  input [3:0] SW;
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
	//wire reset;

	//reg audio_reset;
	//reg [9:0] reset_count;
	/*
	reg [31:0] left_channel_audio_out;
	reg [31:0] right_channel_audio_out;
	*/

	wire [31:0] left_channel_audio_out;
	wire [31:0] right_channel_audio_out;

  /*
  reg [18:0] delay_cnt;
  reg snd;
  wire [18:0] delay;
  */

	/*
	assign reset = ~KEY[1];

	always @(posedge CLOCK_50)
		begin
			if(reset)
				begin
					audio_reset <= 1'b0;
					reset_count <= 0;
				end
			else if(reset_count == 1023)
				audio_reset <= 1'b1;
			else
				reset_count <= reset_count + 1;
	end
	*/

	assign read_audio_in = audio_in_available & audio_out_allowed;
	assign write_audio_out = audio_in_available & audio_out_allowed;

	/*
	always @(mix_down, read_audio_in, write_audio_out)
		begin
			right_channel_audio_out <= right_channel_audio_out + mix_down;
			left_channel_audio_out <= left_channel_audio_out + mix_down;
	end
	*/

  /*
  always @(posedge CLOCK_50)
    if(delay_cnt == delay) begin
      delay_cnt <= 0;
      snd <= !snd;
    end else delay_cnt <= delay_cnt + 1;


  assign delay = {SW[3:0], 15'd3000};
  */

	// wire [31:0] out_sound = (mix_down) ? mix_down : 0;
  // wire [31:0] out_sound = (SW == 0) ? 0 : snd ? 32'd10000000 : -32'd10000000;

	assign left_channel_audio_out = mix_down; // out_sound;
	assign right_channel_audio_out = mix_down; // out_sound;

	Audio_Controller Audio_Controller(
		.CLOCK_50(CLOCK_50),
		.reset(~KEY[1]),
		.clear_audio_in_memory(),
		.read_audio_in(read_audio_in),
		.clear_audio_out_memory(),
		.left_channel_audio_out(left_channel_audio_out),
		.right_channel_audio_out(right_channel_audio_out),
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

	avconf #(.USE_MIC_INPUT(1)) avc(
    .I2C_SCLK(I2C_SCLK),
		.I2C_SDAT(I2C_SDAT),
		.CLOCK_50(CLOCK_50),
		.reset(~KEY[1])
		);

endmodule
