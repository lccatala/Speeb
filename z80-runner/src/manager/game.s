.module game
.include "game.h.s"

.include "manager/entity.h.s"
.include "system/render.h.s"
.include "system/physics.h.s"
.include "utility/keyboard.h.s"

.globl cpct_waitVSYNC_asm

game_level_speed:: .db #-1 ;; This has to be at -1 or the enemy won't restart to the right of the screen
game_collision_detected:: .db #0x00

game_init::
    call     entity_init
    call     render_init
    ret

game_loop::
   call     keyboard_update
   call     physics_update
   call     render_update
   
   ;; 50/3 FPS? fix
   .rept 2
      halt
      halt
      call     cpct_waitVSYNC_asm
   .endm
   
    jr          game_loop
    ret