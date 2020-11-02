;; Speeb
;; Copyright (C) 2020  University of Alicante
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

.module ai_control

.globl ai_control_update
.globl ai_control_stand_by_x
.globl ai_control_stand_by_y
.globl ai_control_move_to_x
.globl ai_control_move_to_y
.globl ai_control_cross_screen
.globl ai_control_zigzag
.globl ai_control_suicide
;;.globl ai_control_init