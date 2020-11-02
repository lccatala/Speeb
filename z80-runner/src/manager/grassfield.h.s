.module grassfield

.globl grassfield_init
.globl grassfield_grass

grass_x_coord       = 0
grass_y_coord       = grass_x_coord+1
grass_last_screen   = grass_y_coord+1
grass_last_screen_l = grass_last_screen
grass_last_screen_h = grass_last_screen+1
grass_size          = grass_last_screen+2

grass_max           = 10

.macro grass_define
    .rept #grass_size
        .db #0xAA
    .endm
.endm

.macro grass_define_array _N
    .rept #_N
        grass_define
    .endm
.endm
