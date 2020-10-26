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

;;Render the entity.
;;INPUT:   IX (entity) 
;;DESTROY: AF, BC, DE, HL 
render_entity_draw::
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

;;Erase the last entity.
;;INPUT:   IX (entity)
;;DESTROY: AF, BC, DE, HL
render_entity_erase::
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

;;DESTROYS: AF, BC, DE, HL, IX
render_update::

	ld      ix, #entity_end
	call	render_entity_erase
	call	render_entity_draw
	

	
	ld hl, #render_entity_erase
	call entity_for_all_enemies
	
	
	ld hl, #render_entity_draw
	call entity_for_all_enemies


	ld      ix, #entity_main_player
	
	
	call	render_entity_erase
	call	render_entity_draw



	ret
	