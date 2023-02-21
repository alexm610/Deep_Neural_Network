volatile unsigned *vga = (volatile unsigned *) 0x00004000; /* VGA adapter base address */
#include "vga_plot.c"

unsigned char pixel_list[] = {
#include "../../data/misc/pixels.txt"
};
unsigned num_pixels = sizeof(pixel_list)/2;

int main() {
	int y, x, colour;
	
	for (y = 0; y < 120; y++) {
		for (x = 0; x < 160; x++) {
			// print black and white stripes
			if (x % 2 != 0) colour = 0; else colour = 255;
			vga_plot(x, y, colour);
		}
	}
}
