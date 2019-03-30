module sample(out, clk, sample_clk, slow_clk, play, ins_signal, sel);
	output reg [7:0] out;
	input [2:0] sel; // Select which of the four samples to play
	input clk, sample_clk, slow_clk, play, ins_signal;

	wire [12:0] address; 
	wire [7:0] kick_out, snare_out, hat_out, clap_out; // Output per ROM
	wire done; // For signal to specify if counting finished

	// Increment the address per sample clock, or restart count when necessary
	counter counter(
		.count(address),
		.done(done),
		.clk(sample_clk),
		.slow_clk(slow_clk), 
		.ins_signal(ins_signal)
		);

	// Read sample information from the specified ROMs
	// Retrieves the the value at address per clock cycle
	kick_rom kick(.address(address), .clock(clk), .q(kick_out));
	snare_rom snare(.address(address), .clock(clk), .q(snare_out));
	hat_rom hat(.address(address), .clock(clk), .q(hat_out));
	clap_rom clap(.address(address), .clock(clk), .q(clap_out));

	// Select which sample gets sent to output
	always @(*) begin
		// If still counting addresses and recieving signal to play instrument
		if (!done && ins_signal) begin 
			if (sel == 2'b00) // Select kick
				out <= kick_out;
			else if (sel == 2'b01) // Select snare
				out <= snare_out;
			else if (sel == 2'b10) // Select hat
				out <= hat_out;
			else if (sel == 2'b11) // Select clap
				out <= clap_out;
		end
		else
			out <= 8'b0; // Default output sends no sample information
	end
	
endmodule
