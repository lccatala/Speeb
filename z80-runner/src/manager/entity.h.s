.globl entity_init
.globl entity_main_player
.globl entity_enemy

entity_y_speed        = 0
entity_x_coord        = 1
entity_y_coord        = 2
entity_last_screen    = 3 ;;2
entity_last_screen_l  = 3
entity_last_screen_h  = 4
entity_width          = 5
entity_height         = 6
entity_color          = 7
entity_size           = 8

.macro entity_define
    .rept #entity_size
        .db #0xAA
    .endm
.endm

;;INPUT:
;;  _ENTITY: direct or indirect 2 byte adress
;;  _Y_SPEED: 1 byte number or registers: a, b, c, d, e, h, l
;;  _X_COORD: 1 byte number or registers: a, b, c, d, e, h, l
;;  _Y_COORD: 1 byte number or registers: a, b, c, d, e, h, l
;;DESTROYS: ix
.macro entity_fill _ENTITY, _Y_SPEED, _X_COORD, _Y_COORD, _WIDTH, _HEIGHT, _COLOR
    ld ix, _ENTITY
    ld entity_y_speed(ix), _Y_SPEED
    ld entity_x_coord(ix), _X_COORD
    ld entity_y_coord(ix), _Y_COORD
    ld entity_width(ix),     _WIDTH
    ld entity_height(ix),   _HEIGHT
    ld entity_color(ix),     _COLOR
.endm