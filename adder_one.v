module adder_one(out, in0, in1);
	output [17:0] out;
	input [16:0] in0, in1;

	wire fa0_cout, fa1_cout, fa2_cout, fa3_cout, fa4_cout, fa5_cout, fa6_cout, 
		 fa7_cout, fa8_cout, fa9_cout, fa10_cout, fa11_cout, fa12_cout,
		 fa13_cout, fa14_cout, fa15_cout, fa16_cout, cin;

	assign cin = 1'b0;

	full_adder fa0(fa0_cout, out[0], in0[0], in1[0], cin);
	full_adder fa1(fa1_cout, out[1], in0[1], in1[1], fa0_cout);
	full_adder fa2(fa2_cout, out[2], in0[2], in1[2], fa1_cout);
	full_adder fa3(fa3_cout, out[3], in0[3], in1[3], fa2_cout);
	full_adder fa4(fa4_cout, out[4], in0[4], in1[4], fa3_cout);
	full_adder fa5(fa5_cout, out[5], in0[5], in1[5], fa4_cout);
	full_adder fa6(fa6_cout, out[6], in0[6], in1[6], fa5_cout);
	full_adder fa7(fa7_cout, out[7], in0[7], in1[7], fa6_cout);
	full_adder fa8(fa8_cout, out[8], in0[8], in1[8], fa7_cout);
	full_adder fa9(fa9_cout, out[9], in0[9], in1[9], fa8_cout);
	full_adder fa10(fa10_cout, out[10], in0[10], in1[10], fa9_cout);
	full_adder fa11(fa11_cout, out[11], in0[11], in1[11], fa10_cout);
	full_adder fa12(fa12_cout, out[12], in0[12], in1[12], fa11_cout);
	full_adder fa13(fa13_cout, out[13], in0[13], in1[13], fa12_cout);
	full_adder fa14(fa14_cout, out[14], in0[14], in1[14], fa13_cout);
	full_adder fa15(fa15_cout, out[15], in0[15], in1[15], fa14_cout);
	full_adder fa16(fa16_cout, out[16], in0[16], in1[16], fa15_cout);

	assign out[17] = fa16_cout;

endmodule