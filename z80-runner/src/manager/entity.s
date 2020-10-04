.include "entity.h.s"

;;NOTE: reconsider whether this being public is a good idea
entity_main_player:: entity_define
entity_enemy:: entity_define

entity_init::
    entity_fill #entity_main_player, #10, #4, #0x88
    ret

entity_update:
    ret