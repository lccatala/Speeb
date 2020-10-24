.include "render.h.s"
.include "cpctelera.h.s"
.include "manager/entity.h.s"

;;DESTROYS: AF, BC, DE, HL
render_clean:
	render_draw_solid_box_at #0x00, #0x00, #0x00, #0x40, #0xC8
	render_draw_solid_box_at #0x40, #0x00, #0x00, #0x10, #0xC8
	ret

;;DESTROYS: AF, BC, DE, HL
render_ground::
	render_draw_solid_box_at #0x00, #0x90, #0x0F, #0x40, #0x38
	render_draw_solid_box_at #0x40, #0x90, #0x0F, #0x10, #0x38
	ret

;;DESTROY: AF, BC, DE, HL
render_init::
	ld		c, #0 
	call	cpct_setVideoMode_asm
	cpctm_setBorder_asm	0x14
	ld		hl, #_PALETTE
	ld		de, #16
	call	cpct_setPalette_asm
	call	render_ground
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
	ld		c, entity_width(ix)
	ld		b, entity_height(ix)
	call	cpct_drawSprite_asm
	ret

;;Erase the last entity.
;;INPUT:   IX (entity)
;;DESTROY: AF, BC, DE, HL
render_entity_erase::
	ld 		e, entity_last_screen_l(ix)
	ld 		d, entity_last_screen_h(ix)
	render_draw_solid_box #0x00, entity_width(ix), entity_height(ix)
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
	