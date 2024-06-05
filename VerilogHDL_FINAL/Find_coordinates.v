module Find_coordinates(
	input wire [9:0] hc,
	input wire [9:0] vc,
	input wire [8:0] distance,
	input wire [3:0] angle,
	input wire CLK,
	output wire [9:0] entity_x,
	output wire [9:0] entity_y,
	output wire is_entity_in_pixel
	);	
	localparam offset_x = 160; // Due to GUI width
	localparam d = 18; // Due to size of entity
	
	wire [15:0] temp0 = 16'd45 * distance;
	wire [15:0] temp1 = 16'd59 * distance;
	wire [15:0] temp2 = 16'd24 * distance;
	
	reg [9:0] x;
	reg [9:0] y;
	
	assign entity_x = d - x + hc;
	assign entity_y = d - y + vc;
	
	
	assign is_entity_in_pixel = (hc >= x - d && hc < x + d && vc >= y - d && vc < y + d && y < y + d && y > y - d && x < x + d);
	// cos0 = 1, sin0 = 0
	// cos45 = sin45 = 45/64
	// cos22.5 = 59/64, sin22.5 = 24/64
	always @(posedge CLK) begin	
		case(angle)
			4'd0,4'd4,4'd8,4'd12: begin
				y = (angle == 4'd4) ? 10'd239 -distance:
					(angle == 4'd12) ? 10'd239 + distance
					: 10'd239;
				x = (angle == 4'd0) ? 10'd239 + distance + offset_x :
					(angle == 4'd8) ? 10'd239 - distance + offset_x 
					: 10'd239 + offset_x;
			end
			4'd2,4'd6,4'd10,4'd14: begin

				y = (angle == 4'd2 || angle == 4'd6) ? 10'd239 - temp0[15:6]
				: 10'd239 + temp0[15:6];
				x = (angle == 4'd2 || angle == 4'd14) ? 10'd239 + temp0[15:6] + offset_x 
				: 10'd239 - temp0[15:6] + offset_x;	
			end
			default: begin
				y = (angle == 4'd1 || angle == 4'd7) ? 10'd239 - temp2[15:6]:
					(angle == 4'd9 || angle == 4'd15) ? 10'd239 + temp2[15:6]:
					(angle == 4'd3 || angle == 4'd5) ? 10'd239 - temp1[15:6]:
					10'd239 + temp1[15:6];
				x = (angle == 4'd1 || angle == 4'd15) ? 10'd239 + temp1[15:6] + offset_x:
					(angle == 4'd7 || angle == 4'd9) ? 10'd239 - temp1[15:6] + offset_x:
					(angle == 4'd3 || angle == 4'd13) ? 10'd239 + temp2[15:6] + offset_x:
					10'd239 - temp2[15:6] + offset_x;
			end
		endcase
	end
endmodule
