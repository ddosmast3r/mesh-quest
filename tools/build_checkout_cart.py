#!/usr/bin/env python3
"""Build the checkout cutscene cart from the payment-error reference."""

from __future__ import annotations

from collections import Counter
import sys
from pathlib import Path

from PIL import Image

from build_game_cart import (
    FULL_TILE_COUNT,
    PICO8_PALETTE,
    SUBTILE_BASE,
    place,
    section,
    source_tile,
    subtile,
)


TARGET_SIZE = (192, 128)


def load_pixels(source: Path) -> list[list[int]]:
    image = Image.open(source).convert("RGB").resize(
        TARGET_SIZE, Image.Resampling.LANCZOS
    )
    pixels: list[list[int]] = []
    for y in range(image.height):
        row: list[int] = []
        for x in range(image.width):
            color = image.getpixel((x, y))
            row.append(min(
                range(len(PICO8_PALETTE)),
                key=lambda index: sum(
                    (component - target) ** 2
                    for component, target in zip(color, PICO8_PALETTE[index])
                ),
            ))
        pixels.append(row)
    return pixels


def build_art(source: Path) -> tuple[list[str], list[str], str]:
    pixels = load_pixels(source)
    width, height = TARGET_SIZE
    map_width = (width + 7) // 8
    map_height = (height + 7) // 8
    tiles = [
        source_tile(pixels, tx, ty)
        for ty in range(map_height) for tx in range(map_width)
    ]
    blank = (0,) * 64
    ordered = [tile for tile, _ in Counter(tiles).most_common() if tile != blank]
    full_tiles = ordered[:FULL_TILE_COUNT]
    full_ids = {tile: index + 1 for index, tile in enumerate(full_tiles)}

    atlas = [[0 for _ in range(128)] for _ in range(128)]
    for tile, sprite_id in full_ids.items():
        place(atlas, tile, sprite_id % 16 * 8, sprite_id // 16 * 8, 8)

    tilemap = [[0 for _ in range(128)] for _ in range(32)]
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
    if sprite_count > 256:
        raise ValueError(f"{source}: tiled image needs {sprite_count} sprites")

    for small, small_id in small_ids.items():
        sprite_id = SUBTILE_BASE + small_id // 4
        quadrant = small_id % 4
        place(
            atlas,
            small,
            sprite_id % 16 * 8 + quadrant % 2 * 4,
            sprite_id // 16 * 8 + quadrant // 2 * 4,
            4,
        )

    gfx = ["".join(format(pixel, "x") for pixel in row) for row in atlas]
    map_rows = ["".join(format(cell, "02x") for cell in row) for row in tilemap]
    encoded = ";".join(",".join(str(value) for value in row) for row in overflows)
    lua = f'''-- Generated from {source.name}. Edit the PNG, not this file.

checkout_art={{width={width},height={height},map_width={map_width},map_height={map_height}}}
checkout_art.overflows={{}}

for record in all(split("{encoded}",";")) do
 add(checkout_art.overflows,split(record,","))
end

function checkout_art.draw()
 map(0,0,0,0,checkout_art.map_width,checkout_art.map_height)
 for record in all(checkout_art.overflows) do
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
end
'''
    return gfx, map_rows, lua


def main() -> None:
    if len(sys.argv) != 6:
        raise SystemExit(
            "usage: build_checkout_cart.py SOURCE_CART INTRO_CART PNG LUA OUTPUT"
        )

    source_cart, intro_cart, art_source, lua_output, cart_output = map(
        Path, sys.argv[1:]
    )
    source = source_cart.read_text(encoding="ascii").rstrip()
    intro = intro_cart.read_text(encoding="ascii")
    gfx, map_rows, lua = build_art(art_source)

    lua_output.parent.mkdir(parents=True, exist_ok=True)
    lua_output.write_text(lua, encoding="ascii")
    cart_output.parent.mkdir(parents=True, exist_ok=True)
    cart_output.write_text(
        source + "\n__gfx__\n" + "\n".join(gfx)
        + "\n__gff__\n__map__\n" + "\n".join(map_rows) + "\n"
        + section(intro, "sfx") + "\n" + section(intro, "music") + "\n",
        encoding="ascii",
    )


if __name__ == "__main__":
    main()
