
; Copy BC bytes from [HL] to [DE]. Clobbers A.
LongCopy: MACRO
.loop\@
    ld A, [HL+]
    ld [DE], A
    inc DE
    dec BC
    xor A
    cp C
    jr nz, .loop\@
    cp B
    jr nz, .loop\@
	ENDM

; Copy B bytes from [HL] to [DE]. Clobbers A.
Copy: MACRO
.loop\@
	ld A, [HL+]
	ld [DE], A
	inc DE
	dec B
	jr nz, .loop\@
	ENDM
