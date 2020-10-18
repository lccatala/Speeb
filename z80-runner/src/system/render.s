.include "render.h.s"
.include "cpctelera.h.s"
.include "manager/entity.h.s"


	;;[======================================================]
	;;| Identifier		  | Value| Identifier		  | Value|
	;;|------------------------------------------------------|
	;;| HW_BLACK			| 0x14 | HW_BLUE		  | 0x04 |
	;;| HW_BRIGHT_BLUE		| 0x15 | HW_RED			  | 0x1C |
	;;| HW_MAGENTA		  	| 0x18 | HW_MAUVE		  | 0x1D |
	;;| HW_BRIGHT_RED	 	| 0x0C | HW_PURPLE		  | 0x05 |
	;;| HW_BRIGHT_MAGENTA 	| 0x0D | HW_GREEN		  | 0x16 |
	;;| HW_CYAN			 	| 0x06 | HW_SKY_BLUE	  | 0x17 |
	;;| HW_YELLOW		   	| 0x1E | HW_WHITE		  | 0x00 |
	;;| HW_PASTEL_BLUE		| 0x1F | HW_ORANGE		  | 0x0E |
	;;| HW_PINK			 	| 0x07 | HW_PASTEL_MAGENTA| 0x0F |
	;;| HW_BRIGHT_GREEN   	| 0x12 | HW_SEA_GREEN	  | 0x02 |
	;;| HW_BRIGHT_CYAN		| 0x13 | HW_LIME		  | 0x1A |
	;;| HW_PASTEL_GREEN   	| 0x19 | HW_PASTEL_CYAN	  | 0x1B |
	;;| HW_BRIGHT_YELLOW  	| 0x0A | HW_PASTEL_YELLOW | 0x03 |
	;;| HW_BRIGHT_WHITE   	| 0x0B |						 |		
	
	;;ld		c, #0
	;;call	cpct_setVideoMode_asm

	;;ld		hl, #palette
	;;ld		de, #16
	;;call	cpct_setPalette_asm 

;;DESTROYS: AF, BC, DE, HL
render_clean:
	render_draw_solid_box_at #0x00, #0x50, #0x00, #0x40, #0x78
	render_draw_solid_box_at #0x40, #0x50, #0x00, #0x10, #0x78
	ret

;;DESTROYS: AF, BC, DE, HL
render_ground:
	render_draw_solid_box_at #0x00, #0x90, #0xF0, #0x40, #0x38
	render_draw_solid_box_at #0x40, #0x90, #0xF0, #0x10, #0x38
	ret

;;DESTROY: AF, BC, DE, HL
render_init::
	cpctm_setBorder_asm	0x14
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
	render_draw_solid_box entity_color(ix), entity_width(ix), entity_height(ix)
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
	ld      ix, #entity_enemy
	call	render_entity_erase

	ld      ix, #entity_main_player
	call	render_entity_erase

	ld hl, #render_entity_erase
	call entity_for_all_enemies

	ld      ix, #entity_enemy
	call	render_entity_draw

	ld      ix, #entity_main_player
	call	render_entity_draw

	ld hl, #render_entity_draw
	call entity_for_all_enemies
	
	ret
	