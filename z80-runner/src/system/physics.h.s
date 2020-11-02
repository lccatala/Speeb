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

.module	physics

.globl physics_main_player_dashing
.globl physics_main_player_dashing_double
.globl physics_collision_detected
.globl physics_update
.globl physics_action_jump
.globl physics_action_dodge_left
.globl physics_action_dodge_right

.globl physics_current_speed
.globl physics_current_spawning_x
.globl physics_load_level

physics_ground_level              = 0xA0
physics_jump_initial_speed        = -10
physics_dodge_initial_speed_left  = -3
physics_dodge_initial_speed_right = 3
physics_dodge_initial_x_coord     = 12
physics_dodge_limit_x_coord_left  = 4
physics_dodge_limit_x_coord_right = 20

physics_dashing_no  = 0x00
physics_dashing     = 0x01

physics_collision_no                = 0x00
physics_collision_with_enemy        = 0x01
physics_collision_with_end          = 0x10

;;INPUT:
;;  _COORD_OFFSET:  offset of entity coordinate, can be **
;;  _SIZE_OFFSET:   offset of entity axis-dependant size (height/width), can be **
;;  _START_ENTITY:  entity who's start is being checked, can be ix, iy
;;  _END_ENTITY:    entity who's end is being checked, can be ix, iy
;;DESTROYS: AF
.macro physics_ret_if_start_lesser_end _COORD_OFFSET, _SIZE_OFFSET, _START_ENTITY, _END_ENTITY
    ld	a,	_COORD_OFFSET(_END_ENTITY)
    add _SIZE_OFFSET(_END_ENTITY)
    sub	_COORD_OFFSET(_START_ENTITY)
    ret m ;;if substraction is negative, endIX < startIY
.endm