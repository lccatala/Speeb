.include "entity.h.s"
.include "system/ai_control.h.s"
.include "system/render.h.s"
.include "macros/cpct_undocumentedOpcodes.h.s"
.include "../system/physics.h.s"

;;NOTE: reconsider whether this being public is a good idea
entity_main_player:: entity_define
entity_end:: entity_define

entity_enemy_array:: entity_define_array #entity_max_enemies
entity_next_enemy: .dw #entity_enemy_array

entity_prototype_main_player: entity_create_prototype #0, #8, #16, #0x0000, _bunny_0
entity_prototype_basic_enemy: entity_create_prototype #0, #4, #32, #0x0000, _plant
entity_prototype_end: entity_create_prototype #0, #1, #64, #0x0000, _goal
entity_prototype_flying_enemy: entity_create_prototype #0, #16, #16, #ai_control_move_to_x, _cloud
;;entity_prototype_bomb_enemy:: entity_create_prototype #0, #0x01, #0x05, #0xFF, #0x0000, 



entity_init::
    ld de, #entity_main_player
    entity_instantiate_prototype #entity_prototype_main_player, #12, #physics_ground_level

    ld de, #entity_end
    entity_instantiate_prototype #entity_prototype_end, #75, #physics_ground_level

    call entity_clean_enemy_array

    call entity_create_enemy
    entity_instantiate_prototype #entity_prototype_basic_enemy, #70, #physics_ground_level
    
    ;;call entity_create_enemy
    ;;entity_instantiate_prototype #entity_prototype_basic_enemy, #60, #physics_ground_level

    call entity_create_enemy
    entity_instantiate_prototype #entity_prototype_flying_enemy, #40, #30

    
    ret

;; Applies a function to all enemies
;;INPUT:
;;  HL:     Pointer a function that recieves an entity on IX
;;DESTROYS: AF, BC, IX, whatever the called function destroys
entity_for_all_enemies::
    ld (entity_for_all_enemies_call), hl ; cambia la llamada a funcion
    ld ix, (entity_next_enemy)

    entity_for_all_enemies_loop:
        ;;ends if last byte of next free position is the same as last byte of entity array direction
        ;;size of enemy array!!!!!!!!!!! cannot be higher than 254
        ld a, #entity_enemy_array
        cp__ixl
        ret z

        ld bc, #-entity_size
        add ix, bc
        push ix
        entity_for_all_enemies_call = .+1
        call #0xABAC
        pop ix

        jr entity_for_all_enemies_loop

entity_clean_enemy_array:
    ld hl, #entity_next_enemy
    ld (hl), #entity_enemy_array
    ret

;;INPUT:
;;  IX:     pointer to entity that might be dead
;;DESTROYS: AF, BC, DE, HL, IX
entity_destroy_enemy_if_dead:
    xor a
    cp entity_is_dead(ix)
    ret z
entity_destroy_enemy:
    call render_entity_erase
    ld__d_ixh
    ld__e_ixl
    ld hl, (entity_next_enemy)
    ld bc, #-entity_size
    add hl, bc
    ld bc, #entity_size
    ldir
    ld hl, (entity_next_enemy)
    ld bc, #-entity_size
    add hl, bc
    ld (entity_next_enemy), hl
    ret

;;Reserves the space for a new enemy in the array
;;DESTROYS: AF, DE, HL
;;OUTPUT:
;;  DE:     new enemy address, is 0000 if full, check when creating!!!!
entity_create_enemy::
    ;;ends if last byte of next free position is the same as last byte of entity_next_enemy direction
    ;;size of enemy array!!!!!!!!!!! can not be higher than 254
    ld a, (entity_next_enemy)
    ld hl, #entity_next_enemy
    cp l
    ld de, #0x0000
    ret z

    ld hl, (entity_next_enemy)
    ld de, #entity_size
    add hl, de
    ld de, (entity_next_enemy)
    ld (entity_next_enemy), hl
    ret

;;BREAKS: AF, BC, DE, HL, IX
entity_update::
    ld hl, #entity_destroy_enemy_if_dead
    call entity_for_all_enemies
    ret