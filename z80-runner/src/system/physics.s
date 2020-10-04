.include "physics.h.s"
.include "../manager/player.h.s"

;; Update player speed and position along Y axis if it's not touching the ground
;; INPUT: none
;; OUTPUT: none
;; BREAKS: AF
physics_update::	
	ld	ix,	#player_main

	inc player_y_speed(ix)

	ld	a, player_y_coord(ix)
	add	player_y_speed(ix)
	ld	player_y_coord(ix), a

	;; if y < 88 ret
	add	#(256-136)
	ret nc
	;; if y > 88
	ld	player_y_speed(ix), #-10
	ld 	player_y_coord(ix), #136

	ret