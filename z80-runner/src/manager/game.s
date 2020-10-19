.module game
.include "game.h.s"

.include "manager/entity.h.s"
.include "system/render.h.s"
.include "system/physics.h.s"
.include "utility/keyboard.h.s"
.include "system/control.h.s"

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
game_win_message:   .asciz "You won! Press SPACE to restart";

game_level_speed:: .db #-1 ;; This has to be at -1 or the enemy won't restart to the right of the screen (end of screen detection problem)

;;DESTROYS: AF, BC, DE, HL, IX
game_init::
   call     entity_init
   call     render_init
   call     control_init
   call     physics_init
   ret

;; DESTROYS: A
game_check_end_conditions:
   ;; If collision was not detected, game continues as usual
	ld a, (physics_collision_detected)

   ;; Collision with level end
   cp #0x10
   jr    z,   game_win

   ;; Collision with enemy
   cp #0x01
   jr    z,   game_death
   ret

;;DESTROYS: AF, BC, DE, HL, IX, IY
game_loop::
   call     keyboard_update
   call     control_update
   call     physics_update
   call     render_update
   
   ;; Screen synchronization, the more repts, the more the game slows down
   ld a, #2
   call game_wait_cycles
   
   call game_check_end_conditions
   jr game_loop

   ;; Game waits until you press space
   game_death:
      game_end game_death_message
      jr game_loop_restart

   game_win:
      game_end game_win_message

game_loop_restart:
   call  keyboard_update
   call	keyboard_check_space_just_pressed
   jr    nz,   game_loop_restart

game_restart:
   ;; After you press space screen gets cleaned and game is restarted
   call  render_clean
   call  game_init
   jr    game_loop