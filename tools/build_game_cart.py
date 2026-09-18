#!/usr/bin/env python3
"""Build the gameplay cart with lossless tiled shop art and shared audio."""

from __future__ import annotations

from collections import Counter
import re
import sys
from pathlib import Path

from PIL import Image


PICO8_PALETTE = (
    (0, 0, 0), (29, 43, 83), (126, 37, 83), (0, 135, 81),
    (171, 82, 54), (95, 87, 79), (194, 195, 199), (255, 241, 232),
    (255, 0, 77), (255, 163, 0), (255, 236, 39), (0, 228, 54),
    (41, 173, 255), (131, 118, 156), (255, 119, 168), (255, 204, 170),
)

FULL_TILE_COUNT = 220
SUBTILE_BASE = 221
CURSOR_SPRITE = 255


def section(cart: str, name: str) -> str:
    marker = f"__{name}__"
    start = cart.index(marker)
    match = re.search(r"^__[a-z0-9_]+__$", cart[start + len(marker):], re.MULTILINE)
    end = start + len(marker) + match.start() if match else len(cart)
    return cart[start:end].rstrip()


def load_pixels(source: Path) -> tuple[list[list[int]], int, int, tuple[int, int, int, int]]:
    image = Image.open(source).convert("RGBA")
    width, height = image.size
    buy = (126, 64, 189, 77)
    pixels: list[list[int]] = []
    for y in range(height):
        row: list[int] = []
        for x in range(width):
            red, green, blue, alpha = image.getpixel((x, y))
            if alpha not in (0, 255):
                raise ValueError(f"{source}: alpha must be either 0 or 255")
            if alpha == 0:
                row.append(0)
                continue
            try:
                row.append(PICO8_PALETTE.index((red, green, blue)))
            except ValueError as error:
                raise ValueError(
                    f"{source}: off-palette pixel {(red, green, blue)} at {(x, y)}"
                ) from error
        pixels.append(row)

    return pixels, width, height, buy


def source_tile(pixels: list[list[int]], tx: int, ty: int) -> tuple[int, ...]:
    height = len(pixels)
    width = len(pixels[0])
    return tuple(
        pixels[ty * 8 + y][tx * 8 + x]
        if tx * 8 + x < width and ty * 8 + y < height else 0
        for y in range(8) for x in range(8)
    )


def subtile(tile: tuple[int, ...], ox: int, oy: int) -> tuple[int, ...]:
    return tuple(tile[(oy + y) * 8 + ox + x] for y in range(4) for x in range(4))


def place(atlas: list[list[int]], tile: tuple[int, ...], x: int, y: int, size: int) -> None:
    for py in range(size):
        for px in range(size):
            atlas[y + py][x + px] = tile[py * size + px]


