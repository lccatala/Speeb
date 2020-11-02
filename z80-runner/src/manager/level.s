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
    level_add_spawn #entity_prototype_plant_enemy, #0, #100, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #180, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #240, #physics_ground_level
    level_end

level_second_name: .asciz "LEVEL 2"
level_second_advice: .asciz "Keep jumping!"
level_second::
    level_create_header #-1, #1, #level_third, #level_second_name, #level_second_advice
    level_add_spawn #entity_prototype_plant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #120, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #180, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #220, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #250, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #270, #physics_ground_level

    level_end

level_third_name: .asciz "LEVEL 3"
level_third_advice: .asciz "Jump... more!"
level_third::
    level_create_header #-1, #1, #level_fourth, #level_third_name, #level_third_advice
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #100, #physics_ground_level
    level_end


level_fourth_name: .asciz "LEVEL 4"
level_fourth_advice: .asciz "Jump EVEN more!"
level_fourth::
    level_create_header #-1, #2, #level_fifth, #level_fourth_name, #level_fourth_advice
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #150, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #200, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #0, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #40, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #70, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #120, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #150, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #190, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #240, #physics_ground_level
    level_end

level_fifth_name: .asciz "LEVEL 5"
level_fifth_advice: .asciz "Dodge!"
level_fifth::
    level_create_header #-1, #1, #level_sixth, #level_fifth_name, #level_fifth_advice
    level_add_spawn #entity_prototype_cloud_enemy, #0, #160, #30
    level_end

level_sixth_name: .asciz "LEVEL 6"
level_sixth_advice: .asciz "Jump, then dodge!"
level_sixth::
    level_create_header #-1, #2, #level_seventh, #level_sixth_name, #level_sixth_advice
    level_add_spawn #entity_prototype_plant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #0, #160, #30
    level_add_spawn #entity_prototype_plant_enemy, #0, #230, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #10, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #1, #56, #30
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #100, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #1, #150, #30
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #200, #physics_ground_level
    level_end

level_seventh_name: .asciz "LEVEL 7"
level_seventh_advice: .asciz "Have you tried dodging while jumping?"
level_seventh::
    level_create_header #-1, #1, #level_eighth, #level_seventh_name, #level_seventh_advice
    level_add_spawn #entity_prototype_plant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #85, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #90, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #170, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #175, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #220, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #225, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #230, #physics_ground_level
    level_end

level_eighth_name: .asciz "LEVEL 8"
level_eighth_advice: .asciz "Just don't abuse it!"
level_eighth::
    level_create_header #-1, #1, #level_ninth, #level_eighth_name, #level_eighth_advice
    level_add_spawn #entity_prototype_plant_enemy, #0, #70, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #75, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #0, #150, #30
    level_end

level_ninth_name: .asciz "LEVEL 9"
level_ninth_advice: .asciz "Remember those big plants?"
level_ninth::
    level_create_header #-1, #1, #level_tenth, #level_ninth_name, #level_ninth_advice
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #120, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #125, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #200, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #205, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #210, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #0, #230, #30
    level_end

level_tenth_name: .asciz "LEVEL 10"
level_tenth_advice: .asciz "Dont't forget to look at the sky!"
level_tenth::
    level_create_header #-1, #4, #level_eleventh, #level_tenth_name, #level_tenth_advice
    level_add_spawn #entity_prototype_plant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #120, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #125, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #200, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #205, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #210, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #0, #230, #30
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #40, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #1, #80, #30
    level_add_spawn #entity_prototype_plant_enemy, #1, #250, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #20, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #80, #30
    level_add_spawn #entity_prototype_largeplant_enemy, #2, #120, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #2, #200, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #2, #205, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #20, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #25, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #30, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #3, #70, #30
    level_add_spawn #entity_prototype_cloud_enemy, #3, #150, #30
    level_add_spawn #entity_prototype_cloud_enemy, #3, #200, #30
    level_add_spawn #entity_prototype_cloud_enemy, #3, #230, #30
    level_end

level_eleventh_name: .asciz "LEVEL 11"
level_eleventh_advice: .asciz "Is it a bird?"
level_eleventh::
    level_create_header #-1, #2, #level_twelfth, #level_eleventh_name, #level_eleventh_advice
    level_add_spawn #entity_prototype_bird_enemy, #0, #70, #physics_ground_level-50
    level_add_spawn #entity_prototype_bird_enemy, #0, #110, #physics_ground_level-30
    level_add_spawn #entity_prototype_bird_enemy, #0, #140, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #0, #220, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #20, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #1, #80, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #120, #physics_ground_level-20
    level_add_spawn #entity_prototype_plant_enemy, #1, #130, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #180, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #1, #210, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #250, #physics_ground_level
    level_end

level_twelfth_name: .asciz "LEVEL 12"
level_twelfth_advice: .asciz "Too many birds"
level_twelfth::
    level_create_header #-1, #2, #level_thirteenth, #level_twelfth_name, #level_twelfth_advice
    level_add_spawn #entity_prototype_plant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #0, #100, #physics_ground_level-30
    level_add_spawn #entity_prototype_bird_enemy, #0, #150, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #0, #180, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #0, #210, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #0, #230, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #0, #250, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #1, #10, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #40, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #1, #50, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #90, #physics_ground_level-20
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #140, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #180, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #220, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #250, #physics_ground_level-20
    
    level_end

level_thirteenth_name: .asciz "LEVEL 13"
level_thirteenth_advice: .asciz "Is it a bat?"
level_thirteenth::
    level_create_header #-1, #2, #level_fourteenth, #level_twelfth_name, #level_twelfth_advice
    level_add_spawn #entity_prototype_bat_enemy, #0, #100, #30
    level_add_spawn #entity_prototype_plant_enemy, #1, #20, #physics_ground_level
    level_add_spawn #entity_prototype_bat_enemy, #1, #50, #30
    level_add_spawn #entity_prototype_bat_enemy, #1, #170, #30
    level_add_spawn #entity_prototype_bird_enemy, #1, #200, #physics_ground_level-40
    level_end

level_fourteenth_name: .asciz "LEVEL 14"
level_fourteenth_advice: .asciz "Yes"
level_fourteenth::
    level_create_header #-1, #2, #level_no_next_level, #level_twelfth_name, #level_fourteenth_advice
    level_add_spawn #entity_prototype_bat_enemy, #0, #80, #30
    level_add_spawn #entity_prototype_bird_enemy, #0, #120, #physics_ground_level-40
    level_add_spawn #entity_prototype_bird_enemy, #0, #250, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #20, #physics_ground_level-20
    level_add_spawn #entity_prototype_bat_enemy, #1, #30, #30
    level_add_spawn #entity_prototype_bat_enemy, #1, #170, #30
    level_add_spawn #entity_prototype_bird_enemy, #1, #200, #physics_ground_level-40
    level_add_spawn #entity_prototype_bat_enemy, #1, #200, #30
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
