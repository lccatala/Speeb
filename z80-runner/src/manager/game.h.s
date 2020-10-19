.module game

.globl game_level_speed
.globl game_init
.globl game_loop

;; Game has ended. Add a bit of delay and write a final message (for either death or victory)
;;INPUT:
;;  _MESSAGE: can be **, (**)
;;DESTROYS: AF, BC, DE, HL, IY
.macro game_end _MESSAGE
    ;; Waits a bit so you see what you did!
    ld a, #25
    call game_wait_cycles

    call  render_clean

    ;; Final message is written
    render_draw_text_at #0x08, #0x85, #0, #1, #_MESSAGE
.endm