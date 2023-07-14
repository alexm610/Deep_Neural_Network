#include <stdio.h>
#include "vga_plot.c"
volatile unsigned *vga = (volatile unsigned *) 0x00004000; /* VGA adapter base address */
volatile unsigned *wordcopy = (volatile unsigned *) 0x00001040; /* Wordcopy module base address */
#define STRING_LOCATION (char *) 0x00008000
unsigned char pixel_list[] = {
	#include "../../data/misc/pixels.txt"
};
unsigned num_pixels = sizeof(pixel_list)/2;
int main() {
	unsigned i, y, x, colour, pixel;
	
	// VGA Blurred dog printing 
	for (y = 0; y < 120; y++) {
		for (x =0; x < 160; x++) {
			vga_plot(x, y, 0);
		}
	}






	//THIS DOESN'T WORK AS WELL AS THE ORIGINAL because it doesn't shade pixels that are not already in the list
	pixel = 0;
	while (pixel <= num_pixels) {
		// iterate through entire list of pixels
			// as you iterate, check if any given pixel is equivalent to a position "near" the main pixel	
		colour = 0;	
		
		// get coordinate of current pixel
		x = pixel_list[2*pixel];
		y = pixel_list[2*pixel+1];	
		colour += 16; //we know this pixel exists, because it is in the list; so we automatically add full brightness to it

		i = 0;
		while (i <= num_pixels) {
			if (i == pixel) { // if the current pixel we are checking is equivalent to the main pixel we are looking at, skip it
				//i++;
				break;
			} else if ((pixel_list[2*i] == x - 2) || (pixel_list[2*i] == x + 2)) { // check if current pixel is two rows above/below the main pixel
				if ((pixel_list[2*i+1] == y - 2) || (pixel_list[2*i+1] == y + 2)) {
					colour += 1;
				} else if ((pixel_list[2*i+1] == y - 1) || (pixel_list[2*i+1] == y + 1)) {
					colour += 2;
				} else if (pixel_list[2*i+1] == y) {
					colour += 4;
				}
			} else if ((pixel_list[2*i] == x - 1) || (pixel_list[2*i] == x + 1)) {
				if ((pixel_list[2*i+1] == y - 2) || (pixel_list[2*i+1] == y + 2)) {
					colour += 2;
				} else if ((pixel_list[2*i+1] == y - 1) || (pixel_list[2*i+1] == y + 1)) {
					colour += 4;
				} else if (pixel_list[2*i+1] == y) {
					colour += 8;
				}
			} else if (pixel_list[2*i] == x) {
				if ((pixel_list[2*i+1] == y - 2) || (pixel_list[2*i+1] == y + 2)) {
					colour += 4;
				} else if ((pixel_list[2*i+1] == y - 1) || (pixel_list[2*i+1] == y + 1)) {
					colour += 8;
				}
			} 	
			i++;
		}
		vga_plot(x, y, (255*colour)/100);
		pixel++; // move to next pixel
	}
	

	/* //INITIAL ALGORITHM 
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
	} */
}