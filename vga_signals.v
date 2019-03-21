module vga_signals
	(
		clk,						//	On Board 50 MHz
		play,
		reset,
		ins1,
		ins2,
		ins3,
		ins4,
		timing,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   							//	VGA Blue[9:0]
		square_number // TESTING
	);

	input	clk;				//	50 MHz
	input play;
	input reset;			// we will actually reset the screen to all black
	input [7:0] ins1;				// from datapath, if each instrument is on at the moment
	input [7:0] ins2;
	input [7:0] ins3;
	input [7:0] ins4;
	input [3:0] timing;  // timing representing what note we are currently on

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output [4:0] square_number;

	reg [2:0] colour; // colour of each square
	wire [3:0] square_offset; // 4 bit counter used to draw our 4 pixel square
	wire [7:0] dx_offset; // x offset for each square
	wire [6:0] dy_offset; // y offset for each square
	//wire [4:0] square_number; // what square are we drawing
	reg [7:0] x; // final x value for vga adapter
	reg [6:0] y; // final y value for vga adapter


	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(reset),
			.clock(clk),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(play),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

	// using x: 10, 30, 50, 70, 90, 110, 130, 150
	// using y: 20, 40, 60, 80
	vga_counters counter1(
		.square_counter(square_offset),
		.dx(dx_offset),
		.dy(dy_offset),
		.square_number(square_number),
		.en(play),
		.reset(reset),
		.clk(clk)
		);
	
	// display colour block
	always @(*)
	begin
		// timing == 0001
		if (square_number == 5'd0) // square 1
			if (ins1[0] == 1'b1)
				if (timing == 4'd1)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd1)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd1) // square 2
			if (ins2[0] == 1'b1)
				if (timing == 4'd1)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd1)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd2) // square 3
			if (ins3[0] == 1'b1)
				if (timing == 4'd1)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd1)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd3) // square 4
			if (ins4[0] == 1'b1)
				if (timing == 4'd1)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd1)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		// timing == 0010
		else if (square_number == 5'd4) // square 5
			if (ins1[1] == 1'b1)
				if (timing == 4'd2)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd2)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd5) // square 6
			if (ins2[1] == 1'b1)
				if (timing == 4'd2)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd2)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd6) // square 7
			if (ins3[1] == 1'b1)
				if (timing == 4'd2)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd2)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd7) // square 8
			if (ins4[1] == 1'b1)
				if (timing == 4'd2)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd2)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		// timing == 0011
		else if (square_number == 5'd8) // square 9
			if (ins1[2] == 1'b1)
				if (timing == 4'd3)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd3)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd9) // square 10
			if (ins2[2] == 1'b1)
				if (timing == 4'd3)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd3)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd10) // square 11
			if (ins3[2] == 1'b1)
				if (timing == 4'd3)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd3)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd11) // square 12
			if (ins4[2] == 1'b1)
				if (timing == 4'd3)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd3)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		// timing == 0100
		else if (square_number == 5'd12) // square 13
			if (ins1[3] == 1'b1)
				if (timing == 4'd4)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd4)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd13) // square 14
			if (ins2[3] == 1'b1)
				if (timing == 4'd4)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd4)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd14) // square 15
			if (ins3[3] == 1'b1)
				if (timing == 4'd4)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd4)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd15) // square 16
			if (ins4[3] == 1'b1)
				if (timing == 4'd4)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd4)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		// timing == 0101
		else if (square_number == 5'd16) // square 17
			if (ins1[4] == 1'b1)
				if (timing == 4'd5)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd5)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd17) // square 18
			if (ins2[4] == 1'b1)
				if (timing == 4'd5)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd5)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd18) // square 19
			if (ins3[4] == 1'b1)
				if (timing == 4'd5)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd5)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd19) // square 20
			if (ins4[4] == 1'b1)
				if (timing == 4'd5)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd5)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		// timing == 0110
		else if (square_number == 5'd20) // square 21
			if (ins1[5] == 1'b1)
				if (timing == 4'd6)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd6)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd21) // square 22
			if (ins2[5] == 1'b1)
				if (timing == 4'd6)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd6)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd22) // square 23
			if (ins3[5] == 1'b1)
				if (timing == 4'd6)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd6)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd23) // square 24
			if (ins4[5] == 1'b1)
				if (timing == 4'd6)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd6)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		// timing == 0111
		else if (square_number == 5'd24) // square 25
			if (ins1[6] == 1'b1)
				if (timing == 4'd7)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd7)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd25) // square 26
			if (ins2[6] == 1'b1)
				if (timing == 4'd7)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd7)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd26) // square 27
			if (ins3[6] == 1'b1)
				if (timing == 4'd7)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd7)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd27) // square 28
			if (ins4[6] == 1'b1)
				if (timing == 4'd7)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd7)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		// timing == 1000
		else if (square_number == 5'd28) // square 29
			if (ins1[7] == 1'b1)
				if (timing == 4'd8)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd8)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd29) // square 30
			if (ins2[7] == 1'b1)
				if (timing == 4'd8)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd8)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd30) // square 31
			if (ins3[7] == 1'b1)
				if (timing == 4'd8)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd8)
					colour <= 3'b001;
				else
					colour <= 3'b111;
		else if (square_number == 5'd31) // square 32
			if (ins4[7] == 1'b1)
				if (timing == 4'd8)
					colour <= 3'b100;
				else
					colour <= 3'b010;
			else
				if (timing == 4'd8)
					colour <= 3'b001;
				else
					colour <= 3'b111;
	end

	// display timing block
	always @(*)
	begin
		x <= dx_offset + square_offset[1:0];
		y <= dy_offset + square_offset[3:2];
	end

endmodule

module vga_counters(
	output reg [3:0] square_counter,
	output reg [7:0] dx,
	output reg [6:0] dy,
	output reg [4:0] square_number,
	input en,
	input reset,
	input clk
);

	reg count_zero;
	reg [4:0] square_state;
	reg [4:0] next_square, current_square;
	
	// 4 bit counter
	always @(posedge clk)
	begin: counter_4bit
		if (!reset || square_counter == 4'b0)
		begin
			square_counter <= 4'b1111;
			count_zero <= 1'b1;
		end
		else
		begin
			square_counter <= square_counter - 4'b0001;
			count_zero <= 1'b0;
		end
	end

	
	localparam square1 = 5'd0,
		square2 = 5'd1,
		square3 = 5'd2,
		square4 = 5'd3,
		square5 = 5'd4,
		square6 = 5'd5,
		square7 = 5'd6,
		square8 = 5'd7,
		square9 = 5'd8,
		square10 = 5'd9,
		square11 = 5'd10,
		square12 = 5'd11,
		square13 = 5'd12,
		square14 = 5'd13,
		square15 = 5'd14,
		square16 = 5'd15,
		square17 = 5'd16,
		square18 = 5'd17,
		square19 = 5'd18,
		square20 = 5'd19,
		square21 = 5'd20,
		square22 = 5'd21,
		square23 = 5'd22,
		square24 = 5'd23,
		square25 = 5'd24,
		square26 = 5'd25,
		square27 = 5'd26,
		square28 = 5'd27,
		square29 = 5'd28,
		square30 = 5'd29,
		square31 = 5'd30,
		square32 = 5'd31;
		
	// FSM for which square we are drawing - squares numbered as below
	/*
	1	 5	  9	 13	17		21		25		29
	2	 6	  10	 14	18		22		26		30
	3	 7	  11	 15	19		23		27		31
	4	 8	  12	 16	20		24		28		32
	*/
	always @(*)
	begin: square_state_table
		case(current_square)
			square1: next_square = count_zero ? square2 : square1;
			square2: next_square = count_zero ? square3 : square2;
			square3: next_square = count_zero ? square4 : square3;
			square4: next_square = count_zero ? square5 : square4;
			square5: next_square = count_zero ? square6 : square5;
			square6: next_square = count_zero ? square7 : square6;
			square7: next_square = count_zero ? square8 : square7;
			square8: next_square = count_zero ? square9 : square8;
			square9: next_square = count_zero ? square10 : square9;
			square10: next_square = count_zero ? square11 : square10;
			square11: next_square = count_zero ? square12 : square11;
			square12: next_square = count_zero ? square13 : square12;
			square13: next_square = count_zero ? square14 : square13;
			square14: next_square = count_zero ? square15 : square14;
			square15: next_square = count_zero ? square16 : square15;
			square16: next_square = count_zero ? square17 : square16;
			square17: next_square = count_zero ? square18 : square17;
			square18: next_square = count_zero ? square19 : square18;
			square19: next_square = count_zero ? square20 : square19;
			square20: next_square = count_zero ? square21 : square20;
			square21: next_square = count_zero ? square22 : square21;
			square22: next_square = count_zero ? square23 : square22;
			square23: next_square = count_zero ? square24 : square23;
			square24: next_square = count_zero ? square25 : square24;
			square25: next_square = count_zero ? square26 : square25;
			square26: next_square = count_zero ? square27 : square26;
			square27: next_square = count_zero ? square28 : square27;
			square28: next_square = count_zero ? square29 : square28;
			square29: next_square = count_zero ? square30 : square29;
			square30: next_square = count_zero ? square31 : square30;
			square31: next_square = count_zero ? square32 : square31;
			square32: next_square = count_zero ? square1 : square32;
			default: next_square = square1;
		endcase
	end

	always @(posedge clk)
	begin: square_state_transition
		if (!reset)
			current_square <= square1;
		else
			current_square <= next_square;
	end
	
	// using dx: 10, 30, 50, 70, 90, 110, 130, 150
	// using dy: 20, 40, 60, 80
	always @(*)
	begin: square_state_signals
		case(current_square)
			square1: begin // col 1
				square_number <= 5'd0;
				dx <= 8'd10;
				dy <= 7'd20;
			end
			square2: begin
				square_number <= 5'd1;
				dx <= 8'd10;
				dy <= 7'd40;
			end
			square3: begin
				square_number <= 5'd2;
				dx <= 8'd10;
				dy <= 7'd60;
			end
			square4: begin
				square_number <= 5'd3;
				dx <= 8'd10;
				dy <= 7'd80;
			end
			square5: begin // col 2
				square_number <= 5'd4;
				dx <= 8'd30;
				dy <= 7'd20;
			end
			square6: begin
				square_number <= 5'd5;
				dx <= 8'd30;
				dy <= 7'd40;
			end
			square7: begin
				square_number <= 5'd6;
				dx <= 8'd30;
				dy <= 7'd60;
			end
			square8: begin
				square_number <= 5'd7;
				dx <= 8'd30;
				dy <= 7'd80;
			end
			square9: begin // col 3
				square_number <= 5'd8;
				dx <= 8'd50;
				dy <= 7'd20;
			end
			square10: begin
				square_number <= 5'd9;
				dx <= 8'd50;
				dy <= 7'd40;
			end
			square11: begin
				square_number <= 5'd10;
				dx <= 8'd50;
				dy <= 7'd60;
			end
			square12: begin
				square_number <= 5'd11;
				dx <= 8'd50;
				dy <= 7'd80;
			end
			square9: begin // col 4
				square_number <= 5'd12;
				dx <= 8'd70;
				dy <= 7'd20;
			end
			square10: begin
				square_number <= 5'd13;
				dx <= 8'd70;
				dy <= 7'd40;
			end
			square11: begin
				square_number <= 5'd14;
				dx <= 8'd70;
				dy <= 7'd60;
			end
			square12: begin
				square_number <= 5'd15;
				dx <= 8'd70;
				dy <= 7'd80;
			end
			square9: begin // col 5
				square_number <= 5'd16;
				dx <= 8'd90;
				dy <= 7'd20;
			end
			square10: begin
				square_number <= 5'd17;
				dx <= 8'd90;
				dy <= 7'd40;
			end
			square11: begin
				square_number <= 5'd18;
				dx <= 8'd90;
				dy <= 7'd60;
			end
			square12: begin
				square_number <= 5'd19;
				dx <= 8'd90;
				dy <= 7'd80;
			end
			square9: begin // col 6
				square_number <= 5'd20;
				dx <= 8'd110;
				dy <= 7'd20;
			end
			square10: begin
				square_number <= 5'd21;
				dx <= 8'd110;
				dy <= 7'd40;
			end
			square11: begin
				square_number <= 5'd22;
				dx <= 8'd110;
				dy <= 7'd60;
			end
			square12: begin
				square_number <= 5'd23;
				dx <= 8'd110;
				dy <= 7'd80;
			end
			square9: begin // col 7
				square_number <= 5'd24;
				dx <= 8'd130;
				dy <= 7'd20;
			end
			square10: begin
				square_number <= 5'd25;
				dx <= 8'd130;
				dy <= 7'd40;
			end
			square11: begin
				square_number <= 5'd26;
				dx <= 8'd130;
				dy <= 7'd60;
			end
			square12: begin
				square_number <= 5'd27;
				dx <= 8'd130;
				dy <= 7'd80;
			end
			square9: begin // col 8
				square_number <= 5'd28;
				dx <= 8'd150;
				dy <= 7'd20;
			end
			square10: begin
				square_number <= 5'd29;
				dx <= 8'd150;
				dy <= 7'd40;
			end
			square11: begin
				square_number <= 5'd30;
				dx <= 8'd150;
				dy <= 7'd60;
			end
			square12: begin
				square_number <= 5'd31;
				dx <= 8'd150;
				dy <= 7'd80;
			end
			default: begin // default to square 1
				square_number <= 5'd0;
				dx <= 8'd10;
				dy <= 7'd20;
			end
		endcase
	end
endmodule
