.include "level.h.s"
.include "utility/general.h.s"
.include "system/physics.h.s"
.include "entity.h.s"
.include "macros/cpct_undocumentedOpcodes.h.s"

level_current:: .dw #level_no_next_level
level_first_name: .asciz "LEVEL 1"
level_first_advice: .asciz "Jump!"
level_first::
    level_create_header #-1, #1, #level_second, #level_first_name, #level_first_advice
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #140, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #180, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #240, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #70, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #100, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #130, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #160, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #190, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #230, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #130, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #160, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #190, #30
;    level_add_spawn #entity_prototype_bird_enemy, #2, #190, #30
;    level_add_spawn #entity_prototype_bat_enemy, #2, #190, #30
;    level_add_spawn #entity_prototype_cloud_enemy, #1, #50, #30
    level_end
level_second_name: .asciz "LEVEL 2"
level_second_advice: .asciz "Dodge!"
level_second::
    level_create_header #-1, #1, #level_third, #level_second_name, #level_second_advice
    level_add_spawn #entity_prototype_cloud_enemy, #0, #150, #30
    level_end
level_third_name: .asciz "There Is Only       Madness In This     Damned Hell"
level_third::
    level_create_header #-1, #1, #level_no_next_level, #level_third_name, #level_no_advice
    level_add_spawn #entity_prototype_cloud_enemy, #2, #190, #30
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
;;DESTROYS: AF, DE, HL, IX
level_for_all_spawns_in::
	ld__d_ixh
	ld__e_ixl
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
    ret z

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
