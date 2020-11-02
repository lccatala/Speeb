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

.include "grassfield.h.s"
.include "macros/cpct_undocumentedOpcodes.h.s"

.globl cpct_getRandom_mxor_u8_asm

grassfield_grass_array:: grass_define_array #grass_max
grassfield_next_grass: .dw #grassfield_grass_array

grassfield_advance_count:: .db #grassfield_space_between_grass
grassfield_advance_offset:: .db #0x00

grassfield_next_y_coord:: .db #0xA4

;;A4 A8 AC B0 B4 B8 BC C0
;;4 y C
grassfield_change_next_y:

    call cpct_getRandom_mxor_u8_asm
    ld a, l
    and #0x07

    cp #0x00
    jr nz, grassfield_change_next_y_1
        ld a, #0xA4
        ld (grassfield_next_y_coord), a
        ret
    grassfield_change_next_y_1:

    cp #0x01
    jr nz, grassfield_change_next_y_2
        ld a, #0xA8
        ld (grassfield_next_y_coord), a
        ret
    grassfield_change_next_y_2:

    cp #0x02
    jr nz, grassfield_change_next_y_3
        ld a, #0xAC
        ld (grassfield_next_y_coord), a
        ret
    grassfield_change_next_y_3:

    cp #0x03
    jr nz, grassfield_change_next_y_4
        ld a, #0xB0
        ld (grassfield_next_y_coord), a
        ret
    grassfield_change_next_y_4:

    cp #0x04
    jr nz, grassfield_change_next_y_5
        ld a, #0xB4
        ld (grassfield_next_y_coord), a
        ret
    grassfield_change_next_y_5:

    cp #0x05
    jr nz, grassfield_change_next_y_6
        ld a, #0xB8
        ld (grassfield_next_y_coord), a
        ret
    grassfield_change_next_y_6:
    
    cp #0x06
    jr nz, grassfield_change_next_y_7
        ld a, #0xBC
        ld (grassfield_next_y_coord), a
        ret

    grassfield_change_next_y_7:
        ld a, #0xC0
        ld (grassfield_next_y_coord), a
        ret

grassfield_init::
    ld hl, #grassfield_advance_count
    ld (hl), #grassfield_space_between_grass

    ld hl, #grassfield_advance_offset
    ld (hl), #0x00

    call grassfield_clean_grass_array

    grassfield_init_loop:
    call grassfield_create_grass

    ld hl, #grassfield_advance_offset
    ld a, #grassfield_space_between_grass
    add a, (hl)
    cp #0x50
	;; 0x50<=a means it got out of the level
    jr nc, grassfield_init_end

    ld (grassfield_advance_offset), a
    jr grassfield_init_loop
    
    grassfield_init_end:

    ld hl, #grassfield_advance_offset
    ld (hl), #0x00

    ret

grassfield_for_all_grass::
    ld (grassfield_for_all_grass_call), hl
    ld ix, (grassfield_next_grass)

    grassfield_for_all_grass_loop:
        ld a, #grassfield_grass_array
        cp__ixl
        ret z

        ld bc, #-grass_size
        add ix, bc
        push ix
        grassfield_for_all_grass_call = .+1
        call #0xABAC
        pop ix

        jr grassfield_for_all_grass_loop

grassfield_clean_grass_array:
    ld hl, #grassfield_grass_array
    ld (grassfield_next_grass), hl
    ret

grassfield_destroy_grass_if_dead:
    xor a
    cp grass_is_dead(ix)
    ret z
grassfield_destroy_grass:
    ld__d_ixh
    ld__e_ixl
    ld hl, (grassfield_next_grass)
    ld bc, #-grass_size
    add hl, bc
    ld bc, #grass_size
    ldir
    ld hl, (grassfield_next_grass)
    ld bc, #-grass_size
    add hl, bc
    ld (grassfield_next_grass), hl
    ret

grassfield_create_grass:
    ld a, (grassfield_next_grass)
    ld hl, #grassfield_next_grass
    cp l
    ld de, #0x0000
    ret z

    ld hl, (grassfield_next_grass)
    ld de, #grass_size
    add hl, de
    ld de, (grassfield_next_grass)

    push hl
    ld__ixh_d
    ld__ixl_e
    ld a, #0x4D
    ld hl, #grassfield_advance_offset
    sub (hl)
    ld grass_is_dead(ix), #0x00
    ld grass_x_coord(ix), a
    ld a, (grassfield_next_y_coord)
    ld grass_y_coord(ix), a
    ld grass_last_screen_h(ix), #0x00
    ld grass_last_screen_l(ix), #0x00

    call grassfield_change_next_y
    pop hl
    
    ld (grassfield_next_grass), hl
    ret

grassfield_update::
    ld hl, #grassfield_destroy_grass_if_dead
    call grassfield_for_all_grass

    ;;if count is 0, reset and spawn a new one
    xor a
    ld hl, #grassfield_advance_count
    cp (hl)
    ret nz
    
    call grassfield_create_grass

    ld hl, #grassfield_advance_count
    ld (hl), #grassfield_space_between_grass

    ret