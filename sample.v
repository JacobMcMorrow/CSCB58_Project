module sample(out, clk, sample_clk, slow_clk, play, ins_signal, sel);
	output reg [7:0] out;
	input [2:0] sel;
	input clk, sample_clk, slow_clk, play, ins_signal;

	wire [12:0] address;
	wire [7:0] kick_out, snare_out, hat_out, clap_out;
	wire done;
	wire slow_reg;
	

	// remove slow_reg after testing
	counter counter(.count(address), .done(done), .clk(sample_clk), .slow_clk(slow_clk), .ins_signal(ins_signal));

	kick_rom kick(.address(address), .clock(clk), .q(kick_out));
	snare_rom snare(.address(address), .clock(clk), .q(snare_out));
	hat_rom hat(.address(address), .clock(clk), .q(hat_out));
	clap_rom clap(.address(address), .clock(clk), .q(clap_out));

	// sample select
	always @(*) begin
		if (!done && ins_signal) begin
			if (sel == 2'b00)
				out <= kick_out;
			else if (sel == 2'b01)
				out <= snare_out;
			else if (sel == 2'b10)
				out <= hat_out;
			else if (sel == 2'b11)
				out <= clap_out;
		end
		else
			out <= 8'b0;
	end
	
endmodule
