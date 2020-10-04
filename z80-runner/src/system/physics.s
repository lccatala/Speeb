.include "physics.h.s"
.include "../manager/player.h.s"

;; Update player speed and position along Y axis if it's not touching the ground
;; INPUT: none
;; OUTPUT: none
;; BREAKS: AF
physics_update::	
	ld	ix,	#player_main
	inc	player_y_speed(ix)

	ld	a,	player_y_coord(ix)
	sub	player_y_speed(ix)
	ld	player_y_coord(ix),	a

	;; if player_y < 184: ret 
	sub	#184
	ret	c

	;; player_y > 184
	ld	player_y_speed(ix),	#-16
	ld	player_y_coord(ix),	#184

	ret