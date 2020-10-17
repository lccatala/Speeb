.include "physics.h.s"
.include "manager/entity.h.s"
.include "manager/game.h.s"
.include "macros/cpct_undocumentedOpcodes.h.s"


physics_collision_detected:: .db #0x00 ;; flag for collision detection, should be changed to an array


;; Initialize physics
;; DESTROYS: A
physics_init::
	;; Resets the collision flag
	xor	a
	ld	(physics_collision_detected), a
	ret

;; call the action specified on the entity, destroys whatever that action destroys
;; INPUT:
;;	IX:		entity to act
;; DESTROYS: AF, HL
physics_act:
	xor	a
	cp	entity_next_action_h(ix)
	jr	nz, physics_act_not_empty
	cp	entity_next_action_l(ix)
	ret	z ;; action empy
	physics_act_not_empty:
	ld	l,	entity_next_action_l(ix)
	ld	h,	entity_next_action_h(ix)
	ld (physics_act_call+1), hl
	physics_act_call: call #0xABAC
	ret

;; Action: jump!
;; INPUT:
;;	IX:		entity to move
;; DESTROYS: AF
physics_action_jump::
	;; ground level?
	ld		a,	#physics_ground_level
	sub		entity_height(ix)
	cp		entity_y_coord(ix)
	ret nz

	ld		entity_y_speed(ix), #physics_jump_initial_speed ;; jumps
	ret

;; Action: shoot!
;; INPUT:
;; DESTROYS: A
physics_action_shoot::
	ld  a,	#0xFF
	ld (#0xc000), a
	ret

;; Action: dodge left!
;; INPUT:
;; DESTROYS: A
physics_action_dodge_left::
	ld  a,	#0x0F
	ld (#0xc000), a
	ret

;; Action: dodge right!
;; INPUT:
;; DESTROYS: A
physics_action_dodge_right::
	ld  a,	#0xF0
	ld (#0xc000), a
	ret

;; move y
;; INPUT:
;;	IX:		entity to move
;; DESTROYS: AF
physics_entity_move_y:

	;; move
	ld		a, entity_y_coord(ix)
	add		entity_y_speed(ix)
	ld		entity_y_coord(ix), a

	;; where is the entity in relation to the ground?
	add		entity_height(ix)
	add		#(256-physics_ground_level)
	jr 		c,	physics_update_on_the_ground

	;; if y < 88 (over the ground)
	;; gravity applies
	inc 	entity_y_speed(ix)
	ret

	physics_update_on_the_ground:
	;; if y >= 88 (on the ground or lower)
	ld		a, #physics_ground_level
	sub		entity_height(ix)
	ld 		entity_y_coord(ix), a		;; puts entity on the ground
	ld		entity_y_speed(ix), #0		;; entity has no speed

	ret

;; move x
;; INPUT:
;;	IX:		entity to move
;; DESTROYS: AF, BC
physics_entity_move_x:
	ld	bc,	#entity_main_player
	ld	a,	c
	cp__ixl
	jr	nz, physics_entity_move_x_not_player
	ld	a,	b
	cp__ixh
	jr	nz,	physics_entity_move_x_not_player
	xor a
	jr	physics_entity_move_x_player

	physics_entity_move_x_not_player:
	ld	a,	(game_level_speed)

	physics_entity_move_x_player:
	add	entity_x_speed(ix)
	ld	b,	a ;; B = total speed

	ld	a,	entity_x_coord(ix)
	add	b
	ld	entity_x_coord(ix),	a

	ret nz
	;; TODO: HACK, FIX!
	;; When enemy reaches left border, move it to right border
	ld	entity_x_coord(ix), #79
	ret

;; Collision considers entities as squares, having starting and ending points for both their x and y.
;; we consider the coordinates to be the start, and the coordinates + width/height to be the end
;; if startIY < endIX &&  startIX < endIY, then the entities "collide" in that axis
;; INPUTS:
;;	IX:		first entity pointer
;;	IY:		second entity pointer
;;   B:     flag value in case of collision
;; DESTROYS: AF, BC
physics_check_collision::
	
	;; X AXIS: startIY < endIX
	physics_ret_if_start_lesser_end entity_x_coord, entity_width, iy, ix 

	;; X AXIS: startIX < endIY
	physics_ret_if_start_lesser_end entity_x_coord, entity_width, ix, iy

	;; Y AXIS: startIY < endIX
	physics_ret_if_start_lesser_end entity_y_coord, entity_height, iy, ix
	
	;; Y AXIS: startIX < endIY
	physics_ret_if_start_lesser_end entity_y_coord, entity_height, ix, iy

	;; COLLISION: set collision flag to value stored in B
	ld	a,	b
	ld	(physics_collision_detected), a
	ret

;; Destroys whatever the action function destroys (be craneful mai fren!)
;; INPUT:
;;	IX:		entity to move
;; DESTROYS: AF, BC, HL
physics_update_entity:
	call physics_entity_move_y
	call physics_entity_move_x
	call physics_act
	ret

;; Update speed and position of all entities in the level
;; INPUT: none
;; OUTPUT: none
;; BREAKS: AF, BC, IX, IY
physics_update::
	;; physics_entity_move (update should do other stuff too?)
	ld ix, #entity_main_player
	call physics_update_entity
	ld ix, #entity_enemy
	call	physics_update_entity
	ld ix, #entity_end
	call   physics_update_entity

	ld	ix,	#entity_enemy
	ld	iy,	#entity_main_player
	ld  b,  #0x01
	call	physics_check_collision

	ld	ix,	#entity_end
	ld	iy,	#entity_main_player
	ld  b,  #0x10
	call	physics_check_collision
	
	ret