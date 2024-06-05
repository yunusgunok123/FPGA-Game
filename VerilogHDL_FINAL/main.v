module main(
input wire CLK,             	// 25.175 MHz clock
input wire Weapon_switch, 		// To switch the current weapon (KEY3)
input wire Fire, 		// Fire button (Button4)
input wire Rotate_CW, 			// To rotate 22.5 degrees in clockwise direction (KEY0)
input wire Rotate_CCW, 			// To rotate 22.5 degrees in counter-clockwise direction (KEY1) 
input wire Pause,					// Pause the game
input wire Interaction,			// It start the game when we are in initial state, it resart
output wire hsync,            // Horizontal sync output
output wire vsync,            // Vertical sync output
output wire[7:0] red,		   // Pixel color information about red color
output wire[7:0] green,		   // Pixel color information about green color
output wire[7:0] blue,		   // Pixel color information about blue color
output wire[6:0] HEX0,			// 7 Segment display for first digit of level
output wire[6:0] HEX1,			// 7 Segment display for second digit of level
output wire[6:0] HEX4,			// 7 Segment display for "V" letter
output wire[6:0] HEX5,			// 7 Segment display for "L" letter
output reg level_up				// It pops up when there is a level change, and it also turn on and off all the leds in the FPGA when a level change occurs
);


wire[9:0] hc;
wire[9:0] vc;
wire is_blanking;
reg start;

// Used to change the state of the game from "start" and "game_over" to playing 
reg try_again;

// Store the information about current level we are in
reg [4:0] current_level;

// Counter to increment the current level (Every 20 sec a level up)
reg [8:0] level_counter;

// Number of enemies in the current level
reg [3:0] number_of_enemies;

// Number of different enemy types in the current level
reg [2:0] number_of_enemy_type;

// Speed boost for enemies in the current level
reg [1:0] extra_speed_of_enemies;

// Arrange the 7 Segment display for the current level
Level_typer lvl_inst(.current_level(current_level),.HEX0(HEX0),.HEX1(HEX1),.HEX4(HEX4),.HEX5(HEX5),.on(~start),.CLK(CLK_5Hz));

// Reset the level when we start or restart the game
reg level_reset;

