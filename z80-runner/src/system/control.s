.include "control.h.s"
.include "physics.h.s"
.include "manager/entity.h.s"
.include "utility/keyboard.h.s"

control_init::
    ;;enemy jumps, hehe, funny
    ;;ld ix, #entity_enemy
    ;;ld      hl, #physics_action_jump
    ;;ld      entity_next_action_l(ix),   l
    ;;ld      entity_next_action_h(ix),   h
    ret

;; #0x00 means no action
;;DESTROYS: AF, HL, IX
control_update::
    ld      ix, #entity_main_player
    ld      entity_next_action_l(ix),   #0x00
    ld      entity_next_action_h(ix),   #0x00
	call    keyboard_check_space_just_pressed
    jr nz, control_update_check_shoot

    ld      hl, #physics_action_jump
    ld      entity_next_action_l(ix),   l
    ld      entity_next_action_h(ix),   h

control_update_check_shoot:
    call    keyboard_check_enter_just_pressed
    jr nz, control_update_check_dodge_left

    ld      hl, #physics_action_shoot
    ld      entity_next_action_l(ix),   l
    ld      entity_next_action_h(ix),   h

control_update_check_dodge_left:
    call    keyboard_check_a_just_pressed
    jr nz, control_update_check_dodge_right


    ld      hl, #physics_action_dodge_left
    ld      entity_next_action_l(ix),   l
    ld      entity_next_action_h(ix),   h

control_update_check_dodge_right:
    call    keyboard_check_d_just_pressed
    ret     nz

    ld      hl, #physics_action_dodge_right
    ld      entity_next_action_l(ix),   l
    ld      entity_next_action_h(ix),   h

    ret

    