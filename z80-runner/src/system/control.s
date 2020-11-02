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
;;MUST NOT CHANGE Z FLAG
control_set_double:
    ld a, #physics_dashing
    ld (physics_main_player_dashing_double), a
    ret
;; #0x00 means no action
;;DESTROYS: AF, HL, IX
control_update::
    ld      ix, #entity_main_player
    ld      entity_next_action_l(ix),   #0x00
    ld      entity_next_action_h(ix),   #0x00
	call    keyboard_check_space_just_pressed
    jr      nz, control_update_check_dodge_left

    ld      hl, #physics_action_jump
    ld      entity_next_action_l(ix),   l
    ld      entity_next_action_h(ix),   h


control_update_check_dodge_left:
    call    keyboard_check_a_just_pressed
    jr      nz, control_update_check_dodge_right
    ld      a, (physics_main_player_dashing)
    cp      #0
    call    nz, control_set_double
    jr      nz, control_update_check_dodge_right
    ld      a, entity_x_speed(ix)
    cp      #0
    call    nz, control_set_double
    jr      nz, control_update_check_dodge_right
    

    ld      hl, #physics_action_dodge_left
    ld      entity_next_action_l(ix),   l
    ld      entity_next_action_h(ix),   h


control_update_check_dodge_right:
    call    keyboard_check_d_just_pressed
    jr      nz, control_update_check_return_right
    ld      a, (physics_main_player_dashing)
    cp      #0
    call    nz, control_set_double
    jr      nz, control_update_check_return_right
    ld      a, entity_x_speed(ix)
    cp      #0
    call    nz, control_set_double
    jr      nz, control_update_check_return_right
    
    ld      hl, #physics_action_dodge_right
    ld      entity_next_action_l(ix),   l
    ld      entity_next_action_h(ix),   h

control_update_check_return_right:
    call    keyboard_check_d_just_released
    jr      nz, control_update_check_return_left
    ld      a, (physics_main_player_dashing)
    cp      #1
    jr      nz, control_update_check_return_left

    ld      hl, #physics_action_dodge_left
    ld      entity_next_action_l(ix),   l
    ld      entity_next_action_h(ix),   h

control_update_check_return_left:
    call    keyboard_check_a_just_released
    ret     nz
    ld      a, (physics_main_player_dashing)
    cp      #1
    ret     nz


    ld      hl, #physics_action_dodge_right
    ld      entity_next_action_l(ix),   l
    ld      entity_next_action_h(ix),   h

    ret

    