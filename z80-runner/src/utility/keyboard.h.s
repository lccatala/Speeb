.globl keyboard_update
.globl keyboard_check_key_space_released

keyboard_not_pressed_state = 0x00
keyboard_pressed_state = 0x01
keyboard_released_state = 0x02

keyboard_key_space = 0x8005

;;INPUT:
;;  _KEY:   adress to the key state direction
;;  _VALUE: value to check
;;RETURNS:
;;  z if _KEY is set at _VALUE, nz otherwise
;;DESTROYS: A
.macro keyboard_check_key_value _KEY, _VALUE
    ld a, (_KEY)
    cp _VALUE
.endm