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

.include "level.h.s"
.include "utility/general.h.s"
.include "system/physics.h.s"
.include "entity.h.s"
.include "macros/cpct_undocumentedOpcodes.h.s"

level_current:: .dw #level_no_next_level

level_first_name: .asciz "LEVEL 1"
level_first_advice: .asciz "Jump!"
level_first::
    level_create_header #-1, #3, #level_second, #level_first_name, #level_first_advice
    
    level_add_spawn #entity_prototype_plant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #110, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #160, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #200, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #250, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #15, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #50, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #80, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #110, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #140, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #190, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #220, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #240, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #10, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #15, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #60, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #2, #150, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #2, #190, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #220, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #225, #physics_ground_level



    level_end

level_second_name: .asciz "LEVEL 2"
level_second_advice: .asciz "Dodge!"
level_second::
    level_create_header #-1, #4, #level_third, #level_second_name, #level_second_advice
    level_add_spawn #entity_prototype_cloud_enemy, #0, #100, #30
    level_add_spawn #entity_prototype_plant_enemy, #0, #170, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #190, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #220, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #1, #30, #30
    level_add_spawn #entity_prototype_plant_enemy, #1, #80, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #105, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #130, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #1, #170, #30
    level_add_spawn #entity_prototype_plant_enemy, #1, #170, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #225, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #250, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #20, #30
    level_add_spawn #entity_prototype_cloud_enemy, #2, #70, #30
    level_add_spawn #entity_prototype_plant_enemy, #2, #140, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #145, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #150, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #2, #185, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #2, #190, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #220, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #250, #30
    level_add_spawn #entity_prototype_cloud_enemy, #3, #10, #30
    level_add_spawn #entity_prototype_cloud_enemy, #3, #30, #30
    level_add_spawn #entity_prototype_plant_enemy, #3, #70, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #3, #120, #30
    level_add_spawn #entity_prototype_plant_enemy, #3, #150, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #190, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #3, #200, #30
    level_add_spawn #entity_prototype_plant_enemy, #3, #230, #physics_ground_level
    level_end

level_third_name: .asciz "LEVEL 3"
level_third_advice: .asciz "Is it a bird?"
level_third::
    level_create_header #-1, #4, #level_fourth, #level_third_name, #level_third_advice
    level_add_spawn #entity_prototype_bird_enemy, #0, #120, #30
    level_add_spawn #entity_prototype_bird_enemy, #0, #160, #80
    level_add_spawn #entity_prototype_bird_enemy, #0, #200, #130
    level_add_spawn #entity_prototype_bird_enemy, #0, #240, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #10, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #45, #120
    level_add_spawn #entity_prototype_cloud_enemy, #1, #80, #30
    level_add_spawn #entity_prototype_bird_enemy, #1, #140, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #1, #170, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #190, #physics_ground_level-30
    level_add_spawn #entity_prototype_bird_enemy, #1, #215, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #240, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #10, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #15, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #20, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #60, #30
    level_add_spawn #entity_prototype_bird_enemy, #2, #100, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #2, #110, #physics_ground_level-10
    level_add_spawn #entity_prototype_bird_enemy, #2, #115, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #170, #30
    level_add_spawn #entity_prototype_cloud_enemy, #2, #210, #30
    level_add_spawn #entity_prototype_cloud_enemy, #2, #220, #30
    level_add_spawn #entity_prototype_largeplant_enemy, #3, #5, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #30, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #60, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #65, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #70, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #3, #120, #physics_ground_level-20
    level_add_spawn #entity_prototype_largeplant_enemy, #3, #170, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #3, #200, #30
    level_add_spawn #entity_prototype_bird_enemy, #3, #220, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #3, #250, #physics_ground_level-30
    level_end


