module main(
    input wire CLK,             // 25.175 MHz clock
    input wire RESET,           // Reset signal
    input wire Weapon_switch, 	// To switch the current weapon (Button3)
    input wire Rotate_CW, 	// To rotate 22.5 degrees in clockwise direction (Button2)
    input wire Rotate_CCW, 	// To rotate 22.5 degrees in counter-clockwise direction (Button1)
    input wire Interaction,	// Used as an interaction button for "Try again", "OKAY" (Button4)
    output wire hsync,           // Horizontal sync output
    output wire vsync,           // Vertical sync output
    output reg[7:0] red,	// Pixel color information about red color
    output reg[7:0] green,	// Pixel color information about green color
    output reg[7:0] blue	// Pixel color information about blue color
);

// Creating all needed wires and registers
wire[9:0] hc;
wire[9:0] vc;

wire is_blanking;

reg[17:0] score;

wire[3:0] score_digit0;
wire[3:0] score_digit1;
wire[3:0] score_digit2;
wire[3:0] score_digit3;
wire[3:0] score_digit4;

// Storing Number images
reg[3:0] Number0 [0:22][0:28];
reg[3:0] Number1 [0:22][0:28];
reg[3:0] Number2 [0:22][0:28];
reg[3:0] Number3 [0:22][0:28];
reg[3:0] Number4 [0:22][0:28];
reg[3:0] Number5 [0:22][0:28];
reg[3:0] Number6 [0:22][0:28];
reg[3:0] Number7 [0:22][0:28];
reg[3:0] Number8 [0:22][0:28];
reg[3:0] Number9 [0:22][0:28];

// Storing Spaceship images for different angles

reg [3:0] SS0[0:47][0:47]; // 270 degrees
reg [3:0] SS1[0:47][0:47]; // 247.5 degrees
reg [3:0] SS2[0:47][0:47]; // 225 degrees
reg [3:0] SS3[0:47][0:47]; // 202.5 degrees
reg [3:0] SS4[0:47][0:47]; // 180 degrees
reg [3:0] SS5[0:47][0:47]; // 167.5 degrees
reg [3:0] SS6[0:47][0:47]; // 135 degrees
reg [3:0] SS7[0:47][0:47]; // 112.5 degrees
reg [3:0] SS8[0:47][0:47]; // 90 degrees
reg [3:0] SS9[0:47][0:47]; // 67.5 degrees
reg [3:0] SS10[0:47][0:47]; // 45 degrees
reg [3:0] SS11[0:47][0:47]; // 22.5 degrees
reg [3:0] SS12[0:47][0:47]; // 0 degrees
reg [3:0] SS13[0:47][0:47]; // 292.5 degrees
reg [3:0] SS14[0:47][0:47]; // 315 degrees
reg [3:0] SS15[0:47][0:47]; // 337.5 degrees


// Creating all needed blocks

// Arranging the number images
Numbers_init(.Number0(Number0),.Number1(Number1),.Number2(Number2),.Number3(Number3),.Number4(Number4),.Number5(Number5),.Number6(Number6),.Number7(Number7),.Number8(Number8),.Number9(Number9));

// Arranging the spaceship images
SpaceShip_init(.SS0(SS0),.SS1(SS1),.SS2(SS2),.SS3(SS3),.SS4(SS4),.SS5(SS5),.SS6(SS6),.SS7(SS7),.SS8(SS8),.SS9(SS9),.SS10(SS10),.SS11(SS11),.SS12(SS12),.SS13(SS13),.SS14(SS14),.SS15(SS15));

VGA_initializer(.CLK(CLK),.RESET(RESET),.hsync(hsync),.vsync(vsync),.hc(hc),.vc(vc),.is_blanking(is_blanking));

Score_display(.score(score),.digit0(score_digit0),.digit1(score_digit1),.digit2(score_digit2),.digit3(score_digit3),.digit4(score_digit4));

always @(posedge CLK) begin
		if (~is_blanking) begin
		// Write finding the corresponding color information  code here
		
		end
		else begin 
		red <= 8'b00000000;
		green <= 8'b00000000;
		blue <= 8'b00000000;
		end

end


endmodule
