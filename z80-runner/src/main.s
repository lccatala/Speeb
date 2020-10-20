.include "cpctelera.h.s"
.include "manager/game.h.s"
.include "manager/menu.h.s"

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm

_main::
   call     cpct_disableFirmware_asm
   call     menu_show_title_screen ;;handle here the menu output (maybe call other menus and do stuff)
   call     game_init
   jp       game_loop
