module Game_Over_Article(input wire is_in_pixel,
				  input wire [9:0] hc,
				  input wire [9:0] vc,
				  input wire CLK,
				  output wire [3:0] pixel 
);

localparam WIDTH = 42;
localparam HEIGHT = 5;

localparam DEPTH = WIDTH * HEIGHT;

reg [3:0] G_O [0:DEPTH-1];	 
					
 initial begin
	  $readmemh("G_O.hex", G_O);
 end
 
assign pixel = (is_in_pixel) ? G_O[hc[9:3] + vc[9:3]*WIDTH]: 4'b0;
 
endmodule