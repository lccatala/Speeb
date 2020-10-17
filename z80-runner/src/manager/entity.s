.include "entity.h.s"
.include "../system/physics.h.s"

;;NOTE: reconsider whether this being public is a good idea
entity_main_player:: entity_define
entity_enemy:: entity_define
entity_end:: entity_define


entity_init::
    entity_fill #entity_main_player, #0, #4, #(physics_ground_level-0x08), #0x02, #0x08, #0x0F

    entity_fill #entity_enemy, #0, #50, #(physics_ground_level-0x20), #0x01, #0x20, #0xFF

    entity_fill #entity_end, #0, #70, #(physics_ground_level-0x50), #0x02, #0x50, #0x0f
    ret
