
module main2(
input wire CLK,             	// 25.175 MHz clock
input wire RESET,             	// Reset signal
input wire Weapon_switch, 		// To switch the current weapon (Button3)
input wire Fire, 		// Fire button (Button4)
input wire Rotate_CW, 			// To rotate 22.5 degrees in clockwise direction (Button2)
input wire Rotate_CCW, 			// To rotate 22.5 degrees in counter-clockwise direction (Button1)
input wire Interaction,		    // Used as an interaction button for "Try again", "OKAY" (Button5)
output wire hsync,              // Horizontal sync output
output wire vsync,              // Vertical sync output
output wire[7:0] red,		    // Pixel color information about red color
output wire[7:0] green,		    // Pixel color information about green color
output wire[7:0] blue,		    // Pixel color information about blue color
output reg deneme1,					// Player is alive or not
output reg deneme2
);


wire[9:0] hc;
wire[9:0] vc;
wire is_blanking;

VGA_init(.CLK(CLK),.RESET(RESET),.hsync(hsync),.vsync(vsync),.hc(hc),.vc(vc),.is_blanking(is_blanking));

wire CLK_5Hz; 

CLK_5Hz_divider(.CLK(CLK),.CLK_divided(CLK_5Hz));


parameter [23:0] color0  = {8'd000, 8'd000, 8'd000};
parameter [23:0] color1  = {8'd093, 8'd038, 8'd093};
parameter [23:0] color2  = {8'd178, 8'd062, 8'd083};
parameter [23:0] color3  = {8'd239, 8'd125, 8'd088};
parameter [23:0] color4  = {8'd255, 8'd205, 8'd118};
parameter [23:0] color5  = {8'd168, 8'd240, 8'd112};
parameter [23:0] color6  = {8'd054, 8'd184, 8'd101};
parameter [23:0] color7  = {8'd036, 8'd113, 8'd121};
parameter [23:0] color8  = {8'd042, 8'd054, 8'd112};
parameter [23:0] color9  = {8'd059, 8'd093, 8'd201};
parameter [23:0] color10 = {8'd065, 8'd166, 8'd246};
parameter [23:0] color11 = {8'd115, 8'd239, 8'd247};
parameter [23:0] color12 = {8'd244, 8'd244, 8'd244};
parameter [23:0] color13 = {8'd149, 8'd176, 8'd195};
parameter [23:0] color14 = {8'd086, 8'd107, 8'd134};
parameter [23:0] color15 = {8'd050, 8'd060, 8'd087};

reg[3:0] pixel;

assign red = (is_blanking) ? 8'b00000000:
	(pixel == 4'd0) ? color0[23:16]:
	(pixel == 4'd1) ? color1[23:16]:
	(pixel == 4'd2) ? color2[23:16]:
	(pixel == 4'd3) ? color3[23:16]:
	(pixel == 4'd4) ? color4[23:16]:
	(pixel == 4'd5) ? color5[23:16]:
	(pixel == 4'd6) ? color6[23:16]:
	(pixel == 4'd7) ? color7[23:16]:
	(pixel == 4'd8) ? color8[23:16]:
	(pixel == 4'd9) ? color9[23:16]:
	(pixel == 4'd10) ? color10[23:16]:
	(pixel == 4'd11) ? color11[23:16]:
	(pixel == 4'd12) ? color12[23:16]:
	(pixel == 4'd13) ? color13[23:16]:
	(pixel == 4'd14) ? color14[23:16]:
	color15[23:16];

assign green = (is_blanking) ? 8'b00000000:
	(pixel == 4'd0) ? color0[15:8]:
	(pixel == 4'd1) ? color1[15:8]:
	(pixel == 4'd2) ? color2[15:8]:
	(pixel == 4'd3) ? color3[15:8]:
	(pixel == 4'd4) ? color4[15:8]:
	(pixel == 4'd5) ? color5[15:8]:
	(pixel == 4'd6) ? color6[15:8]:
	(pixel == 4'd7) ? color7[15:8]:
	(pixel == 4'd8) ? color8[15:8]:
	(pixel == 4'd9) ? color9[15:8]:
	(pixel == 4'd10) ? color10[15:8]:
	(pixel == 4'd11) ? color11[15:8]:
	(pixel == 4'd12) ? color12[15:8]:
	(pixel == 4'd13) ? color13[15:8]:
	(pixel == 4'd14) ? color14[15:8]:
	color15[15:8];

assign blue = (is_blanking) ? 8'b00000000:
	(pixel == 4'd0) ? color0[7:0]:
	(pixel == 4'd1) ? color1[7:0]:
	(pixel == 4'd2) ? color2[7:0]:
	(pixel == 4'd3) ? color3[7:0]:
	(pixel == 4'd4) ? color4[7:0]:
	(pixel == 4'd5) ? color5[7:0]:
	(pixel == 4'd6) ? color6[7:0]:
	(pixel == 4'd7) ? color7[7:0]:
	(pixel == 4'd8) ? color8[7:0]:
	(pixel == 4'd9) ? color9[7:0]:
	(pixel == 4'd10) ? color10[7:0]:
	(pixel == 4'd11) ? color11[7:0]:
	(pixel == 4'd12) ? color12[7:0]:
	(pixel == 4'd13) ? color13[7:0]:
	(pixel == 4'd14) ? color14[7:0]:
	color15[7:0];

// Each digit of score
wire [3:0] score_digit0;
wire [3:0] score_digit1;
wire [3:0] score_digit2;
wire [3:0] score_digit3;
wire [3:0] score_digit4;
	
// Update each digit whenever score changes
Score_init(.score(score),.digit4(score_digit4),.digit3(score_digit3),.digit2(score_digit2),.digit1(score_digit1),.digit0(score_digit0));
	
parameter GUI_width = 160; // Width of the GUI
parameter Center_point_hc = GUI_width + 239; // Horizontal coordinate of center point
parameter Center_point_vc = 239; // Vertical coordinate of center point
		
// Parameters for weapon
parameter weapon_art_hc = 25; // Horizontal coordinate of Up Left corner of the weapon article
parameter weapon_art_vc = 350; // Vertical coordinate of Up Left corner of the weapon article
parameter weapon_art_width = 108; // Width of weapon article
parameter weapon_art_height = 29; // Height of weapon article

parameter weapon_img0_hc = 63; // Horizontal coordinate of Up Left corner of the weapon image 0
parameter weapon_img0_vc = 416; // Vertical coordinate of Up Left corner of the weapon image 0
parameter weapon_img0_width = 32; // Width of weapon image 0
parameter weapon_img0_height = 32; // Height of weapon image 0

parameter weapon_img1_hc = 55; // Horizontal coordinate of Up Left corner of the weapon image 1
parameter weapon_img1_vc = 408; // Vertical coordinate of Up Left corner of the weapon image 1
parameter weapon_img1_width = 48; // Width of weapon image 1
parameter weapon_img1_height = 48; // Height of weapon image 1

parameter weapon_img2_hc = 48; // Horizontal coordinate of Up Left corner of the weapon image 2
parameter weapon_img2_vc = 400; // Vertical coordinate of Up Left corner of the weapon image 2
parameter weapon_img2_width = 64; // Width of weapon image 2
parameter weapon_img2_height = 64; // Height of weapon image 2

// Curret weapon register
reg[1:0] current_weapon;

		
// Parameters for score		
parameter score_art_hc = 22; // Horizontal coordinate of Up Left corner of the score article
parameter score_art_vc = 69; // Vertical coordinate of Up Left corner of the score article
parameter score_art_width = 115; // Width of score article
parameter score_art_height = 29; // Height of score article
		
parameter score_hc = 19;  // Horizontal coordinate of Up Left corner of the score
parameter score_vc = 109; // Vertical coordinate of Up Left corner of the score
parameter score_width = 24; // Width of each digit of score
parameter score_height = 30; // Height of score
		
// Score register and wires
reg[16:0] score;
	
// Spaceship settings
parameter spaceship_hc = GUI_width + 215;
parameter spaceship_vc = 215;
parameter spaceship_height = 48;
parameter spaceship_width = 48;

// Unnecessary variable
reg u2;

// Always block to find the color information of the current location
always @(posedge CLK) begin
	if (~is_blanking) begin
		pixel = 4'b0000;
		// Check whether we are in the pixels of GUI
		if (hc <= GUI_width) begin 
			if((hc >= score_art_hc) & (vc >= score_art_vc) & (hc <= score_art_hc + score_art_width) & (vc <= score_art_vc + score_art_height)) pixel = GUI_img(hc-score_art_hc,vc-score_art_vc,4'd10);
			else if ((hc >= score_hc) & (vc >= score_vc) & (hc <= score_hc + score_width*5) & (vc <= score_vc + score_height)) begin
				if (hc >= score_hc + 4* score_width) pixel = GUI_img(hc-score_hc-4* score_width,vc-score_vc,score_digit0);
				else if (hc >= score_hc + 3* score_width) pixel = GUI_img(hc-score_hc-3* score_width,vc-score_vc,score_digit1);
				else if (hc >= score_hc + 2* score_width) pixel = GUI_img(hc-score_hc-2* score_width,vc-score_vc,score_digit2);
				else if (hc >= score_hc + score_width) pixel = GUI_img(hc-score_hc- score_width,vc-score_vc,score_digit3);
				else pixel = GUI_img(hc-score_hc-4* score_width,vc-score_vc,score_digit4);
			end
			else if ((hc >= weapon_art_hc) & (vc >= weapon_art_vc) & (hc <= weapon_art_hc + weapon_art_width) & (vc <= weapon_art_vc + weapon_art_height)) pixel = GUI_img(hc-weapon_art_hc,vc-weapon_art_vc,4'd11);
			else if (current_weapon == 2'd0) begin
				if ((hc >= weapon_img0_hc) & (vc >= weapon_img0_vc) & (hc <= weapon_img0_hc + weapon_img0_width) & (vc <= weapon_img0_vc + weapon_img0_height)) pixel = Bullet_img(hc-weapon_img0_hc,vc-weapon_img0_vc,4'd2,2'd0);
				else pixel = 4'b1111;
			end
			else if (current_weapon == 2'd1) begin
				if ((hc >= weapon_img1_hc) & (vc >= weapon_img1_vc) & (hc <= weapon_img1_hc + weapon_img1_width) & (vc <= weapon_img1_vc + weapon_img1_height)) pixel = Bullet_img(hc-weapon_img1_hc,vc-weapon_img1_vc,4'd2,2'd1);
				else pixel = 4'b1111;
			end
			else if (current_weapon == 2'd2) begin
				if ((hc >= weapon_img2_hc) & (vc >= weapon_img2_vc) & (hc <= weapon_img2_hc + weapon_img2_width) & (vc <= weapon_img2_vc + weapon_img2_height)) pixel = Bullet_img(hc-weapon_img2_hc,vc-weapon_img2_vc,4'd2,2'd2);
				else pixel = 4'b1111;
			end

		end
		
		else begin
		u2 = pixel_finder();
		end 
	
	end
end

reg is_fire_pressed;
// Unnecessary variable
reg u; 
always @(posedge CLK_5Hz) begin
	deneme2 = 1'b1;
	if (RESET) begin
		score = 17'd0;
		enemies_active = 8'd0;
		bullets_active = 32'd0;
	end
	else if (~Fire & ~is_fire_pressed) begin
	is_fire_pressed = 1'b1;
	u = bullet_init(current_weapon,spaceship_angle);
	u = enemy_init(rand_mod5_int);
	u = enemies_action();
	u = bullets_action();
	end
	else begin
		deneme1 = 1'b1;
		if (Fire) is_fire_pressed = 1'b0;
		u = enemy_init(rand_mod5_int);
		u = enemies_action();
		u = bullets_action();
	end
end


reg [7:0] enemies_dist[7:0];
reg [3:0] enemies_angle[7:0];
reg [3:0] enemies_health[7:0];
reg [3:0] enemies_type[7:0];
reg [7:0]enemies_active;

reg [7:0] bullets_dist[31:0];
reg [3:0] bullets_angle[31:0];
reg [1:0] bullets_type[31:0];
reg [31:0]bullets_active;

wire [3:0] spaceship_angle;

reg temp;

reg [3:0] Angle1;
reg [3:0] Angle2;

assign spaceship_angle = Angle1 + Angle2;

// Always block for updating the state of spaceship
always @(negedge Rotate_CW) Angle1 = Angle1 - 4'd1;
always @(negedge Rotate_CCW) Angle2 = Angle2 + 4'd1;


// Always block for updating the type of weapon
always @(negedge Weapon_switch) begin
current_weapon = current_weapon + 2'd1;
if (current_weapon == 2'd3) current_weapon = 2'd0;
end


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
			change_cor[17:9] = (_angle == 4'd0) ? 9'd240 + _dist:
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

wire[3:0] rand_int;
wire[3:0] rand_mod5_int;
reg count [2:0];

random(CLK_5Hz,rand_int);
random_mod5(CLK_5Hz,rand_mod5_int);

function enemy_init(input [3:0] e_type);
begin
	reg [3:0] i;
	reg stop = 1'b0;
	for(i = 4'd0; i < 4'd8 && ~stop; i = i + 4'd1) begin
		if(~enemies_active[i]) begin
			stop = 1'b1;
			enemies_active[i] = 1'b1;
			enemies_type[i] = e_type;
			enemies_dist[i] = 8'd240; // Başlangıçta en uzak değer yaptım
			enemies_angle[i] = rand_int; // Random değerini değiştirmek gerek
			enemies_health[i] = (e_type == 0) ? 4'd6:
				(e_type == 1) ? 4'd3:
				(e_type == 2) ? 4'd2:
				(e_type == 3) ? 4'd9:
				4'd15;
		end
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

function enemies_action;
begin

	reg [3:0] i;
	for(i = 4'd0; i < 4'd7; i = i + 4'd1)
	begin
		if (enemies_type[i] == 3'd0) begin
			if (enemies_dist[i] < 8'd15) 	enemies_active[i] = 1'b0;
			else temp = enemy_move(i);
		end
		else if (enemies_type[i] == 3'd1) begin
			if (enemies_dist[i] < 8'd8) 	enemies_active[i] = 1'b0;
			else temp = enemy_move(i);
		end
		else if (enemies_type[i] == 3'd2) begin
			if (enemies_dist[i] < 8'd8) 	enemies_active[i] = 1'b0;
			else temp = enemy_move(i);
		end
		else if (enemies_type[i] == 3'd3) begin
			if (enemies_dist[i] < 8'd42) 	enemies_active[i] = 1'b0;
			else temp = enemy_move(i);
		end
		else begin
			if (enemies_dist[i] < 8'd46) 	enemies_active[i] = 1'b0;
			else temp = enemy_move(i);
		end
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
        bullets_active[i] = 1'b1;
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
	if (bullets_dist[i] < 9'd240) begin
		bullets_dist[i] = (bullets_type[i] == 2'd0) ? bullets_dist[i] + 8'd7 :
		(bullets_type[i] == 2'd1) ? bullets_dist[i] + 8'd5 :
		bullets_dist[i] + 8'd4;
	end
	else bullets_active[i] = 1'b0;
endfunction

function check_col(input [4:0] i);
begin 
	reg [3:0] j;
	reg stop = 1'b0;
	reg [3:0] damage_dealt;
	for(j = 4'd0; j < 4'd7 && ~stop; j = j + 4'd1)
	if(enemies_active[j] && bullets_dist[i] >= enemies_dist[j] && enemies_angle[j] == bullets_angle[i]) begin
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

function bullets_action;
begin
	reg [4:0] i;
	for(i = 5'd0; i < 5'd31; i = i + 5'd1)
	if(bullets_active[i]) begin
		temp = bullet_move(i);
		temp = check_col(i);
	end
end
endfunction

function pixel_finder;
begin
	reg [5:0] i;
	reg [9:0] x;
	reg [9:0] y;
   reg [8:0] d;
	reg [17:0] temp1;
    reg stop = 1'b0;
		
    // For Spaceship
    if(hc >= spaceship_hc && hc < spaceship_hc + spaceship_width && vc >= spaceship_vc && vc < spaceship_vc + spaceship_height) begin
		  if (Spaceship_img(hc - spaceship_hc, vc - spaceship_vc, spaceship_angle) != 4'b0000) begin
			  pixel = Spaceship_img(hc - spaceship_hc, vc - spaceship_vc, spaceship_angle);
			  stop = 1'b1;
		  end
    end

	// For enemies
    for (i = 6'd0; i < 6'd7 && ~stop; i = i + 6'd1) begin
			if (enemies_active[i]) begin
			  temp1 = change_cor(enemies_dist[i], enemies_angle[i]);
			  x = {1'b0,temp1[17:9]};
			  y = {1'b0,temp1[8:0]};
			  
			  d = (enemies_type[i] == 3'd3 | enemies_type[i] == 3'd4) ? 9'd64:
					9'd32;

			  if(hc >= x + GUI_width - d && hc < x + GUI_width + d && vc >= y - d && vc < y + d && y < y + d && y > y - d && x + GUI_width < x + d  + GUI_width) begin
					if (Enemy_img(hc - x + d, vc - y + d, bullets_angle[i], bullets_type[i]) != 4'b0000) begin
						stop = 1'b1;
						pixel = Enemy_img(hc - x + d, vc - y + d, bullets_angle[i], bullets_type[i]);
					end
			  end
			end
    end

    // For bullets
	for (i = 6'd0; i < 6'd31 && ~stop; i = i + 6'd1) begin
		if (bullets_active[i]) begin
			  temp1 = change_cor(bullets_dist[i], bullets_angle[i]);
			  x = temp1[17:9];
			  y = temp1[8:0];

			  d = (bullets_type[i] == 3'd0) ? 9'd16:
					(bullets_type[i] == 3'd1) ? 9'd24:
					9'd32; 

			  if(hc >= x + GUI_width - d && hc < x + GUI_width + d && vc >= y - d && vc < y + d && y < y + d && y > y - d && x + GUI_width < x + d  + GUI_width) begin
					if(Bullet_img(hc - x + d, vc - y + d, bullets_angle[i], bullets_type[i]) != 4'b0000) begin
						stop = 1'b1;
						pixel = Bullet_img(hc - x + d, vc - y + d, bullets_angle[i], bullets_type[i]);
					end
			  end
		end
    end
end
endfunction

function [3:0] Spaceship_img(input [6:0] x, input [6:0] y, input [3:0] angle);
begin
Spaceship_img = 4'd7;
end
endfunction


function [3:0] Enemy_img(input [6:0] x, input [6:0] y, input [3:0] angle, input [2:0] e_type);
begin
Enemy_img = 4'd10;
end
endfunction

function [3:0] Bullet_img(input [6:0] x, input [6:0] y, input [3:0] angle, input [1:0] b_type);
begin
Bullet_img = 4'd6;
end
endfunction

function [3:0] GUI_img(input [6:0] x, input [6:0] y, input [3:0] e_type);
begin
GUI_img = 4'd9;
end
endfunction
endmodule
