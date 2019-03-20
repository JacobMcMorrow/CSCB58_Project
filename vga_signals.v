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
		VGA_B   							//	VGA Blue[9:0]
	);

	input	clk;				//	50 MHz
	input play;
	input reset;			// we will actually reset the screen to all black
	input ins1;				// from datapath, if each instrument is on at the moment
	input ins2;
	input ins3;
	input ins4;
	input [2:0] timing;  // timing representing what note we are currently on

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

	reg [2:0] colour;
	reg [3:0] square_offset;
	reg [6:0] dy_offset;
	reg [7:0] x;
	reg [6:0] y;


	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(reset),
			.clock(CLOCK_50),
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
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

	// using x: 10, 30, 50, 70, 90, 110, 130, 150
	// using y: 20, 40, 60, 80
	vga_counters counter1(
		.square_counter(square_offset),
		.dy(dy_offset),
		.en(play),
		.reset(reset),
		.clk(clk)
		);

endmodule

module vga_counters(
	output reg [3:0] square_counter,
	output reg [6:0] dy,
	input en,
	input reset,
	input clk
);

	reg next_square;
	reg [1:0] current_state, next_state;
	
	// 4 bit counter
	always @(posedge clk)
	begin: counter_4bit
		if (!reset || square_counter == 4'b0)
		begin
			square_counter <= 4'b1111;
			next_square <= 1'b1;
		end
		else
		begin
			square_counter <= square_counter - 4'b0001;
			next_square <= 1'b0;
		end
	end
	
	// extra dy offset for drawing 4 squares 
	localparam dy_offset20 = 2'b00,
		dy_offset40 = 2'b01,
		dy_offset60 = 2'b10,
		dy_offset80 = 2'b11;
	
	// small FSM to control dy offset
	always @(posedge clk)
	begin: dy_offset_FSM
		case(current_state)
			dy_offset20: next_state = next_square ? dy_offset40 : dy_offset20;
			dy_offset40: next_state = next_square ? dy_offset60 : dy_offset40;
			dy_offset60: next_state = next_square ? dy_offset80 : dy_offset60;
			dy_offset80: next_state = next_square ? dy_offset20 : dy_offset80;
			default: next_state = dy_offset20;
		endcase
	end
	
	always @(posedge clk)
	begin: load_state_transitions
		if (!reset)
			current_state <= dy_offset20;
		else
			current_state <= next_state;
	end
	
	always @(*)
	begin: dy_signals
		case(current_state)
			dy_offset20: dy <= 7'd20;
			dy_offset40: dy <= 7'd40;
			dy_offset60: dy <= 7'd60;
			dy_offset80: dy <= 7'd80;
			default: dy <= 7'd20;
		endcase
	end
	
endmodule
