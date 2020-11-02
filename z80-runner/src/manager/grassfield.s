.include "grassfield.h.s"

grassfield_grass:: grass_define

grassfield_init::
    ld  ix, #grassfield_grass
    ld grass_is_dead(ix), #0x00
    ld grass_x_coord(ix), #0x4D
    ld grass_y_coord(ix), #0xA4
    ld grass_last_screen_h(ix), #0x00
    ld grass_last_screen_l(ix), #0x00
    ret
