module adder_one(out, in0, in1, clk);
	// New 10-bit audio output
	output [9:0] out;
	// 50MHz system clock
	input clk;
	// 9-bit audio signal inputs
	input [8:0] in0, in1;

	// Create wires for carry-over bit outputs and first carry-over input
	wire fa0_cout, fa1_cout, fa2_cout, fa3_cout, fa4_cout, fa5_cout, fa6_cout, 
		 fa7_cout, fa8_cout, cin;

	// Initialize carry-over into first full adder to 0
	assign cin = 1'b0;

	/*
		 A series of single bit full adders where the first full adders takes the
		 initial 0 carry over input and  each successful full adder takes the carry
		 over output from the previous adder as input. Each adder is taking the sum
		 of each individual bit from both input audio signals and adding them
		 together in order. I.e. bit 1 from signal one is added to bit 1 from signal
		 two  bit 2 to bit 2, etc. The equivalent bit of the output signal is
		 assigned the subsequet sum of the corresponding bits.

		 We assign the carry over bit from the final addition to be the tenth bit
		 of the resultant signal.
	*/
	full_adder fa0(
		.cout(fa0_cout),
		.sum(out[0]),
		.a(in0[0]),
		.b(in1[0]),
		.cin(cin),
		.clk(clk)
		);

	full_adder fa1(
		.cout(fa1_cout),
		.sum(out[1]),
		.a(in0[1]),
		.b(in1[1]),
		.cin(fa0_cout),
		.clk(clk)
		);

	full_adder fa2(
		.cout(fa2_cout),
		.sum(out[2]),
		.a(in0[2]),
		.b(in1[2]),
		.cin(fa1_cout),
		.clk(clk)
		);

	full_adder fa3(
		.cout(fa3_cout),
		.sum(out[3]),
		.a(in0[3]),
		.b(in1[3]),
		.cin(fa2_cout),
		.clk(clk)
		);

	full_adder fa4(
		.cout(fa4_cout),
		.sum(out[4]),
		.a(in0[4]),
		.b(in1[4]),
		.cin(fa3_cout),
		.clk(clk)
		);

	full_adder fa5(
		.cout(fa5_cout),
		.sum(out[5]),
		.a(in0[5]),
		.b(in1[5]),
		.cin(fa4_cout),
		.clk(clk)
		);

	full_adder fa6(
		.cout(fa6_cout),
		.sum(out[6]),
		.a(in0[6]),
		.b(in1[6]),
		.cin(fa5_cout),
		.clk(clk)
		);

	full_adder fa7(
		.cout(fa7_cout),
		.sum(out[7]),
		.a(in0[7]),
		.b(in1[7]),
		.cin(fa6_cout),
		.clk(clk)
		);

	full_adder fa8(
		.cout(fa8_cout),
		.sum(out[8]),
		.a(in0[8]),
		.b(in1[8]),
		.cin(fa7_cout),
		.clk(clk)
		);

	// Assign the tennth bit of new audio signal to ninth adder's carry over
	assign out[9] = fa8_cout;

endmodule