level_fourth_name: .asciz "LEVEL 4"
level_fourth_advice: .asciz "Is it a bat?"
level_fourth::
    level_create_header #-1, #4, #level_fifth, #level_fourth_name, #level_fourth_advice
    level_add_spawn #entity_prototype_bird_enemy, #0, #120, #30
    level_add_spawn #entity_prototype_bird_enemy, #0, #160, #80
    level_add_spawn #entity_prototype_bird_enemy, #0, #200, #130
    level_add_spawn #entity_prototype_bird_enemy, #0, #240, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #10, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #45, #120
    level_add_spawn #entity_prototype_cloud_enemy, #1, #80, #30
    level_add_spawn #entity_prototype_bird_enemy, #1, #140, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #1, #170, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #190, #physics_ground_level-30
    level_add_spawn #entity_prototype_bird_enemy, #1, #215, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #240, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #10, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #15, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #20, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #60, #30
    level_add_spawn #entity_prototype_bird_enemy, #2, #100, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #2, #110, #physics_ground_level-10
    level_add_spawn #entity_prototype_bird_enemy, #2, #115, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #170, #30
    level_add_spawn #entity_prototype_cloud_enemy, #2, #210, #30
    level_add_spawn #entity_prototype_cloud_enemy, #2, #220, #30
    level_add_spawn #entity_prototype_largeplant_enemy, #3, #5, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #30, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #60, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #65, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #70, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #3, #110, #physics_ground_level-20
    level_add_spawn #entity_prototype_largeplant_enemy, #3, #170, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #3, #200, #30
    level_add_spawn #entity_prototype_bird_enemy, #3, #220, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #3, #250, #physics_ground_level-30
    level_end

level_fifth_name: .asciz "LEVEL 5"
level_fifth_advice: .asciz "Is this speeding up?"
level_fifth::
    level_create_header #-2, #5, #level_sixth, #level_fifth_name, #level_fifth_advice

    level_add_spawn #entity_prototype_cloud_enemy, #0, #80, #30
    level_add_spawn #entity_prototype_bird_enemy, #0, #180, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #0, #220, #physics_ground_level-30
    level_add_spawn #entity_prototype_plant_enemy, #0, #250, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #50, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #100, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #150, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #180, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #2, #20, #physics_ground_level
    level_add_spawn #entity_prototype_bat_enemy, #2, #80, #30
    level_add_spawn #entity_prototype_plant_enemy, #3, #20, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #30, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #40, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #50, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #3, #180, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #3, #240, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #4, #80, #physics_ground_level-40
    level_add_spawn #entity_prototype_largeplant_enemy, #4, #170, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #4, #180, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #4, #230, #physics_ground_level
    level_end

level_sixth_name: .asciz "LEVEL 6"
level_sixth_advice: .asciz "Nah, just kidding"
level_sixth::
    level_create_header #-1, #3, #level_seventh, #level_sixth_name, #level_sixth_advice
    level_add_spawn #entity_prototype_plant_enemy, #0, #80, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #100, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #160, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #190, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #0, #250, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #15, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #50, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #70, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #110, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #130, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #200, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #210, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #240, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #0, #30
    level_add_spawn #entity_prototype_plant_enemy, #2, #10, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #15, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #20, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #2, #60, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #2, #150, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #2, #180, #physics_ground_level
    level_add_spawn #entity_prototype_cloud_enemy, #2, #200, #30
    level_end

level_seventh_name: .asciz "LEVEL 7"
level_seventh_advice: .asciz "Unless..."
level_seventh::
    level_create_header #-2, #6, #level_no_next_level, #level_seventh_name, #level_seventh_advice
    level_add_spawn #entity_prototype_largeplant_enemy, #0, #160, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #0, #200, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #80, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #90, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #1, #100, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #120, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #1, #130, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #1, #170, #physics_ground_level-20
    level_add_spawn #entity_prototype_bat_enemy, #1, #210, #30
    level_add_spawn #entity_prototype_cloud_enemy, #2, #20, #30
    level_add_spawn #entity_prototype_bird_enemy, #2, #140, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #2, #200, #physics_ground_level-30
    level_add_spawn #entity_prototype_cloud_enemy, #2, #250, #30
    level_add_spawn #entity_prototype_plant_enemy, #3, #40, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #50, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #60, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #3, #100, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #3, #110, #50
    level_add_spawn #entity_prototype_largeplant_enemy, #3, #180, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #3, #190, #physics_ground_level
    level_add_spawn #entity_prototype_largeplant_enemy, #3, #200, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #3, #250, #physics_ground_level
    level_add_spawn #entity_prototype_plant_enemy, #4, #20, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #4, #100, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #4, #120, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #4, #180, #physics_ground_level-30
    level_add_spawn #entity_prototype_bat_enemy, #4, #180, #30
    level_add_spawn #entity_prototype_bird_enemy, #5, #0, #physics_ground_level-20
    level_add_spawn #entity_prototype_bird_enemy, #5, #30, #physics_ground_level
    level_add_spawn #entity_prototype_bird_enemy, #5, #50, #physics_ground_level-20
    level_add_spawn #entity_prototype_bat_enemy, #5, #130, #30
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
