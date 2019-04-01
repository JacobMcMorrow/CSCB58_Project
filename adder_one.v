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
	full_adder fa0(fa0_cout, out[0], in0[0], in1[0], cin, clk);
	full_adder fa1(fa1_cout, out[1], in0[1], in1[1], fa0_cout, clk);
	full_adder fa2(fa2_cout, out[2], in0[2], in1[2], fa1_cout, clk);
	full_adder fa3(fa3_cout, out[3], in0[3], in1[3], fa2_cout, clk);
	full_adder fa4(fa4_cout, out[4], in0[4], in1[4], fa3_cout, clk);
	full_adder fa5(fa5_cout, out[5], in0[5], in1[5], fa4_cout, clk);
	full_adder fa6(fa6_cout, out[6], in0[6], in1[6], fa5_cout, clk);
	full_adder fa7(fa7_cout, out[7], in0[7], in1[7], fa6_cout, clk);
	full_adder fa8(fa8_cout, out[8], in0[8], in1[8], fa7_cout, clk);

	// Assign the tennth bit of new audio signal to ninth adder's carry over
	assign out[9] = fa8_cout;

endmodule
