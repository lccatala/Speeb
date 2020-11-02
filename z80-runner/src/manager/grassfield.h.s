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

.module grassfield


.globl grassfield_init
.globl grassfield_grass_array
.globl grassfield_update
.globl grassfield_for_all_grass
.globl grassfield_advance_count
.globl grassfield_advance_offset

grassfield_space_between_grass = 14

grass_is_dead       = 0
grass_x_coord       = grass_is_dead+1
grass_y_coord       = grass_x_coord+1
grass_last_screen   = grass_y_coord+1
grass_last_screen_l = grass_last_screen
grass_last_screen_h = grass_last_screen+1
grass_size          = grass_last_screen+2

grass_max           = 20

.macro grass_define
    .rept #grass_size
        .db #0xAA
    .endm
.endm

.macro grass_define_array _N
    .rept #_N
        grass_define
    .endm
.endm
