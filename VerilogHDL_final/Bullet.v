module Bullet( input wire is_bullet_in_pixel[19:0],
				  input wire is_bullet_active[19:0],
				  input wire [3:0] bullet_angle[20:0],
				  input wire [3:0] bullet_type[20:0],
				  input wire [8:0] bullet_hc[20:0],
				  input wire [8:0] bullet_vc[20:0],
				  input wire CLK,
				  output reg [3:0] pixel 
);

localparam ANGLE_AMOUNT = 16;
localparam B_SIZE = 36;
localparam B_AMOUNT = 3;


localparam DEPTH_ANGLE = B_SIZE * B_SIZE;

localparam DEPTH_ENTITY = DEPTH_ANGLE * ANGLE_AMOUNT;


reg [3:0] B [0:DEPTH_ENTITY*B_AMOUNT];	 
	 
wire [5:0] index = (is_bullet_in_pixel[0] | is_bullet_active[0]) ? 6'd0:
                   (is_bullet_in_pixel[1] | is_bullet_active[1]) ? 6'd1:
                   (is_bullet_in_pixel[2] | is_bullet_active[2]) ? 6'd2:
                   (is_bullet_in_pixel[3] | is_bullet_active[3]) ? 6'd3:
                   (is_bullet_in_pixel[4] | is_bullet_active[4]) ? 6'd4:
                   (is_bullet_in_pixel[5] | is_bullet_active[5]) ? 6'd5:
                   (is_bullet_in_pixel[6] | is_bullet_active[6]) ? 6'd6:
                   (is_bullet_in_pixel[7] | is_bullet_active[7]) ? 6'd7:
                   (is_bullet_in_pixel[8] | is_bullet_active[8]) ? 6'd8:
                   (is_bullet_in_pixel[9] | is_bullet_active[9]) ? 6'd9:
                   (is_bullet_in_pixel[10] | is_bullet_active[10]) ? 6'd10:
                   (is_bullet_in_pixel[11] | is_bullet_active[11]) ? 6'd11:
                   (is_bullet_in_pixel[12] | is_bullet_active[12]) ? 6'd12:
                   (is_bullet_in_pixel[13] | is_bullet_active[13]) ? 6'd13:
                   (is_bullet_in_pixel[14] | is_bullet_active[14]) ? 6'd14:
                   (is_bullet_in_pixel[15] | is_bullet_active[15]) ? 6'd15:
                   (is_bullet_in_pixel[16] | is_bullet_active[16]) ? 6'd16:
                   (is_bullet_in_pixel[17] | is_bullet_active[17]) ? 6'd17:
                   (is_bullet_in_pixel[18] | is_bullet_active[18]) ? 6'd18:
                   (is_bullet_in_pixel[19] | is_bullet_active[19]) ? 6'd19:
                   6'd20;
					
 initial begin
	  $readmemh("B.hex", B);
 end
 
 always @(posedge CLK) begin
		pixel <= B[bullet_hc[index] + bullet_vc[index]*B_SIZE + bullet_angle[index]*DEPTH_ANGLE + bullet_type[index]*DEPTH_ENTITY];
 end
 
 endmodule