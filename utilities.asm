include "ioregs.asm"
include "longcalc.asm"

Section "Utilities", ROM0

SpritesBit EQU 1

EnableSprites::
	ld HL, LCDControl
	set SpritesBit, [HL]
	ret

DisableSprites::
	ld HL, LCDControl
	res SpritesBit, [HL]
	ret

; HL = HL + DE * C
; Multiply DE by C and *add* the result to HL. Does not clobber A, B or C. Clobbers DE.
; If you care about speed and both your numbers are 8 bit, put the one that is probably small in C.
Multiply::
	; fully unrolled for speed. god knows it's slow enough.
	bit 0, C
	jr z, .next0
	LongAdd H,L, D,E, H,L
.next0
	LongShiftL D,E
	bit 1, C
	jr z, .next1
	LongAdd H,L, D,E, H,L
.next1
	LongShiftL D,E
	bit 2, C
	jr z, .next2
	LongAdd H,L, D,E, H,L
.next2
	LongShiftL D,E
	bit 3, C
	jr z, .next3
	LongAdd H,L, D,E, H,L
.next3
	LongShiftL D,E
	bit 4, C
	jr z, .next4
	LongAdd H,L, D,E, H,L
.next4
	LongShiftL D,E
	bit 5, C
	jr z, .next5
	LongAdd H,L, D,E, H,L
.next5
	LongShiftL D,E
	bit 6, C
	jr z, .next6
	LongAdd H,L, D,E, H,L
.next6
	LongShiftL D,E
	bit 7, C
	ret z
	LongAdd H,L, D,E, H,L
	ret
