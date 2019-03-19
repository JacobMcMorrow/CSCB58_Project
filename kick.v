module kick(out, clk, en, go);
	output [7:0] out;
	input clk, en, go

	// Max address 43840

	wire [15:0] address;
	wire [7:0] rom_out;

	// counter
	counter_kick counter(.count(address), .clk(clk), .en(en), .go(go));

	// rom
	kick_rom rom(.address(address), .clock(clock), .q(rom_out));	

	assign out = rom_out;

endmodule
