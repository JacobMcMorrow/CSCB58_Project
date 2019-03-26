module adder_one(out, in0, in1, clk);
	output [9:0] out;
	input clk;
	input [8:0] in0, in1;

	wire fa0_cout, fa1_cout, fa2_cout, fa3_cout, fa4_cout, fa5_cout, fa6_cout, 
		 fa7_cout, fa8_cout, cin;

	assign cin = 1'b0;

	full_adder fa0(fa0_cout, out[0], in0[0], in1[0], cin, clk);
	full_adder fa1(fa1_cout, out[1], in0[1], in1[1], fa0_cout, clk);
	full_adder fa2(fa2_cout, out[2], in0[2], in1[2], fa1_cout, clk);
	full_adder fa3(fa3_cout, out[3], in0[3], in1[3], fa2_cout, clk);
	full_adder fa4(fa4_cout, out[4], in0[4], in1[4], fa3_cout, clk);
	full_adder fa5(fa5_cout, out[5], in0[5], in1[5], fa4_cout, clk);
	full_adder fa6(fa6_cout, out[6], in0[6], in1[6], fa5_cout, clk);
	full_adder fa7(fa7_cout, out[7], in0[7], in1[7], fa6_cout, clk);
	full_adder fa8(fa8_cout, out[8], in0[8], in1[8], fa7_cout, clk);

	assign out[9] = fa8_cout;

endmodule
