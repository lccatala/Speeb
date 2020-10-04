.include "keyboard.h.s"

.globl cpct_scanKeyboard_asm
.globl cpct_isKeyPressed_asm

keyboard_key_space_state: .db #keyboard_not_pressed_state

;;CALL EACH GAME CYCLE!!!
;;DESTROYS: AF, BC, DE, HL
keyboard_update::
    call    cpct_scanKeyboard_asm

    ;; is key pressed?
    ld  hl, #keyboard_key_space
    call    cpct_isKeyPressed_asm
    jr  nz, keyboard_update_key_space_pressed

    ;; was key pressed before?
    ld  a,  (keyboard_key_space_state)
    cp  #keyboard_pressed_state
    jr  z,  keyboard_update_key_space_released ;; it was pressed

    keyboard_update_key_space_not_pressed:
        ld  a,  #keyboard_not_pressed_state
        ld  (keyboard_key_space_state), a
        jr  keyboard_update_key_space_continue

    keyboard_update_key_space_released:
        ld  a,  #keyboard_released_state
        ld  (keyboard_key_space_state), a
        jr  keyboard_update_key_space_continue

    keyboard_update_key_space_pressed:
        ld  a,  #keyboard_pressed_state
        ld  (keyboard_key_space_state), a

    keyboard_update_key_space_continue:
    ret

;;RETURNS:
;;  z if _KEY is set at _VALUE, nz otherwise
;;DESTROYS: AF
keyboard_check_key_space_released::
    keyboard_check_key_value #keyboard_key_space_state, #keyboard_released_state
    ret
