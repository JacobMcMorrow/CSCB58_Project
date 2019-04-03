module full_adder(cout, sum, a, b, cin, clk);
	input a, b, cin, clk;
	output reg cout, sum;

	always @(posedge clk) begin
		cout = a & b | a & cin | b & cin;
		sum = a ^ b ^ cin;
	end
endmodule
