module Health_bar(
	input wire [9:0] x,
	input wire [9:0] y,
	input wire CLK,
	input wire is_enemy_in_pixel,
	input wire [3:0] enemy_type,
	input wire [7:0] enemy_health,
	input wire enemy_active,
	output reg [3:0] pixel
	);	

localparam health_bar_width = 32;
localparam health_bar_height = 3;
localparam d = 2;
	
wire is_bar_in_pixel = is_enemy_in_pixel & enemy_active & (health_bar_width > x  & d <= x & health_bar_height > y  & 10'd0 <= y);

	
always @(posedge CLK) begin
	if(is_bar_in_pixel)begin
		case(enemy_type)
		4'd0: begin
			if((x - 10'd2) >> 2 <= enemy_health) pixel = 4'd6;
			else pixel = 4'd2;
		end
		4'd1: begin
			if((x - 10'd2) >> 3 <= enemy_health) pixel = 4'd6;
			else pixel = 4'd2;
		end
		4'd2: begin
			if((x-10'd2) <= enemy_health) pixel = 4'd6;
			else pixel = 4'd2;
		end
		4'd3: begin
			if((x - 10'd2) << 2 <= enemy_health) pixel = 4'd6;
			else pixel = 4'd2;
		end
		endcase
	end
	else pixel = 4'd0;
end	

endmodule
