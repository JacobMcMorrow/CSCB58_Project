module sample(out, clk, en, go, sel);
	output reg [7:0] out;
	input [2:0] sel;
	input clk, en, go;

	wire [12:0] address;
	wire [7:0] kick_out, snare_out, hat_out, clap_out;

	counter counter(.count(address), .clk(clk), .en(en), .go(go));

	kick_rom kick(.adress(address), .clock(clk), .q(kick_out));
	snare_rom snare(.adress(address), .clock(clk), .q(snare_out));
	hat_rom hat(.adress(address), .clock(clk), .q(hat_out));
	clap_rom clap(.adress(address), .clock(clk), .q(clap_out));

	// sample select
	always @(*) begin
		case(sel)
			2'b00: out <= kick_out;
			2'b01: out <= snare_out;
			2'b10: out <= hat_out;
			2'b11: out <= clap_out;
		endcase
	end

endmodule