// Each level up it basically updates the difficulty
always @(posedge level_up) begin 
	 // Reset the current level
	 if (level_reset) current_level = 5'd0;
	 // Maximum level kept at 30
	 if (current_level == 5'd30) current_level = 5'd29;
	 current_level = current_level +5'd1;
	 case(current_level)
	 5'd1 : begin
		number_of_enemies = 4'd2;
		number_of_enemy_type = 3'd1;
		extra_speed_of_enemies = 2'd0;
	 end
	 5'd2 : begin
		number_of_enemy_type = 3'd2; 
	 end
	 5'd3 : begin
		number_of_enemies = 4'd3;
	 end
	 5'd4 : begin
		number_of_enemy_type = 3'd3;
	 end
	 5'd5 : begin
		number_of_enemies = 4'd4;
	 end
	 5'd6 : begin
		extra_speed_of_enemies = 2'd1;
	 end
	 5'd8 : begin
		number_of_enemies = 4'd5;
	 end
	 5'd9 : begin
		number_of_enemy_type = 3'd4;
	 end
	 5'd12 : begin
		number_of_enemies = 3'd6;
	 end
	 5'd15 : begin
		extra_speed_of_enemies = 2'd2;
	 end
	 5'd20 : begin
		extra_speed_of_enemies = 2'd3;
	 end
	 endcase
	 
end

// Represent the game over state
reg game_over;

// Initialize VGA
VGA_init(.CLK(CLK),.RESET(RESET),.hsync(hsync),.vsync(vsync),.hc(hc),.vc(vc),.is_blanking(is_blanking));

// 5 Hz clock
wire CLK_5Hz; 

// Divide the clock to obtain 5Hz clock
CLK_divider(.CLK(CLK),.CLK_divided(CLK_5Hz));

// Color information in the selected color palette
localparam [23:0] color0  = {8'd000, 8'd000, 8'd000};
localparam [23:0] color1  = {8'd093, 8'd038, 8'd093};
localparam [23:0] color2  = {8'd178, 8'd062, 8'd083};
localparam [23:0] color3  = {8'd239, 8'd125, 8'd088};
localparam [23:0] color4  = {8'd255, 8'd205, 8'd118};
localparam [23:0] color5  = {8'd168, 8'd240, 8'd112};
localparam [23:0] color6  = {8'd054, 8'd184, 8'd101};
localparam [23:0] color7  = {8'd036, 8'd113, 8'd121};
localparam [23:0] color8  = {8'd042, 8'd054, 8'd112};
localparam [23:0] color9  = {8'd059, 8'd093, 8'd201};
localparam [23:0] color10 = {8'd065, 8'd166, 8'd246};
localparam [23:0] color11 = {8'd115, 8'd239, 8'd247};
localparam [23:0] color12 = {8'd244, 8'd244, 8'd244};
localparam [23:0] color13 = {8'd149, 8'd176, 8'd195};
localparam [23:0] color14 = {8'd086, 8'd107, 8'd134};
localparam [23:0] color15 = {8'd050, 8'd060, 8'd087};

// Current pixel color information to be displayed in VGA
reg[3:0] pixel;

// Arrange the 8-bit data for red color
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

// Arrange the 8-bit data for green color
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

// Arrange the 8-bit data for blue color
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
wire [3:0] score_digits [4:0];

// Update each digit whenever score changes
Score_init(.score(score),.digits(score_digits));

// Parameters for score		
localparam score_art_hc1 = 35; // Horizontal coordinate of Up Left corner of the score article
localparam score_art_vc1 = 69; // Vertical coordinate of Up Left corner of the score article

localparam score_art_hc2 = 275; // Horizontal coordinate of Up Left corner of the score article in game over state
localparam score_art_vc2 = 239; // Vertical coordinate of Up Left corner of the score article in game over state

wire [9:0] score_art_hc = (game_over) ? score_art_hc2 : score_art_hc1;
wire [9:0] score_art_vc = (game_over) ? score_art_vc2 : score_art_vc1;

localparam score_art_width = 88; // Width of score article
localparam score_art_height = 20; // Height of score article
		
localparam score_hc1 = 31;  // Horizontal coordinate of Up Left corner of the score
localparam score_vc1 = 109; // Vertical coordinate of Up Left corner of the score

localparam score_hc2 = 271;  // Horizontal coordinate of Up Left corner of the score in game over state
localparam score_vc2 = 269; // Vertical coordinate of Up Left corner of the score in game over state

wire [9:0] score_hc = (game_over) ? score_hc2 : score_hc1;
wire [9:0] score_vc = (game_over) ? score_vc2 : score_vc1;

localparam score_width = 16; // Width of each digit of score
localparam score_height = 20; // Height of score
localparam score_space = 4; // Width of score space
	
localparam GUI_width = 160; // Width of the GUI

// Parameters for health
localparam heart_hc = 35; // Horizontal coordinate of Up Left corner of the weapon article
localparam heart_vc = 300; // Vertical coordinate of Up Left corner of the weapon article
localparam heart_width = 26; // Width of weapon article
localparam heart_height = 24; // Height of weapon article
localparam heart_space = 5; // Width of score space

// Represent the current lives of the player
reg [1:0] current_heart;
// Store the info if the pixel is inside of heart image to be given in "Heart" module
wire is_heart_in_pixel [2:0];
// Horizontal coordinate of heart image to be given in "Heart" module
wire [9:0] heart_x [2:0];


assign is_heart_in_pixel[0] = (hc >= heart_hc && hc < heart_hc + heart_width && vc >= heart_vc && vc < heart_vc + heart_height) & (current_heart > 2'd2); 
assign is_heart_in_pixel[1] = (hc >= heart_hc + heart_width + heart_space  && hc < heart_hc + heart_width*2 + heart_space  && vc >= heart_vc && vc < heart_vc + heart_height) & (current_heart > 2'd1); 
assign is_heart_in_pixel[2] = (hc >= heart_hc + heart_width*2 + heart_space*2  && hc < heart_hc + heart_width*3 + heart_space*2 && vc < heart_vc + heart_height && vc >= heart_vc) & (current_heart > 2'd0);

assign heart_x [0] = hc - (heart_hc);
assign heart_x [1] = hc - (heart_hc + heart_width + heart_space);
assign heart_x [2] = hc - (heart_hc + heart_width*2 + heart_space*2);

// Heart module to find the pixel color info if the pixel coordinate is in the heart image
Heart heart_inst(
    .is_in_pixel(is_heart_in_pixel),
    .hc(heart_x),
    .vc(vc - heart_vc),
    .CLK(CLK),
    .pixel(h_pixel)
);     
						 

// Score register and wires
reg[16:0] score;
	
// Spaceship settings
localparam SS_hc = GUI_width + 221;
localparam SS_vc = 221;
localparam SS_size = 36;

// Store the info if the pixel is inside of spaceship image to be given in "Spaceship" module
wire is_SS_in_pixel = (hc >= SS_hc && hc < SS_hc + SS_size && vc >= SS_vc && vc < SS_vc + SS_size);

// Spaceship module to find the pixel color info if the pixel coordinate is in the spaceship image
Spaceship ss_inst (
    .is_SS_in_pixel(is_SS_in_pixel),
    .SS_angle(SS_angle),
    .SS_hc(hc-SS_hc),
    .SS_vc(vc-SS_vc),
    .CLK(CLK),
    .pixel(ss_pixel)
);

// Parameters for ee logo
localparam ee_hc = 100; // Horizontal coordinate of Up Left corner of ee logo
localparam ee_vc = 250; // Vertical coordinate of Up Left corner of ee logo
localparam ee_width = 160; // Width of ee logo
localparam ee_height = 160; // Height of ee logo

// Store the info if the pixel is inside of ee logo image to be given in "EE_logo" module
wire is_ee_in_pixel = (hc >= ee_hc && hc < ee_hc + ee_width && vc >= ee_vc && vc < ee_vc  + ee_height);

// EE_logo module to find the pixel color info if the pixel coordinate is in the ee logo image
EE_logo(
	.is_in_pixel(is_ee_in_pixel),
	.hc(hc-ee_hc),
	.vc(vc-ee_vc),
	.CLK(CLK),
	.pixel(ee_pixel) 
);

// Parameters for heading (Name of the game)
localparam head_hc = 107; // Horizontal coordinate of Up Left corner of heading
localparam head_vc = 100; // Vertical coordinate of Up Left corner of heading
localparam head_width = 424; // Width of heading
localparam head_height = 96; // Height of heading

// Store the info if the pixel is inside of heading image to be given in "Heading" module
wire is_head_in_pixel = (hc >= head_hc && hc < head_hc + head_width && vc >= head_vc && vc < head_vc  + head_height);

// Heading module to find the pixel color info if the pixel coordinate is in the heading image
Heading(
	.is_in_pixel(is_head_in_pixel),
	.hc(hc-head_hc),
	.vc(vc-head_vc),
	.CLK(CLK),
	.pixel(head_pixel) 
);

// Parameters for play button
localparam play_hc = 400; // Horizontal coordinate of Up Left corner of play button
localparam play_vc = 300; // Vertical coordinate of Up Left corner of play button
localparam play_width = 160; // Width of play button
localparam play_height = 56; // Height of play button

// Store the info if the pixel is inside of play button image to be given in "Play" module
wire is_play_in_pixel = (hc >= play_hc && hc < play_hc + play_width && vc >= play_vc && vc < play_vc  + play_height);

// Play module to find the pixel color info if the pixel coordinate is in the play button image
Play(
	.is_in_pixel(is_play_in_pixel),
	.hc(hc-play_hc),
	.vc(vc-play_vc),
	.CLK(CLK),
	.pixel(play_pixel) 
);

// Each register below is connected to a module and each module the pixel color for the corresponding element is determined
// If the current coordinate is not in the image of the element register is assigned to 0 value by module

wire [3:0] head_pixel; // Heading pixel
wire [3:0] ee_pixel; // EE logo pixel
wire [3:0] play_pixel; // Play button pixel

wire[3:0] e_pixel; // Enemies pixel
wire[3:0] b_pixel; // Bullets pixel
wire[3:0] ss_pixel; // Spaceship pixel
wire[3:0] bg_pixel; // Background pixel
wire[3:0] hb_pixel; // Health bar pixel

wire[3:0] n_pixel; // Numbers for score pixel
wire[3:0] s_a_pixel; // Score article pixel
wire[3:0] w_a_pixel; // Weapon article pixel
wire[3:0] w_img_pixel; // Weapon image pixel in gui
wire[3:0] h_pixel; // Heart pixel

// Pixel in "Start" phase
wire [3:0] pixel_start = (head_pixel != 4'd8) ? head_pixel:
								 (play_pixel != 4'd8) ? play_pixel:
								 (ee_pixel != 4'd8) ? ee_pixel:
								 4'd8;

// Left hand side pixel in "Playing" phase
wire [3:0] pixel_left = ((n_pixel | s_a_pixel | w_a_pixel | w_img_pixel | h_pixel ) == 4'd0) ? 4'd15 : (n_pixel | s_a_pixel | w_a_pixel | w_img_pixel | h_pixel );

// Pixel in "Game_over" phase
wire [3:0] pixel_go = (n_pixel | go_a_pixel | s_a_pixel);




// Right hand side pixel in "Playing" phase 
wire [3:0] pixel_right = (ss_pixel != 4'd0) ? ss_pixel:
								 (hb_pixel != 4'd0) ? hb_pixel:
								 (e_pixel != 4'd0) ? e_pixel:
								 (b_pixel != 4'd0) ? b_pixel:
								 (bg_pixel != 4'd0) ? bg_pixel:
								 4'd0;
// Here the priority is for spaceship pixel, if other image is at the same location with spaceship
// spaceship image will be displayed

// Enemy module to find the pixel color info if the pixel coordinate is in the enemy image
Enemy enemy_inst (
    .is_enemy_in_pixel(is_enemy_in_pixel),
	 .is_enemy_active(enemies_active),
    .enemy_angle(enemies_angle),
    .enemy_type(enemies_type),
    .enemy_hc(enemies_x),
    .enemy_vc(enemies_y),
    .CLK(CLK),
    .pixel(e_pixel)
);

// Bullet module to find the pixel color info if the pixel coordinate is in the bullet image
Bullet bullet_inst (
    .is_bullet_in_pixel(is_bullet_in_pixel),
	 .is_bullet_active(bullets_active),
    .bullet_angle(bullets_angle),
    .bullet_type(bullets_type),
    .bullet_hc(bullets_x),
    .bullet_vc(bullets_y),
    .CLK(CLK),
    .pixel(b_pixel)
);

// Background module to find the pixel color info if the pixel coordinate is in the background image
Background(
    .hc(hc-GUI_width),
    .vc(vc),
    .CLK(CLK),
    .pixel(bg_pixel)
);

// Registers for to be given as an input to "Number" module
wire [3:0] all_number_types[5:0];
wire [9:0] all_number_hcs[5:0];
wire [9:0] all_number_vcs[5:0];
wire is_number_in_pixel [4:0];

assign is_number_in_pixel[4] = (hc >= score_hc && hc < score_hc + score_width && vc >= score_vc && vc < score_vc + score_height);
assign is_number_in_pixel[3] = (hc >= score_hc + score_width + score_space && hc < score_hc + score_width*2 + score_space && vc >= score_vc && vc < score_vc + score_height);
assign is_number_in_pixel[2] = (hc >= score_hc + score_width*2 + score_space*2 && hc < score_hc + score_width*3 + score_space*2 && vc >= score_vc && vc < score_vc + score_height);
assign is_number_in_pixel[1] = (hc >= score_hc + score_width*3 + score_space*3 && hc < score_hc + score_width*4 + score_space*3 && vc >= score_vc && vc < score_vc + score_height);
assign is_number_in_pixel[0] = (hc >= score_hc + score_width*4 + score_space*4 && hc < score_hc + score_width*5 + score_space*4 && vc >= score_vc && vc < score_vc + score_height);

assign all_number_types[0] = score_digits[0];
assign all_number_types[1] = score_digits[1];
assign all_number_types[2] = score_digits[2];
assign all_number_types[3] = score_digits[3];
assign all_number_types[4] = score_digits[4];
assign all_number_types[5] = 4'd10;

assign all_number_hcs[4] = hc - score_hc;
assign all_number_hcs[3] = hc - score_hc - score_width - score_space;
assign all_number_hcs[2] = hc - score_hc - score_width * 2 - score_space * 2;
assign all_number_hcs[1] = hc - score_hc - score_width * 3 - score_space * 3;
assign all_number_hcs[0] = hc - score_hc - score_width * 4 - score_space * 4;
assign all_number_hcs[5] = 4'd0;

assign all_number_vcs[4] = vc - score_vc;
assign all_number_vcs[3] = vc - score_vc;
assign all_number_vcs[2] = vc - score_vc;
assign all_number_vcs[1] = vc - score_vc;
assign all_number_vcs[0] = vc - score_vc;
assign all_number_vcs[5] = 4'd0;

// Number module to find the pixel color info if the pixel coordinate is in the number image
Number num_inst(
    .is_number_in_pixel(is_number_in_pixel),
    .number_type(all_number_types),
    .number_hc(all_number_hcs),
    .number_vc(all_number_vcs),
    .CLK(CLK),
    .pixel(n_pixel)
);

// Score_Article module to find the pixel color info if the pixel coordinate is in the score_article image
Score_Article(
	.is_in_pixel(is_SA_in_pixel),
	.hc(hc-score_art_hc),
	.vc(vc-score_art_vc),
	.CLK(CLK),
	.pixel(s_a_pixel) 
);

// Parameters for weapon article
localparam weapon_art_hc = 19; // Horizontal coordinate of Up Left corner of the weapon article
localparam weapon_art_vc = 350; // Vertical coordinate of Up Left corner of the weapon article
localparam weapon_art_width = 120; // Width of weapon article
localparam weapon_art_height = 28; // Height of weapon article

wire is_WA_in_pixel = (hc >= weapon_art_hc && hc < weapon_art_hc + weapon_art_width && vc >= weapon_art_vc && vc < weapon_art_vc  + weapon_art_height);

Weapon_Article(
	.is_in_pixel(is_WA_in_pixel),
	.hc(hc-weapon_art_hc),
	.vc(vc-weapon_art_vc),
	.CLK(CLK),
	.pixel(w_a_pixel) 
);

// Parameters for weapon image in gui
localparam weapon_img_hc = 61; // Horizontal coordinate of Up Left corner of the weapon image 0
localparam weapon_img_vc = 400; // Vertical coordinate of Up Left corner of the weapon image 0
localparam weapon_img_width = 36; // Width of weapon image 0
localparam weapon_img_height = 36; // Height of weapon image 0

wire is_wep_img_in_pixel = (hc >= weapon_img_hc && hc < weapon_img_hc + weapon_img_width && vc >= weapon_img_vc && vc < weapon_img_vc  + weapon_img_height);

Weapon_img(
	.is_wep_img_in_pixel(is_wep_img_in_pixel),
	.wep_type(current_weapon),
	.wep_hc(hc-weapon_img_hc),
	.wep_vc(vc-weapon_img_vc),
	.CLK(CLK),
	.pixel(w_img_pixel) 
);

// Parameters for game over screen	
localparam go_art_hc = 151; // Horizontal coordinate of Up Left corner of the game over article
localparam go_art_vc = 179; // Vertical coordinate of Up Left corner of the game over article
localparam go_art_width = 336; // Width of game over article
localparam go_art_height = 40; // Height of game over article

wire [3:0] go_a_pixel;

wire is_go_art_in_pixel = (hc >= go_art_hc && hc < go_art_hc + go_art_width && vc >= go_art_vc && vc < go_art_vc  + go_art_height);

Game_Over_Article(
	.is_in_pixel(is_go_art_in_pixel),
	.hc(hc-go_art_hc),
	.vc(vc-go_art_vc),
	.CLK(CLK),
	.pixel(go_a_pixel) 
);

wire [3:0] hb_1_pixel;
wire [3:0] hb_2_pixel;
wire [3:0] hb_3_pixel;
wire [3:0] hb_4_pixel;
wire [3:0] hb_5_pixel;
wire [3:0] hb_6_pixel;

assign hb_pixel = (hb_1_pixel != 4'd0) ? hb_1_pixel:
						(hb_2_pixel != 4'd0) ? hb_2_pixel:
						(hb_3_pixel != 4'd0) ? hb_3_pixel:
						(hb_4_pixel != 4'd0) ? hb_4_pixel:
						(hb_5_pixel != 4'd0) ? hb_5_pixel:
						(hb_6_pixel != 4'd0) ? hb_6_pixel:
						4'd0;

// Health bar pixel arrangers
Health_bar h1(.x(enemies_x[0]), .y(enemies_y[0]), .CLK(CLK), .is_enemy_in_pixel(is_enemy_in_pixel[0]), .enemy_type(enemies_type[0]), .enemy_health(enemies_health[0]), .pixel(hb_1_pixel),.enemy_active(enemies_active[0]));
Health_bar h2(.x(enemies_x[1]), .y(enemies_y[1]), .CLK(CLK), .is_enemy_in_pixel(is_enemy_in_pixel[1]), .enemy_type(enemies_type[1]), .enemy_health(enemies_health[1]), .pixel(hb_2_pixel),.enemy_active(enemies_active[1]));
Health_bar h3(.x(enemies_x[2]), .y(enemies_y[2]), .CLK(CLK), .is_enemy_in_pixel(is_enemy_in_pixel[2]), .enemy_type(enemies_type[2]), .enemy_health(enemies_health[2]), .pixel(hb_3_pixel),.enemy_active(enemies_active[2]));
Health_bar h4(.x(enemies_x[3]), .y(enemies_y[3]), .CLK(CLK), .is_enemy_in_pixel(is_enemy_in_pixel[3]), .enemy_type(enemies_type[3]), .enemy_health(enemies_health[3]), .pixel(hb_4_pixel),.enemy_active(enemies_active[3]));
Health_bar h5(.x(enemies_x[4]), .y(enemies_y[4]), .CLK(CLK), .is_enemy_in_pixel(is_enemy_in_pixel[4]), .enemy_type(enemies_type[4]), .enemy_health(enemies_health[4]), .pixel(hb_5_pixel),.enemy_active(enemies_active[4]));
Health_bar h6(.x(enemies_x[5]), .y(enemies_y[5]), .CLK(CLK), .is_enemy_in_pixel(is_enemy_in_pixel[5]), .enemy_type(enemies_type[5]), .enemy_health(enemies_health[5]), .pixel(hb_6_pixel),.enemy_active(enemies_active[5]));

// For enemies finds the corresponding horizontal and vertical values with given distance, and also calculate in the pixel is in enemy image
Find_coordinates e1(.hc(hc),.vc(vc),.distance(enemies_dist[0]),.angle(enemies_angle[0]),.CLK(CLK_5Hz),.entity_x(enemies_x[0]),.entity_y(enemies_y[0]),.is_entity_in_pixel(is_enemy_in_pixel[0]));
Find_coordinates e2(.hc(hc),.vc(vc),.distance(enemies_dist[1]),.angle(enemies_angle[1]),.CLK(CLK_5Hz),.entity_x(enemies_x[1]),.entity_y(enemies_y[1]),.is_entity_in_pixel(is_enemy_in_pixel[1]));
Find_coordinates e3(.hc(hc),.vc(vc),.distance(enemies_dist[2]),.angle(enemies_angle[2]),.CLK(CLK_5Hz),.entity_x(enemies_x[2]),.entity_y(enemies_y[2]),.is_entity_in_pixel(is_enemy_in_pixel[2]));
Find_coordinates e4(.hc(hc),.vc(vc),.distance(enemies_dist[3]),.angle(enemies_angle[3]),.CLK(CLK_5Hz),.entity_x(enemies_x[3]),.entity_y(enemies_y[3]),.is_entity_in_pixel(is_enemy_in_pixel[3]));
Find_coordinates e5(.hc(hc),.vc(vc),.distance(enemies_dist[4]),.angle(enemies_angle[4]),.CLK(CLK_5Hz),.entity_x(enemies_x[4]),.entity_y(enemies_y[4]),.is_entity_in_pixel(is_enemy_in_pixel[4]));
Find_coordinates e6(.hc(hc),.vc(vc),.distance(enemies_dist[5]),.angle(enemies_angle[5]),.CLK(CLK_5Hz),.entity_x(enemies_x[5]),.entity_y(enemies_y[5]),.is_entity_in_pixel(is_enemy_in_pixel[5]));

// For bullets finds the corresponding horizontal and vertical values with given distance, and also calculate in the pixel is in bullet image
Find_coordinates b1(.hc(hc),.vc(vc),.distance(bullets_dist[0]),.angle(bullets_angle[0]),.CLK(CLK_5Hz),.entity_x(bullets_x[0]),.entity_y(bullets_y[0]),.is_entity_in_pixel(is_bullet_in_pixel[0]));
Find_coordinates b2(.hc(hc),.vc(vc),.distance(bullets_dist[1]),.angle(bullets_angle[1]),.CLK(CLK_5Hz),.entity_x(bullets_x[1]),.entity_y(bullets_y[1]),.is_entity_in_pixel(is_bullet_in_pixel[1]));
Find_coordinates b3(.hc(hc),.vc(vc),.distance(bullets_dist[2]),.angle(bullets_angle[2]),.CLK(CLK_5Hz),.entity_x(bullets_x[2]),.entity_y(bullets_y[2]),.is_entity_in_pixel(is_bullet_in_pixel[2]));
Find_coordinates b4(.hc(hc),.vc(vc),.distance(bullets_dist[3]),.angle(bullets_angle[3]),.CLK(CLK_5Hz),.entity_x(bullets_x[3]),.entity_y(bullets_y[3]),.is_entity_in_pixel(is_bullet_in_pixel[3]));
Find_coordinates b5(.hc(hc),.vc(vc),.distance(bullets_dist[4]),.angle(bullets_angle[4]),.CLK(CLK_5Hz),.entity_x(bullets_x[4]),.entity_y(bullets_y[4]),.is_entity_in_pixel(is_bullet_in_pixel[4]));
Find_coordinates b6(.hc(hc),.vc(vc),.distance(bullets_dist[5]),.angle(bullets_angle[5]),.CLK(CLK_5Hz),.entity_x(bullets_x[5]),.entity_y(bullets_y[5]),.is_entity_in_pixel(is_bullet_in_pixel[5]));
Find_coordinates b7(.hc(hc),.vc(vc),.distance(bullets_dist[6]),.angle(bullets_angle[6]),.CLK(CLK_5Hz),.entity_x(bullets_x[6]),.entity_y(bullets_y[6]),.is_entity_in_pixel(is_bullet_in_pixel[6]));
Find_coordinates b8(.hc(hc),.vc(vc),.distance(bullets_dist[7]),.angle(bullets_angle[7]),.CLK(CLK_5Hz),.entity_x(bullets_x[7]),.entity_y(bullets_y[7]),.is_entity_in_pixel(is_bullet_in_pixel[7]));
Find_coordinates b9(.hc(hc),.vc(vc),.distance(bullets_dist[8]),.angle(bullets_angle[8]),.CLK(CLK_5Hz),.entity_x(bullets_x[8]),.entity_y(bullets_y[8]),.is_entity_in_pixel(is_bullet_in_pixel[8]));
Find_coordinates b10(.hc(hc),.vc(vc),.distance(bullets_dist[9]),.angle(bullets_angle[9]),.CLK(CLK_5Hz),.entity_x(bullets_x[9]),.entity_y(bullets_y[9]),.is_entity_in_pixel(is_bullet_in_pixel[9]));
Find_coordinates b11(.hc(hc),.vc(vc),.distance(bullets_dist[10]),.angle(bullets_angle[10]),.CLK(CLK_5Hz),.entity_x(bullets_x[10]),.entity_y(bullets_y[10]),.is_entity_in_pixel(is_bullet_in_pixel[10]));
Find_coordinates b12(.hc(hc),.vc(vc),.distance(bullets_dist[11]),.angle(bullets_angle[11]),.CLK(CLK_5Hz),.entity_x(bullets_x[11]),.entity_y(bullets_y[11]),.is_entity_in_pixel(is_bullet_in_pixel[11]));
Find_coordinates b13(.hc(hc),.vc(vc),.distance(bullets_dist[12]),.angle(bullets_angle[12]),.CLK(CLK_5Hz),.entity_x(bullets_x[12]),.entity_y(bullets_y[12]),.is_entity_in_pixel(is_bullet_in_pixel[12]));
Find_coordinates b14(.hc(hc),.vc(vc),.distance(bullets_dist[13]),.angle(bullets_angle[13]),.CLK(CLK_5Hz),.entity_x(bullets_x[13]),.entity_y(bullets_y[13]),.is_entity_in_pixel(is_bullet_in_pixel[13]));
Find_coordinates b15(.hc(hc),.vc(vc),.distance(bullets_dist[14]),.angle(bullets_angle[14]),.CLK(CLK_5Hz),.entity_x(bullets_x[14]),.entity_y(bullets_y[14]),.is_entity_in_pixel(is_bullet_in_pixel[14]));
Find_coordinates b16(.hc(hc),.vc(vc),.distance(bullets_dist[15]),.angle(bullets_angle[15]),.CLK(CLK_5Hz),.entity_x(bullets_x[15]),.entity_y(bullets_y[15]),.is_entity_in_pixel(is_bullet_in_pixel[15]));
Find_coordinates b17(.hc(hc),.vc(vc),.distance(bullets_dist[16]),.angle(bullets_angle[16]),.CLK(CLK_5Hz),.entity_x(bullets_x[16]),.entity_y(bullets_y[16]),.is_entity_in_pixel(is_bullet_in_pixel[16]));
Find_coordinates b18(.hc(hc),.vc(vc),.distance(bullets_dist[17]),.angle(bullets_angle[17]),.CLK(CLK_5Hz),.entity_x(bullets_x[17]),.entity_y(bullets_y[17]),.is_entity_in_pixel(is_bullet_in_pixel[17]));
Find_coordinates b19(.hc(hc),.vc(vc),.distance(bullets_dist[18]),.angle(bullets_angle[18]),.CLK(CLK_5Hz),.entity_x(bullets_x[18]),.entity_y(bullets_y[18]),.is_entity_in_pixel(is_bullet_in_pixel[18]));
Find_coordinates b20(.hc(hc),.vc(vc),.distance(bullets_dist[19]),.angle(bullets_angle[19]),.CLK(CLK_5Hz),.entity_x(bullets_x[19]),.entity_y(bullets_y[19]),.is_entity_in_pixel(is_bullet_in_pixel[19]));

// Always block to find the color information of the current location
always @(posedge CLK) begin
	if (~is_blanking) begin
			// Check whether we are in start state
			if (start) pixel = pixel_start;	
			// Check whether we are in game over state
			else if (game_over) pixel = pixel_go;
			// Check whether we are in the pixels of GUI
			else begin	
				if (hc < GUI_width) pixel = pixel_left;	
				else begin
					pixel = pixel_right;	
				end
			end
	end
end

// Register used fore fire operation
reg is_fire_pressed;

// Less frequency clock to update enemies
reg CLK_2_5Hz;

// When the button stay as pressed after certain delay the ss rotates continuously
reg [2:0] rotation_delay;

// Unnecessary variable
reg u;
 
always @(posedge CLK_5Hz) begin
	CLK_2_5Hz = ~CLK_2_5Hz;
	// If we are in start phase check is there a change of interaction switch, if there is a change start phase is over
	if((Interaction != try_again) & start) begin
		start = 1'd0;
	end
	// If we are in game_over phase check is there a change of interaction switch, if there is a change game_over phase is over
	else if((Interaction != try_again) & game_over) begin
		// Resetting all parameters for restart
		score = 17'd0;
		enemies_active[0] = 1'b0;
		enemies_active[1] = 1'b0;
		enemies_active[2] = 1'b0;
		enemies_active[3] = 1'b0;
		enemies_active[4] = 1'b0;
		enemies_active[5] = 1'b0;
		current_heart = 2'd3;
		try_again = ~try_again;
		game_over = 1'b0;
		level_counter = 7'd0;
		level_reset = 1'd1;
	end
	// Because we do not have enough button for interaction, to change the game phase with every switch location 
	// changes we added this strange system so that if the switch position is changed during playing phase, it does nothing
	// If we are in start or game over phases, we go into playing phase
	else if (Interaction != try_again) try_again = ~try_again;
	
	// If we are in playing phase
	// If Pause is given all the game stops
	else if (~game_over & ~start) begin
		level_reset = 1'd0;
		if(CLK_2_5Hz & ~Pause) 	u = enemies_action();
		if((level_counter == 9'd0) & ~Pause) begin
			level_up = 1'b1;
			level_counter = level_counter + 9'b1;
		end
		else if(~Pause) begin
			level_counter = level_counter + 9'b1;
			level_up = 1'b0;
		end
		if(~Pause) begin
			if (~Fire & ~is_fire_pressed) begin
			is_fire_pressed = 1'b1;
			u = bullet_init(current_weapon,SS_angle);
			u = enemy_init(rand_2bit % number_of_enemy_type);
			u = bullets_action();
			end
			else begin
				if (Fire) is_fire_pressed = 1'b0;
				u = enemy_init(rand_2bit % number_of_enemy_type);
				u = bullets_action();
			end
			// When the button stay as pressed after certain delay the spaceship rotates continuously
			// If both rotation buttons pressed at the same time, angle does not change
			if (Rotate_CCW ^ Rotate_CW) begin
				if(~Rotate_CCW & ~CLK_2_5Hz & ((rotation_delay == 3'd0)|(rotation_delay == 3'd5))) begin
					SS_angle = SS_angle +4'd1;
					rotation_delay = rotation_delay + 3'd1;
				end
				else if(~Rotate_CW & ~CLK_2_5Hz & ((rotation_delay == 3'd0)|(rotation_delay == 3'd5))) begin
					SS_angle = SS_angle -4'd1;
					rotation_delay = rotation_delay + 3'd1;
				end
				else rotation_delay = rotation_delay + 3'd1;
			end
			else rotation_delay = 3'd0;
		end
	end
end

// Enemy registers
reg is_enemy_in_pixel[5:0];
wire [9:0] enemies_x[6:0];
wire [9:0] enemies_y[6:0];
reg [8:0] enemies_dist[5:0];
reg [3:0] enemies_angle[6:0];	
reg [7:0] enemies_health[5:0];
reg [3:0] enemies_type[6:0];
reg enemies_active[5:0];

// Bullet registers
reg is_bullet_in_pixel[19:0];
wire [9:0] bullets_x[20:0];
wire [9:0] bullets_y[20:0];
reg [8:0] bullets_dist[19:0];
reg [3:0] bullets_angle[20:0];
reg [3:0] bullets_type[20:0];
reg bullets_active[19:0];

// Initial settings
initial begin
enemies_x[6] = 9'd0;
enemies_y[6] = 9'd0;
enemies_angle[6] = 4'd0;
enemies_type[6] = 4'd4;

enemies_dist[0] = 9'd200;
enemies_dist[1] = 9'd200;
enemies_dist[2] = 9'd200;
enemies_dist[3] = 9'd200;
enemies_dist[4] = 9'd200;
enemies_dist[5] = 9'd200;

bullets_x[20] = 9'd0;
bullets_y[20] = 9'd0;
bullets_angle[20] = 4'd0; 
bullets_type[20] = 4'd3;

current_heart = 2'd3;
start = 1'b1;
try_again = Interaction;
end

// Spaceship angle
wire [3:0] SS_angle;

// Unnecessary variable
reg temp;

// Current weapon register
reg[3:0] current_weapon;

// Always block for updating the type of weapon
always @(negedge Weapon_switch) begin
current_weapon = current_weapon + 4'd1;
if (current_weapon == 4'd3) current_weapon = 4'd0;
end

// Random 2 and 4 bit numbers
wire[3:0] rand_4bit;
wire[3:0] rand_2bit;

// Random 2 and 4 bit number generators
random_4bit(CLK_5Hz,rand_4bit);
random_2bit(CLK_5Hz,rand_2bit);

localparam MAX_ENEMIES = 6;

function enemy_init(input [3:0] e_type);
begin
	reg [3:0] i;
	reg stop = 1'b0;
	for(i = 4'd0; i < number_of_enemies && ~stop && i < MAX_ENEMIES; i = i + 4'd1) begin
		if(~enemies_active[i]) begin
			stop = 1'b1;
			enemies_active[i] = 1'b1;
			enemies_type[i] = e_type;
			enemies_angle[i] = rand_4bit;
			if (enemies_angle[i] == 4'd0 | enemies_angle[i] == 4'd4 | enemies_angle[i] == 4'd8 | enemies_angle[i] == 4'd12 ) enemies_dist[i] = 10'd240;
			else if (enemies_angle[i] == 4'd2 | enemies_angle[i] == 4'd6 | enemies_angle[i] == 4'd10 | enemies_angle[i] == 4'd14 ) enemies_dist[i] = 10'd340;
			else enemies_dist[i] = 10'd260;
			enemies_health[i] = (e_type == 4'd0) ? 8'd8:
									  (e_type == 4'd1) ? 8'd4:
									  (e_type == 4'd2) ? 8'd32:
									   8'd128;
		end
	end
end
endfunction


function enemy_move(input [3:0] i);
begin
enemies_dist[i] = (enemies_type[i] == 4'd0) ? enemies_dist[i] - 8'd2 - extra_speed_of_enemies :
						(enemies_type[i] == 4'd1) ? enemies_dist[i] - 8'd3 - extra_speed_of_enemies :
						(enemies_type[i] == 4'd2) ? enemies_dist[i] - 8'd2 - extra_speed_of_enemies :
						enemies_dist[i] - 8'd1 - extra_speed_of_enemies;

end
endfunction

function enemies_action;
begin

	reg [3:0] i;
	for(i = 4'd0; i < number_of_enemies && i < MAX_ENEMIES; i = i + 4'd1)
	begin
		if (enemies_dist[i] < 9'd15) begin
			enemies_active[i] = 1'b0;
			if(current_heart == 2'd1) game_over = 1'b1;
			else current_heart = current_heart - 2'd1;
		end
		else temp = enemy_move(i);
	end
end
endfunction

function bullet_init(input [3:0] b_type, input [3:0] angle);
begin
	reg [4:0] i;
	reg [2:0] counter = (b_type == 4'd0) ? 3'd5:
		(b_type == 4'd1) ? 3'd3:
		3'd1;
	
	for(i = 5'd0; i < 5'd19 && counter > 0; i = i + 5'd1)
	if(~bullets_active[i]) begin
		bullets_active[i] = 1'b1;
		bullets_dist[i] = 9'd0; // Başlangıçta merkezde
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
	if (bullets_angle[i] == 4'd0 | bullets_angle[i] == 4'd4 | bullets_angle[i] == 4'd8 | bullets_angle[i] == 4'd12 ) begin 
		if (bullets_dist[i] < 9'd240) begin
		bullets_dist[i] = (bullets_type[i] == 4'd0) ? bullets_dist[i] + 9'd7 :
								(bullets_type[i] == 4'd1) ? bullets_dist[i] + 9'd6 :
								 bullets_dist[i] + 9'd5;
		end
		else bullets_active[i] = 1'b0;
	end
	else if (bullets_angle[i] == 4'd2 | bullets_angle[i] == 4'd6 | bullets_angle[i] == 4'd10 | bullets_angle[i] == 4'd14) begin
		if (bullets_dist[i] < 9'd340) begin
		bullets_dist[i] = (bullets_type[i] == 4'd0) ? bullets_dist[i] + 9'd7 :
								(bullets_type[i] == 4'd2) ? bullets_dist[i] + 9'd6 :
								 bullets_dist[i] + 9'd5;
		end
		else bullets_active[i] = 1'b0;
	end
	else begin
		if (bullets_dist[i] < 9'd260) begin
		bullets_dist[i] = (bullets_type[i] == 4'd0) ? bullets_dist[i] + 9'd7 :
								(bullets_type[i] == 4'd1) ? bullets_dist[i] + 9'd6 :
								 bullets_dist[i] + 9'd5;
		end
		else bullets_active[i] = 1'b0;
	end
endfunction

function check_col(input [4:0] i);
begin 
	reg [3:0] j;
	reg stop = 1'b0;
	reg [7:0] damage_dealt;
	for(j = 4'd0; j < number_of_enemies && ~stop && j < MAX_ENEMIES; j = j + 4'd1)
	if(enemies_active[j] && bullets_dist[i] >= enemies_dist[j] && enemies_angle[j] == bullets_angle[i]) begin
		stop = 1'b1;
		bullets_active[i] = 1'b0; 
		damage_dealt = (bullets_type[i] == 4'd0) ? 8'd3:
							(bullets_type[i] == 4'd1) ? 8'd6: 
							8'd20;
		if(damage_dealt >= enemies_health[j]) begin
			score =  (enemies_type[j] == 4'd0) ? score + 17'd2:
						(enemies_type[j] == 4'd1) ? score + 17'd3:
						(enemies_type[j] == 4'd2) ? score + 17'd5:
						score + 17'd10;
			enemies_active[j] = 1'b0;
		end
		else enemies_health[j] = enemies_health[j] - damage_dealt;
	end
end
endfunction

function bullets_action;
begin
	reg [4:0] i;
	for(i = 5'd0; i < 5'd19; i = i + 5'd1)
	if(bullets_active[i]) begin
		temp = bullet_move(i);
		temp = check_col(i);
	end
end
endfunction


endmodule
