module CLK_divider(
		input wire CLK,
		output reg CLK_divided
);

reg[21:0] counter;
// Decrease the frequency by a factor of 5000000
always @(posedge CLK) begin
		counter = counter + 22'b1;
		if (counter == 21'd2500000-21'd1) begin
		CLK_divided <= ~CLK_divided;
		counter = 22'b0;
		end
end

endmodule