.include "grassfield.h.s"
.include "macros/cpct_undocumentedOpcodes.h.s"

grassfield_grass_array:: grass_define_array #grass_max
grassfield_next_grass: .dw #grassfield_grass_array

grassfield_advance_count:: .db #grassfield_space_between_grass
grassfield_advance_offset:: .db #0x00

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
    ld grass_y_coord(ix), #0xA4
    ld grass_last_screen_h(ix), #0x00
    ld grass_last_screen_l(ix), #0x00
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