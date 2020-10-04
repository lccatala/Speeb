.include "render.h.s"
.include "cpctelera.h.s"
.include "manager/entity.h.s"

.globl cpct_drawSolidBox_asm
.globl cpct_getScreenPtr_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPalette_asm

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


render_clean:
	ld		de, #0xC000
	ld		bc, #0x5000
	call	cpct_getScreenPtr_asm

	ex		de, hl
	ld		 a, #0x00
	ld		bc, #0x7840
	call	cpct_drawSolidBox_asm

	ld		de, #0xC000
	ld		bc, #0x5040
	call	cpct_getScreenPtr_asm

	ex		de, hl
	ld		 a, #0x00
	ld		bc, #0x7810
	call	cpct_drawSolidBox_asm

	ret

render_ground:
	ld		de, #0xC000
	ld		bc, #0x9000
	call	cpct_getScreenPtr_asm

	ex		de, hl
	ld		 a, #0xF0
	ld		bc, #0x3840
	call	cpct_drawSolidBox_asm

	ld		de, #0xC000
	ld		bc, #0x9040
	call	cpct_getScreenPtr_asm

	ex		de, hl
	ld		 a, #0xF0
	ld		bc, #0x3810
	call	cpct_drawSolidBox_asm

	ret

;;INPUT:	 
;;DESTROY:  
render_init::
	cpctm_setBorder_asm	0x14
	call	render_ground
	ret

;;Render the entity entitie.
;;INPUT:   IX (#entity_main_player)  
;;DESTROY: AF, BC, DE, HL, 
render_entity_draw::
	ld		de, #0xC000
	ld		 b, entity_y_coord(ix)
	ld		 c, entity_x_coord(ix)
	call	cpct_getScreenPtr_asm
	ld 		entity_last_screen_l(ix), l
	ld		entity_last_screen_h(ix), h

	ex		de, hl
	ld		 a, entity_color(ix)
	ld		 b, entity_height(ix)
	ld		 c, entity_width(ix)
	call	cpct_drawSolidBox_asm

	ret
;;Erase the last entity entitie.
;;INPUT:   IX (#entity_main_player)  
;;DESTROY: AF, BC, DE, HL, 
render_entity_erase::
	ld		de, #0xC000
	ld 		e, entity_last_screen_l(ix)
	ld 		d, entity_last_screen_h(ix)
	ld		 a, #0x00
	ld		 b, entity_height(ix)
	ld		 c, entity_width(ix)
	call	cpct_drawSolidBox_asm

	ret
render_update::
	ld      ix, #entity_enemy
	call	render_entity_erase
	call	render_entity_draw
	ld      ix, #entity_main_player
	call	render_entity_erase
	call	render_entity_draw
	
	ret
	