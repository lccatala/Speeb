.include "physics.h.s"
.include "../manager/entity.h.s"
.include "../utility/keyboard.h.s"
.include "../manager/game.h.s"


physics_collision_detected:: .db #0x00 ;; flag for collision detection, should be changed by an array

;; Update player speed and position along Y axis and, if it's touching the ground, checks for jumps
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
	call	keyboard_check_space_just_pressed
	ret 	nz

	ld		entity_y_speed(ix), #-10 ;; jumps
	ret

;; Update speed and position of all entities in the level except the player
;; INPUT: none
;; OUTPUT: none
;; BREAKS: AF, IX BC
physics_entities_update::
	ld	ix,	#entity_enemy
	ld	a,	(game_level_speed)
	add	entity_x_speed(ix)
	ld	b,	a ;; B = total speed

	ld	a,	entity_x_coord(ix)
	add	b

	ld	entity_x_coord(ix),	a

	ret nz

	;; When enemy reaches left border, move it to right border
	ld	entity_x_coord(ix), #79
	ret

;; Check if player collides with enemy
;; BREAKS: AF, IX, IY, BC
physics_check_collision::

	xor	a
	ld	(physics_collision_detected), a

	ld	b,	#0x00

	;; TODO: this is temporary, in the future any 2 entities could be loaded in IX and IY
	ld	ix,	#entity_enemy
	ld	iy,	#entity_main_player

	ld	a,	entity_x_coord(ix)
	sub	entity_x_coord(iy)
	jp	p,	physics_check_collision_second_check
	ld	a,	#0x01
	or	b
	ld	b,	a

;; player starting x is left of enemy starting x
physics_check_collision_second_check:
	ld	a,	entity_x_coord(ix)
	add	entity_width(ix) ;; A contains enemy ending x
	sub	entity_x_coord(iy)
	jp	p,	physics_check_collision_third_check
	ld	a,	#0x10
	or	b
	ld	b,	a

;; player ending x is left of enemy ending x
physics_check_collision_third_check:
	ld	a,	entity_y_coord(ix)
	;add	entity_height(ix)
	sub	entity_y_coord(iy)
	ret	p
	
	ld	a,	b
	sub	#0x11
	ret	nz

	;; COLLISION: set collision flag to 01
	ld	a,	#0x01
	ld	(physics_collision_detected), a
	ret


;; Update speed and position of all entities in the level
;; INPUT: none
;; OUTPUT: none
;; BREAKS: AF, IX, BC
physics_update::
	call	physics_check_collision
	call	physics_player_update
	call	physics_entities_update
	ret