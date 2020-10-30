.include "sound.h.s"

.globl _song_menu
.globl _song_victory
.globl cpct_akp_musicInit_asm
.globl cpct_akp_musicPlay_asm
.globl cpct_waitVSYNC_asm

sound_int_counter: .db 06
sound_int_handler::
   push af
   push bc
   push de
   push hl
   
   ld a, (sound_int_counter)
   dec a
   jr  nz, sound_int_handler_continue

   sound_int_handler_counter_zero:
      call  cpct_akp_musicPlay_asm
      ld    a, #6

   sound_int_handler_continue:
      ld (sound_int_counter), a

   pop hl
   pop de
   pop bc
   pop af

   ei
reti

;; Add a call to int_handler in the interruptions vector
;; BREAKS: HL
sound_set_int_handler:
   ld hl, #0x38
   ld (hl), #0xc3
   inc hl
   ld (hl), #<sound_int_handler
   inc hl
   ld (hl), #>sound_int_handler
   inc hl
   ld (hl), #0xc9
ret

sound_play_victory_theme::
   ld    de, #_song_victory
   call  cpct_akp_musicInit_asm
ret

sound_play_menu_theme::
   ld    de, #_song_menu
   call  cpct_akp_musicInit_asm
ret 
;; Set up interruption handler for playing SFX and load title song
;; BREAKS: HL
sound_init::
    call  sound_set_int_handler
ret