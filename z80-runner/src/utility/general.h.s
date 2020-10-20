.module general

.globl general_wait_cycles

.macro general_blank_bytes _N
    .rept _N
        .db #0xAA
    .endm
.endm
