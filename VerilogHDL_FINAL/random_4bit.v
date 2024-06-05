module random_4bit(input CLK, output reg[3:0] out, output reg star);

reg[15:0] shift = 16'h9252;

always @(posedge CLK) begin
	shift[15] <= shift[13] ~^ shift[8] ~^ shift[3] ~^ shift[4] ~^ shift[10];
	shift[14:0] <= shift[15:1];

	out = {shift[6],shift[1],shift[11],shift[3]};
	star = shift[0] & shift[1] & shift[2] & shift[3] & shift[4] & shift[5] & shift[6];
end

endmodule