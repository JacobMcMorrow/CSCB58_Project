module full_adder(cout, sum, a, b, cin);
	input a, b, cin;
	output cout, sum;
	
	assign cout = a & b | a & cin | b & cin;
	assign sum = a ^ b ^ cin;
endmodule