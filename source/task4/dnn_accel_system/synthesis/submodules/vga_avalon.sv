module vga_avalon (input logic clk, input logic reset_n,
                  input logic [3:0] address,
                  input logic read, output logic [31:0] readdata,
                  input logic write, input logic [31:0] writedata,
                  output logic [7:0] vga_red, output logic [7:0] vga_grn, output logic [7:0] vga_blu,
                  output logic vga_hsync, output logic vga_vsync, output logic vga_clk);

    logic [9:0] VGA_R_10, VGA_G_10, VGA_B_10;
    logic set_plot, x_valid, y_valid;

    assign x_valid = (writedata[23:16] <= 8'd160) && (writedata[23:16] >= 8'd0) ? 1 : 0;
    assign y_valid = (writedata[31:24] <= 7'd120) && (writedata[31:24] >= 7'd0) ? 1 : 0;
    assign set_plot = (x_valid && y_valid) ? write : 0;
    assign vga_red = VGA_R_10[9:2];
    assign vga_grn = VGA_G_10[9:2];
    assign vga_blu = VGA_B_10[9:2];

    vga_adapter #( .RESOLUTION("160x120"), .MONOCHROME("TRUE"), .BITS_PER_COLOUR_CHANNEL(8) ) vga (
        .resetn(reset_n),
        .clock(clk),
        .x(writedata[23:16]),
        .y(writedata[31:24]),
        .plot(set_plot),
        .colour(writedata[7:0]),
        .VGA_R(VGA_R_10),
        .VGA_G(VGA_G_10),
        .VGA_B(VGA_B_10),
        .VGA_HS(vga_hsync),
        .VGA_VS(vga_vsync),
        .VGA_CLK(vga_clk));
endmodule: vga_avalon

    // NOTE: We will ignore the VGA_SYNC and VGA_BLANK signals.
    //       Either don't connect them or connect them to dangling wires.
    //       In addition, the VGA_{R,G,B} should be the upper 8 bits of the VGA module outputs.