#define led (char *) 0x00000010
#define switches (volatile char *) 0x00000000
int main() {
    while(1) {
        *led = *switches;
    }
}