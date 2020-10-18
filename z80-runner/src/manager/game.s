.module game
.include "game.h.s"

.include "manager/entity.h.s"
.include "system/render.h.s"
.include "system/physics.h.s"
.include "utility/keyboard.h.s"
.include "system/control.h.s"
.include "system/ai_control.h.s"

.globl cpct_waitVSYNC_asm
.globl cpct_getScreenPtr_asm

;;INPUT:
;; A: number of times to wait
;;DESTROYS: AF, BC
game_wait_cycles:
   halt
   halt
   push af
   call     cpct_waitVSYNC_asm
   pop af
   dec a
   jr nz, game_wait_cycles
   ret

game_death_message: .asciz "You died! Press SPACE to restart";

game_level_speed:: .db #-1 ;; This has to be at -1 or the enemy won't restart to the right of the screen (end of screen detection problem)

;;DESTROYS: AF, BC, DE, HL, IX
game_init::
   call     entity_init
   call     render_init
   call     control_init
   call     ai_control_init

   ret

;;DESTROYS: AF, BC, DE, HL, IX, IY
game_loop::
   call     keyboard_update
   call     ai_control_update
   call     control_update
   call     physics_update
   call     render_update
   call     entity_update
   
   ;; Screen synchronization, the more repts, the more the game slows down
   ld a, #2
   call game_wait_cycles
   
   ;; If collision was not detected, game continues as usual
	ld a, (physics_collision_detected)
   cp #0x00
   jr    z,   game_loop ;;if collision==0

   ;; Waits a bit so you see how you died!
   ld a, #25
   call game_wait_cycles

   ;; If collision was detected screen is cleaned 
   call  render_clean

   ;; Death message is written
   render_draw_text_at #0x08, #0x85, #0, #1, #game_death_message

   ;; Game waits until you press space
   game_loop_death:
      call  keyboard_update
	   call	keyboard_check_space_just_pressed
      jr    nz,   game_loop_death
   
   ;; After you press space screen cleaned and game is restarted
   call  render_clean
   call  game_init
   jr    game_loop