.include "cpctelera.h.s"
.include "manager/game.h.s"
.include "manager/menu.h.s"
.include "system/sound.h.s"


.globl cpct_setVideoMode_asm
.globl cpct_setPalette_asm
.globl _PALETTE

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm

_main::
   ld		c, #0 
	call	cpct_setVideoMode_asm
   cpctm_setBorder_asm 0x14
	ld		hl, #_PALETTE
	ld		de, #16
	call	cpct_setPalette_asm

   call     cpct_disableFirmware_asm
   call     game_init
   jp       game_loop
