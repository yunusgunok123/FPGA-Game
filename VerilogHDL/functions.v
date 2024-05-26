module Test(x, y, z);

input wire x, y, z;

reg [7:0] enemies_dist[7:0];
reg [3:0] enemies_angle[7:0];
reg [3:0] enemies_health[7:0];
reg [3:0] enemies_type[7:0];
reg enemies_active[7:0];

reg [7:0] bullets_dist[31:0];
reg [3:0] bullets_angle[31:0];
reg [1:0] bullets_type[31:0];
reg bullets_active[31:0];

reg [16:0] score;

reg temp;

function [17:0] change_cor(input [7:0] _dist, input [3:0] _angle);
begin
	// cos0 = 1, sin0 = 0
	// cos45 = sin45 = 45/64
	// cos22.5 = 59/64, sin22.5 = 24/64
	// Pozitif y aşağı [17:9]
	// Pozitif x sağ [8:0]
	case(_angle)
		4'd0,4'd4,4'd8,4'd12: begin
			change_cor[8:0] = (_angle == 4'd4) ? 9'd240 -_dist:
				(_angle == 4'd12) ? 9'd240 + _dist
				: 9'd240;
			change_cor[11:6] = (_angle == 4'd0) ? 9'd240 + _dist:
				(_angle == 4'd8) ? 9'd240 - _dist
				: 9'd240;
		end
		4'd2,4'd6,4'd10,4'd14: begin
			reg [14:0] temp1 = 15'd45 * _dist;
			change_cor[8:0] = (_angle == 4'd2 || _angle == 4'd6) ? 9'd240 - temp1[14:6]
			: 9'd240 + temp1[14:6];
			change_cor[17:9] = (_angle == 4'd2 || _angle == 4'd14) ? 9'd240 + temp1[14:6]
			: 9'd240 - temp1[14:6];	
		end
		default: begin
			reg [14:0] temp1 = 15'd59 * _dist;
			reg [14:0] temp2 = 15'd24 * _dist;
			change_cor[8:0] = (_angle == 4'd1 || _angle == 4'd7) ? 9'd240 - temp2[14:6]:
				(_angle == 4'd9 || _angle == 4'd15) ? 9'd240 + temp2[14:6]:
				(_angle == 4'd3 || _angle == 4'd5) ? 9'd240 - temp1[14:6]:
				9'd240 + temp1[14:6];
			change_cor[17:9] = (_angle == 4'd1 || _angle == 4'd15) ? 9'd240 + temp1[14:6]:
				(_angle == 4'd7 || _angle == 4'd9) ? 9'd240 - temp1[14:6]:
				(_angle == 4'd3 || _angle == 4'd13) ? 9'd240 + temp2[14:6]:
				9'd240 - temp2[14:6];
		end
	endcase
end
endfunction

function enemy_init(input [3:0] e_type);
begin
	reg [3:0] i;
	reg stop = 1'b0;
	for(i = 4'd0; i < 4'd8 && ~stop; i = i + 4'd1)
	if(~enemies_active[i]) begin
		stop = 1'b1;
		enemies_type[i] = e_type;
		enemies_dist[i] = 8'd255; // Başlangıçta en uzak değer yaptım
		enemies_angle[i] = $random;
		enemies_health[i] = (e_type == 0) ? 4'd6:
			(e_type == 1) ? 4'd3:
			(e_type == 2) ? 4'd2:
			(e_type == 3) ? 4'd9:
			4'd15;
	end
end
endfunction


function enemy_move(input [3:0] i);
enemies_dist[i] = (enemies_type[i] == 3'd0) ? enemies_dist[i] - 8'd3 :
	(enemies_type[i] == 3'd1) ? enemies_dist[i] - 8'd4 :
	(enemies_type[i] == 3'd2) ? enemies_dist[i] - 8'd5 :
	(enemies_type[i] == 3'd3) ? enemies_dist[i] - 8'd2 :
	enemies_dist[i] - 8'd1;
endfunction

function enemies_action();
begin
	reg [3:0] i;
	for(i = 4'd0; i < 4'd7; i = i + 4'd1)
	if(enemies_active[i]) begin
		temp = enemy_move(i);
	end
end
endfunction

function bullet_init(input [1:0] b_type, input [3:0] angle);
begin
	reg [4:0] i;
	reg [3:0] counter = (b_type == 2'd0) ? 3'd5:
		(b_type == 2'd1) ? 3'd3:
		3'd1;
	
	for(i = 5'd0; i < 5'd31 && counter > 0; i = i + 5'd1)
	if(~bullets_active[i]) begin
		bullets_dist[i] = 7'd0; // Başlangıçta merkezde
		bullets_type[i] = b_type;
		bullets_angle[i] = (counter == 5) ? angle + 4'd2:
			(counter == 4) ? angle - 4'd2:
			(counter == 3) ? angle + 4'd1:
			(counter == 2) ? angle - 4'd1:
			angle;
		counter = counter - 1;
	end
end
endfunction

function bullet_move(input [4:0] i);
bullets_dist[i] = (bullets_type[i] == 2'd0) ? bullets_dist[i] + 8'd7 :
	(bullets_type[i] == 2'd1) ? bullets_dist[i] + 8'd5 :
	bullets_dist[i] + 8'd4;
endfunction

function bullets_action();
begin
	reg [4:0] i;
	for(i = 5'd0; i < 5'd31; i = i + 5'd1)
	if(bullets_active[i]) begin
		temp = bullet_move(i);
		temp = check_col(i);
	end
end
endfunction

function check_col(input [4:0] i);
begin 
	reg [3:0] j;
	reg stop = 1'b0;
	reg [3:0] damage_dealt;
	for(j = 4'd0; j < 4'd7 && ~stop; j = j + 4'd1)
	if(enemies_active[j] && bullets_dist[i] >= enemies_dist[j]) begin
		stop = 1'b1;
		bullets_active[i] = 1'b0; 
		damage_dealt = (bullets_type[i] == 2'd0) ? 4'd2:
			(bullets_type[i] == 2'd1) ? 4'd3: 
			4'd9;
		if(damage_dealt >= enemies_health[j]) begin
			score = (enemies_type[j] == 3'd0) ? score + 17'd6:
				(enemies_type[j] == 3'd1) ? score + 17'd3:
				(enemies_type[j] == 3'd2) ? score + 17'd2:
				(enemies_type[j] == 3'd3) ? score + 17'd9:
				17'd5;
			enemies_active[j] = 1'b0;
		end
		else enemies_health[j] = enemies_health[j] - damage_dealt;
	end
end
endfunction

endmodule
