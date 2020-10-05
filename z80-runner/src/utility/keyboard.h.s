.globl keyboard_update
.globl keyboard_check_space_just_pressed

keyboard_not_pressed_state = 0x00
keyboard_pressed_state = 0x01
keyboard_just_pressed_state = 0x02

keyboard_space = 0x8005

;;INPUT:
;;  _KEY:   adress to the key state direction
;;  _VALUE: value to check
;;RETURNS:
;;  z if _KEY is set at _VALUE, nz otherwise
;;DESTROYS: AF
.macro keyboard_check_key_value _KEY, _VALUE
    ld a, (_KEY)
    cp _VALUE
.endm

;;INPUT:
;;  HL:         key code
;;  _OUTPUT:    state byte for the key/set of keys
;;DESTROYS: AF, BC, DE, HL
.macro keyboard_update_state _OUTPUT
    call    cpct_isKeyPressed_asm
    jr      z,  .+2 +3+2+2 +3+3+2               ;; (jr not pressed)

    ;; was key pressed before?
    ld  a,  (_OUTPUT)                           ;;  3 bytes
    cp  #keyboard_not_pressed_state             ;;  2 bytes
    jr  z,  .+2 +2+3+2                          ;;  2 bytes (jr just pressed)

    ;;  pressed
        ld  a,  #keyboard_pressed_state         ;;  2 bytes
        ld  (_OUTPUT), a                        ;;  3 bytes
        jr  .+2 +2+3+2 +2+3                     ;;  2 bytes (jr continue)

    ;;  just_pressed
        ld  a,  #keyboard_just_pressed_state    ;;  2 bytes
        ld  (_OUTPUT), a                        ;;  3 bytes
        jr  .+2 +2+3                            ;;  2 bytes (jr continue)

    ;;  not_pressed
        ld  a,  #keyboard_not_pressed_state     ;;  2 bytes
        ld  (_OUTPUT), a                        ;;  3 bytes

    ;;  continue:
.endm