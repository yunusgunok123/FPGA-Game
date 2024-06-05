module Level_typer(
				input wire [4:0] current_level,
				input wire on,
				output wire[6:0] HEX0,
				output wire [6:0] HEX1,
				output wire[6:0] HEX4,
				output wire [6:0] HEX5,
				input wire CLK
);

// Least significan bit in BCD form
reg [4:0] LSB;

// Temporary variable
reg [4:0] temp;

// Find the first digit of current level in bcd form
always @(posedge CLK) begin
    temp = current_level;
    
    if (temp >= 5'd30) temp = temp - 5'd30;
    else if (temp >= 5'd20) temp = temp - 5'd20;
	 else if (temp >= 5'd10) temp = temp - 5'd10; 
    
    LSB = temp;
end

// 7 Segment display for first digit of level
assign HEX0 = (LSB == 5'd1) ? 7'b1111001:
				  (LSB == 5'd2) ? 7'b0100100:
				  (LSB == 5'd3) ? 7'b0110000:
				  (LSB == 5'd4) ? 7'b0011001:
				  (LSB == 5'd5) ? 7'b0010010:
				  (LSB == 5'd6) ? 7'b0000010:
				  (LSB == 5'd7) ? 7'b1111000:
				  (LSB == 5'd8) ? 7'b0000000:
				  (LSB == 5'd9) ? 7'b0010000:
				  7'b1000000;

// 7 Segment display for second digit of level				  
assign HEX1 = (~on) ? 7'b1111111 :
				(current_level < 5'd10) ? 7'b1000000:
				(current_level < 5'd20) ? 7'b1111001:
				(current_level < 5'd30) ? 7'b0100100:
				 7'b0110000;
				 

// 7 Segment display for "V" letter
assign HEX4 = (on) ? 7'b1000001 : 7'b1111111;
// 7 Segment display for "L" letter
assign HEX5 = (on) ? 7'b1000111 : 7'b1111111;
				 
endmodule