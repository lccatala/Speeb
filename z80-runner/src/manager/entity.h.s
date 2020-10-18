.module entity

.globl entity_init
.globl entity_main_player
.globl entity_for_all_enemies
.globl entity_create_enemy
.globl entity_update

entity_max_enemies      = 16

entity_is_dead          = 0
entity_x_speed          = entity_is_dead+1
entity_y_speed          = entity_x_speed+1
entity_x_coord          = entity_y_speed+1
entity_y_coord          = entity_x_coord+1
entity_last_screen      = entity_y_coord+1 ;; pointer to last place in video memory, 2 bytes
entity_last_screen_l    = entity_last_screen
entity_last_screen_h    = entity_last_screen+1
entity_width            = entity_last_screen+2
entity_height           = entity_width+1
entity_color            = entity_height+1
entity_next_action      = entity_color+1  ;; control system! 2 bytes
entity_next_action_l    = entity_next_action
entity_next_action_h    = entity_next_action+1
entity_size             = entity_next_action+2

.macro entity_define
    .rept #entity_size
        .db #0xAA
    .endm
.endm

.macro entity_define_array _N
    .rept #_N
        entity_define
    .endm
.endm

;; As readable and neat this macro might be, it wastes space to some extent
;; Usual way to do this is having a value-filled prototype in memory, and ldir the _ENTITY you wanna fill
;; DEPRECATED!!!!!!!!!! USE PROTOTYPES AND INSTANTIATE!!!
;;INPUT:
;;  _ENTITY: can be **, (**)
;;  _Y_SPEED: can be *, a, b, c, d, e, h, l
;;  _X_COORD: can be *, a, b, c, d, e, h, l
;;  _Y_COORD: can be *, a, b, c, d, e, h, l
;;DESTROYS: ix
.macro entity_fill _ENTITY, _Y_SPEED, _X_COORD, _Y_COORD, _WIDTH, _HEIGHT, _COLOR
    ld ix, _ENTITY
    ld entity_is_dead(ix), #0
    ld entity_x_speed(ix), #0 ;; TODO: temporary (everything is, memento mori)
    ld entity_y_speed(ix), _Y_SPEED
    ld entity_x_coord(ix), _X_COORD
    ld entity_y_coord(ix), _Y_COORD
    ld entity_width(ix),     _WIDTH
    ld entity_height(ix),   _HEIGHT
    ld entity_color(ix),     _COLOR
    ld entity_next_action_l(ix),    #0x00
    ld entity_next_action_h(ix),    #0x00
.endm

.macro blank_bytes _N
    .rept _N
        .db #0xAA
    .endm
.endm

.macro entity_create_prototype _Y_SPEED, _WIDTH, _HEIGHT, _COLOR
    blank_bytes entity_is_dead-0
    .db #0x00           ;; entity_is_dead
    blank_bytes entity_x_speed-(entity_is_dead+1)
    .db #0x00           ;; entity_x_speed
    blank_bytes entity_y_speed-(entity_x_speed+1)
    .db _Y_SPEED        ;; entity_y_speed
    blank_bytes entity_width-(entity_y_speed+1)
    .db _WIDTH          ;; entity_width
    blank_bytes entity_height-(entity_width+1)
    .db _HEIGHT         ;; entity_height
    blank_bytes entity_color-(entity_height+1)
    .db _COLOR          ;; entity_color
    blank_bytes entity_next_action-(entity_color+1)
    .db #0x00
    .db #0x00 ;; entity_next_action
    blank_bytes entity_size-(entity_next_action+2)
.endm


;;INPUT:
;;  _ORIGIN:    pointer to the prototype you want to copy, can be **
;;  _X_COORD:   left x coordinate to put the entity at, can be *
;;  _Y_COORD:   bottom y coordinate to put the entity at, can be *
;;  DE:         pointer to the entity you want to copy the prototype to
;;DESTROYS: AF, BC, DE, HL, IX
.macro entity_instantiate_prototype _ORIGIN, _X_COORD, _Y_COORD
    ld__ixh_d
    ld__ixl_e
    ld hl, _ORIGIN
    ld bc, #entity_size
    ldir

    ld a, _Y_COORD
    sub entity_height(ix)
    ld entity_x_coord(ix), _X_COORD
    ld entity_y_coord(ix), a
.endm