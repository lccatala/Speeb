.include "physics.h.s"
.include "manager/entity.h.s"
.include "manager/game.h.s"
.include "manager/level.h.s"
.include "system/render.h.s"
.include "macros/cpct_undocumentedOpcodes.h.s"


physics_collision_detected:: .db #physics_collision_no ;; flag for collision detection, should be changed to an array
physics_main_player_dashing:: .db #0x00 ;; flag for dashing detection

;;INPUT
;;	A:		level length
;;	B:		level speed
;;DESTROYS:	AF, BC, IX
physics_load_level::
	;;sets the level length
	ld (physics_current_length), a

	;; sets the level speed
	ld  a, b
   	ld  (physics_current_speed), a
	ld	ix, #entity_end
	
	;; inverts the speed
	ld  b, a
	xor a
	sub b
	ld	entity_x_speed(ix), a
	;;kils the end
	ld  entity_is_dead(ix), #1

	;; sets the coord x to max
	ld	a, #render_max_x
	sub	entity_width(ix)
	ld	entity_x_coord(ix), a

	;; restarts the position counters
	xor a
	ld (physics_current_coord), a
	ld (physics_current_section), a
	
	ld	h, #-render_max_x
	call physics_move_level
	ret


physics_current_speed:: .db #-1 ;; This has to be at -1 or the enemy won't restart to the right of the screen (end of screen detection problem)
physics_current_length:: .db #-1

physics_current_coord: .db #0x00
physics_current_section: .db #0x00

physics_current_spawning_x: .db #render_max_x

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
	ld	a, (physics_current_coord)
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

;;INPUT
;; H:		amount to move (negative)
;;DESTROYS: AF, BC, DE, HL, IX
physics_move_level:
	;;moves backwards the map
	ld	a, (physics_current_spawning_x)
	add h
	ld (physics_current_spawning_x), a

	;;loads position in map
	ld	a, (physics_current_coord)
	ld	c, a
	ld	a, (physics_current_section)
	ld  b, a

	physics_move_level_loop:
		;;increments the spawning x
		ld	hl, #physics_current_spawning_x
		inc (hl)
		;;increments the position in map
		ld	a, c
		inc c
		cp	c
		;; c <= a, section ends
		jp c, physics_move_level_no_overflow
			inc b
			;;detects the end of level
			ld	a, (physics_current_length)
			cp	b
			jr	nz, physics_move_level_no_end
				ld	ix, #entity_end
				ld  entity_x_speed(ix), #0
				ld  entity_is_dead(ix), #0
			physics_move_level_no_end:
		physics_move_level_no_overflow:

		;;spawns for current position in bc
		ld	ix, #entity_spawn
		call level_for_all_spawns_in

		;;stops if you finished the screen
		ld	a, (physics_current_spawning_x)
		cp #render_max_x
	jr	nz, physics_move_level_loop

	;;saves position in map
	ld  a, c
	ld  (physics_current_coord), a
	ld	a, b
	ld	(physics_current_section), a

	ret

;; Action: dodge left!
;; INPUT:
;; DESTROYS: A
physics_action_dodge_left::
	;;if dash == 0, we are not in a dash 
	ld		a, (physics_main_player_dashing)
	xor		#1
	ld		(physics_main_player_dashing), a
	ld		entity_x_speed(ix), #physics_dodge_initial_speed_left
	ret
;; Action: dodge right!
;; INPUT:
;; DESTROYS: A
physics_action_dodge_right::
	ld		a, (physics_main_player_dashing)
	xor		#1
	ld		(physics_main_player_dashing), a
	ld		entity_x_speed(ix), #physics_dodge_initial_speed_right
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
	;; if y >= physics_ground_level (on the ground or lower)
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
	;;If the entity is main player, move x means dash
	jr	physics_main_player_dash

	physics_entity_move_x_not_player:
	ld	a,	(physics_current_speed)

	add	entity_x_speed(ix)
	ld	b,	a ;; B = total speed

	ld	a,	entity_x_coord(ix)
	add	b
	ld	entity_x_coord(ix),	a

	ret nz
	;; When enemy reaches left border, destroy it
	ld	entity_is_dead(ix), #1
	ret

;; INPUT:
;;	IX:		entity to move
;; DESTROYS: A
physics_main_player_dash:
	;;move on x 
	ld		a, entity_x_speed(ix)
	cp 		#0
	ret 	z
	add		entity_x_coord(ix)
	ld		entity_x_coord(ix), a

	;;dash or return?
	ld		a, (physics_main_player_dashing)
	cp 		#0
	jr		z, physics_main_player_return

	;;direction of dash?
	ld		a, entity_x_coord(ix)
	sub		#physics_dodge_initial_x_coord
	jp		p, physics_main_player_dash_right ;;positive
	
	;;left//negative
	ld		a, entity_x_coord(ix)
	sub 	#physics_dodge_limit_x_coord_left
	ret 	p
	ld		a, #physics_dodge_limit_x_coord_left
	ld 		entity_x_coord(ix), a		;; puts entity on the limit
	ld		entity_x_speed(ix), #0
	ret

	physics_main_player_dash_right:
	ld		a, entity_x_coord(ix)
	sub 	#physics_dodge_limit_x_coord_right
	ret		m
	ld		a, #physics_dodge_limit_x_coord_right
	ld 		entity_x_coord(ix), a		;; puts entity on the limit
	ld		entity_x_speed(ix), #0
	ret


	physics_main_player_return:
	;;direction of dash?
	ld		a, entity_x_speed(ix)
	cp		#0
	jp		m, physics_main_player_return_left ;;positive
	
	;;return to inital moving with right dash
	ld		a, entity_x_coord(ix)
	sub 	#physics_dodge_initial_x_coord
	ret		m
	ld		a, #physics_dodge_initial_x_coord
	ld 		entity_x_coord(ix), a		;; puts entity on the limit
	ld		entity_x_speed(ix), #0
	ret

	physics_main_player_return_left:
	ld		a, entity_x_coord(ix)
	sub 	#physics_dodge_initial_x_coord
	ret		p
	ld		a, #physics_dodge_initial_x_coord
	ld 		entity_x_coord(ix), a		;; puts entity on the limit
	ld		entity_x_speed(ix), #0
	ret
	

;; Collision considers entities as squares, having starting and ending points for both their x and y.
;; we consider the coordinates to be the start, and the coordinates + width/height to be the end
;; if startIY < endIX &&  startIX < endIY, then the entities "collide" in that axis
;; INPUTS:
;;	IX:		first entity pointer
;;	IY:		second entity pointer
;;   D:     flag value in case of collision
;; DESTROYS: AF
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
	ld	a,	d
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
	;; Resets the collision flag
	ld a, #physics_collision_no
	ld	(physics_collision_detected), a

	;; move stuff
	ld ix, #entity_main_player
	call physics_update_entity
	
	ld ix, #entity_end
	call   physics_update_entity
	
	ld hl, #physics_update_entity
	call entity_for_all_enemies

	ld	hl, #physics_current_speed
	ld	h, (hl)
	call physics_move_level

	;; detect collisions (end is checked last so collision with end overwrites death)
	
	ld  d,  #physics_collision_with_enemy
	ld hl, #physics_check_collision
	call entity_for_all_enemies
	
	ld	ix,	#entity_end
	ld	iy,	#entity_main_player
	ld  d,  #physics_collision_with_end
	call	physics_check_collision


	ret