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
.include "manager/level.h.s"

;;INPUT
;; IX:      Level to load
;;DESTROYS: AF, BC, IX
game_load_level:
   call level_load
   ld  ix, (level_current)
   ld  b, level_header_speed(ix)
   ld  a, level_header_length(ix)
   call physics_load_level
   ret

;;DESTROYS: AF, BC, DE, HL, IX
game_init::
   call     entity_init
   call     render_init
   call     control_init

   ld  ix, #level_first
   call game_load_level
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

   ld    a, #1
   ld    (game_loop_physics), a
   call game_restart
   ret
game_loop_physics:
   .db      #0

;;DESTROYS: AF, BC, DE, HL, IX, IY
game_loop::
   ld       a, (game_loop_physics)
   cp       #0
   call     z, keyboard_update
   call     ai_control_update
   call     entity_update
   call     control_update
   ld       a, (game_loop_physics)
   xor      #1
   ld       (game_loop_physics), a
   call     z, physics_update
   call     render_update
   
   
   ;; Screen synchronization, the more repts, the more the game slows down
   ;; REDO!!! WE CANNOT WASTE CYCLES LIKE THIS!!! HALF THE FPS?
   ;; UPDATE PHYSICS ONCE FOR EVERY 2 CYCLES
   
   call game_check_end_conditions
   jr game_loop

game_restart:
   ;; After you press space screen gets cleaned and game is restarted
   call  render_clean
   call  game_init
   ret