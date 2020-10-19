.module render

.globl render_init
.globl render_update
.globl render_clean
.globl render_entity_erase

.globl cpct_drawSolidBox_asm
.globl cpct_getScreenPtr_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPalette_asm
.globl cpct_setDrawCharM1_asm
.globl cpct_drawStringM1_asm

render_vid_mem_start = 0xC000

;;INPUT:
;;  _X:                 X coordinate (c for getScreenPtr) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;  _Y:                 Y coordinate (b for getScreenPtr) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;  _BACKGROUND_COLOR:  Background color (d for setDrawCharM1) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;  _FONT_COLOR:        Font color (e for setDrawCharM1) can be *, a, b, c, d, e, h, l, (hl), (ix+*), (iy+*)
;;  _STRING:            String to write (iy for drawStringM1) can be **, (**)
;;DESTROYS: AF, BC, DE, HL, IY
.macro  render_draw_text_at _X, _Y, _BACKGROUND_COLOR, _FONT_COLOR, _STRING
   ld    d, _BACKGROUND_COLOR ;; background dark blue
   ld    e, _FONT_COLOR ;; letters yellow
   call cpct_setDrawCharM1_asm

   render_get_screen_pointer _X, _Y

   ld   iy, _STRING
   call cpct_drawStringM1_asm
.endm

.macro render_clean_and_draw_message _MESSAGE
	call  render_clean

    ;; Final message is written
    render_draw_text_at #0x08, #0x85, #0, #1, #_MESSAGE
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