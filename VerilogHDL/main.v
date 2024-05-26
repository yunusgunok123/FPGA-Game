module main(
    input wire CLK,             // 25.175 MHz clock
    input wire RESET,             // Reset signal
	 input wire Weapon_switch, 	// To switch the current weapon (Button3)
	 input wire Rotate_CW, 			// To rotate 22.5 degrees in clockwise direction (Button2)
	 input wire Rotate_CCW, 		// To rotate 22.5 degrees in counter-clockwise direction (Button1)
	 input wire Interaction,		// Used as an interaction button for "Try again", "OKAY" (Button4)
    output wire hsync,           // Horizontal sync output
    output wire vsync,           // Vertical sync output
	 output wire[7:0] red,			// Pixel color information about red color
	 output wire[7:0] green,			// Pixel color information about green color
	 output wire[7:0] blue			// Pixel color information about blue color
);

// Creating all needed wires, registers, and parameters

	
	// Location information
	wire[9:0] hc;
	wire[9:0] vc;

	// Blanking state indicator register
	wire is_blanking;
	
	// Color information registers
	
	reg[23:0] color0 = {8'd026,8'd028,8'd043};
	reg[23:0] color1 = {8'd093,8'd038,8'd093};
	reg[23:0] color2 = {8'd178,8'd062,8'd083};
	reg[23:0] color3 = {8'd239,8'd125,8'd088};
	reg[23:0] color4 = {8'd255,8'd205,8'd118};
	reg[23:0] color5 = {8'd168,8'd240,8'd112};
	reg[23:0] color6 = {8'd054,8'd184,8'd101};
	reg[23:0] color7 = {8'd036,8'd113,8'd121};
	reg[23:0] color8 = {8'd042,8'd054,8'd112};
	reg[23:0] color9 = {8'd059,8'd093,8'd201};
	reg[23:0] color10 = {8'd065,8'd166,8'd246};
	reg[23:0] color11 = {8'd115,8'd239,8'd247};
	reg[23:0] color12 = {8'd244,8'd244,8'd244};
	reg[23:0] color13 = {8'd149,8'd176,8'd195};
	reg[23:0] color14 = {8'd086,8'd107,8'd134};
	reg[23:0] color15 = {8'd050,8'd060,8'd087};
	
	// Register for color information about current pixel for VGA
	reg[3:0] pixel;
	
	// Assignment for red color
	assign red = (~is_blanking & (pixel == 4'b0000)) ? color0[23:16]:
					 (~is_blanking & (pixel == 4'b0001)) ? color1[23:16]:
					 (~is_blanking & (pixel == 4'b0010)) ? color2[23:16]:
					 (~is_blanking & (pixel == 4'b0011)) ? color3[23:16]:
					 (~is_blanking & (pixel == 4'b0100)) ? color4[23:16]:
					 (~is_blanking & (pixel == 4'b0101)) ? color5[23:16]:
					 (~is_blanking & (pixel == 4'b0110)) ? color6[23:16]:
					 (~is_blanking & (pixel == 4'b0111)) ? color7[23:16]:
					 (~is_blanking & (pixel == 4'b1000)) ? color8[23:16]:
					 (~is_blanking & (pixel == 4'b1001)) ? color9[23:16]:
					 (~is_blanking & (pixel == 4'b1010)) ? color10[23:16]:
					 (~is_blanking & (pixel == 4'b1011)) ? color11[23:16]:
					 (~is_blanking & (pixel == 4'b1100)) ? color12[23:16]:
					 (~is_blanking & (pixel == 4'b1101)) ? color13[23:16]:
					 (~is_blanking & (pixel == 4'b1110)) ? color14[23:16]:
					 (~is_blanking & (pixel == 4'b1111)) ? color15[23:16]:
					 8'b00000000;
	
	// Assignment for green color	
	assign green = (~is_blanking & (pixel == 4'b0000)) ? color0[15:8]:
					 (~is_blanking & (pixel == 4'b0001)) ? color1[15:8]:
					 (~is_blanking & (pixel == 4'b0010)) ? color2[15:8]:
					 (~is_blanking & (pixel == 4'b0011)) ? color3[15:8]:
					 (~is_blanking & (pixel == 4'b0100)) ? color4[15:8]:
					 (~is_blanking & (pixel == 4'b0101)) ? color5[15:8]:
					 (~is_blanking & (pixel == 4'b0110)) ? color6[15:8]:
					 (~is_blanking & (pixel == 4'b0111)) ? color7[15:8]:
					 (~is_blanking & (pixel == 4'b1000)) ? color8[15:8]:
					 (~is_blanking & (pixel == 4'b1001)) ? color9[15:8]:
					 (~is_blanking & (pixel == 4'b1010)) ? color10[15:8]:
					 (~is_blanking & (pixel == 4'b1011)) ? color11[15:8]:
					 (~is_blanking & (pixel == 4'b1100)) ? color12[15:8]:
					 (~is_blanking & (pixel == 4'b1101)) ? color13[15:8]:
					 (~is_blanking & (pixel == 4'b1110)) ? color14[15:8]:
					 (~is_blanking & (pixel == 4'b1111)) ? color15[15:8]:
					 8'b00000000;
	
	// Assignment for blue color
	assign blue = (~is_blanking & (pixel == 4'b0000)) ? color0[7:0]:
					 (~is_blanking & (pixel == 4'b0001)) ? color1[7:0]:
					 (~is_blanking & (pixel == 4'b0010)) ? color2[7:0]:
					 (~is_blanking & (pixel == 4'b0011)) ? color3[7:0]:
					 (~is_blanking & (pixel == 4'b0100)) ? color4[7:0]:
					 (~is_blanking & (pixel == 4'b0101)) ? color5[7:0]:
					 (~is_blanking & (pixel == 4'b0110)) ? color6[7:0]:
					 (~is_blanking & (pixel == 4'b0111)) ? color7[7:0]:
					 (~is_blanking & (pixel == 4'b1000)) ? color8[7:0]:
					 (~is_blanking & (pixel == 4'b1001)) ? color9[7:0]:
					 (~is_blanking & (pixel == 4'b1010)) ? color10[7:0]:
					 (~is_blanking & (pixel == 4'b1011)) ? color11[7:0]:
					 (~is_blanking & (pixel == 4'b1100)) ? color12[7:0]:
					 (~is_blanking & (pixel == 4'b1101)) ? color13[7:0]:
					 (~is_blanking & (pixel == 4'b1110)) ? color14[7:0]:
					 (~is_blanking & (pixel == 4'b1111)) ? color15[7:0]:
					 8'b00000000;
					 
	// GUI settings
	
		parameter GUI_width = 160; // Width of the GUI
		
		// Weapon display settings
		
			// Weapon article image
			wire[3:0] weapon_art [0:107][0:28];
			
			// Parameters for weapon
			parameter weapon_art_hc = 25; // Horizontal coordinate of Up Left corner of the weapon article
			parameter weapon_art_vc = 350; // Vertical coordinate of Up Left corner of the weapon article
			parameter weapon_art_width = 108; // Width of weapon article
			parameter weapon_art_height = 29; // Height of weapon article
		
		// Score settings	
		
			// Score article image
			wire[3:0] score_art [0:114][0:28];
			
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

			wire[3:0] score_digit0;
			wire[3:0] score_digit1;
			wire[3:0] score_digit2;
			wire[3:0] score_digit3;
			wire[3:0] score_digit4;

			// Wires for displaying score image
			wire[3:0] score_img_digit0 [0:23][0:29];
			wire[3:0] score_img_digit1 [0:23][0:29];
			wire[3:0] score_img_digit2 [0:23][0:29];
			wire[3:0] score_img_digit3 [0:23][0:29];
			wire[3:0] score_img_digit4 [0:23][0:29];
			
			// Storing Number images
			wire[3:0] Number0 [0:23][0:29];
			wire[3:0] Number1 [0:23][0:29];
			wire[3:0] Number2 [0:23][0:29];
			wire[3:0] Number3 [0:23][0:29];
			wire[3:0] Number4 [0:23][0:29];
			wire[3:0] Number5 [0:23][0:29];
			wire[3:0] Number6 [0:23][0:29];
			wire[3:0] Number7 [0:23][0:29];
			wire[3:0] Number8 [0:23][0:29];
			wire[3:0] Number9 [0:23][0:29];
			
			// Assigning score images for each digits of the score
			assign score_img_digit0 = (score_digit0 == 4'd0) ? Number0:
											  (score_digit0 == 4'd1) ? Number1:
											  (score_digit0 == 4'd2) ? Number2:
											  (score_digit0 == 4'd3) ? Number3:
											  (score_digit0 == 4'd4) ? Number4:
											  (score_digit0 == 4'd5) ? Number5:
											  (score_digit0 == 4'd6) ? Number6:
											  (score_digit0 == 4'd7) ? Number7:
											  (score_digit0 == 4'd8) ? Number8:
											  Number9;
											  
			assign score_img_digit1 = (score_digit1 == 4'd0) ? Number0:
											  (score_digit1 == 4'd1) ? Number1:
											  (score_digit1 == 4'd2) ? Number2:
											  (score_digit1 == 4'd3) ? Number3:
											  (score_digit1 == 4'd4) ? Number4:
											  (score_digit1 == 4'd5) ? Number5:
											  (score_digit1 == 4'd6) ? Number6:
											  (score_digit1 == 4'd7) ? Number7:
											  (score_digit1 == 4'd8) ? Number8:
											  Number9;
			
			assign score_img_digit2 = (score_digit2 == 4'd0) ? Number0:
											  (score_digit2 == 4'd1) ? Number1:
											  (score_digit2 == 4'd2) ? Number2:
											  (score_digit2 == 4'd3) ? Number3:
											  (score_digit2 == 4'd4) ? Number4:
											  (score_digit2 == 4'd5) ? Number5:
											  (score_digit2 == 4'd6) ? Number6:
											  (score_digit2 == 4'd7) ? Number7:
											  (score_digit2 == 4'd8) ? Number8:
											  Number9;
			
			assign score_img_digit3 = (score_digit3 == 4'd0) ? Number0:
											  (score_digit3 == 4'd1) ? Number1:
											  (score_digit3 == 4'd2) ? Number2:
											  (score_digit3 == 4'd3) ? Number3:
											  (score_digit3 == 4'd4) ? Number4:
											  (score_digit3 == 4'd5) ? Number5:
											  (score_digit3 == 4'd6) ? Number6:
											  (score_digit3 == 4'd7) ? Number7:
											  (score_digit3 == 4'd8) ? Number8:
											  Number9;
			
			assign score_img_digit4 = (score_digit4 == 4'd0) ? Number0:
											  (score_digit4 == 4'd1) ? Number1:
											  (score_digit4 == 4'd2) ? Number2:
											  (score_digit4 == 4'd3) ? Number3:
											  (score_digit4 == 4'd4) ? Number4:
											  (score_digit4 == 4'd5) ? Number5:
											  (score_digit4 == 4'd6) ? Number6:
											  (score_digit4 == 4'd7) ? Number7:
											  (score_digit4 == 4'd8) ? Number8:
											  Number9;

	// Other settings
	
		parameter center_point_hc = GUI_width + 239;  // Horizontal coordinate of the center point of the game screen
		parameter center_point_vc = 239; // Vertical coordinate of the center point of the game screen
	
	// Spaceship settings

		parameter SS_hc = GUI_width + 215;
		parameter SS_vc = 215;
		parameter SS_height = 48;
		parameter SS_width = 48;
	
		reg[3:0] SS_state; // State of spaceship (i.e. the angle)
		
		// Storing Spaceship images for different angles

		wire [3:0] SS0[0:47][0:47]; // 270 degrees
		wire [3:0] SS1[0:47][0:47]; // 247.5 degrees
		wire [3:0] SS2[0:47][0:47]; // 225 degrees
		wire [3:0] SS3[0:47][0:47]; // 202.5 degrees
		wire [3:0] SS4[0:47][0:47]; // 180 degrees
		wire [3:0] SS5[0:47][0:47]; // 167.5 degrees
		wire [3:0] SS6[0:47][0:47]; // 135 degrees
		wire [3:0] SS7[0:47][0:47]; // 112.5 degrees
		wire [3:0] SS8[0:47][0:47]; // 90 degrees
		wire [3:0] SS9[0:47][0:47]; // 67.5 degrees
		wire [3:0] SS10[0:47][0:47]; // 45 degrees
		wire [3:0] SS11[0:47][0:47]; // 22.5 degrees
		wire [3:0] SS12[0:47][0:47]; // 0 degrees
		wire [3:0] SS13[0:47][0:47]; // 337.5 degrees
		wire [3:0] SS14[0:47][0:47]; // 315 degrees
		wire [3:0] SS15[0:47][0:47]; // 292.5 degrees
		
		wire [3:0] SS_current[0:47][0:47]; // Current spaceship image to be displayed via VGA
		
		// Assignment for current image for spaceship
		assign SS_current = (SS_state == 4'b0000) ? SS12 :
								  (SS_state == 4'b0001) ? SS11 :
								  (SS_state == 4'b0010) ? SS10 :
								  (SS_state == 4'b0011) ? SS9 :
								  (SS_state == 4'b0100) ? SS8 :
								  (SS_state == 4'b0101) ? SS7 :
								  (SS_state == 4'b0110) ? SS6 :
								  (SS_state == 4'b0111) ? SS5 :
								  (SS_state == 4'b1000) ? SS4 :
								  (SS_state == 4'b1001) ? SS3 :
								  (SS_state == 4'b1010) ? SS2 :
								  (SS_state == 4'b1011) ? SS1 :
								  (SS_state == 4'b1100) ? SS0 :
								  (SS_state == 4'b1101) ? SS15 :
								  (SS_state == 4'b1110) ? SS14 :
								  SS13;
								  
// Creating all needed blocks

	// Arranging the GUI images
	GUI_init(.Number0(Number0),.Number1(Number1),.Number2(Number2),.Number3(Number3),.Number4(Number4),.Number5(Number5),.Number6(Number6),.Number7(Number7),.Number8(Number8),.Number9(Number9),.S_A(score_art),.W_A(weapon_art));

	// Arranging the spaceship images
	Spaceship_init(.SS0(SS0),.SS1(SS1),.SS2(SS2),.SS3(SS3),.SS4(SS4),.SS5(SS5),.SS6(SS6),.SS7(SS7),.SS8(SS8),.SS9(SS9),.SS10(SS10),.SS11(SS11),.SS12(SS12),.SS13(SS13),.SS14(SS14),.SS15(SS15));

	VGA_init(.CLK(CLK),.RESET(RESET),.hsync(hsync),.vsync(vsync),.hc(hc),.vc(vc),.is_blanking(is_blanking));

	Score_init(.score(score),.digit0(score_digit0),.digit1(score_digit1),.digit2(score_digit2),.digit3(score_digit3),.digit4(score_digit4));

// Always block to find the color information of the current location
always @(posedge CLK) begin
	
//	// If we are not in blanking state
//	if (~is_blanking) begin
//
//		// Check whether we are in the pixels of GUI
//		if (hc <= GUI_width) begin 
//		
//			// Check the pixel is in Score article image
//			if ((hc >= score_art_hc) & (vc >= score_art_vc) & (hc <= score_art_hc + score_art_width) & (vc <= score_art_vc + score_art_height)) pixel = score_art[hc - score_art_hc][vc - score_art_vc];
//			
//			// Check the pixel is in Score image
//			else if ((hc >= score_hc) & (vc >= score_vc) & (hc <= score_hc + score_width*5) & (vc <= score_vc + score_height)) begin
//				if (hc <= score_hc + score_width) pixel = score_img_digit4[hc - score_hc][vc - score_vc]; // Fourth digit
//				else if (hc <= score_hc + score_width*2) pixel = score_img_digit3[hc - score_hc - score_width][vc - score_vc]; // Third digit
//				else if (hc <= score_hc + score_width*3) pixel = score_img_digit2[hc - score_hc - score_width*2][vc - score_vc]; // Second digit
//				else if (hc <= score_hc + score_width*4) pixel = score_img_digit1[hc - score_hc - score_width*3][vc - score_vc]; // First digit
//				else pixel = score_img_digit0[hc - score_hc - score_width*4][vc - score_vc]; // Zeroth digit
//			end
//			
//			// Check the pixel is in Weapon article image
//			else if ((hc >= weapon_art_hc) & (vc >= weapon_art_vc) & (hc <= weapon_art_hc + weapon_art_width) & (vc <= weapon_art_vc + weapon_art_height)) pixel = weapon_art[hc - weapon_art_hc][vc - weapon_art_vc];
//		
//			else pixel = 4'b1111;
//		
//		end
//		
//		// Check whether we are in the pixels of the spaceship
//		else if ((hc >= SS_hc) & (vc >= SS_vc) & (hc <= SS_hc + SS_width) & (vc <= SS_vc + SS_height)) pixel = SS_current[hc - SS_hc][vc - SS_vc];
//		
//	else pixel = 4'b0000;
//		
//	end	

	// If we are not in blanking state
	if (~is_blanking) begin
	
		// Check whether we are in the pixels of GUI
		if (hc <= GUI_width) begin 
		
		end
		
		else begin
		pixel = pixel_finder();
		end 
	
	end
end

// Always block for updating the state of spaceship
always @(posedge ~Rotate_CCW or posedge ~Rotate_CW) begin
	if (~Rotate_CCW) SS_state = SS_state + 4'b0001;
	if (~Rotate_CW) SS_state = SS_state - 4'b0001;
end




reg [6:0] enemies_dist[7:0];
reg [3:0] enemies_angle[7:0];
reg [3:0] enemies_health[7:0];
reg [2:0] enemies_type[7:0];
reg enemies_active[7:0];

reg [6:0] bullets_dist[15:0];
reg [3:0] bullets_angle[15:0];
reg [1:0] bullets_type[15:0];
reg bullets_active[15:0];



reg temp;

function [11:0] change_cor(input [5:0] _dist, input [3:0] _angle);
begin
	// cos0 = 1, sin0 = 0
	// cos45 = sin45 = 45/64
	// cos22.5 = 59/64, sin22.5 = 24/64
	// Pozitif y aşağı
	// Pozitif x sağ
	case(_angle)
		4'd0,4'd4,4'd8,4'd12: begin
			change_cor[5:0] = (_angle == 4'd4) ? -_dist:
				(_angle == 4'd12) ? _dist: 0;
			change_cor[11:6] = (_angle == 4'd0) ? _dist:
				(_angle == 4'd8) ? -_dist: 0;
		end
		4'd2,4'd6,4'd10,4'd14: begin
			reg [11:0] temp1 = 12'd45 * _dist;
			change_cor[5:0] = (_angle == 4'd2 || _angle == 4'd6) ? -temp1[11:6]: temp1[11:6];
			change_cor[11:6] = (_angle == 4'd2 || _angle == 4'd14) ? temp1[11:6]: -temp1[11:6];	
		end
		default: begin
			reg [11:0] temp1 = 12'd59 * _dist;
			reg [11:0] temp2 = 12'd24 * _dist;
			change_cor[5:0] = (_angle == 4'd1 || _angle == 4'd7) ? -temp2[11:6]:
				(_angle == 4'd9 || _angle == 4'd15) ? temp2[11:6]:
				(_angle == 4'd3 || _angle == 4'd5) ? -temp1[11:6]:
				temp1[11:6];
			change_cor[11:6] = (_angle == 4'd1 || _angle == 4'd15) ? temp1[11:6]:
				(_angle == 4'd7 || _angle == 4'd9) ? -temp1[11:6]:
				(_angle == 4'd3 || _angle == 4'd13) ? temp2[11:6]:
				-temp2[11:6];
		end
	endcase
end
endfunction

function enemy_init(input [2:0] e_type);
begin
	reg [3:0] i;
	reg stop = 1'b0;
	for(i = 4'd0; i < 4'd7 && ~stop; i = i + 4'd1)
	if(~enemies_active[i]) begin
		stop = 1'b1;
		enemies_dist[i] = 7'd127; // Başlangıçta en uzak değer yaptım
		enemies_angle[i] = $random;
		enemies_health[i] = (e_type == 0) ? 4'd6:
								  (e_type == 0) ? 4'd3:
								  (e_type == 0) ? 4'd2:
								  (e_type == 0) ? 4'd9:
									4'd15; 
	end
end
endfunction


function enemy_move(input [2:0] i);
enemies_dist[i] = (enemies_type[i] == 3'd0) ? enemies_dist[i] - 7'd3 :
						(enemies_type[i] == 3'd1) ? enemies_dist[i] - 7'd4 :
						(enemies_type[i] == 3'd2) ? enemies_dist[i] - 7'd5 :
						(enemies_type[i] == 3'd3) ? enemies_dist[i] - 7'd2 :
						enemies_dist[i] - 7'd1;
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

function bullet_init(input [1:0] w_type, input [3:0] angle);
begin
	reg [4:0] i;
	reg [2:0] stop = 3'd0;
	reg [2:0] counter;
	for(i = 5'd0; i < 5'd15; i = i + 5'd1) begin
	if(~bullets_active[i]) counter = counter + 3'b1;
	end
	
	// Five Shot
	if ((w_type == 2'd0) && (counter >= 3'd5)) begin
		
		for(i = 5'd0; i < 5'd15 && (stop < 3'd5); i = i + 5'd1)
			if(~bullets_active[i]) begin
					bullets_dist[i] = 7'd0; 
					bullets_angle[i] = angle - 4'd2 + stop;
					bullets_active[i] = 1'b1;	
					stop = stop + 3'd1;
			end
	end	
	// Triple Shot
	else if ((w_type == 2'd1) && (counter >= 3'd3)) begin
		
		for(i = 5'd0; i < 5'd15 && (stop < 3'd3); i = i + 5'd1)
			if(~bullets_active[i]) begin
					bullets_dist[i] = 7'd0; 
					bullets_angle[i] = angle - 4'd1 + stop;
					bullets_active[i] = 1'b1;	
					stop = stop + 3'd1;
			end
	end
	// Single Shot
	else if (counter >= 3'd1) begin
		for(i = 5'd0; i < 5'd15 && (stop < 3'd1); i = i + 5'd1)
			if(~bullets_active[i]) begin
					bullets_dist[i] = 7'd0; 
					bullets_angle[i] = angle;
					bullets_active[i] = 1'b1;	
					stop = stop + 3'd1;
			end
	end
end
endfunction

function bullet_move(input [3:0] i);
bullets_dist[i] = (bullets_type[i] == 2'b0) ? bullets_dist[i] + 7'd7 :
						(bullets_type[i] == 2'b1) ? bullets_dist[i] + 7'd5 :
						 bullets_dist[i] + 7'd4;
endfunction

function bullets_action();
begin
	reg [4:0] i;
	for(i = 5'd0; i < 5'd15; i = i + 5'd1)
	if(bullets_active[i]) begin
		temp = bullet_move(i);
		temp = check_col(i);
	end
end
endfunction

function check_col(input [3:0] i);
begin 
	reg [3:0] damage_dealt;
	reg [3:0] j;
	reg stop = 1'b0;
	for(j = 4'd0; j < 4'd7 && ~stop; j = j + 4'd1)
	if(enemies_active[j] && enemies_dist[j] <= bullets_dist[i]) begin
		bullets_active[i] = 1'b0;
		damage_dealt = (bullets_type[i] == 2'b0) ? 4'd2 :
							(bullets_type[i] == 2'b1) ? 4'd3 :
							 4'd9;
		if (enemies_health[j] <= damage_dealt) begin 
		score = (enemies_type[j] == 3'd0) ? score + 18'd6 :
				  (enemies_type[j] == 3'd1) ? score + 18'd3 :
				  (enemies_type[j] == 3'd2) ? score + 18'd2 :
				  (enemies_type[j] == 3'd3) ? score + 18'd9 :
				  score + 18'd15;
		
		enemies_active[j] = 1'd0;
		
		end
		else enemies_health[j] = enemies_health[j] - damage_dealt;
	end
end
endfunction

function [3:0] pixel_finder;
begin

//	pixel_finder = 4'd0;
	reg [4:0] i;
	reg [5:0] x;
	reg [5:0] y;
	reg [11:0] temp3;
		
	// For bullets
	for (i = 5'd0; i < 5'd15; i = i + 5'd1)
		temp3 = change_cor(bullets_dist[i],bullets_angle[i]);
		x = temp3[11:6];
		y = temp3[5:0];
		
		if ((hc >= (x + center_point_hc - 16) ) & (hc <= (x + center_point_hc + 16) ) & (vc >= (y + center_point_vc - 16) ) & (vc <= (y + center_point_vc + 16) )) begin
			pixel_finder = Bullet_img((hc - x - center_point_hc + 16) , (vc - y - center_point_vc + 16), bullets_angle[i], bullets_type[i]);
		end
	// For enemies
	for (i = 5'd0; i < 5'd7; i = i + 5'd1)
		temp3 = change_cor(enemies_dist[i],enemies_angle[i]);
		x = temp3[11:6];
		y = temp3[5:0];
		if (enemies_type[i] == 3'd3 | enemies_type[i] == 3'd4) begin
			if ((hc >= x + center_point_hc - 64 ) & (hc <= x + center_point_hc + 64 ) & (vc >= y + center_point_vc - 64 ) & (vc <= y + center_point_vc + 64 )) begin
				pixel_finder = Enemy_img((hc - x - center_point_hc + 64) , (vc - y - center_point_vc + 64), enemies_angle[i], enemies_type[i]);
				end
		end
		else begin
			if ((hc >= x + center_point_hc - 32 ) & (hc <= x + center_point_hc + 32 ) & (vc >= y + center_point_vc - 32 ) & (vc <= y + center_point_vc + 32 )) begin
				pixel_finder = Enemy_img((hc - x - center_point_hc + 32) , (vc - y - center_point_vc + 32), enemies_angle[i], enemies_type[i]);
				end
		end
	// For Spaceship
	
	if ((hc >= SS_hc) & (vc >= SS_vc) & (hc <= SS_hc + SS_width) & (vc <= SS_vc + SS_height)) begin
		pixel_finder = Spaceship_img((hc - SS_hc),(vc - SS_vc),SS_state);
	end 
end
endfunction

function [3:0] Spaceship_img(input [9:0] x, input [9:0] y, input [3:0] angle);
begin
// Eklenecek
end
endfunction

function [3:0] Enemy_img(input [9:0] x, input [9:0] y, input [3:0] angle, input [2:0] _type);
begin
// Eklenecek
end
endfunction

function [3:0] Bullet_img(input [9:0] x, input [9:0] y, input [3:0] angle, input [1:0] _type);
begin
// Eklenecek
end
endfunction
endmodule
