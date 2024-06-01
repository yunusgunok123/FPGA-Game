module CLK_divider_25MHz(
		input wire CLK,
		output reg CLK_divided
);

// Decrease the frequency by a factor of 2
always @(posedge CLK) begin
		CLK_divided <= ~CLK_divided;
end

endmodule