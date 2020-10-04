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

string: .asciz "You died! Press SPACE to restart";

game_level_speed:: .db #-1 ;; This has to be at -1 or the enemy won't restart to the right of the screen

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
   
	call	keyboard_check_key_space_just_pressed
   jr    nz,   game_loop ;;if collision==0
   call  render_clean

   ld    d, #0         ;; D = Background PEN (0)
   ld    e, #1         ;; E = Foreground PEN (3)
   call cpct_setDrawCharM1_asm
   ld   de, #0xC000
   ld    b, #0x85
   ld    c, #8
   call cpct_getScreenPtr_asm
   ld   iy, #string
   call cpct_drawStringM1_asm

   game_loop_death:
      call  keyboard_update
	   call	keyboard_check_key_space_just_pressed
      jr    nz,   game_loop_death
   call  render_clean
   call  render_init
   jr    game_loop    
   ret