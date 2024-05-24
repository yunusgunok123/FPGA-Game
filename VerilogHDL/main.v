module main(
    input wire CLK,             // 25.175 MHz clock
    input wire RESET,           // Reset signal
    input wire Weapon_switch, 	// To switch the current weapon (Button3)
    input wire Rotate_CW, 	// To rotate 22.5 degrees in clockwise direction (Button2)
    input wire Rotate_CCW, 	// To rotate 22.5 degrees in counter-clockwise direction (Button1)
    input wire Interaction,	// Used as an interaction button for "Try again", "OKAY" (Button4)
    output wire hsync,           // Horizontal sync output
    output wire vsync,           // Vertical sync output
    output wire[7:0] red,	// Pixel color information about red color
    output wire[7:0] green,	// Pixel color information about green color
    output wire[7:0] blue	// Pixel color information about blue color
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
		
		// Score settings	
			
			// Parameters for score
			
			parameter score_art_hc = 0; // Horizontal coordinate of Up Left corner of the score article
			parameter score_art_vc = 0; // Vertical coordinate of Up Left corner of the score article
			parameter score_art_width = 0; // Width of score article
			parameter score_art_height = 0; // Height of score article
			
			parameter score_hc = 0;  // Horizontal coordinate of Up Left corner of the score
			parameter score_vc = 0; // Vertical coordinate of Up Left corner of the score
			parameter score_width = 0; // Width of each digit of score
			parameter score_height = 0; // Height of score
			
			// Score registers
			reg[17:0] score;

			wire[3:0] score_digit0;
			wire[3:0] score_digit1;
			wire[3:0] score_digit2;
			wire[3:0] score_digit3;
			wire[3:0] score_digit4;

			// Storing Number images
			wire[3:0] Number0 [0:22][0:28];
			wire[3:0] Number1 [0:22][0:28];
			wire[3:0] Number2 [0:22][0:28];
			wire[3:0] Number3 [0:22][0:28];
			wire[3:0] Number4 [0:22][0:28];
			wire[3:0] Number5 [0:22][0:28];
			wire[3:0] Number6 [0:22][0:28];
			wire[3:0] Number7 [0:22][0:28];
			wire[3:0] Number8 [0:22][0:28];
			wire[3:0] Number9 [0:22][0:28];

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

	// Arranging the number images
	Numbers_init(.Number0(Number0),.Number1(Number1),.Number2(Number2),.Number3(Number3),.Number4(Number4),.Number5(Number5),.Number6(Number6),.Number7(Number7),.Number8(Number8),.Number9(Number9));

	// Arranging the spaceship images
	SpaceShip_init(.SS0(SS0),.SS1(SS1),.SS2(SS2),.SS3(SS3),.SS4(SS4),.SS5(SS5),.SS6(SS6),.SS7(SS7),.SS8(SS8),.SS9(SS9),.SS10(SS10),.SS11(SS11),.SS12(SS12),.SS13(SS13),.SS14(SS14),.SS15(SS15));

	VGA_initializer(.CLK(CLK),.RESET(RESET),.hsync(hsync),.vsync(vsync),.hc(hc),.vc(vc),.is_blanking(is_blanking));

	Score_display(.score(score),.digit0(score_digit0),.digit1(score_digit1),.digit2(score_digit2),.digit3(score_digit3),.digit4(score_digit4));

// Always block to find the color information of the current location
always @(posedge CLK) begin
	
	// If we are not in blanking state
	if (~is_blanking) begin

		// Check whether we are in the pixels of GUI
		if (hc <= GUI_width) pixel = 4'b1111;
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
