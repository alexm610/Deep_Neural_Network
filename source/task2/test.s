main:
    addi r3, zero, 0x4
    addi r2, zero, 0x8000
    addi r1, zero, 0x89C0
    addi r7, zero, 0x1040

    stwio r1, 4(r7)
    stwio r2, 8(r7)
    stwio r3, 12(r7)
    stwio zero, 0(r7)
    ldw r4, 0(r7)
    ldwio r4, 0(r4)
loop:
    beq zero, zero, loop


