
INCLUDE "vram.asm"
INCLUDE "macros.asm"

Section "Tile Assets", ROMX, BANK[1]

TileMapData:
INCLUDE "assets.asm"
EndTileMapData:

TileMapDataSize EQU EndTileMapData - TileMapData

Section "VRAM Init methods", ROMX, BANK[1]

; Copies tile data into vram. Display should be off.
LoadTileData::
	ld HL, TileMapData
	ld DE, BaseTileMap
	ld BC, TileMapDataSize
	LongCopy ; copy BC bytes from [HL] to [DE]

; Write zeroes to sprite data
ClearSpriteData::
	ld B, 40 * 4 ; length of sprite table
	xor a
	ld HL, SpriteTable
.loop
	ld [HL+], a
	dec b
	jr nz, .loop
	ret
