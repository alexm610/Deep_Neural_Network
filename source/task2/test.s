main:
    movia r3, 0x00001010
    movia r4, 0x08000000
    movui r2, 0x00
    stw r2, 0(r3)
loop:
    addi r4, r4, 1
    ldbio r5, 0(r4)
    stw r5, 0(r3)
    beq zero, zero, loop