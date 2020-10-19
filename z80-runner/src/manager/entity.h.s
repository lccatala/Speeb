.module entity
.globl entity_init
.globl entity_main_player
.globl entity_end
.globl entity_for_all_enemies
.globl entity_create_enemy
.globl entity_update

entity_max_enemies      = 10

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
entity_ai_aim_x         = entity_color+1
entity_ai_aim_y         = entity_ai_aim_x+1
entity_ai_next_action   = entity_ai_aim_y+1
entity_ai_next_action_l = entity_ai_next_action
entity_ai_next_action_h = entity_ai_next_action+1
entity_next_action      = entity_ai_next_action+2  ;; control system! 2 bytes
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


.macro blank_bytes _N
    .rept _N
        .db #0xAA
    .endm
.endm

.macro entity_create_prototype _Y_SPEED, _WIDTH, _HEIGHT, _COLOR, _AI_FUNCTION
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
    blank_bytes entity_ai_next_action-(entity_color+1)
    .dw _AI_FUNCTION          ;; entity_ai_function
    blank_bytes entity_next_action-(entity_ai_next_action+2)
    .dw #0x0000 ;; entity_next_action
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