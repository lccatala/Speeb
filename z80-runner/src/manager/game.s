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
.include "system/sound.h.s"
.include "manager/level.h.s"
.include "macros/cpct_undocumentedOpcodes.h.s"

;;INPUT
;; IX:      Level to load
;;DESTROYS: AF, BC, IX
game_load_level:
   push ix
   ;;if you load a level you restart the entities and the render
   call     entity_init
   call     render_init
   pop ix

   call level_load
   ld  ix, (level_current)
   ld  b, level_header_speed(ix)
   ld  a, level_header_length(ix)
   call physics_load_level
   ret

;;DESTROYS: AF, BC, DE, HL, IX
game_init::
   ;; This needs to be called here or we won't have sound in the title screen
   call     sound_init
   call     sound_play_menu_theme
   
   call     menu_title_screen ;;handle here the menu output (maybe call other menus and do stuff)

   call     control_init

   ld  ix, #level_first
   call game_load_level
   ret

game_win:
   call sound_play_victory_theme
   call menu_win_screen
   call game_restart
   ret

game_level_end:
   ld ix, (level_current)
   ld h, level_header_next_h(ix)
   ld l, level_header_next_l(ix)
   xor a
   cp  h
   jr  nz, game_level_end_next
   cp  l
   jr  nz, game_level_end_next
   call game_win
   ret

   game_level_end_next:
   ex de, hl
   ld__ixh_d
   ld__ixl_e
   call game_load_level
   ret


game_die:
   call sound_play_death_theme
   call menu_death_screen
   call game_restart
   ret

;; DESTROYS: A
game_check_end_conditions:
   ;; Collision with level end
	ld a, (physics_collision_detected)
   cp #physics_collision_with_end
   call z, game_level_end

   ;; Collision with enemy
	ld a, (physics_collision_detected)
   cp #physics_collision_with_enemy
   call z, game_die

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
   ;; REDO!!! WE CANNOT WASTE CYCLES LIKE THIS!!! HALF THE FPS?
   ;; UPDATE PHYSICS ONCE FOR EVERY 2 CYCLES
   
   call game_check_end_conditions
   jr game_loop

game_restart:
   ;; After you press space screen gets cleaned and game is restarted
   call  render_clean
   call  game_init
   ret