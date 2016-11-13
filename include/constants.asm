
; Acceleration per frame from accelerator
BusAccel EQU 3

; Max speed by holding accelerator. Upper byte only, ie. it's in units of 256 substeps.
BusTopSpeedHi EQU $2

; Slow-down on road per frame
BusDrag EQU 1

; Extra slow-down offroad, per frame
BusDragOffroad EQU 5

; Value BusYSubPosHi must reach before moving BusYPos by 1 pixel
BusDriftSubLimit EQU 12

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