def build_shop(source: Path) -> tuple[list[str], list[str], str]:
    pixels, width, height, buy = load_pixels(source)
    map_width = (width + 7) // 8
    map_height = (height + 7) // 8
    tiles = [
        source_tile(pixels, tx, ty)
        for ty in range(map_height) for tx in range(map_width)
    ]
    blank = (0,) * 64
    ordered = [tile for tile, _count in Counter(tiles).most_common() if tile != blank]
    full_tiles = ordered[:FULL_TILE_COUNT]
    full_ids = {tile: index + 1 for index, tile in enumerate(full_tiles)}

    atlas = [[0 for _x in range(128)] for _y in range(128)]
    for tile, sprite_id in full_ids.items():
        place(atlas, tile, sprite_id % 16 * 8, sprite_id // 16 * 8, 8)

    tilemap = [[0 for _x in range(128)] for _y in range(32)]
    small_ids: dict[tuple[int, ...], int] = {}
    overflows: list[tuple[int, ...]] = []

    for ty in range(map_height):
        for tx in range(map_width):
            tile = tiles[ty * map_width + tx]
            if tile == blank:
                continue
            if tile in full_ids:
                tilemap[ty][tx] = full_ids[tile]
                continue

            record = [tx, ty]
            for oy in (0, 4):
                for ox in (0, 4):
                    small = subtile(tile, ox, oy)
                    if small not in small_ids:
                        small_ids[small] = len(small_ids)
                    record.append(small_ids[small])
            overflows.append(tuple(record))

    sprite_count = SUBTILE_BASE + (len(small_ids) + 3) // 4
    if sprite_count > CURSOR_SPRITE:
        raise ValueError(f"{source}: tiled image needs {sprite_count} sprites")

    small_by_id = [None] * len(small_ids)
    for small, small_id in small_ids.items():
        small_by_id[small_id] = small
        sprite_id = SUBTILE_BASE + small_id // 4
        quadrant = small_id % 4
        x = sprite_id % 16 * 8 + quadrant % 2 * 4
        y = sprite_id // 16 * 8 + quadrant // 2 * 4
        place(atlas, small, x, y, 4)

    cursor = (
        "1.......",
        "11......",
        "171.....",
        "1771....",
        "17771...",
        "177771..",
        "17111...",
        "1.171...",
    )
    for y, row in enumerate(cursor):
        for x, value in enumerate(row):
            if value != ".":
                atlas[CURSOR_SPRITE // 16 * 8 + y][CURSOR_SPRITE % 16 * 8 + x] = int(value)

    # Prove that the atlas plan reconstructs every source pixel exactly.
    reconstructed = [[0 for _x in range(map_width * 8)] for _y in range(map_height * 8)]
    overflow_by_pos = {(record[0], record[1]): record for record in overflows}
    for ty in range(map_height):
        for tx in range(map_width):
            sprite_id = tilemap[ty][tx]
            if sprite_id:
                tile = full_tiles[sprite_id - 1]
                for y in range(8):
                    reconstructed[ty * 8 + y][tx * 8:tx * 8 + 8] = tile[y * 8:y * 8 + 8]
            elif (tx, ty) in overflow_by_pos:
                record = overflow_by_pos[(tx, ty)]
                for part, small_id in enumerate(record[2:]):
                    small = small_by_id[small_id]
                    ox, oy = part % 2 * 4, part // 2 * 4
                    for y in range(4):
                        reconstructed[ty * 8 + oy + y][tx * 8 + ox:tx * 8 + ox + 4] = \
                            small[y * 4:y * 4 + 4]

    assert all(
        reconstructed[y][x] == pixels[y][x]
        for y in range(height) for x in range(width)
    ), "lossless shop reconstruction failed"

    gfx = ["".join(format(pixel, "x") for pixel in row) for row in atlas]
    map_rows = ["".join(format(cell, "02x") for cell in row) for row in tilemap]
    encoded = ";".join(",".join(str(value) for value in record) for record in overflows)
    overflow_setup = f'''shop_art.overflows={{}}

for record in all(split("{encoded}",";")) do
 add(shop_art.overflows,split(record,","))
end
''' if overflows else ""
    overflow_draw = f''' for record in all(shop_art.overflows) do
  for part=0,3 do
   local small_id=record[part+3]
   local sprite_id={SUBTILE_BASE}+small_id\\4
   sspr(
    sprite_id%16*8+small_id%2*4,
    sprite_id\\16*8+(small_id\\2)%2*4,
    4,4,
    record[1]*8+part%2*4,
    record[2]*8+part\\2*4
   )
  end
 end
''' if overflows else ""
    lua = f'''-- Generated from {source.name}. Edit the PNG, not this file.

shop_art={{
 width={width},height={height},map_width={map_width},map_height={map_height},
 buy={{{buy[0]},{buy[1]},{buy[2]},{buy[3]}}},
 close={{187,4,193,10}},
 browser_address={{60,3,158,11}},
 description={{124,79,196,127}}
}}
{overflow_setup}

function shop_art.draw()
 map(0,0,0,0,shop_art.map_width,shop_art.map_height)
{overflow_draw}
end
'''
    return gfx, map_rows, lua


def main() -> None:
    if len(sys.argv) != 6:
        raise SystemExit(
            "usage: build_game_cart.py GAME_SOURCE INTRO_CART SHOP_PNG SHOP_LUA OUTPUT"
        )

    game_source = Path(sys.argv[1])
    intro_source = Path(sys.argv[2])
    shop_source = Path(sys.argv[3])
    shop_lua = Path(sys.argv[4])
    output = Path(sys.argv[5])

    source = game_source.read_text(encoding="ascii").rstrip()
    intro = intro_source.read_text(encoding="ascii")
    gfx, map_rows, lua = build_shop(shop_source)

    shop_lua.parent.mkdir(parents=True, exist_ok=True)
    shop_lua.write_text(lua, encoding="ascii")
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        source + "\n__gfx__\n" + "\n".join(gfx) +
        "\n__gff__\n__map__\n" + "\n".join(map_rows) + "\n" +
        section(intro, "sfx") + "\n" + section(intro, "music") + "\n",
        encoding="ascii",
    )


if __name__ == "__main__":
    main()
