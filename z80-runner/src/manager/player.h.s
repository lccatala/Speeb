.globl player_init
.globl player_main


player_x_speed = 0
player_y_speed = 1
player_y_coord = 2
player_size    = 3

.macro player_define
    .rept #player_size
        .db #0xAA
    .endm
.endm

;;INPUT:
;;  _PLAYER: direct or indirect 2 byte adress
;;  _X_SPEED: 1 byte number or registers: a, b, c, d, e, h, l
;;  _Y_SPEED: 1 byte number or registers: a, b, c, d, e, h, l
;;DESTROYS: ix
.macro player_fill _PLAYER, _X_SPEED, _Y_SPEED, _Y_COORD
    ld ix, _PLAYER
    ld player_x_speed(ix), _X_SPEED
    ld player_y_speed(ix), _Y_SPEED
    ld player_y_coord(ix), _Y_COORD
.endm