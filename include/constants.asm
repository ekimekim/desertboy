
; Acceleration per frame from accelerator
BusAccel EQU 3

; Max speed by holding accelerator. Upper byte only, ie. it's in units of 256 substeps.
BusTopSpeedHi EQU $2

; How many seconds it should take to get a point at top speed
; BusPointTimeSec EQU 3600*8 ; real value
; BusPointTimeSec EQU 10 ; for testing
BusPointTimeSec EQU 120 ; for showing off

; Derived from above, the Distance value required
BusPointTimeFrames EQU BusPointTimeSec * 60
BusPointDist256Subs EQU BusPointTimeFrames * BusTopSpeedHi
BusPointDistance EQU BusPointDist256Subs / 256
BusPointDistanceHi EQU BusPointDistance / 256
BusPointDistanceLo EQU BusPointDistance % 256

BusXPosInitial EQU 36
BusYPosInitial EQU 64

; Slow-down on road per frame
BusDrag EQU 1

; Extra slow-down offroad, per frame
BusDragOffroad EQU 5

BusSteerSpeed EQU 127
BusDriftSpeed EQU 8

IF BusSteerSpeed * BusTopSpeedHi >= 256
FAIL "Steer Speed * Top Speed must fit within 8 bits"
ENDC

; Debugging values
AR EQU BusAccel - BusDrag
NAR EQU BusDrag
AO EQU BusDrag + BusDragOffroad - BusAccel
NAO EQU BusDrag + BusDragOffroad
PRINTT "Acceleration grid:\n"
PRINTT "A  on off\n"
PRINTT "R: {AR} {NAR}\n"
PRINTT "O: {AO} {NAO}\n"
PURGE AR, NAR, AO, NAO

PRINTT "Milliseconds to max speed: "
PRINTV BusTopSpeedHi * 256 * 1000 / ((BusAccel - BusDrag) * 60)
PRINTT "\n"

PRINTT "Actual time for point at max speed after rounding, in frames: "
PRINTV BusPointDistance * 256 / BusTopSpeedHi
PRINTT "\n"
