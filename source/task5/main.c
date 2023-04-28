#include <stdio.h>
#include "vga_plot.c"
volatile unsigned *vga = (volatile unsigned *) 0x00004000; /* VGA adapter base address */
#define STRING_LOCATION (char *) 0x00008000
unsigned char pixel_list[] = {
	#include "../../data/misc/pixels.txt"
};
unsigned num_pixels = sizeof(pixel_list)/2;
int main() {
	unsigned y, x, colour, pixel;
	for (y = 0; y < 120; y++) {
		for (x =0; x < 160; x++) {
			vga_plot(x, y, 0);
		}
	}
	for (y=0; y<120; y++) {
		for (x=0; x<160; x++) {
			// search through entire pixel_list[] for pixels that are within desired vicinity, and add weights accordingly
			colour = 0;
			pixel = 0;
			while (pixel <= num_pixels) {
				if ((pixel_list[2*pixel] == x - 2) || (pixel_list[2*pixel] == x + 2)) {
					if ((pixel_list[2*pixel+1] == y - 2) || (pixel_list[2*pixel+1] == y + 2)) {
						colour += 1;
					} else if ((pixel_list[2*pixel+1] == y - 1) || (pixel_list[2*pixel+1] == y + 1)) {
						colour += 2;
					} else if (pixel_list[2*pixel+1] == y) {
						colour += 4;
					}
				} else if ((pixel_list[2*pixel] == x - 1) || (pixel_list[2*pixel] == x + 1)) {
					if ((pixel_list[2*pixel+1] == y - 2) || (pixel_list[2*pixel+1] == y + 2)) {
						colour += 2;
					} else if ((pixel_list[2*pixel+1] == y - 1) || (pixel_list[2*pixel+1] == y + 1)) {
						colour += 4;
					} else if (pixel_list[2*pixel+1] == y) {
						colour += 8;
					}
				} else if (pixel_list[2*pixel] == x) {
					if ((pixel_list[2*pixel+1] == y - 2) || (pixel_list[2*pixel+1] == y + 2)) {
						colour += 4;
					} else if ((pixel_list[2*pixel+1] == y - 1) || (pixel_list[2*pixel+1] == y + 1)) {
						colour += 8;
					} else if (pixel_list[2*pixel+1] == y) {
						colour += 16;
					}
				}
				pixel++;
			}
			vga_plot(x, y, (255*colour)/100);			
		}
	}
}