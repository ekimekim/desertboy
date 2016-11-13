include "constants.asm"
include "ioregs.asm"

SECTION "Input methods", ROM0

UpdateInputs::
	call GetInputs
	ld C, A

	bit 0, C ; set z if A pressed

	



; Load all inputs into a single bit field, 0-7: A, B, Select, Start, Right, Left, Up, Down
; Result in A
GetInputs::

	ld HL, JoyIO

	ld [HL], JoySelectDPad
	; waste time until ready
	ld B, 4
.waitDPad
	dec B
	jp nz, .waitDPad

	ld A, [HL] ; lower half of A contains dpad state
	swap A

	ld [HL], JoySelectButtons
	; waste time until ready
	ld B, 4
.waitButtons
	dec B
	jp nz, .waitButtons

	or [HL] ; A |= button state, which is only the lower half, dpad is upper half

	ret
