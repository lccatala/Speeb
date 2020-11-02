.include "ai_control.h.s"
.include "cpctelera.h.s"
.include "manager/entity.h.s"
.include "manager/game.h.s"
.include "system/physics.h.s"



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

ai_control_physics_current_speed_counter::
    ld      a, #0
    ld      hl, #physics_current_speed
    ld      b, (hl)
    sub     b
ret
ai_control_stand_by_y::
    ld      entity_y_speed(ix), #0
    call    ai_control_physics_current_speed_counter
    ld      entity_x_speed(ix), a
ret

ai_control_stand_by_x::
    ld      entity_x_speed(ix), #0
    call    ai_control_physics_current_speed_counter
    ld      entity_y_speed(ix), a
ret

ai_control_move_to_x::
    call    ai_control_update_aim_coords
    ld      entity_y_speed(ix), #0
    ld      a, entity_ai_aim_x(ix)
    sub     entity_x_coord(ix)
    jr      nc, ai_control_move_to_x_greater_or_equal

ai_control_move_to_x_lesser:
    call    ai_control_physics_current_speed_counter
    dec     a
    ld      entity_x_speed(ix), a
    ret

ai_control_move_to_x_greater_or_equal:
    jr      z, ai_control_move_to_x_arrived
    call    ai_control_physics_current_speed_counter
    inc     a
    ld      entity_x_speed(ix), a
    ret

ai_control_move_to_x_arrived:
    call    ai_control_stand_by_y
    ld      hl, #ai_control_drop_ice
    ld      entity_ai_next_action_h(ix), h
    ld      entity_ai_next_action_l(ix), l
ret

ai_control_move_to_y::
    call    ai_control_update_aim_coords

    call    ai_control_stand_by_x
    ld      entity_y_speed(ix), #0x01
    ld      a, entity_ai_aim_y(ix)
    sub     entity_y_coord(ix)
    jr      nc, ai_control_move_to_y_greater_or_equal

ai_control_move_to_y_lesser:
    call    ai_control_physics_current_speed_counter
    dec     a
    ld      entity_y_speed(ix), a
    ret

ai_control_move_to_y_greater_or_equal:
    jr      z, ai_control_move_to_y_arrived
    call    ai_control_physics_current_speed_counter
    inc     a
    ld      entity_y_speed(ix), a
    ret

ai_control_move_to_y_arrived:
    ;call    ai_control_stand_by_y
    ld      entity_y_speed(ix), #0
    ;call    ai_control_cross_screen
    ld      hl, #ai_control_cross_screen
    ld      entity_ai_next_action_h(ix), h
    ld      entity_ai_next_action_l(ix), l
ret
ai_control_move_to::

ret

ai_control_suicide::
    call    ai_control_physics_current_speed_counter
    ld      entity_x_speed(ix), a
    ld      a, #physics_ground_level
    sub     entity_height(ix)
    cp     entity_y_coord(ix)
    jr      z, ai_control_suicide_killyourself
    ret

ai_control_suicide_killyourself:
    ld      entity_is_dead(ix), #1   
    ret

ai_control_drop_ice::
    ld      hl, #ai_control_cross_screen
    ld      entity_ai_next_action_h(ix), h
    ld      entity_ai_next_action_l(ix), l

    ld      hl, #entity_prototype_ice_enemy
    call entity_ice_spawn
    

ret

ai_control_cross_screen::
    ld entity_x_speed(ix), #0xFE
    ld entity_y_speed(ix), #0x00

    ;; Kill enemy if it's at the border of the screen.
    ;; TODO: generalize this to all entities
    ld a, entity_x_coord(ix)
    sub #0x04
    ret nc
    ld      entity_is_dead(ix), #1
ret

;; BREAKS: A
ai_control_zigzag::
    ld entity_y_speed(ix), #0x01
    
    ;; If enemy has positive speed, check position with regards to right border
    ld a, entity_x_speed(ix)
    sub #0x03
    jr z, ai_control_zigzag_check_position_right

    ;; Otherwise, we check it with left border
    ;; Enemy turns around if it gets close to end of screen
    ai_control_zigzag_check_position_left:
        ld a, entity_x_coord(ix)
        sub #0x05
        ret nc

        ;; Leave
        ld a, entity_y_coord(ix)
        sub #0x80
        jr nc, ai_control_zigzag_leave

        ld  entity_x_speed(ix), #0x03
    ret
    
    ai_control_zigzag_check_position_right:
        ld a, #0x35
        sub entity_x_coord(ix)
        ret nc
        ld  entity_x_speed(ix), #0xFE

    ;; Enemy disappears when approaching lower left corner
    ai_control_zigzag_leave:
        ld a, entity_x_coord(ix)
        sub #0x04
        ret nc
        ld  entity_is_dead(ix), #1
    ret
ret