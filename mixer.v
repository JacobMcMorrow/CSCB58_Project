module mixer(mix_down,
						 audio0,
						 audio1,
						 audio2,
						 audio3
						 );
	input [7:0] audio0, audio1, audio2, audio3;
	output [31:0] mix_down;

	wire [8:0] add_zero0, add_zero1;
	wire [9:0] add_one;

	// First stage
	adder_zero a0(.out(add_zero0), .in0(audio0), .in1(audio1));
	adder_zero a1(.out(add_zero1), .in0(audio2), .in1(audio3));
	
	// Second stage
	adder_one a4(.out(add_one), .in0(add_zero0), .in1(add_zero1));

	assign mix_down = add_one;

endmodule
