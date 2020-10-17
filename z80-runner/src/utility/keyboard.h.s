.globl keyboard_update
.globl keyboard_check_space_just_pressed
.globl keyboard_check_enter_just_pressed
.globl keyboard_check_a_just_pressed
.globl keyboard_check_d_just_pressed

keyboard_not_pressed_state = 0x00
keyboard_pressed_state = 0x01
keyboard_just_pressed_state = 0x02

keyboard_space = 0x8005
keyboard_enter = 0x4000
keyboard_a     = 0x2008
keyboard_d     = 0x2007

;;INPUT:
;;  _KEY:   adress to the key state direction, can be **
;;  _VALUE: value to check, can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;RETURNS:
;;  z if _KEY is set at _VALUE, nz otherwise
;;DESTROYS: AF
.macro keyboard_check_key_value _KEY, _VALUE
    ld a, (_KEY)
    cp _VALUE
.endm

;;INPUT:
;;  HL:         key code
;;  _OUTPUT:    state byte for the key/set of keys, can be **
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