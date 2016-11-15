
INCLUDE "vram.asm"
INCLUDE "ioregs.asm"
INCLUDE "macros.asm"
INCLUDE "tiledefs.asm"

Section "Tile Assets", ROMX, BANK[1]

TileMapData:
INCLUDE "tilemap.asm"
EndTileMapData:

TileGridData:
INCLUDE "tilegrid.asm"
EndTileGridData:

WindowGridData:
INCLUDE "windowgrid.asm"
EndWindowGridData

TileMapDataSize EQU EndTileMapData - TileMapData
TileGridDataSize EQU EndTileGridData - TileGridData
WindowGridDataSize EQU EndWindowGridData - WindowGridData

SpriteData:
; the bus is the first 6 sprite slots
; sprites are (Y+16, X+8, Tile, flags: priority, y flip, x flip, alt pallete, unused*4)
; numbers are arranged on screen thus:
;   1 3 5
;   2 4 6
db 0, 0, TileBus1, 0
db 0, 0, TileBus2, 0
db 0, 0, TileBus3, 0
db 0, 0, TileBus4, 0
db 0, 0, TileBus5, 0
db 0, 0, TileBus6, 0
EndSpriteData:
ds 40 * 4 - (EndSpriteData - SpriteData)

Section "VRAM Init methods", ROMX, BANK[1]

; Copies tile data into vram. Display should be off.
LoadTileData::
	ld HL, TileMapData
	ld DE, BaseTileMap
	ld BC, TileMapDataSize
	LongCopy ; copy BC bytes from [HL] to [DE]
	ret

; Copies initial values to sprite data
LoadSpriteData::
	ld B, 40 * 4 ; length of sprite table
	ld HL, SpriteData
	ld DE, SpriteTable
	Copy ; copy B bytes from [HL] to [DE]
	ret

; Copies 32x18 ribbon of cycling map tiles into TileGrid
LoadTileGrid::
	ld HL, TileGridData
	ld DE, TileGrid
	ld BC, TileGridDataSize
	LongCopy
	ret


; Copies 32x18 of data to the AltTileGrid, for use in the window
LoadWindow::
	xor A
	ld [WindowX], A
	ld A, $ff
	ld [WindowY], A

	ld HL, WindowGridData
	ld DE, AltTileGrid
	ld BC, WindowGridDataSize
	LongCopy
	ret
