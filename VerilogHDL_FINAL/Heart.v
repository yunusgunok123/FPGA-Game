module Heart(input wire is_in_pixel [2:0],
				  input wire [9:0] hc [2:0],
				  input wire [9:0] vc,
				  input wire CLK,
				  output wire [3:0] pixel 				  
);


localparam WIDTH = 13;
localparam HEIGHT = 12;

localparam DEPTH = WIDTH * HEIGHT;

reg [3:0] H [0:DEPTH-1];

wire [1:0] index = (is_in_pixel[0]) ? 2'd0:
						(is_in_pixel[1]) ? 2'd1:
						(is_in_pixel[2]) ? 2'd2:
						2'd3;

initial begin
	  $readmemh("H.hex", H);
end
 
assign pixel = (index != 2'd3) ? H[hc[index][9:1] + vc[9:1]*WIDTH] : 4'd0;
 
endmodule