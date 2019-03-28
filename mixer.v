module mixer(mix_down,
					audio0out, // TESTINg
					audio1out, // T
					audio2out, // T
					audio3out, // T
						 audio0,
						 audio1,
						 audio2,
						 audio3,
						 clk
						 );
	input [7:0] audio0, audio1, audio2, audio3;
	input clk;
	output [7:0] audio0out, audio1out, audio2out, audio3out;
	output [31:0] mix_down;

	wire [8:0] add_zero0, add_zero1;
	wire [9:0] add_one;
	
	assign audio0out = audio0;
	assign audio1out = audio1;
	assign audio2out = audio2;
	assign audio3out = audio3;

	// First stage
	adder_zero a0(.out(add_zero0), .in0(audio0), .in1(audio1), .clk(clk));
	adder_zero a1(.out(add_zero1), .in0(audio2), .in1(audio3), .clk(clk));
	
	// Second stage
	adder_one a4(.out(add_one), .in0(add_zero0), .in1(add_zero1), .clk(clk));

	assign mix_down = {add_one, 22'b0};

endmodule
