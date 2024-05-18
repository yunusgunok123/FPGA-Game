module main(
    input wire CLK,             	// 25.175 MHz clock
    input wire RESET,             	// Reset signal
    input wire Weapon_switch, 		// To switch the current weapon (Button3)
    input wire Rotate_CW, 		// To rotate 22.5 degrees in clockwise direction (Button2)
    input wire Rotate_CCW, 		// To rotate 22.5 degrees in counter-clockwise direction (Button1)
    input wire Interaction,		// Used as an interaction button for "Try again", "OKAY" (Button4)
    output wire hsync,           	// Horizontal sync output
    output wire vsync,           	// Vertical sync output
    output reg[7:0] red,		// Pixel color information about red color
    output reg[7:0] green,		// Pixel color information about green color
    output reg[7:0] blue		// Pixel color information about blue color
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

// Creating all needed blocks
VGA_initializer(.CLK(CLK),.RESET(RESET),.hsync(hsync),.vsync(vsync),.hc(hc),.vc(vc),.is_blanking(is_blanking));
Score_display(.score(score),.digit0(score_digit0),.digit1(score_digit1),.digit2(score_digit2),.digit3(score_digit3),.digit4(score_digit4));

always @(posedge CLK) begin

end


endmodule
