#!/usr/bin/env python3
"""Import scene_0 reference frames into reserved PICO-8 sprite-sheet areas."""

from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image


ASSETS = (
    ("slide_1.png", 0, 16, 60, 72, "sunlight"),
    ("slide_2.png", 60, 16, 68, 72, "computer"),
)

BAYER_4X4 = (
    (0, 8, 2, 10),
    (12, 4, 14, 6),
    (3, 11, 1, 9),
    (15, 7, 13, 5),
)


def quantize_sunlight(red: int, green: int, blue: int, dither: float) -> int:
    luminance = .2126 * red + .7152 * green + .0722 * blue + dither * 2

    if max(red, green, blue) < 22 or luminance < 28:
        return 0
    if luminance < 100:
        return 4
    if luminance < 175:
        return 9
    if luminance < 232:
        return 10
    return 15


def quantize_computer(red: int, green: int, blue: int, _dither: float) -> int:
    luminance = .2126 * red + .7152 * green + .0722 * blue

    if max(red, green, blue) < 22 or luminance < 25:
        return 0

    # Keep the phosphor screen green instead of letting its dark pixels turn grey.
    if green > red * 1.3 and green > blue * 1.3:
        if luminance < 45:
            return 3
        return 11

    if luminance < 82:
        return 5
    if luminance < 168:
        return 6
    if luminance < 226:
        return 15
    return 7


def convert(reference: Path, width: int, height: int, mode: str) -> list[list[int]]:
    image = Image.open(reference).convert("RGB")
    mask = Image.new("1", image.size)
    mask.putdata([max(pixel) > 20 for pixel in image.getdata()])
    bounds = mask.getbbox()
    if bounds is None:
        raise ValueError(f"{reference}: image contains no visible pixels")

    image = image.crop(bounds).resize(
        (width, height),
        Image.Resampling.LANCZOS,
    )

    pixels: list[list[int]] = []
    quantize = quantize_sunlight if mode == "sunlight" else quantize_computer

    for y in range(height):
        row: list[int] = []
        for x in range(width):
            red, green, blue = image.getpixel((x, y))
            dither = BAYER_4X4[y % 4][x % 4] - 7.5
            row.append(quantize(red, green, blue, dither))
        pixels.append(row)

    return pixels


def convert_frame(reference: Path) -> list[list[int]]:
    image = Image.open(reference).convert("RGB").resize(
        (64, 64), Image.Resampling.LANCZOS
    )
    canvas = Image.new("RGB", (128, 64))
    canvas.paste(image, (32, 0))
    pixels: list[list[int]] = []
    for y in range(64):
        row: list[int] = []
        for x in range(128):
            red, green, blue = canvas.getpixel((x, y))
            dither = BAYER_4X4[y % 4][x % 4] - 7.5
            row.append(quantize_sunlight(red, green, blue, dither))
        pixels.append(row)
    return pixels


def patch_cartridge(cartridge: Path, reference_dir: Path) -> None:
    lines = cartridge.read_text(encoding="ascii").splitlines()
    gfx_header = lines.index("__gfx__")
    gff_header = lines.index("__gff__")
    gfx = [list(line) for line in lines[gfx_header + 1:gff_header]]

    if len(gfx) != 128 or any(len(row) != 128 for row in gfx):
        raise ValueError(f"{cartridge}: expected a 128x128 __gfx__ section")

    for filename, sprite_x, sprite_y, width, height, mode in ASSETS:
        pixels = convert(reference_dir / filename, width, height, mode)
        for y in range(height):
            for x in range(width):
                gfx[sprite_y + y][sprite_x + x] = format(pixels[y][x], "x")

    lines[gfx_header + 1:gff_header] = ["".join(row) for row in gfx]

    # The third 128x64 frame fits exactly in the cartridge's 4096-byte map.
    frame = convert_frame(reference_dir / "slide_3.png")
    packed = [
        frame[y][x] | frame[y][x + 1] << 4
        for y in range(64) for x in range(0, 128, 2)
    ]
    map_header = lines.index("__map__")
    sfx_header = lines.index("__sfx__")
    lines[map_header + 1:sfx_header] = [
        "".join(f"{byte:02x}" for byte in packed[offset:offset + 128])
        for offset in range(0, len(packed), 128)
    ]
    cartridge.write_text("\n".join(lines) + "\n", encoding="ascii")


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: build_story_art.py REFERENCE_DIR CARTRIDGE.p8")

    reference_dir = Path(sys.argv[1])
    cartridge = Path(sys.argv[2])
    patch_cartridge(cartridge, reference_dir)


if __name__ == "__main__":
    main()
