.module game
.include "game.h.s"

.include "manager/entity.h.s"
.include "system/render.h.s"
.include "system/physics.h.s"
.include "utility/keyboard.h.s"

.globl cpct_waitVSYNC_asm
.globl cpct_setDrawCharM1_asm
.globl cpct_drawStringM1_asm
.globl cpct_getScreenPtr_asm

game_death_message: .asciz "You died! Press SPACE to restart";

game_level_speed:: .db #-1 ;; This has to be at -1 or the enemy won't restart to the right of the screen (end of screen detection problem)

;;DESTROYS: 
game_init::
    call     entity_init
    call     render_init
    ret

;;DESTROYS: 
game_loop::
   call     keyboard_update
   call     physics_update
   call     render_update
   
   ;; Screen synchronization, the more repts, the more the game slows down
   .rept 2
      halt
      halt
      call     cpct_waitVSYNC_asm
   .endm
   
   ;; If collision was not detected, game continues as usual
	ld a, (physics_collision_detected)
   cp #0x00
   jr    z,   game_loop ;;if collision==0

   ;; If collision was detected screen is cleaned 
   call  render_clean

   ;; Death message is written
   ld    d, #0 ;; background dark blue
   ld    e, #1 ;; letters yellow
   call cpct_setDrawCharM1_asm

   ld   de, #0xC000
   ld    b, #0x85
   ld    c, #8
   call cpct_getScreenPtr_asm

   ld   iy, #game_death_message
   call cpct_drawStringM1_asm

   ;; Game waits until you press space
   game_loop_death:
      call  keyboard_update
	   call	keyboard_check_space_just_pressed
      jr    nz,   game_loop_death
   
   ;; After you press space screen cleaned and game is restarted
   call  render_clean
   call  game_init
   jr    game_loop