.include "physics.h.s"
.include "../manager/entity.h.s"
.include "../utility/keyboard.h.s"


;; Update player speed and position along Y axis if it's not touching the ground
;; INPUT: none
;; OUTPUT: none
;; BREAKS: AF, IX
physics_player_update::
	ld		ix,	#entity_main_player

	;; move
	ld		a, entity_y_coord(ix)
	add		entity_y_speed(ix)
	ld		entity_y_coord(ix), a

	;; where is the entity in relation to the ground?
	add		#(256-136)
	jr 		c,	physics_update_on_the_ground

	;; if y < 88 (over the ground)
	;; gravity applies
	inc 	entity_y_speed(ix)
	ret

	physics_update_on_the_ground:
	;; if y >= 88 (on the ground or lower)
	ld 		entity_y_coord(ix), #136	;; puts entity on the ground
	ld		entity_y_speed(ix), #0		;; entity has no speed
	;; if key just pressed
	call	keyboard_check_key_space_just_pressed
	ret 	nz

	ld		entity_y_speed(ix), #-10 ;; jumps
	ret

physics_update::
	call	physics_player_update
	ret