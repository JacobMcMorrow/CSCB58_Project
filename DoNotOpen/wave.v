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
	input en_sine
	);

	reg [ACCUMULATOR_BITS-1:0] accumulator;
  reg [ACCUMULATOR_BITS-1:0] prev_accumulator;
 
  wire [OUTPUT_BITS-1:0] noise_dout;
  noise #(
    .OUTPUT_BITS(OUTPUT_BITS)
 	  )
	  noise(.clk(accumulator[19]), .reset(reset || test), .dout(noise_dout));
 
  wire [OUTPUT_BITS-1:0] triangle_dout;
  triangle_wave #(
    .ACCUMULATOR_BITS(ACCUMULATOR_BITS),
    .OUTPUT_BITS(OUTPUT_BITS)
  	) 
		triangle_wave (
    .accumulator(accumulator),
    .dout(triangle_dout),
    .en_ringmod(en_ringmod),
    .ringmod_source(ringmod_source)
    );

	reg [OUTPUT_BITS-1:0] dout_tmp;

  always @(posedge main_clk) begin
    if ((en_sync && sync_source) || test) begin
			prev_accumulator <= 0;
		 	accumulator <= 0;
		end
		else begin
      prev_accumulator <= accumulator;
      accumulator <= accumulator + tone_freq;
    end
  end

	assign accumulator_msb = accumulator[ACCUMULATOR_BITS-1];

  always @(posedge sample_clk) begin
    dout_tmp = (2**OUTPUT_BITS)-1;
    if (en_noise)
      dout_tmp = dout_tmp & noise_dout;
    if (en_triangle)
      dout_tmp = dout_tmp & triangle_dout;
  end

  // convert dout value to a signed value
	assign dout = dout_tmp ^ (2**(OUTPUT_BITS-1));

endmodule
