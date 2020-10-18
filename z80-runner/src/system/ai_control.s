.include "cpctelera.h.s"
.include "manager/entity.h.s"



ai_control_init::

    ret




;; Updates AI for the entities
;; INPUT:
;;      IX: Pointer entity array
;;       A: Number of elements in the array
;; DESTROYS: A
ai_control_update::
    ld      (entity_counter), a

entity_array_ptr = . + 2
    ld      ix, #0x0000

ai_control_update_loop:

    ld      a, entity_ai_status(ix)
    cp      #entity_ai_status_no
    jr      z, no_ai_control_entity

ai_control_entity:
    call ai_control_update_aim_coords
    cp #entity_ai_status_stand_by
    call z, ai_control_stand_by
    cp #entity_ai_status_move_to
    call z, ai_control_move_to
    cp #entity_ai_status_move_to_x
    call z, ai_control_move_to
    cp #entity_ai_status_move_to_y
    call z, ai_control_move_to
no_ai_control_entity:
entity_counter = . +1
    ld      a, #0
    dec     a
    ret     z

    ld      (entity_counter), a
    ;;jumps to the next entity
    ld      de, #entity_size
    add     ix, de
    
    ret

ai_control_update_aim_coords::
    ld      ix, #entity_main_player
    ld       a, entity_x_coord(ix)
    ld       a, entity_x_coord(iy)

    ld       a, entity_y_coord(ix)
    ld       a, entity_y_coord(iy)
ret

ai_control_stand_by::
    ld      entity_x_speed(ix), #0
    ld      entity_y_speed(ix), #0
ret

ai_control_move_to_x::
    ;;ld      entity_y_speed(ix), #0

    ;;ld      a, entity_ai_aim_x(ix)



ret

ai_control_move_to_y::

ret
ai_control_move_to::

ret