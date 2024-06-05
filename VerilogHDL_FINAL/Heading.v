module Heading(input wire is_in_pixel,
				  input wire [9:0] hc,
				  input wire [9:0] vc,
				  input wire CLK,
				  output wire [3:0] pixel 
);

localparam WIDTH = 53;
localparam HEIGHT = 12;

localparam DEPTH = WIDTH * HEIGHT;

reg [3:0] Head [0:DEPTH-1];	 
					
 initial begin
	  $readmemh("Head.hex", Head);
 end
 
assign pixel = (is_in_pixel) ? Head[hc[9:3] + vc[9:3]*WIDTH]: 4'd8;
 
endmodule