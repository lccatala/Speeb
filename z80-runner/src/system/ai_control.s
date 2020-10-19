.include "ai_control.h.s"
.include "cpctelera.h.s"
.include "manager/entity.h.s"
.include "manager/game.h.s"



;;ai_control_init::

;;    ret




;; Updates AI for the entities
;; INPUT:
;; DESTROYS: A, HL, IX, IY
ai_control_update::

    ld      hl, #ai_control_update_entity
    call    entity_for_all_enemies
    ret

ai_control_update_entity:

    ld      a, entity_ai_status(ix)
    cp      #entity_ai_status_no
    jr      z, no_ai_control_entity

ai_control_entity:
    call ai_control_update_aim_coords
    ld      a, entity_ai_status(ix)
    cp #entity_ai_status_stand_by
    call    z, ai_control_stand_by
    ld      a, entity_ai_status(ix)
    cp #entity_ai_status_move_to
    call    z, ai_control_move_to
    ld      a, entity_ai_status(ix)
    cp #entity_ai_status_move_to_x
    call    z, ai_control_move_to_x
    ld      a, entity_ai_status(ix)
    cp #entity_ai_status_move_to_y
    call    z, ai_control_move_to_y
no_ai_control_entity:

    ret
;;INFO:  Save the main player's coordinates on the aim enemy coordinates
;;INPUT:
;;         IX: Enemy entity
;;DESTROY: A, IY
ai_control_update_aim_coords::
    ld      iy, #entity_main_player
    ld       a, entity_x_coord(iy)
    ld       entity_ai_aim_x(ix), a

    ld       a, entity_y_coord(iy)
    ld       entity_ai_aim_y(ix), a 
ret

ai_control_game_level_speed_counter::
    ld      a, #0
    ld      hl, #game_level_speed
    ld      b, (hl)
    sub     b
ret
ai_control_stand_by::
    ld      entity_y_speed(ix), #0
    call    ai_control_game_level_speed_counter
    ld      entity_x_speed(ix), a
ret

ai_control_move_to_x::
    ld      entity_y_speed(ix), #0
    ld      a, entity_ai_aim_x(ix)
    sub     entity_x_coord(ix)
    jr      nc, ai_control_move_to_x_greater

ai_control_move_to_x_not_greater:
    jr      z, ai_control_move_to_x_arrived

ai_control_move_to_x_lesser:
    call    ai_control_game_level_speed_counter
    dec     a
    ld      entity_x_speed(ix), a
    ret

ai_control_move_to_x_greater:
    call    ai_control_game_level_speed_counter
    inc     a
    ld      entity_x_speed(ix), a
    ret

ai_control_move_to_x_arrived:
    call    ai_control_stand_by
    ld      entity_ai_status(ix), #entity_ai_status_stand_by
ret

ai_control_move_to_y::

ret
ai_control_move_to::

ret