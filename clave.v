module clave(out, clk, en, go);
	output [7:0] out;
	input clk, en, go

	wire [12:0] address;
	wire [7:0] rom_out;

	// max address 6600

	// counter
	counter_clave counter(.count(address), .clk(clk), .en(en), .go(go));

	// rom
	clave_rom rom(.address(address), .clock(clock), .q(rom_out));	

	assign out = rom_out;

endmodule
