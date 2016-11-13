include "ioregs.asm"
include "hram.asm"

Section "Stack", WRAM0

StackBottom::
	ds 128
StackTop::

section "Main", ROM0

; Actual execution starts here
Start::
	DI ; disable interrupts until we set a few things up

	xor A
	ld [SoundControl], A ; disable sound quickly to avoid weird noise

	; Set stack to top of internal RAM
	ld SP, StackTop

	; Initialize HRAM
	call LoadHRAMData

	; Initialize game state

	; Disable background while we're fucking with vram
	xor A
	ld [LCDControl], A

	; Initialize VRAM

	; Initialize other settings
	; Set pallettes
	ld A, %11100100
	ld [TileGridPalette], A
	ld [SpritePaletteTransparent], A
	ld [SpritePaletteSolid], A

	; Set up display
	ld A, %10010011 ; window off, background and sprites on, use signed tile map
	ld [LCDControl], A

	; Which interrupts we want: VBlank only
	ld a, %00000001
	ld [InterruptsEnabled], a

	xor a
	ld [InterruptFlags], a ; Cancel pending VBlank so interrupt doesn't fire immediately

	; enable interrupts, we're ready to go
	EI

	jp HaltForever # for now, we just let the vblank handler do everything

; Called upon vblank
Draw::
	push AF
	push BC
	push DE
	push HL

	call UpdateGraphics ; this part is vblank-sensitive
	call UpdateGame

	pop HL
	pop DE
	pop BC
	pop AF
	reti

