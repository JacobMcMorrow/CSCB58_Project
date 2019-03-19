module snare(snare_out, clk, en, go);
	output [15:0] snare_out;
	input clk, en, go

	wire [14:0] address;
	wire [15:0] rom_out;

	// counter
	counter_snare counter(.count(address), .clk(clk), .en(en), .go(go));

	// rom
	// check if can generate from built in files
	// if yes:
	// Snare snare_rom(.out(rom_out), .address(address), .clk(clk));	
	// else:
	// check about passing strings to modules and generalize if so
	snare_rom snare_rom(.out(rom_out), .address(address), .clk(clk));

	assign snare_out = rom_out;

endmodule
