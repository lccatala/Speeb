.include "keyboard.h.s"

.globl cpct_scanKeyboard_asm
.globl cpct_isKeyPressed_asm

keyboard_space_state: .db #keyboard_not_pressed_state

;;CALL EACH GAME CYCLE!!!
;;DESTROYS: AF, BC, DE, HL
keyboard_update::
    call    cpct_scanKeyboard_asm

    ;; is key pressed?
    ld      hl, #keyboard_space
    call keyboard_update_space_state
    ret

;; This function may be called more than once (to assign different keys to the same state)
;; Using the macro directly would be wasting lots of mem
;;INPUT:
;;  HL:         key code
;;DESTROYS: AF, BC, DE, HL
keyboard_update_space_state:
    keyboard_update_state keyboard_space_state
    ret

;;RETURNS:
;;  z if space is set at just pressed, nz otherwise
;;DESTROYS: AF
keyboard_check_space_just_pressed::
    keyboard_check_key_value #keyboard_space_state, #keyboard_just_pressed_state
    ret
