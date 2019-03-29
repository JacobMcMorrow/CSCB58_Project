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

	/*
		 The mixer operates by adding each of the input audio signals pairwise
		 bit by bit, which results in a signal that is comprised of the each
		 pair of sounds combined. This process is repeated until we are left with
		 a single signal which is one bit longer per mixer stage than the original
		 signals

		 First stage of mixer

		 Add pairs of eight bit audio signals to combine sounds resulting in a
		 nine bit signal
	*/
	adder_zero a0(.out(add_zero0), .in0(audio0), .in1(audio1), .clk(clk));
	adder_zero a1(.out(add_zero1), .in0(audio2), .in1(audio3), .clk(clk));

	/*
	   Second stage of mixer
		 
		 Add pairs of nine bit audio signals to combine sounds resulting in a
		 ten bit audio signal
	*/
	adder_one a4(.out(add_one), .in0(add_zero0), .in1(add_zero1), .clk(clk));

	/*
		 Pad the end of add_one with zeros to bring signal up to appropriate level
		 in 32-bit audio environment
	*/
	assign mix_down = {add_one, 22'b0};

endmodule
