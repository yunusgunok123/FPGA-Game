module Spaceship( input wire is_SS_in_pixel,
				  input wire [3:0] SS_angle,
				  input wire [8:0] SS_hc,
				  input wire [8:0] SS_vc,
				  input wire CLK,
				  output reg [3:0] pixel 
);

localparam ANGLE_AMOUNT = 16;
localparam SS_SIZE = 36;

localparam DEPTH_ANGLE = SS_SIZE * SS_SIZE;

localparam DEPTH_ENTITY = DEPTH_ANGLE * ANGLE_AMOUNT;


reg [3:0] SS [0:DEPTH_ENTITY-1];	 
					
 initial begin
	  $readmemh("SS.hex", SS);
 end
 
 always @(posedge CLK) begin
		pixel <= SS[(SS_hc + SS_vc*SS_SIZE + SS_angle*DEPTH_ANGLE)*is_SS_in_pixel];
 end
 
 endmodule