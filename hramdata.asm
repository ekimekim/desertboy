INCLUDE "macros.asm"

Section "HRAM Initial Values", ROMX, BANK[1]

HRAMData:
	dw 0 ; SubStep
	dw 0 ; Distance
	db 36, 64 ; Bus coords (X,Y)
EndManualHRAMData:
	REPT $7f - (EndManualHRAMData - HRAMData)
	db 0 ; fill the rest with zeroes
	ENDR

LoadHRAMData::
	ld HL, HRAMData
	ld DE, $ff80
	ld B, $7f
	Copy
	ret
