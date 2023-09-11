main:
    movui r2, 0xaa
    movui r3, 0x0010
    stwio r2, 0(r3)
loop:
    beq zero, zero, loop