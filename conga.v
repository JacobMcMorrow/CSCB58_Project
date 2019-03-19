module conga(out, clk, en, go);
	output [7:0] out;
	input clk, en, go

	wire [15:0] address;
	wire [7:0] rom_out;

	// max address 39648

	// counter
	counter_conga counter(.count(address), .clk(clk), .en(en), .go(go));

	// rom
	conga_rom rom(.address(address), .clock(clock), .q(rom_out));	

	assign out = rom_out;

endmodule
