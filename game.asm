include "constants.asm"
include "ioregs.asm"
include "longcalc.asm"
include "hram.asm"

SECTION "Input methods", ROM0

UpdateGame::
	call GetInputs
	ld C, A

	; load DE = speed
	ld A, [BusVelHi]
	ld D, A
	ld A, [BusVelLo]
	ld E, A

	bit 0, C ; set z if A pressed
	jr nz, .noAccel
	; accelerate
	LongAdd D,E, 0,BusAccel, D,E ; DE += BusAccel
.noAccel

	; road drag
	LongSub D,E, 0,BusDrag, D,E ; DE -= BusDrag
	jr c, .zeroSpeed ; on underflow, stop dragging and set zero

	; are we offroad?
	; TODO
.notOffroad

	; check speed upper bound
	ld A, BusTopSpeedHi
	cp D ; set carry if D > Top Speed, set zero if equal
	jr z, .topSpeed
	jr nc, .noTopSpeed
.topSpeed
	ld D, A
	ld E, 0
.noTopSpeed
	jr .afterZeroSpeed

.zeroSpeed
	ld D, 0
	ld E, 0

	; TODO check lose cond

.afterZeroSpeed

	; save VelY
	ld A, D
	ld [BusVelHi], A
	ld A, E
	ld [BusVelLo], A

	; add to Distance and SubStep
	LongAdd [SubStepHi],[SubStepLo], D,E, [SubStepHi],[SubStepLo]
	; Distance += 0 with carry
	ld A, [DistanceLo]
	adc 0
	ld [DistanceLo], A
	ld A, [DistanceHi]
	adc 0
	ld [DistanceHi], A
	; TODO check win cond

	; BusYSubPos += forward speed, then check if it exceeds BusDriftSubLimit
	; and if so, BusYPos -= 1

	LongAdd [BusYSubPosHi],[BusYSubPosLo], D,E, D,E ; DE = YSubPos + speed

	ld HL, BusYPos

	ld A, D
	sub BusDriftSubLimit
	jr c, .noDrift ; jump if D < drift limit
	ld D, A ; D -= drift limit
	dec [HL] ; BusYPos -= 1
.noDrift

	; save the BusYSubPos
	ld A, D
	ld [BusYSubPosHi], A
	ld A, E
	ld [BusYSubPosLo], A

	; check for Joy up or down
	xor A
	bit 6, C
	jr nz, .noUp
	inc A
.noUp
	bit 7, C
	jr nz, .noDown
	dec A
.noDown

	add [HL]
	ld [HL], A ; BusYPos += delta

	ret


; Load all inputs into a single bit field, 0-7: A, B, Select, Start, Right, Left, Up, Down
; Result in C. Clobbers ABHL
GetInputs::

	ld HL, JoyIO

	ld [HL], JoySelectDPad
	; waste time until ready
	ld B, 4
.waitDPad
	dec B
	jp nz, .waitDPad

	ld A, [HL] ; lower half of A contains dpad state
	and $0f
	swap A
	ld C, A

	ld [HL], JoySelectButtons
	; waste time until ready
	ld B, 4
.waitButtons
	dec B
	jp nz, .waitButtons

	ld A, [HL]
	and $0f
	or C
	ld C, A ; or together the two halves

	ret
