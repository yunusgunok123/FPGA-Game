module random_2bit(input CLK, output reg[2:0] out);

reg[15:0] shift = 16'h5235;

always @(posedge CLK) begin
	shift[15] <= shift[13] ~^ shift[8] ~^ shift[3] ~^ shift[4] ~^ shift[10];
	shift[14:0] <= shift[15:1];

	out = {3'b0,shift[1],shift[11]};

end

endmodule