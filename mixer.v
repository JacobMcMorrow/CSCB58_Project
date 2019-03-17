module mixer(mix_down
						 CLOCK_50, 
						 audio0,
						 audio1,
						 audio2,
						 audio3,
						 audio4,
						 audio5,
						 audio6,
						 audio7);
	input CLOCK_50;
	input [15:0] audio0, audio1, audio2, audio3, audio4, audio5, audio6, audio7);
	output [31:0] mix_down;

	wire [16:0] add_zero0, add_zero1, add_zero2, add_zero3;
	wire [17:0] add_one0, add_one1;
	wire [18:0] add_two;

	// First stage
	adder_zero a0(.out(add_zero0), .in0(audio0), .in1(audio1), .clk(CLOCK_50));
	adder_zero a1(.out(add_zero1), .in0(audio2), .in1(audio3), .clk(CLOCK_50));
	adder_zero a2(.out(add_zero2), .in0(audio4), .in1(audio5), .clk(CLOCK_50));
	adder_zero a3(.out(add_zero3), .in0(audio6), .in1(audio7), .clk(CLOCK_50));
	
	// Second stage
	adder_one a4(.out(add_one0), .in0(add_zero0), .in1(add_zero1), .clk(CLOCK_50));
	adder_one a5(.out(add_one1), .in0(add_zero2), .in1(add_zero3), .clk(CLOCK_50));

	// Third stage
	adder_two a6(.out(add_two), .in0(add_one0), .in1(add_one1), .clk(CLOCK_50));

	assign mix_down = add_two;

endmodule
