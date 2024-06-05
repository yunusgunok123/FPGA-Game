module Background(
	  input wire [9:0] hc,
	  input wire [9:0] vc,
	  input wire CLK,
	  output reg [3:0] pixel 
);

localparam WIDTH = 240;
localparam HEIGHT = 240;

localparam DEPTH = WIDTH * HEIGHT;

reg [3:0] BG [0:DEPTH-1];	 
					
 initial begin
	  $readmemh("BG.hex", BG);
 end

always @(posedge CLK) begin
		pixel <= BG[hc[9:1] + vc[9:1]*WIDTH];
end 
 
endmodule