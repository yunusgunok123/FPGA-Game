module VGA_initializer (
    input wire CLK,             // 25.175 MHz clock
    input wire RESET,             // Reset signal
    output wire hsync,           // Horizontal sync output
    output wire vsync,           // Vertical sync output
	 output reg [9:0] hc = 0,		// Counter for horizontal timing also gives us the horizontal location
    output reg [9:0] vc = 0,		// Counters for vertical timing also gives us the vertical location
	 output wire is_blanking 		// To see whether we are in blanking state or not

);

    // VGA parameters for 640x480 @ 60Hz
    parameter H_VISIBLE = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_SYNC_PULSE = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_TOTAL = 800;

    parameter V_VISIBLE = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_TOTAL = 525;


    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            hc <= 0;
            vc <= 0;
        end else begin
            // Horizontal counter
            if (hc == H_TOTAL - 1) begin
                hc <= 0;
                // Vertical counter
                if (vc == V_TOTAL - 1) begin
                    vc <= 0;
                end else begin
                    vc <= vc + 1;
                end
            end else begin
                hc <= hc + 1;
            end
        end
    end

    // Generate HSYNC and VSYNC signals
        // HSYNC
    assign hsync = (hc >= H_VISIBLE + H_FRONT_PORCH && hc < H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE) ? 0 : 1;

        // VSYNC
    assign vsync = (vc >= V_VISIBLE + V_FRONT_PORCH && vc < V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE) ? 0 : 1;
	 
		 // Blanking state
	 assign is_blanking = ~(hc < H_VISIBLE && vc < V_VISIBLE);

endmodule
