.include "level.h.s"
.include "utility/general.h.s"
.include "system/physics.h.s"
.include "entity.h.s"
.include "macros/cpct_undocumentedOpcodes.h.s"

level_current: .dw level_first
level_first::
    level_create_header #-1, #1
    level_add_spawn #entity_prototype_basic_enemy, #0, #60, #physics_ground_level
    level_add_spawn #entity_prototype_flying_enemy, #0, #30, #13
    level_end

level_next_spawn_pointer: .dw #0x0000

;;INPUT
;;  IX:     level to charge
;;DESTROYS: AF, BC, IX
level_load::
    ld  (level_current), ix
    ld  bc, #level_spawn_start
    add ix, bc
    ld  (level_next_spawn_pointer), ix
    ret


;;Checks if the spawn pointed is in the section+x coord providad
;;If it is, it moves the pointer, and checks again
;;If the spawn prototype is #0x0000, it ends 
;;INPUT
;;  B:      SECTION
;;  C:      X_COORD
;;  IX:     FUNCTION TO CALL
;;DESTROYS: AF, DE, IX
level_for_all_spawns_in::
	ld__d_ixl
	ld__e_ixh
    ex  de, hl
	ld (level_for_all_spawns_in_call), hl
    ex  de, hl ;; leave hl as it was

    ;; Exits if its the end of the spawn list
    ld  ix, (level_next_spawn_pointer)
    level_for_all_spawns_dont_load_function:
	xor	a
	cp	level_spawn_prototype_h(ix)
	jr	nz, level_for_all_spawns_in_valid
	cp	level_spawn_prototype_l(ix)
    ret

    level_for_all_spawns_in_valid:
    ld a, b
    cp  level_spawn_section(ix)
    ret nz ;;if not the section, does nothing
    ld a, c
    cp  level_spawn_x(ix)
    ret nz ;;if not the x_coord, does nothing

    ;; input shouldn't change
    push bc
    
    ;; call the function
    level_for_all_spawns_in_call = .+1
    call #0xABAC

    ;; advance the pointer
    ld  ix, (level_next_spawn_pointer)
    ld  bc, #level_spawn_size
    add ix, bc
    ld  (level_next_spawn_pointer), ix
    
    pop bc 

    jr level_for_all_spawns_dont_load_function
