.module entity
.globl entity_init
.globl entity_main_player
.globl entity_end
.globl entity_for_all_enemies
.globl entity_create_enemy
.globl entity_update
.globl entity_prototype_ice_enemy
.globl entity_ice_spawn
.globl entity_spawn
.globl entity_prototype_plant_enemy
.globl entity_prototype_cloud_enemy
.globl entity_prototype_largeplant_enemy
.globl entity_prototype_bird_enemy
.globl entity_prototype_bat_enemy
.globl entity_for_all_alive_enemies

entity_max_enemies      = 10
entity_max_width        = 8

entity_render_type      = 0
entity_is_dead          = entity_render_type+1
entity_x_speed          = entity_is_dead+1
entity_y_speed          = entity_x_speed+1
entity_x_coord          = entity_y_speed+1
entity_y_coord          = entity_x_coord+1
entity_last_screen      = entity_y_coord+1 ;; pointer to last place in video memory, 2 bytes
entity_last_screen_l    = entity_last_screen
entity_last_screen_h    = entity_last_screen+1
entity_width            = entity_last_screen+2
entity_height           = entity_width+1
entity_sprite           = entity_height+1
entity_sprite_l         = entity_sprite
entity_sprite_h         = entity_sprite+1
entity_ai_aim_x         = entity_sprite+2
entity_ai_aim_y         = entity_ai_aim_x+1
entity_ai_next_action   = entity_ai_aim_y+1
entity_ai_next_action_l = entity_ai_next_action
entity_ai_next_action_h = entity_ai_next_action+1
entity_next_action      = entity_ai_next_action+2  ;; control system! 2 bytes
entity_next_action_l    = entity_next_action
entity_next_action_h    = entity_next_action+1
entity_sprite_width     = entity_next_action+2
entity_sprite_height    = entity_sprite_width+1
entity_x_offset         = entity_sprite_height+1
entity_y_offset         = entity_x_offset+1
entity_size             = entity_y_offset+1

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

;;NEEDS THE INCLUSION OF UTILITY/GENERAL.H.S!!!
.macro entity_create_prototype _Y_SPEED, _WIDTH, _HEIGHT, _AI_FUNCTION, _SPRITE, _RENDER_TYPE, _SPRITE_WIDTH, _SPRITE_HEIGHT, _X_OFFSET, _Y_OFFSET
    general_blank_bytes entity_render_type-0
    .db _RENDER_TYPE    ;; entity_render_type
    general_blank_bytes entity_is_dead-(entity_render_type+1)
    .db #0x00           ;; entity_is_dead
    general_blank_bytes entity_x_speed-(entity_is_dead+1)
    .db #0x00           ;; entity_x_speed
    general_blank_bytes entity_y_speed-(entity_x_speed+1)
    .db _Y_SPEED        ;; entity_y_speed
    general_blank_bytes entity_last_screen-(entity_y_speed+1)
    .dw #0x0000
    general_blank_bytes entity_width-(entity_last_screen+2)
    .db _WIDTH          ;; entity_width
    general_blank_bytes entity_height-(entity_width+1)
    .db _HEIGHT         ;; entity_height
    general_blank_bytes entity_sprite-(entity_height+1)
    .dw _SPRITE         ;; entity_ai_function
    general_blank_bytes entity_ai_next_action-(entity_sprite+2)
    .dw _AI_FUNCTION          ;; entity_ai_function
    general_blank_bytes entity_next_action-(entity_ai_next_action+2)
    .dw #0x0000 ;; entity_next_action
    general_blank_bytes entity_sprite_width-(entity_next_action+2)
    .db _SPRITE_WIDTH
    general_blank_bytes entity_sprite_height-(entity_sprite_width+1)
    .db _SPRITE_HEIGHT
    general_blank_bytes entity_x_offset-(entity_sprite_height+1)
    .db _X_OFFSET
    general_blank_bytes entity_y_offset-(entity_x_offset+1)
    .db _Y_OFFSET
    general_blank_bytes entity_size-(entity_y_offset+1)
.endm

.macro entity_create_prototype_with_x_speed _Y_SPEED, _WIDTH, _HEIGHT, _COLOR, _AI_FUNCTION, _X_SPEED
    general_blank_bytes entity_is_dead-0
    .db #0x00           ;; entity_is_dead
    general_blank_bytes entity_x_speed-(entity_is_dead+1)
    .db _X_SPEED        ;; entity_x_speed
    general_blank_bytes entity_y_speed-(entity_x_speed+1)
    .db _Y_SPEED        ;; entity_y_speed
    general_blank_bytes entity_width-(entity_y_speed+1)
    .db _WIDTH          ;; entity_width
    general_blank_bytes entity_height-(entity_width+1)
    .db _HEIGHT         ;; entity_height
    general_blank_bytes entity_color-(entity_height+1)
    .db _COLOR          ;; entity_color
    general_blank_bytes entity_ai_next_action-(entity_color+1)
    .dw _AI_FUNCTION          ;; entity_ai_function
    general_blank_bytes entity_next_action-(entity_ai_next_action+2)
    .dw #0x0000 ;; entity_next_action
    general_blank_bytes entity_size-(entity_next_action+2)
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
