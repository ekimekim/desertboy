include "constants.asm"
include "ioregs.asm"
include "longcalc.asm"
include "hram.asm"

SECTION "Input methods", ROM0

UpdateGame::
	call GetInputs
	ld B, A

	; load DE = speed
	ld A, [BusVelHi]
	ld D, A
	ld A, [BusVelLo]
	ld E, A

	bit 0, B ; set z if A pressed
	jr nz, .noAccel
	; accelerate
	LongAdd D,E, 0,BusAccel, D,E ; DE += BusAccel
.noAccel

	; are we offroad?
	ld A, [BusYPos]
	; offroad is defined as the bus center line (YPos+8) being above the edge (4*8=32)
	; or the wheels (YPos+12) being below the edge (14*8=112).
	; This translates to a YPos range of 24 < y <= 100
	sub 24
	jr c, .offroad
	cp 100-24 ; set carry if original value > 100
	jr c, .notOffroad
.offroad
	LongSub D,E, 0,BusDragOffroad, D,E ; DE -= BusDragOffroad
	jp c, Crash ; on underflow, it means we're speed 0 and offroad, ie crashed.
	; Note we do a tail call ret elision here, the above line is a "call & ret".
.notOffroad

	; road drag
	LongSub D,E, 0,BusDrag, D,E ; DE -= BusDrag
	jr c, .zeroSpeed ; on underflow, stop dragging and set zero

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

	; check for point
	cp BusPointDistanceHi - 1 ; TODO UPTO

	ld C, BusSteerSpeed
	ld HL, 0
	push DE
	call Multiply ; HL = 128 * speed
	pop DE ; don't clobber DE

	; check for Joy up or down, if found add/sub Steer Speed
	bit 6, B
	jr nz, .noUp

	; YPos.YSubPos -= 128 * speed
	LongSub [BusYSubPosHi],[BusYSubPosLo], H,L, [BusYSubPosHi],[BusYSubPosLo]
	ld A, [BusYPos]
	sbc 0 ; if carry, sub 1
	ld [BusYPos], A
	jr .afterSteer

.noUp
	bit 7, B
	jr nz, .noDown

	; YSubPos += 128 * speed
	LongAdd [BusYSubPosHi],[BusYSubPosLo], H,L, [BusYSubPosHi],[BusYSubPosLo]
	ld A, [BusYPos]
	adc 0 ; if carry, add 1
	ld [BusYPos], A
	jr .afterSteer

.noDown ; drift

	; YSubPos += 8 * speed
	ld C, BusDriftSpeed
	ld HL, 0
	call Multiply ; HL = 8 * speed
	LongAdd [BusYSubPosHi],[BusYSubPosLo], H,L, [BusYSubPosHi],[BusYSubPosLo]
	ld A, [BusYPos]
	adc 0 ; if carry, add 1
	ld [BusYPos], A

.afterSteer

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
	or C ; or together the two halves

	ret


Crash::
	jp HaltForever ; stub for now
