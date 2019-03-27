module adder_one(out, in0, in1, clk);
	output [9:0] out;
	input clk;
	input [8:0] in0, in1;

	wire fa0_cout, fa1_cout, fa2_cout, fa3_cout, fa4_cout, fa5_cout, fa6_cout, 
		 fa7_cout, fa8_cout, cin;

	assign cin = 1'b0;

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

	assign out[9] = fa8_cout;

endmodule
