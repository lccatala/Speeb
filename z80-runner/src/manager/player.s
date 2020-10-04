.include "player.h.s"

;;NOTE: reconsider whether this being public is a good idea
player_main:: player_define
;;_WIDTH, _HEIGHT, _COLOR
player_init::
    player_fill #player_main, #10, #4, #0x88, #0x02, #0x08, #0x0F
    ret

player_update:
    ret