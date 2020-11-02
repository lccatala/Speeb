;; Speeb
;; Copyright (C) 2020  University of Alicante
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
