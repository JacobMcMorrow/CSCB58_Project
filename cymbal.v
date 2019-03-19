module cymbal(out, clk, en, go);
	output [7:0] out;
	input clk, en, go

	wire [17:0] address;
	wire [7:0] rom_out;

	// max address 229120 

	// counter
	counter_cymbal counter(.count(address), .clk(clk), .en(en), .go(go));

	// rom
	cymbal_rom rom(.address(address), .clock(clock), .q(rom_out));	

	assign out = rom_out;

endmodule
