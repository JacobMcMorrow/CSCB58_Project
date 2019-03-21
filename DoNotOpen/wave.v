module wave #(
	parameter FREQ_BITS = 16,
  parameter PULSEWIDTH_BITS = 12,
  parameter OUTPUT_BITS = 12,
  parameter ACCUMULATOR_BITS = 24
  )
  ( 
  input [FREQ_BITS-1:0] tone_freq,
  input [PULSEWIDTH_BITS-1:0] pulse_width,
  input main_clk,
  input sample_clk,
  input reset,
  input test, 
  output wire signed [OUTPUT_BITS-1:0] out,
  output wire accumulator_msb,
  output wire sync_trigger_out,
	input en_noise,
	input en_triangle,
	);

	reg [ACCUMULATOR_BITS-1:0] accumulator;
  reg [ACCUMULATOR_BITS-1:0] prev_accumulator;
 
  wire [OUTPUT_BITS-1:0] noise_dout;
  tone_generator_noise #(
   .OUTPUT_BITS(OUTPUT_BITS)
 	 )
	 noise(.clk(accumulator[19]), .reset(reset || test), .dout(noise_dout));
 
  wire [OUTPUT_BITS-1:0] triangle_dout;
  tone_generator_triangle #(
        .ACCUMULATOR_BITS(ACCUMULATOR_BITS),
        .OUTPUT_BITS(OUTPUT_BITS)
  	) 
		triangle_generator (
    .accumulator(accumulator),
    .dout(triangle_dout),
    .en_ringmod(en_ringmod),
    .ringmod_source(ringmod_source)
    );

	
