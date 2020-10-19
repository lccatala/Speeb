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

    ld      ix, #entity_end
    call    ai_control_update_entity

    ret

ai_control_update_entity:
    
    xor     a
    cp      entity_ai_next_action_h(ix)
    jr      nz, ai_control_action_not_empty
    cp      entity_ai_next_action_l(ix)
    ret     z

    ai_control_action_not_empty:
    ld      l, entity_ai_next_action_l(ix)
    ld      h, entity_ai_next_action_h(ix)

    ld      (ai_control_action_call), hl
    ai_control_action_call= . +1
    call    #0xADDE
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
    call    ai_control_update_aim_coords
    ld      entity_y_speed(ix), #0
    ld      a, entity_ai_aim_x(ix)
    sub     entity_x_coord(ix)
    jr      nc, ai_control_move_to_x_greater_or_equal

ai_control_move_to_x_lesser:
    call    ai_control_game_level_speed_counter
    dec     a
    ld      entity_x_speed(ix), a
    ret

ai_control_move_to_x_greater_or_equal:
    jr      z, ai_control_move_to_x_arrived
    call    ai_control_game_level_speed_counter
    inc     a
    ld      entity_x_speed(ix), a
    ret

ai_control_move_to_x_arrived:
    call    ai_control_stand_by
    ld      hl, #ai_control_stand_by
    ld      entity_ai_next_action_h(ix), h
    ld      entity_ai_next_action_l(ix), l
ret

ai_control_move_to_y::

ret
ai_control_move_to::

ret

ai_control_drop_bomb::
    

ret