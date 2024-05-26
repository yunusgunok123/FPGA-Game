module random(input CLK, output reg[3:0] out);

reg[15:0] shift = 16'h9252;

always @(posedge CLK) begin
	shift[15] <= shift[13] ~^ shift[8] ~^ shift[3] ~^ shift[4] ~^ shift[10];
	shift[14:0] <= shift[15:1];

	out = {shift[6],shift[1],shift[11],shift[3]};

end

endmodule