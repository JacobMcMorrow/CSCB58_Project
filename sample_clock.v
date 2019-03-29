module sample_clock(
	output reg sample_clk,
	input clk
	);
	
	localparam MAXCOUNT = 11'd1042;
	
	reg [10:0] count;
	always @(posedge clk) begin
		if (count == 11'b0) begin
			count <= MAXCOUNT;
			sample_clk <= 1'b1;
		end
		else begin
			count <= count - 11'b1;
			sample_clk <= 1'b0;
		end
	end
endmodule