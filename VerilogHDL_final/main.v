module main(
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

CLK_divider(.CLK(CLK),.CLK_divided(CLK_5Hz));


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
wire [3:0] score_digits [4:0];
								  
// Update each digit whenever score changes
Score_init(.score(score),.digits(score_digits));
	
localparam GUI_width = 160; // Width of the GUI
localparam Center_point_hc = GUI_width + 239; // Horizontal coordinate of center point
localparam Center_point_vc = 239; // Vertical coordinate of center point
		
// Parameters for weapon
localparam weapon_art_hc = 19; // Horizontal coordinate of Up Left corner of the weapon article
localparam weapon_art_vc = 350; // Vertical coordinate of Up Left corner of the weapon article
localparam weapon_art_width = 120; // Width of weapon article
localparam weapon_art_height = 28; // Height of weapon article

localparam weapon_img_hc = 61; // Horizontal coordinate of Up Left corner of the weapon image 0
localparam weapon_img_vc = 400; // Vertical coordinate of Up Left corner of the weapon image 0
localparam weapon_img_width = 36; // Width of weapon image 0
localparam weapon_img_height = 36; // Height of weapon image 0



// Curret weapon register
reg[3:0] current_weapon;

		
// Parameters for score		
localparam score_art_hc = 35; // Horizontal coordinate of Up Left corner of the score article
localparam score_art_vc = 69; // Vertical coordinate of Up Left corner of the score article
localparam score_art_width = 88; // Width of score article
localparam score_art_height = 20; // Height of score article
		
localparam score_hc = 31;  // Horizontal coordinate of Up Left corner of the score
localparam score_vc = 109; // Vertical coordinate of Up Left corner of the score
localparam score_width = 16; // Width of each digit of score
localparam score_height = 20; // Height of score
localparam score_space = 4; // Width of score space
		
// Score register and wires
reg[16:0] score;
	
// Spaceship settings
localparam SS_hc = GUI_width + 221;
localparam SS_vc = 221;
localparam SS_size = 36;

wire is_SS_in_pixel = (hc >= SS_hc && hc < SS_hc + SS_size && vc >= SS_vc && vc < SS_vc + SS_size);

reg[3:0] e_pixel;
reg[3:0] b_pixel;
reg[3:0] ss_pixel;

reg[3:0] n_pixel;
reg[3:0] s_a_pixel;
reg[3:0] w_a_pixel;
reg[3:0] w_img_pixel;

wire [3:0] pixel_left = ((n_pixel + s_a_pixel + w_a_pixel + w_img_pixel) == 4'd0) ? 4'd15 : (n_pixel + s_a_pixel + w_a_pixel + w_img_pixel);

 
wire [3:0] pixel_right = (ss_pixel != 4'd0) ? ss_pixel:
								 (e_pixel != 4'd0) ? e_pixel:
								 (b_pixel != 4'd0) ? b_pixel:
								 4'd0;

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
Bullet bullet_inst (
    .is_bullet_in_pixel(is_bullet_in_pixel),
	 .is_bullet_active(bullets_active),
    .bullet_angle(bullets_angle),
    .bullet_type(bullets_type),
    .bullet_hc(bullets_x),
    .bullet_vc(bullets_x),
    .CLK(CLK),
    .pixel(b_pixel)
);
Spaceship ss_inst (
    .is_SS_in_pixel(is_SS_in_pixel),
    .SS_angle(SS_angle),
    .SS_hc(hc-SS_hc),
    .SS_vc(vc-SS_vc),
    .CLK(CLK),
    .pixel(ss_pixel)
);
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

Number num_inst(
    .is_number_in_pixel(is_number_in_pixel),
    .number_type(all_number_types),
    .number_hc(all_number_hcs),
    .number_vc(all_number_vcs),
    .CLK(CLK),
    .pixel(pixel1)
);

wire is_SA_in_pixel = (hc >= score_art_hc && hc < score_art_hc + score_art_width && vc >= score_art_vc && vc < score_art_vc  + score_art_height);

Score_Article(
	.is_in_pixel(is_SA_in_pixel),
	.hc(hc-score_art_hc),
	.vc(vc-score_art_vc),
	.CLK(CLK),
	.pixel(pixel2) 
);

wire is_WA_in_pixel = (hc >= weapon_art_hc && hc < weapon_art_hc + weapon_art_width && vc >= weapon_art_vc && vc < weapon_art_vc  + weapon_art_height);

Weapon_Article(
	.is_in_pixel(is_WA_in_pixel),
	.hc(hc-weapon_art_hc),
	.vc(vc-weapon_art_vc),
	.CLK(CLK),
	.pixel(pixel3) 
);

wire is_wep_img_in_pixel = (hc >= weapon_img_hc && hc < weapon_img_hc + weapon_img_width && vc >= weapon_img_vc && vc < weapon_img_vc  + weapon_img_height);

Weapon_img(
	.is_wep_img_in_pixel(is_wep_img_in_pixel),
	.wep_type(current_weapon),
	.wep_hc(hc-weapon_img_hc),
	.wep_vc(vc-weapon_img_vc),
	.CLK(CLK),
	.pixel(pixel4) 
);


// For enemies
Find_coordinates e1(.hc(hc),.vc(vc),.distance(enemies_dist[0]),.angle(enemies_angle[0]),.CLK(CLK_5Hz),.entity_x(enemies_x[0]),.entity_y(enemies_y[0]),.is_entity_in_pixel(is_enemy_in_pixel[0]));
Find_coordinates e2(.hc(hc),.vc(vc),.distance(enemies_dist[1]),.angle(enemies_angle[1]),.CLK(CLK_5Hz),.entity_x(enemies_x[1]),.entity_y(enemies_y[1]),.is_entity_in_pixel(is_enemy_in_pixel[1]));
Find_coordinates e3(.hc(hc),.vc(vc),.distance(enemies_dist[2]),.angle(enemies_angle[2]),.CLK(CLK_5Hz),.entity_x(enemies_x[2]),.entity_y(enemies_y[2]),.is_entity_in_pixel(is_enemy_in_pixel[2]));
Find_coordinates e4(.hc(hc),.vc(vc),.distance(enemies_dist[3]),.angle(enemies_angle[3]),.CLK(CLK_5Hz),.entity_x(enemies_x[3]),.entity_y(enemies_y[3]),.is_entity_in_pixel(is_enemy_in_pixel[3]));
Find_coordinates e5(.hc(hc),.vc(vc),.distance(enemies_dist[4]),.angle(enemies_angle[4]),.CLK(CLK_5Hz),.entity_x(enemies_x[4]),.entity_y(enemies_y[4]),.is_entity_in_pixel(is_enemy_in_pixel[4]));
Find_coordinates e6(.hc(hc),.vc(vc),.distance(enemies_dist[5]),.angle(enemies_angle[5]),.CLK(CLK_5Hz),.entity_x(enemies_x[5]),.entity_y(enemies_y[5]),.is_entity_in_pixel(is_enemy_in_pixel[5]));
Find_coordinates e7(.hc(hc),.vc(vc),.distance(enemies_dist[6]),.angle(enemies_angle[6]),.CLK(CLK_5Hz),.entity_x(enemies_x[6]),.entity_y(enemies_y[6]),.is_entity_in_pixel(is_enemy_in_pixel[6]));
Find_coordinates e8(.hc(hc),.vc(vc),.distance(enemies_dist[7]),.angle(enemies_angle[7]),.CLK(CLK_5Hz),.entity_x(enemies_x[7]),.entity_y(enemies_y[7]),.is_entity_in_pixel(is_enemy_in_pixel[7]));

// For bullets
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
		// Check whether we are in the pixels of GUI
		if (hc < GUI_width) pixel = pixel_left;	
		else pixel = pixel_right;	
	end
end

reg is_fire_pressed;
// Unnecessary variable
reg u; 
always @(posedge CLK_5Hz) begin
	deneme2 = 1'b1;
	if (RESET) begin
		score = 17'd0;
		enemies_active[0] = 1'b0;
		enemies_active[1] = 1'b0;
		enemies_active[2] = 1'b0;
		enemies_active[3] = 1'b0;
		enemies_active[4] = 1'b0;
		enemies_active[5] = 1'b0;
		enemies_active[6] = 1'b0;
		enemies_active[7] = 1'b0;
	end
	else if (~Fire & ~is_fire_pressed) begin
	score = score + 17'b1;
	is_fire_pressed = 1'b1;
	u = bullet_init(current_weapon+4'd5,SS_angle);
	u = enemy_init(rand_2bit+3'd1);
	u = enemies_action();
	u = bullets_action();
	end
	else begin
		deneme1 = 1'b1;
		if (Fire) is_fire_pressed = 1'b0;
		u = enemy_init(rand_2bit+3'd1);
		u = enemies_action();
		u = bullets_action();
	end
end

reg is_enemy_in_pixel[7:0];
reg [8:0] enemies_x[8:0];
reg [8:0] enemies_y[8:0];
reg [8:0] enemies_dist[7:0];
reg [3:0] enemies_angle[8:0];	
reg [3:0] enemies_health[7:0];
reg [3:0] enemies_type[8:0];
reg enemies_active[7:0];

reg is_bullet_in_pixel[19:0];
reg [8:0] bullets_x[20:0];
reg [8:0] bullets_y[20:0];
reg [8:0] bullets_dist[19:0];
reg [3:0] bullets_angle[20:0];
reg [3:0] bullets_type[20:0];
reg bullets_active[19:0];

initial begin
enemies_x[8] = 9'd0;
enemies_y[8] = 9'd0;
enemies_angle[8] = 4'd0;
enemies_type[8] = 4'd4;

bullets_x[20] = 9'd0;
bullets_y[20] = 9'd0;
bullets_angle[20] = 4'd0; 
bullets_type[20] = 4'd3;
end

wire [3:0] SS_angle;

reg temp;

reg [3:0] Angle1;
reg [3:0] Angle2;

assign SS_angle = Angle1 + Angle2;

// Always block for updating the state of spaceship
always @(negedge Rotate_CW) Angle1 = Angle1 - 4'd1;
always @(negedge Rotate_CCW) Angle2 = Angle2 + 4'd1;


// Always block for updating the type of weapon
always @(negedge Weapon_switch) begin
current_weapon = current_weapon + 4'd1;
if (current_weapon == 4'd3) current_weapon = 4'd0;
end


wire[3:0] rand_4bit;
wire[3:0] rand_2bit;
reg count [2:0];

random_4bit(CLK_5Hz,rand_4bit);
random_2bit(CLK_5Hz,rand_2bit);

function enemy_init(input [3:0] e_type);
begin
	reg [3:0] i;
	reg stop = 1'b0;
	for(i = 4'd0; i < 4'd8 && ~stop; i = i + 4'd1) begin
		if(~enemies_active[i]) begin
			stop = 1'b1;
			enemies_active[i] = 1'b1;
			enemies_type[i] = e_type;
			enemies_angle[i] = rand_4bit;
			if (enemies_angle[i] == 4'd0 | enemies_angle[i] == 4'd4 | enemies_angle[i] == 4'd8 | enemies_angle[i] == 4'd12 ) enemies_dist[i] = 10'd240;
			else if (enemies_angle[i] == 4'd2 | enemies_angle[i] == 4'd6 | enemies_angle[i] == 4'd10 | enemies_angle[i] == 4'd14 ) enemies_dist[i] = 10'd340;
			else enemies_dist[i] = 10'd260;
			enemies_health[i] = (e_type == 4'd1) ? 4'd6:
									  (e_type == 4'd2) ? 4'd3:
									  (e_type == 4'd3) ? 4'd2:
									   4'd15;
		end
	end
end
endfunction


function enemy_move(input [3:0] i);
begin
enemies_dist[i] = (enemies_type[i] == 4'd1) ? enemies_dist[i] - 8'd3 :
						(enemies_type[i] == 4'd2) ? enemies_dist[i] - 8'd4 :
						(enemies_type[i] == 4'd3) ? enemies_dist[i] - 8'd5 :
						enemies_dist[i] - 8'd1;

end
endfunction

function enemies_action;
begin

	reg [3:0] i;
	for(i = 4'd0; i < 4'd7; i = i + 4'd1)
	begin
		if (enemies_dist[i] < 9'd15) 	enemies_active[i] = 1'b0;
		else temp = enemy_move(i);
	end
end
endfunction

function bullet_init(input [3:0] b_type, input [3:0] angle);
begin
	reg [4:0] i;
	reg [2:0] counter = (b_type == 4'd5) ? 3'd5:
		(b_type == 4'd6) ? 3'd3:
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
		bullets_dist[i] = (bullets_type[i] == 4'd5) ? bullets_dist[i] + 9'd7 :
								(bullets_type[i] == 4'd6) ? bullets_dist[i] + 9'd5 :
								 bullets_dist[i] + 9'd4;
		end
		else bullets_active[i] = 1'b0;
	end
	else if (bullets_angle[i] == 4'd2 | bullets_angle[i] == 4'd6 | bullets_angle[i] == 4'd10 | bullets_angle[i] == 4'd14) begin
		if (bullets_dist[i] < 9'd340) begin
		bullets_dist[i] = (bullets_type[i] == 4'd5) ? bullets_dist[i] + 9'd7 :
								(bullets_type[i] == 4'd6) ? bullets_dist[i] + 9'd5 :
								 bullets_dist[i] + 9'd4;
		end
		else bullets_active[i] = 1'b0;
	end
	else begin
		if (bullets_dist[i] < 9'd260) begin
		bullets_dist[i] = (bullets_type[i] == 4'd5) ? bullets_dist[i] + 9'd7 :
								(bullets_type[i] == 4'd6) ? bullets_dist[i] + 9'd5 :
								 bullets_dist[i] + 9'd4;
		end
		else bullets_active[i] = 1'b0;
	end
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
		damage_dealt = (bullets_type[i] == 4'd5) ? 4'd2:
							(bullets_type[i] == 4'd5) ? 4'd3: 
							4'd9;
		if(damage_dealt >= enemies_health[j]) begin
			score =  (enemies_type[j] == 4'd1) ? score + 17'd6:
						(enemies_type[j] == 4'd2) ? score + 17'd3:
						(enemies_type[j] == 4'd3) ? score + 17'd2:
						score + 17'd15;
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
