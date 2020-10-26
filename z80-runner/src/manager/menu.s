.module menu

.include "menu.h.s"
.include "system/render.h.s"
.include "utility/keyboard.h.s"
.include "utility/general.h.s"
.include "img/screens/screenmenu_z.h.s"
.include "img/screens/screengameover_z.h.s"

.globl cpct_zx7b_decrunch_s_asm


menu_death_message:: .asciz "You died!          Press SPACE to        restart";

menu_win_message::   .asciz "You won! Press SPACE to restart";

menu_title_message_2: .asciz "Press SPACE to PLAY";

;; GIVING THEM A NAME WITHOUT REUSING THEM IS NOT ENOUGH


menu_title_message_2_x = 0x02
menu_title_message_2_y = 0xA0
menu_title_message_2_text_color = 1

menu_title_screen::

   ld 	hl, #_screenmenu_z_end
	ld		de, #0xFFFF
   call cpct_zx7b_decrunch_s_asm
   render_draw_message #menu_title_message_2_x, #menu_title_message_2_y, #0, #menu_title_message_2_text_color, #menu_title_message_2
   call menu_wait_space
   call render_clean
   ret

   ;; Game waits until you press space
menu_death_screen::
   ;; Waits a bit so you see hwo you died!
   ld a, #25
   call general_wait_cycles

	ld 	hl, #_screengameover_z_end
	ld		de, #0xFFFF
   call cpct_zx7b_decrunch_s_asm
   render_draw_message #0x12, #0xA2, #8, #1, #menu_death_message
   call menu_wait_space
   ret

menu_win_screen::
	call  render_clean
   render_draw_message #0x08, #0x85, #0, #1, #menu_win_message
   call menu_wait_space
   ret


;; Wait for player to press space
menu_wait_space:
   call  keyboard_update
   call	keyboard_check_space_just_pressed
   jr    nz,   menu_wait_space
ret