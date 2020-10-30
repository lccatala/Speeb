.include "cpctelera.h.s"
.include "manager/game.h.s"
.include "manager/menu.h.s"
.include "system/sound.h.s"

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPalette_asm
.globl _PALETTE

_main::
   call     cpct_disableFirmware_asm
   ld		c, #0 
	call	cpct_setVideoMode_asm
	cpctm_setBorder_asm	0x14
	ld		hl, #_PALETTE
	ld		de, #16
	call	cpct_setPalette_asm
   ;; This needs to be called here or we won't have sound in the title screen
   call     sound_init
   call     sound_play_menu_theme
   
   call     menu_title_screen ;;handle here the menu output (maybe call other menus and do stuff)
   call     game_init
   jp       game_loop
