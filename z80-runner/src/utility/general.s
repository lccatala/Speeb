.include "general.h.s"


.globl cpct_waitVSYNC_asm

;;INPUT:
;; A: number of times to wait
;;DESTROYS: AF, BC
general_wait_cycles::
   halt
   halt
   push af
   call     cpct_waitVSYNC_asm
   pop af
   dec a
   jr nz, general_wait_cycles
   ret