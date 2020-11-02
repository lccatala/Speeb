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

.include "keyboard.h.s"

.globl cpct_scanKeyboard_asm

keyboard_space_state: .db #keyboard_not_pressed_state
keyboard_enter_state: .db #keyboard_not_pressed_state
keyboard_a_state: .db #keyboard_not_pressed_state
keyboard_d_state: .db #keyboard_not_pressed_state

;;CALL EACH GAME CYCLE!!!
;;DESTROYS: AF, BC, DE, HL
keyboard_update::

    ;; is key pressed?
    keyboard_update_state #keyboard_space_state, #keyboard_space, #keyboard_shoot1
    
    keyboard_update_state #keyboard_a_state, #keyboard_a, #keyboard_left
    keyboard_update_state #keyboard_d_state, #keyboard_d, #keyboard_right
    ret

;; This function may be called more than once (to assign different keys to the same state)
;; Using the macro directly would be wasting lots of mem
;;INPUT:
;;  HL:         key code
;;DESTROYS: AF, BC, DE, HL
; keyboard_update_space_state:
;     keyboard_update_state keyboard_space_state
;     ret

;;RETURNS:
;;  z if space is set at just pressed, nz otherwise
;;DESTROYS: AF
keyboard_check_space_just_pressed::
    keyboard_check_key_value #keyboard_space_state, #keyboard_just_pressed_state
    ret


;;RETURNS:
;;  z if enter is set at just pressed, nz otherwise
;;DESTROYS: AF
keyboard_check_enter_just_pressed::
    keyboard_check_key_value #keyboard_enter_state, #keyboard_just_pressed_state
    ret

;;RETURNS:
;;  z if a is set at just pressed, nz otherwise
;;DESTROYS: AF
keyboard_check_a_just_pressed::
    keyboard_check_key_value #keyboard_a_state, #keyboard_just_pressed_state
    ret

;;RETURNS:
;;  z if d is set at just pressed, nz otherwise
;;DESTROYS: AF
keyboard_check_d_just_pressed::
    keyboard_check_key_value #keyboard_d_state, #keyboard_just_pressed_state
    ret

;;RETURNS:
;;  z if a is set at just pressed, nz otherwise
;;DESTROYS: AF
keyboard_check_a_pressed::
    keyboard_check_key_value #keyboard_a_state, #keyboard_pressed_state
    ret

;;RETURNS:
;;  z if d is set at just pressed, nz otherwise
;;DESTROYS: AF
keyboard_check_d_pressed::
    keyboard_check_key_value #keyboard_d_state, #keyboard_pressed_state
    ret

;;RETURNS:
;;  z if a is set at not pressed, nz otherwise
;;DESTROYS: AF
keyboard_check_a_not_pressed::
    keyboard_check_key_value #keyboard_a_state, #keyboard_not_pressed_state
    ret

;;RETURNS:
;;  z if d is set at not pressed, nz otherwise
;;DESTROYS: AF
keyboard_check_d_not_pressed::
    keyboard_check_key_value #keyboard_d_state, #keyboard_not_pressed_state
    ret

;;RETURNS:
;;  z if a is set at just released, nz otherwise
;;DESTROYS: AF
keyboard_check_a_just_released::
    keyboard_check_key_value #keyboard_a_state, #keyboard_just_released_state
    ret

;;RETURNS:
;;  z if d is set at just released, nz otherwise
;;DESTROYS: AF
keyboard_check_d_just_released::
    keyboard_check_key_value #keyboard_d_state, #keyboard_just_released_state
    ret