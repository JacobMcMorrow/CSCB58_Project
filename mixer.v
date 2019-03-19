module mixer(mix_down
						 CLOCK_50, 
						 audio0,
						 audio1,
						 audio2,
						 audio3,
						 audio4,
						 audio5,
						 audio6,
						 audio7
						 );
	input CLOCK_50;
	input [7:0] audio0, audio1, audio2, audio3, audio4, audio5, audio6, audio7);
	output [31:0] mix_down;

	wire [8:0] add_zero0, add_zero1, add_zero2, add_zero3;
	wire [9:0] add_one0, add_one1;
	wire [10:0] add_two;

	// First stage
	adder_zero a0(.out(add_zero0), .in0(audio0), .in1(audio1));
	adder_zero a1(.out(add_zero1), .in0(audio2), .in1(audio3));
	adder_zero a2(.out(add_zero2), .in0(audio4), .in1(audio5));
	adder_zero a3(.out(add_zero3), .in0(audio6), .in1(audio7));
	
	// Second stage
	adder_one a4(.out(add_one0), .in0(add_zero0), .in1(add_zero1));
	adder_one a5(.out(add_one1), .in0(add_zero2), .in1(add_zero3));

	// Third stage
	adder_two a6(.out(add_two), .in0(add_one0), .in1(add_one1));

	assign mix_down = add_two;

endmodule
