module vga_avalon(input logic clk, input logic reset_n,
                  input logic [3:0] address,
                  input logic read, output logic [31:0] readdata,
                  input logic write, input logic [31:0] writedata,
                  output logic [7:0] vga_red, output logic [7:0] vga_grn, output logic [7:0] vga_blu,
                  output logic vga_hsync, output logic vga_vsync, output logic vga_clk);

    
    logic [9:0] VGA_R_10, VGA_G_10, VGA_B_10;

    assign vga_red = VGA_R_10;
    assign vga_grn = VGA_G_10;
    assign vga_blu = VGA_B_10;

    vga_adapter #( .RESOLUTION("160x120"), .MONOCHROME("TRUE"), .BITS_PER_COLOUR_CHANNEL(8) ) vga (
        .resetn(reset_n),
        .clock(clk),
        .x(),
        .y(),
        .plot(),
        .VGA_R(VGA_R_10),
        .VGA_G(VGA_G_10),
        .VGA_B(VGA_B_10),
        .*);

    // NOTE: We will ignore the VGA_SYNC and VGA_BLANK signals.
    //       Either don't connect them or connect them to dangling wires.
    //       In addition, the VGA_{R,G,B} should be the upper 8 bits of the VGA module outputs.

endmodule: vga_avalon
