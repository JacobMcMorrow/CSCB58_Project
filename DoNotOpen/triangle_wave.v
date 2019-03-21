module triangle_wave #(parameter ACCUMULATOR_BITS = 24,
											 parameter OUTPUT_BITS = 12)
	(input [ACCUMULATOR_BITS-1:0] accumulator,
	 output wire [OUTPUT_BITS-1:0] out,
	 input en_ringmod,
	 input ringmod_source
	 );

	wire invert_wave;

	assign invert_wave = (en_ringmod && ringmod_source) ||
											 (!en_ringmod && accumulator[ACCUMULATOR_BITS-1]);

	assign out = invert_wave ? ~accumulator[ACCUMULATOR_BITS-2 -: OUTPUT_BITS]
													 : accumulator[ACCUMULATOR_BITS-2 -: OUTPUT_BITS];

endmodule
