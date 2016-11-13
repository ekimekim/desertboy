INCLUDE "macros.asm"

Section "HRAM Initial Values", ROMX, BANK[1]

HRAMData:
	REPT $7f
	db 0
	ENDR

LoadHRAMData::
	ld HL, HRAMData
	ld DE, $ff80
	ld B, $7f
	Copy
	ret
