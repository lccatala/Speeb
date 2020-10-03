.include "player.h.s"

;;NOTE: reconsider whether this being public is a good idea
player_main:: player_define

player_init::
    player_fill #player_main, #10, #0x10, #0x88
    ret

player_update:
    ret