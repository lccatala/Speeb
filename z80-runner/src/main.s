.include "cpctelera.h.s"
.include "manager/game.h.s"

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm

_main::
   call     cpct_disableFirmware_asm
   call     game_init
   jp       game_loop
