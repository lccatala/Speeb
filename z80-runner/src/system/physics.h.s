.module	physics

.globl physics_init
.globl physics_collision_detected
.globl physics_update
.globl physics_action_jump 
.globl physics_action_shoot
.globl physics_action_dodge_left
.globl physics_action_dodge_right

physics_ground_level = 0x90
physics_jump_initial_speed = -10

;;INPUT:
;;  _COORD_OFFSET:  offset of entity coordinate, can be **
;;  _SIZE_OFFSET:   offset of entity axis-dependant size (height/width), can be **
;;  _START_ENTITY:  entity who's start is being checked, can be ix, iy
;;  _END_ENTITY:    entity who's end is being checked, can be ix, iy
;;DESTROYS: AF
.macro physics_ret_if_start_lesser_end _COORD_OFFSET, _SIZE_OFFSET, _START_ENTITY, _END_ENTITY
    ld	a,	_COORD_OFFSET(_END_ENTITY)
    add _SIZE_OFFSET(_END_ENTITY)
    sub	_COORD_OFFSET(_START_ENTITY)
    ret m ;;if substraction is negative, endIX < startIY
.endm