module Weapon_Article(input wire is_in_pixel,
				  input wire [9:0] hc,
				  input wire [9:0] vc,
				  input wire CLK,
				  output wire [3:0] pixel 
);

localparam WIDTH = 30;
localparam HEIGHT = 7;

localparam DEPTH = WIDTH * HEIGHT;

reg [3:0] W_A [0:DEPTH-1];	 
					
 initial begin
	  $readmemh("W_A.hex", W_A);
 end
 
assign pixel = (is_in_pixel) ? W_A[hc[9:2] + vc[9:2]*WIDTH]: 4'b0;
 
endmodule