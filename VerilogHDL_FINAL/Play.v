module Play(input wire is_in_pixel,
				  input wire [9:0] hc,
				  input wire [9:0] vc,
				  input wire CLK,
				  output wire [3:0] pixel 
);

localparam WIDTH = 20;
localparam HEIGHT = 7;

localparam DEPTH = WIDTH * HEIGHT;

reg [3:0] Play [0:DEPTH-1];	 
					
 initial begin
	  $readmemh("Play.hex", Play);
 end
 
assign pixel = (is_in_pixel) ? Play[hc[9:3] + vc[9:3]*WIDTH]: 4'd8;
 
endmodule