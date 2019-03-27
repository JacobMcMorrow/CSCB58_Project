module noise #(
  parameter OUTPUT_BITS = 12
	)
	(
  input clk,
  input reset,
  output wire [OUTPUT_BITS-1:0] dout
	);

  reg [22:0] lsfr = 23'b01101110010010000101011;

  always @(posedge clk or posedge rst) begin
    if (reset)
      begin
        lsfr <= 23'b01101110010010000101011;
      end
    else
      begin
        lsfr <= { lsfr[21:0], lsfr[22] ^ lsfr[17] };
    end
  end

  assign dout = { 
								lsfr[22],
								lsfr[20],
								lsfr[16],
								lsfr[13],
								lsfr[11],
								lsfr[7],
								lsfr[4],
								lsfr[2],
								{(OUTPUT_BITS-8){1'b0}}
								};

endmodule

`endif
