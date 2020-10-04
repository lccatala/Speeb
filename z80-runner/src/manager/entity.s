.include "entity.h.s"

;;NOTE: reconsider whether this being public is a good idea
entity_main_player:: entity_define
entity_enemy:: entity_define

entity_init::
    entity_fill #entity_main_player, #0, #4, #0x88, #0x02, #0x08, #0x0F

    entity_fill #entity_enemy, #0, #50, #0x70, #0x01, #0x20, #0xFF
    ret
