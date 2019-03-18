module adder_two(out, in0, in1);
	output [18:0] out;
	input [17:0] a, b;
	input clk;

	wire fa0_cout, fa1_cout, fa2_cout, fa3_cout, fa4_cout, fa5_cout, fa6_cout, 
		 fa7_cout, fa8_cout, fa9_cout, fa10_cout, fa11_cout, fa12_cout,
		 fa13_cout, fa14_cout, fa15_cout, fa16_cout, fa16_cout, cin;

	assign cin = 1'b0;

	full_adder fa0(fa0_cout, sum[0], a[0], b[0], cin);
	full_adder fa1(fa1_cout, sum[1], a[1], b[1], fa0_cout);
	full_adder fa2(fa2_cout, sum[2], a[2], b[2], fa1_cout);
	full_adder fa3(fa3_cout, sum[3], a[3], b[3], fa2_cout);
	full_adder fa4(fa4_cout, sum[4], a[4], b[4], fa3_cout);
	full_adder fa5(fa5_cout, sum[5], a[5], b[5], fa4_cout);
	full_adder fa6(fa6_cout, sum[6], a[6], b[6], fa5_cout);
	full_adder fa7(fa7_cout, sum[7], a[7], b[7], fa6_cout);
	full_adder fa8(fa8_cout, sum[8], a[8], b[8], fa7_cout);
	full_adder fa9(fa9_cout, sum[9], a[9], b[9], fa8_cout);
	full_adder fa10(fa10_cout, sum[10], a[10], b[10], fa9_cout);
	full_adder fa11(fa11_cout, sum[11], a[11], b[11], fa10_cout);
	full_adder fa12(fa12_cout, sum[12], a[12], b[12], fa11_cout);
	full_adder fa13(fa13_cout, sum[13], a[13], b[13], fa12_cout);
	full_adder fa14(fa14_cout, sum[14], a[14], b[14], fa13_cout);
	full_adder fa15(fa15_cout, sum[15], a[15], b[15], fa14_cout);
	full_adder fa16(fa16_cout, sum[16], a[16], b[16], fa15_cout);
	full_adder fa17(fa16_cout, sum[17], a[17], b[17], fa16_cout);

	assign sum[17] = fa17_cout;

endmodule