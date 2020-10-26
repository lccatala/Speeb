.module menu

.include "menu.h.s"
.include "system/render.h.s"
.include "utility/keyboard.h.s"
.include "utility/general.h.s"


menu_death_message:: .asciz "You died! Press SPACE to restart";

menu_win_message::   .asciz "You won! Press SPACE to restart";

menu_title_message_1: .asciz "RUNNING GAME";

menu_title_message_2: .asciz "[Press SPACE to PLAY]";

;; GIVING THEM A NAME WITHOUT REUSING THEM IS NOT ENOUGH

menu_title_message_1_x = 0x08
menu_title_message_1_y = 0x85
menu_title_message_1_text_color = 2

menu_title_message_2_x = 0x08
menu_title_message_2_y = 0xA0
menu_title_message_2_text_color = 1

menu_title_screen::
	call  render_clean
   render_draw_message #menu_title_message_1_x, #menu_title_message_1_y, #0, #menu_title_message_1_text_color, #menu_title_message_1
   render_draw_message #menu_title_message_2_x, #menu_title_message_2_y, #0, #menu_title_message_2_text_color, #menu_title_message_2
   call menu_wait_space
   call render_clean
   ret

   ;; Game waits until you press space
menu_death_screen::
   ;; Waits a bit so you see hwo you died!
   ld a, #25
   call general_wait_cycles

	call  render_clean
   render_draw_message #0x08, #0x85, #0, #1, #menu_death_message
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