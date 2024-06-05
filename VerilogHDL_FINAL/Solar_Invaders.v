
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module Solar_Invaders(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
//	output		     [6:0]		HEX2,
//	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
//	output		          		VGA_SYNC_N,
	output		          		VGA_VS
);



//=======================================================
//  REG/WIRE declarations
//=======================================================


wire CLK_25;
assign VGA_BLANK_N = 1'b1;
assign VGA_CLK = CLK_25;
assign LEDR = (LEDs_on) ? 10'b1111111111 : 10'b0000000000;


//=======================================================
//  Structural coding
//=======================================================


CLK_divider_25MHz(.CLK(CLOCK_50),.CLK_divided(CLK_25));

main(.CLK(CLK_25),
     .RESET(SW[0]),
	  .Weapon_switch(KEY[3]),
	  .Fire(KEY[2]),
	  .Rotate_CW(KEY[0]),
	  .Rotate_CCW(KEY[1]),
	  .hsync(VGA_HS),
	  .vsync(VGA_VS),
	  .red(VGA_R),
	  .green(VGA_G),
	  .blue(VGA_B),
	  .Pause(SW[9]),
	  .Interaction(SW[8]),
	  .HEX0(HEX0),
	  .HEX1(HEX1),
	  .HEX4(HEX4),
	  .HEX5(HEX5),
	  .level_up(LEDs_on)
);


endmodule