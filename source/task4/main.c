#include <stdio.h>
#include "vga_plot.c"
volatile unsigned *vga = (volatile unsigned *) 0x00004000; /* VGA adapter base address */
#define STRING_LOCATION (char *) 0x00008000

unsigned char pixel_list[] = {
	#include "../../data/misc/pixels.txt"
};
unsigned num_pixels = sizeof(pixel_list)/2;

int main() {
	int y, x, colour, pixel = 0;
	sprintf(STRING_LOCATION, "Hello World!");

	for (y = 0; y < 120; y++) {
		for (x =0; x < 160; x++) {
			vga_plot(x, y, 0);
		}
	}

	while (pixel <= num_pixels) {
		x = pixel_list[2*pixel];
		y = pixel_list[2*pixel+1];
		vga_plot(x, y, 255);
		pixel++;
	}

	sprintf(STRING_LOCATION + 16, "Hello Dog!");
}

/*
Following loop prints stripes:

	for (y = 0; y < 60; y++) {
		for (x = 0; x < 80; x++) {
			// print black and white stripes
			if (x % 2 != 0) colour = 0; else colour = 255;
			vga_plot(x, y, colour);
		}
	}
*/
