
; effectively 32-bit milage counter, for convenience represented as a 16-bit substep counter
; and a 16-bit distance counter. One pixel is 256 substeps.
SubStepHi EQU $ff80
SubStepLo EQU $ff81
DistanceHi EQU $ff82
DistanceLo EQU $ff83
