module EE_logo(input wire is_in_pixel,
				  input wire [9:0] hc,
				  input wire [9:0] vc,
				  input wire CLK,
				  output wire [3:0] pixel 
);

localparam WIDTH = 40;
localparam HEIGHT = 40;

localparam DEPTH = WIDTH * HEIGHT;

reg [3:0] EE [0:DEPTH-1];	 
					
 initial begin
	  $readmemh("EE.hex", EE);
 end
 
assign pixel = (is_in_pixel) ? EE[hc[9:2] + vc[9:2]*WIDTH]: 4'd8;
 
endmodule