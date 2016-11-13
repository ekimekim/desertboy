
; effectively 32-bit milage counter, for convenience represented as a 16-bit substep counter
; and a 16-bit distance counter. One pixel is 256 substeps.
SubStepHi EQU $ff80
SubStepLo EQU $ff81
DistanceHi EQU $ff82
DistanceLo EQU $ff83

; x,y coord of top-left corner of bus
BusXPos EQU $ff84
BusYPos EQU $ff85

; X and Y velocity of the bus
; X is 8-bit and in pixels
; Y is 16-bit and in Sub-steps, which as above is 1/256th of a pixel
BusXVel EQU $ff86
BusYVelHi EQU $ff87
BusYVelLo EQU $ff88
