.include "entity.h.s"
.include "../system/physics.h.s"

;;NOTE: reconsider whether this being public is a good idea
entity_main_player:: entity_define
entity_enemy:: entity_define

entity_init::
    entity_fill #entity_main_player, #0, #12, #(physics_ground_level-0x08), #0x02, #0x08, #0x0F, #entity_ai_status_no
    entity_fill #entity_enemy, #0, #50, #(physics_ground_level-0x20), #0x01, #0x20, #0xFF, #entity_ai_status_no
    ret
