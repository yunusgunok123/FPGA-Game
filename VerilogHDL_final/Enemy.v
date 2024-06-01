module Enemy( input wire is_enemy_in_pixel[7:0],
				  input wire is_enemy_active[7:0],
				  input wire [3:0] enemy_angle[8:0],
				  input wire [3:0] enemy_type[8:0],
				  input wire [8:0] enemy_hc[8:0],
				  input wire [8:0] enemy_vc[8:0],
				  input wire CLK,
				  output reg [3:0] pixel 
);

localparam ANGLE_AMOUNT = 16;
localparam E_SIZE = 36;
localparam E_AMOUNT = 4;


localparam DEPTH_ANGLE = E_SIZE * E_SIZE;

localparam DEPTH_ENTITY = DEPTH_ANGLE * ANGLE_AMOUNT;


reg [3:0] E [0:DEPTH_ENTITY*E_AMOUNT];	 
	 
wire [5:0] index = (is_enemy_in_pixel[0] | is_enemy_active[0]) ? 6'd0:
                   (is_enemy_in_pixel[1] | is_enemy_active[1]) ? 6'd1:
                   (is_enemy_in_pixel[2] | is_enemy_active[2]) ? 6'd2:
                   (is_enemy_in_pixel[3] | is_enemy_active[3]) ? 6'd3:
                   (is_enemy_in_pixel[4] | is_enemy_active[4]) ? 6'd4:
                   (is_enemy_in_pixel[5] | is_enemy_active[5]) ? 6'd5:
                   (is_enemy_in_pixel[6] | is_enemy_active[6]) ? 6'd6:
                   (is_enemy_in_pixel[7] | is_enemy_active[7]) ? 6'd7:
                   6'd8;
					
 initial begin
	  $readmemh("E.hex", E);
 end
 
 always @(posedge CLK) begin
		pixel <= E[enemy_hc[index] + enemy_vc[index]*E_SIZE + enemy_angle[index]*DEPTH_ANGLE + enemy_type[index]*DEPTH_ENTITY];
 end
 
 endmodule