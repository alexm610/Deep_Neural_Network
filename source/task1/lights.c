#define SWITCHES (volatile char*) 0x1810
#define LEDs     (char*)          0x1800

void main()
{
    while (1) {
        *LEDs = *SWITCHES;
    }
}