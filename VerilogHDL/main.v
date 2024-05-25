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
			reg[17:0] score;

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
	
	// If we are not in blanking state
	if (~is_blanking) begin

		// Check whether we are in the pixels of GUI
		if (hc <= GUI_width) begin 
		
			// Check the pixel is in Score article image
			if ((hc >= score_art_hc) & (vc >= score_art_vc) & (hc <= score_art_hc + score_art_width) & (vc <= score_art_vc + score_art_height)) pixel = score_art[hc - score_art_hc][vc - score_art_vc];
			
			// Check the pixel is in Score image
			else if ((hc >= score_hc) & (vc >= score_vc) & (hc <= score_hc + score_width*5) & (vc <= score_vc + score_height)) begin
				if (hc <= score_hc + score_width) pixel = score_img_digit4[hc - score_hc][vc - score_vc]; // Fourth digit
				else if (hc <= score_hc + score_width*2) pixel = score_img_digit3[hc - score_hc - score_width][vc - score_vc]; // Third digit
				else if (hc <= score_hc + score_width*3) pixel = score_img_digit2[hc - score_hc - score_width*2][vc - score_vc]; // Second digit
				else if (hc <= score_hc + score_width*4) pixel = score_img_digit1[hc - score_hc - score_width*3][vc - score_vc]; // First digit
				else pixel = score_img_digit0[hc - score_hc - score_width*4][vc - score_vc]; // Zeroth digit
			end
			
			// Check the pixel is in Weapon article image
			else if ((hc >= weapon_art_hc) & (vc >= weapon_art_vc) & (hc <= weapon_art_hc + weapon_art_width) & (vc <= weapon_art_vc + weapon_art_height)) pixel = weapon_art[hc - weapon_art_hc][vc - weapon_art_vc];
		
			else pixel = 4'b1111;
		
		end
		
		// Check whether we are in the pixels of the spaceship
		else if ((hc >= SS_hc) & (vc >= SS_vc) & (hc <= SS_hc + SS_width) & (vc <= SS_vc + SS_height)) pixel = SS_current[hc - SS_hc][vc - SS_vc];
		
	else pixel = 4'b0000;
		
	end	
end

// Always block for updating the state of spaceship
always @(posedge ~Rotate_CCW or posedge ~Rotate_CW) begin
	if (~Rotate_CCW) SS_state = SS_state + 4'b0001;
	if (~Rotate_CW) SS_state = SS_state - 4'b0001;
end


endmodule