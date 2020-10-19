.include "cpctelera.h.s"
.include "manager/game.h.s"
.include "manager/menu.h.s"

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm

_main::
   call     cpct_disableFirmware_asm
   call     menu_init
   call     game_init
   jp       game_loop
