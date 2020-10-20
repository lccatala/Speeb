.module game
.include "game.h.s"

.include "manager/entity.h.s"
.include "system/render.h.s"
.include "manager/menu.h.s"
.include "system/physics.h.s"
.include "utility/keyboard.h.s"
.include "utility/general.h.s"
.include "system/control.h.s"
.include "system/ai_control.h.s"

.globl cpct_getScreenPtr_asm


game_level_speed:: .db #-1 ;; This has to be at -1 or the enemy won't restart to the right of the screen (end of screen detection problem)



;;DESTROYS: AF, BC, DE, HL, IX
game_init::
   call     entity_init
   call     render_init
   call     control_init
;;   call     ai_control_init
   ret

;; DESTROYS: A
game_check_end_conditions:
   ;; Collision with level end
	ld a, (physics_collision_detected)
   cp #physics_collision_with_end
   call z, menu_win_screen

   ;; Collision with enemy
	ld a, (physics_collision_detected)
   cp #physics_collision_with_enemy
   call z, menu_death_screen

	ld a, (physics_collision_detected)
   cp #physics_collision_no
   ret z

   call game_restart
   ret

;;DESTROYS: AF, BC, DE, HL, IX, IY
game_loop::
   
   call     keyboard_update
   call     ai_control_update
   call     entity_update
   call     control_update
   call     physics_update
   call     render_update
   
   
   ;; Screen synchronization, the more repts, the more the game slows down
   ld a, #2
   call general_wait_cycles
   
   call game_check_end_conditions
   jr game_loop

game_restart:
   ;; After you press space screen gets cleaned and game is restarted
   call  render_clean
   call  game_init
   ret