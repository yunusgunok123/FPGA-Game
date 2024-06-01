module Weapon_img( input wire is_wep_img_in_pixel,
				  input wire [3:0] wep_type,
				  input wire [9:0] wep_hc,
				  input wire [9:0] wep_vc,
				  input wire CLK,
				  output reg [3:0] pixel 
);

localparam W_SIZE = 36;
localparam W_AMOUNT = 3;

localparam DEPTH_W = W_SIZE * W_SIZE;

reg [3:0] W [0:DEPTH_W*W_AMOUNT];	 

					
 initial begin
	  $readmemh("W.hex", W);
 end
 
 always @(posedge CLK) begin
		pixel <= W[(wep_hc + wep_vc*W_SIZE + wep_type*DEPTH_W)*is_wep_img_in_pixel];
 end
 
 endmodule