module tom(out, clk, en, go);
	output [7:0] out;
	input clk, en, go;

	wire [15:0] address;
	wire [7:0] rom_out;

	// counter
	counter_tom counter(.count(address), .clk(clk), .en(en), .go(go));

	// rom
	tom_rom rom(.address(address), .clock(clk), .q(rom_out));	

	assign out = rom_out;

endmodule