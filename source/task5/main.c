#include <stdio.h>
#include "vga_plot.c"
volatile unsigned *vga = (volatile unsigned *) 0x00004000; /* VGA adapter base address */
volatile unsigned *wordcopy_acc = (volatile unsigned *) 0x00001040; /* Wordcopy module base address */
volatile unsigned *memory_location = (volatile unsigned *) 0x00008000;
#define STRING_LOCATION (char *) 0x00008000
unsigned char pixel_list[] = {
	#include "../../data/misc/pixels.txt"
};
unsigned char pixel_array[120][160];
unsigned char blurred_image[120][160];
unsigned char weights[5][5] = {	{1, 2, 4, 2, 1},
								{2, 4, 8, 4, 2,},
								{4, 8, 16, 8, 4},
								{2, 4, 8, 4, 2},
								{1, 2, 4, 2, 1}
};
unsigned num_pixels = sizeof(pixel_list)/2;
int main() {
	unsigned i, j, y, x, colour, pixel;

	//*(wordcopy_acc + 1) = (unsigned) 0x00008040;
    //*(wordcopy_acc + 2) = (unsigned) 0x00008000;
    //*(wordcopy_acc + 3) = (unsigned) 1;
    *wordcopy_acc = 1; /* start */
    *wordcopy_acc; /* make sure the accelerator is finished */

	*memory_location = 0xAAAAAAAA;
	// VGA Blurred dog printing 
	for (y = 0; y < 120; y++) {
		for (x =0; x < 160; x++) {
			vga_plot(x, y, 0);
		}
	}


	

	//INITIAL ALGORITHM 
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


/*	
	// VGA Blurred dog printing 
	for (y = 0; y < 120; y++) {
		for (x =0; x < 160; x++) {
			vga_plot(x, y, 0);
			pixel_array[y][x] = 0;
			blurred_image[y][x] = 0;
		}
	}

	pixel = 0;
	while (pixel <= num_pixels) {
		x = pixel_list[2*pixel];
		y = pixel_list[2*pixel+1];

		pixel_array[y][x] = 1;
		pixel++;
	}
	/*
	pixel = 0;
	for (x = 0; x < 160; x++) {
		for (y = 0; y < 120; y++) {
			for (i = 0; i < 5; i++) {
				for (j = 0; j < 5; j++) {
					blurred_image[y][x] += weights[i][j] * pixel_array[y+i-3][x+j-3];
				}
			}
		}
	}

	for (y = 0; y < 120; y++) {
		for (x =0; x < 160; x++) {
			vga_plot(x, y, (255*pixel_array[y][x]));
		}
	}




*/