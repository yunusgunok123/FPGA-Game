module Number( input wire is_number_in_pixel[4:0],
				  input wire [3:0] number_type[5:0],
				  input wire [9:0] number_hc[5:0],
				  input wire [9:0] number_vc[5:0],
				  input wire CLK,
				  output reg [3:0] pixel 
);

localparam N_WIDTH = 4;
localparam N_HEIGHT = 5;
localparam N_AMOUNT = 10;

localparam DEPTH_NUMBER = N_WIDTH * N_HEIGHT;

reg [3:0] N [0:DEPTH_NUMBER*N_AMOUNT];	 
	 
wire [2:0] index = (is_number_in_pixel[0]) ? 3'd0:
						(is_number_in_pixel[1]) ? 3'd1:
						(is_number_in_pixel[2]) ? 3'd2:
						(is_number_in_pixel[3]) ? 3'd3:
						(is_number_in_pixel[4]) ? 3'd4:
						3'd5;

					
 initial begin
	  $readmemh("N.hex", N);
 end
 
 always @(posedge CLK) begin
		pixel <= N[number_hc[index][9:2] + number_vc[index][9:2]*N_WIDTH + number_type[index]*DEPTH_NUMBER];
 end
 
 endmodule