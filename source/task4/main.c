#include <stdio.h>
#include "vga_plot.c"
volatile unsigned *vga = (volatile unsigned *) 0x00004000; /* VGA adapter base address */
#define STRING_LOCATION (char *) 0x00008000

unsigned char pixel_list[] = {
	#include "../../data/misc/pixels.txt"
};
unsigned num_pixels = sizeof(pixel_list)/2;

int main() {
	unsigned y, x, row, column, colour, i, j, pixel = 0;
	sprintf(STRING_LOCATION, "Hello World!");
	for (y = 0; y < 120; y++) {
		for (x =0; x < 160; x++) {
			vga_plot(x, y, 0);
		}
	}
	/*
		CONVOLUTION for greyscaling:
		Unfortunately, the pixel_list[] array doesn't list the pixel coordiante pairs in order, so for each pixel
		we must search through the WHOLE list for the adjacent pixels. 
	*/
	for (pixel=0; pixel<num_pixels; pixel++) {
		// get coordinates for first pixel from first pair in the pixel_list[] array
		x = pixel_list[2*pixel];
		y = pixel_list[2*pixel+1];
		// go through entire list of pixels...
		for (i=0; i<num_pixels; i++) {
			// check if pixel is two rows above or below
			if ((pixel_list[2*i] == x - 2) || (pixel_list[2*i] == x + 2)) {
				// check if it is within (-2) to (+2) columns of the main pixel
				if (pixel_list[2*i+1] == y - 2) {
					colour += 1;
				} else if (pixel_list[2*i+1] == y - 1) {
					colour += 2;
				} else if (pixel_list[2*i+1] == y) {
					colour += 4;
				} else if (pixel_list[2*i+1] == y + 1) {
					colour += 2;
				} else if (pixel_list[2*i+1] == y + 2) {
					colour += 1;
				}
			}
			// check if pixel is one row above or below
			if ((pixel_list[2*i] == x - 1) || (pixel_list[2*i] == x + 1)) {
				// check if it is within (-2) to (+2) columns of the main pixel
				if (pixel_list[2*i+1] == y - 2) {
					colour += 2;
				} else if (pixel_list[2*i+1] == y - 1) {
					colour += 4;
				} else if (pixel_list[2*i+1] == y) {
					colour += 8;
				} else if (pixel_list[2*i+1] == y + 1) {
					colour += 4;
				} else if (pixel_list[2*i+1] == y + 2) {
					colour += 2;
				}
			}
			// check if pixel is in same row
			if (pixel_list[2*i] == x) {
				// check if it is within (-2) to (+2) columns of the main pixel
				if (pixel_list[2*i+1] == y - 2) {
					colour += 4;
				} else if (pixel_list[2*i+1] == y - 1) {
					colour += 8;
				} else if (pixel_list[2*i+1] == y) {
					colour += 16;
				} else if (pixel_list[2*i+1] == y + 1) {
					colour += 8;
				} else if (pixel_list[2*i+1] == y + 2) {
					colour += 4;
				}
			}
		}
		vga_plot(x, y, (255*colour)/100);
		pixel++;
	}
}

/*
	ORIGINAL BLACK/WHITE PRINTING ALGORITHM

while (pixel <= num_pixels) {
		x = pixel_list[2*pixel];
		y = pixel_list[2*pixel+1];
		vga_plot(x, y, 255);
		pixel++;
	}


*/