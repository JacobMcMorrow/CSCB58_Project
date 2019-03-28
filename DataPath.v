module datapath(
	output reg ins1_out,
	output reg ins2_out,
	output reg ins3_out,
	output reg ins4_out,
	output reg [7:0] set_bpm,
	output reg [7:0] ins1,
	output reg [7:0] ins2,
	output reg [7:0] ins3,
	output reg [7:0] ins4,
	input ld_ins1,
	input ld_ins2,
	input ld_ins3,
	input ld_ins4,
	input ld_bpm,
	input clk,
	input slow_clk, // slowed clock from bpm module
	input [3:0] timing, // 3 bit timing
	input [7:0] sel, // this is our select for bpm/drum beat depending on state
	input reset, 
	input play
	);
	
	//reg [7:0] ins1, ins2, ins3, ins4, bpm;
	initial ins1 = 8'b0;
	initial ins2 = 8'b0;
	initial ins3 = 8'b0;
	initial ins4 = 8'b0;
	initial set_bpm = 8'b0;
	// instrument loading block
	always @(*)  // currently inferring latches, do I want this to be synchronous? Leaning towards no.
	begin: instrument_loading
		if (!reset) 
		begin
			ins1 <= 8'b0;
			ins2 <= 8'b0;
			ins3 <= 8'b0;
			ins4 <= 8'b0;
		end
		else
		begin
			if (ld_ins1)
				ins1 <= sel[7:0];
			if (ld_ins2)
				ins2 <= sel[7:0];
			if (ld_ins3)
				ins3 <= sel[7:0];
			if (ld_ins4)
				ins4 <= sel[7:0];
			if (ld_bpm)
				set_bpm <= sel[7:0];
		end
	end
	
	// instrument timing block
	always @(*)
	begin: instrument_timing
		ins1_out <= 1'b0;
		ins2_out <= 1'b0;
		ins3_out <= 1'b0;
		ins4_out <= 1'b0;
		if (play)
		begin
			if (timing == 4'b0001) begin
				ins1_out <= ins1[0];
				ins2_out <= ins2[0];
				ins3_out <= ins3[0];
				ins4_out <= ins4[0];
			end
			else if (timing == 4'b0010) begin
				ins1_out <= ins1[1];
				ins2_out <= ins2[1];
				ins3_out <= ins3[1];
				ins4_out <= ins4[1];
			end
			else if (timing == 4'b0011) begin
				ins1_out <= ins1[2];
				ins2_out <= ins2[2];
				ins3_out <= ins3[2];
				ins4_out <= ins4[2];
			end
			else if (timing == 4'b0100) begin
				ins1_out <= ins1[3];
				ins2_out <= ins2[3];
				ins3_out <= ins3[3];
				ins4_out <= ins4[3];
			end
			else if (timing == 4'b0101) begin
				ins1_out <= ins1[4];
				ins2_out <= ins2[4];
				ins3_out <= ins3[4];
				ins4_out <= ins4[4];
			end
			else if (timing == 4'b0110) begin
				ins1_out <= ins1[5];
				ins2_out <= ins2[5];
				ins3_out <= ins3[5];
				ins4_out <= ins4[5];
			end
			else if (timing == 4'b0111) begin
				ins1_out <= ins1[6];
				ins2_out <= ins2[6];
				ins3_out <= ins3[6];
				ins4_out <= ins4[6];
			end
			else if (timing == 4'b1000) begin
				ins1_out <= ins1[7];
				ins2_out <= ins2[7];
				ins3_out <= ins3[7];
				ins4_out <= ins4[7];
			end
			/*
			else begin
				ins1_out <= 1'b0;
				ins2_out <= 1'b0;
				ins3_out <= 1'b0;
				ins4_out <= 1'b0;
			end
			*/
		end
	end
endmodule
