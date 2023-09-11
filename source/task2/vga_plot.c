void vga_plot(unsigned x, unsigned y, unsigned colour)
{
    volatile unsigned *VGA_controller = (volatile unsigned *) 0x00004000;
    *VGA_controller = (y << 24) | (x << 16) | colour;
}
