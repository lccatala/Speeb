.include "physics.h.s"

;; Decrease player speed and position along Y axis if it's not touching the ground
;; INPUT: B: player_y, C: player_speed_y
;; OUTPUT: B = player_y, C = player_speed_y
;; BREAKS: AF, BC
physics_update::
	ld	a,	b
	cp	#0x00
	jr	Z,	physics_update_grounded


	add	c
	ld	b,	a

	dec	c ;; Decrease speed

physics_update_grounded:
	ret