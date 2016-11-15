
include "hram.asm"
include "vram.asm"
include "ioregs.asm"

Section "VBlank Drawing Routines", ROM0

UpdateGraphics::

	; Update scroll position, moving the entire screen left
	ld A, [SubStepHi]
	ld [ScrollX], A

	call UpdateBusSprite
	call UpdateScoreSprite
	call UpdateFadeGraphics

	ret


UpdateBusSprite::
	ld HL, SpriteTable

	; B, C = top, bottom Y positions
	ld A, [BusYPos]
	add 16
	ld B, A
	add 8
	ld C, A

	; A = leftmost X position
	ld A, [BusXPos]
	add 8

REPT 2
	ld [HL], B ; set Y
	inc HL
	ld [HL+], A ; set X
	inc HL
	inc HL ; inc to next sprite
	ld [HL], C ; set Y
	inc HL
	ld [HL+], A ; set X
	inc HL
	inc HL ; inc to next sprite
	add 8 ; inc X pos for next column
ENDR
	ld [HL], B ; set Y
	inc HL
	ld [HL+], A ; set X
	inc HL
	inc HL ; inc to next sprite
	ld [HL], C ; set Y
	inc HL
	ld [HL], A ; set X

	ret


UpdateScoreSprite::
	; TODO
	ret


; we fade with a flying window, pre-set to be solid color, x position = fade progress - 1 so it's invisible at 0
UpdateFadeGraphics::
	ld A, [FadeProgress]
	sub 1
	ld [WindowX], A
	ret
