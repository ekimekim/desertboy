
include "hram.asm"
include "vram.asm"
include "macros.asm"

Section "VBlank Drawing Routines", ROM0


UpdateGraphics::

	; Calculate how many new rows are exposed as (new scroll / 8) - (old scroll / 8)
	ld A, SubStepHi
	ShiftRN A, 3 ; div by 8
	ld B, ScrollX
	ShiftRN B, 3 ; div by 8
	sub B ; A = A - B

	; Copy in that many new rows
