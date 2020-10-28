.include "render.h.s"
.include "cpctelera.h.s"
.include "manager/entity.h.s"
.include "img/screens/screenbackground_z.h.s"

;;DESTROYS: AF, BC, DE, HL
render_clean:
	render_draw_solid_box_at #0x00, #0x00, #0x00, #0x40, #0xC8
	render_draw_solid_box_at #0x40, #0x00, #0x00, #0x10, #0xC8
	ret

;;DESTROY: AF, BC, DE, HL
render_init::
	

	;(2B DE) dest_end	Ending (latest) byte of the destination (decompressed) array
	;(2B HL) source_end	Ending (latest) byte of the source (compressed) array
	;Assembly call (Input parameters on registers)
	ld 		hl, #_screenbackground_z_end
	ld		de, #0xFFFF
    call cpct_zx7b_decrunch_s_asm

	ret

render_entity_draw_xor_low::
	call_render_for_type render_entity_draw_xor, #render_type_xor_low

render_entity_draw_xor_high::
	call_render_for_type render_entity_draw_xor, #render_type_xor_high

;;Render the entity.
;;INPUT:   IX (entity) 
;;DESTROY: AF, BC, DE, HL 
render_entity_draw_xor::
	render_get_screen_pointer entity_x_coord(ix), entity_y_coord(ix)
	ld 		entity_last_screen_l(ix), l
	ld		entity_last_screen_h(ix), h
	ex		de, hl
	ld		l, entity_sprite_l(ix)
	ld		h, entity_sprite_h(ix)
	ld		b, entity_width(ix)
	ld		c, entity_height(ix)
	call	cpct_drawSpriteBlended_asm
	ret

render_entity_erase_xor_low::
	call_render_for_type render_entity_erase_xor, #render_type_xor_low

render_entity_erase_xor_high::
	call_render_for_type render_entity_erase_xor, #render_type_xor_high

;;Erase the last entity.
;;INPUT:   IX (entity)
;;DESTROY: AF, BC, DE, HL
render_entity_erase_xor::
	;ld 		e, entity_last_screen_l(ix)
	;ld 		d, entity_last_screen_h(ix)
	;render_draw_solid_box #0x00, entity_width(ix), entity_height(ix)
;	render_get_screen_pointer entity_x_coord(ix), entity_y_coord(ix)
	ld 		e, entity_last_screen_l(ix)
	ld 		d, entity_last_screen_h(ix)
;;	ex		de, hl
	ld		l, entity_sprite_l(ix)
	ld		h, entity_sprite_h(ix)
	ld		b, entity_width(ix)
	ld		c, entity_height(ix)
	call	cpct_drawSpriteBlended_asm
	ret

;; Not use direcly, render_message makes it more readable
;;INPUT:
;;	A:	Y
;;	B:	X
;;	H:	BACKGROUND COLOR
;;	L:	FONT COLOR
;;	IY:	STRING
;; DESTROYS: AF, BC, DE, HL, IY
render_draw_text_at::
    ld (render_draw_text_at_y), a
	ld a, b
    ld (render_draw_text_at_x), a

	call cpct_setDrawCharM0_asm

	ld		de, #render_vid_mem_start
	render_draw_text_at_y = .+1
	ld		b, #0xAA
	render_draw_text_at_x = .+1 
	ld		c, #0xAA
	call	cpct_getScreenPtr_asm

	call cpct_drawStringM0_asm

	ret

.globl	cpct_waitVSYNC_asm

;;DESTROYS: AF, BC, DE, HL, IX
render_update::

    call     cpct_waitVSYNC_asm
	
	ld hl, #render_entity_erase_xor_high
	call entity_for_all_enemies
	ld hl, #render_entity_draw_xor_high 
	call entity_for_all_alive_enemies


	ld hl, #render_entity_erase_xor_low
	call entity_for_all_enemies
	ld hl, #render_entity_draw_xor_low 
	call entity_for_all_alive_enemies



	ld      ix, #entity_end
	call	render_entity_erase_xor
	call	render_entity_draw_xor


	render_draw_solid_box_at #0x00, #0x00, #0xC0, #4, #0xC8
	render_draw_solid_box_at #76, #0x00, #0xC0, #4, #0xC8


	ld      ix, #entity_main_player
	call	render_entity_erase_xor
	call	render_entity_draw_xor

	ret
	