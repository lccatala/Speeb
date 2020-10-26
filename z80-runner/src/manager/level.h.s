.module level

.globl level_load
.globl level_first
.globl level_for_all_spawns_in
.globl level_current

level_header_speed      = 0
level_header_length     = level_header_speed+1
level_header_size       = level_header_length+1

level_spawn_start       = level_header_size

level_spawn_prototype   = 0
level_spawn_prototype_h = level_spawn_prototype+1
level_spawn_prototype_l = level_spawn_prototype
level_spawn_section     = level_spawn_prototype+2
level_spawn_x           = level_spawn_section+1
level_spawn_y           = level_spawn_x+1
level_spawn_size        = level_spawn_y+1


;;Starts the level data
;;NEEDS THE INCLUSION OF UTILITY/GENERAL.H.S!!!
;;INPUT
;;  _SPEED:     level speed, must be *
;;  _LENGTH:    level length in number of 256X coordinate sections, must be *
.macro level_create_header _SPEED _LENGTH
    general_blank_bytes level_header_speed-0
    .db _SPEED          ;; level_header_speed
    general_blank_bytes level_header_length-(level_header_speed+1)
    .db _LENGTH         ;; level_header_length
    general_blank_bytes level_header_size-(level_header_length+1)
.endm

;;Adds an entity to be spawned. SPWANS MUST BE ORDERED BY _SECTION AND _X_COORD
;;NEEDS THE INCLUSION OF UTILITY/GENERAL.H.S!!!
;;INPUT
;;  _PRTOTYPE:  entity to copy, must be **
;;  _SECTION:   section of the spawn, must be *
;;  _X_COORD:   x coordinate within the section, must be *
;;  _Y_COORD:   y coordinate of the spawn, must be *
.macro level_add_spawn _PROTOTYPE, _SECTION, _X_COORD, _Y_COORD
    ;;SPAWN PROTOTYPE >>MUST<< BE THE FIRST ITEM (only way to ensure the level_end works)
    .dw _PROTOTYPE
    general_blank_bytes level_spawn_section-(level_spawn_prototype+2)
    .db _SECTION
    general_blank_bytes level_spawn_x-(level_spawn_section+1)
    .db _X_COORD
    general_blank_bytes level_spawn_y-(level_spawn_x+1)
    .db _Y_COORD
    general_blank_bytes level_spawn_size-(level_spawn_y+1)
.endm

;;Marks the end of the level structure
.macro level_end
    .dw #0x0000
.endm