.module render

.globl render_init
.globl render_update
.globl render_clean
.globl render_entity_erase
.globl render_draw_text_at

.globl cpct_drawSolidBox_asm
.globl cpct_getScreenPtr_asm
.globl cpct_setDrawCharM0_asm
.globl cpct_drawStringM0_asm
.globl cpct_drawSprite_asm
.globl cpct_drawSpriteBlended_asm
.globl cpct_zx7b_decrunch_s_asm

.globl _PALETTE
.globl _plant
.globl _cloud
.globl _bunny_0
.globl _bunny_1
.globl _bunny_2
.globl _goal
.globl _ice

render_type_high_xor		= #0x01
render_type_low_xor			= #0x02
render_type_high_self_erase = #0x03
render_type_low_self_erase 	= #0x04

render_vid_mem_start = 0xC000

render_max_x = 0x50

;;INPUT:
;;  _X:                 X coordinate (c for getScreenPtr) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;  _Y:                 Y coordinate (b for getScreenPtr) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;  _BACKGROUND_COLOR:  Background color (d for setDrawCharM1) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;  _FONT_COLOR:        Font color (e for setDrawCharM1) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;  _STRING:            String to write (iy for drawStringM1) can be **, (**)
;;DESTROYS: AF, BC, DE, HL, IY
.macro  render_draw_message _X, _Y, _BACKGROUND_COLOR, _FONT_COLOR, _STRING
    ld   h, _BACKGROUND_COLOR ;; background dark blue
    ld   l, _FONT_COLOR ;; letters yellow
    ld   a, _Y
    ld	 b, _X
    ld	iy, _STRING
    call render_draw_text_at
.endm

;;INPUT:
;;	_X:		X coordinate (c for getScreenPtr) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;	_Y:		Y coordinate (b for getScreenPtr) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;DESTROYS: AF, BC, DE, HL
;;RETURNS:
;;  HL:     screen pointer
.macro render_get_screen_pointer _X, _Y
	ld		de, #render_vid_mem_start
	ld		b, _Y
	ld		c, _X
	call	cpct_getScreenPtr_asm
.endm


;;INPUT:
;;	_COLOR:     color (a for drawSolidBox) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;	_WIDTH:     width (width, c for drawSolidBox) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;	_HEIGHT:    height (height, b for drawSolidBox) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;  DE:     screen pointer (de drawSolidBox)
;;DESTROYS: AF, BC, DE, HL
.macro render_draw_solid_box _COLOR, _WIDTH, _HEIGHT
    ld      a, _COLOR
	ld		b, _HEIGHT
	ld		c, _WIDTH
	call	cpct_drawSolidBox_asm
.endm

;;INPUT:
;;	_X:		    X coordinate (c for getScreenPtr) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;	_Y:		    Y coordinate (b for getScreenPtr) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;	_COLOR:     color (a for drawSolidBox) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;	_WIDTH:     width (width, c for drawSolidBox) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;	_HEIGHT:    height (height, b for drawSolidBox) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;DESTROYS: AF, BC, DE, HL
.macro render_draw_solid_box_at _X, _Y, _COLOR, _WIDTH, _HEIGHT
	render_get_screen_pointer _X, _Y
	ex		de, hl
	render_draw_solid_box _COLOR, _WIDTH, _HEIGHT
.endm