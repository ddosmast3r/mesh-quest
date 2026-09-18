#!/usr/bin/env python3
"""Pack temporary prologue PNGs into compact Lua RLE strings."""

from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image


PALETTE = (
    (0, 0, 0), (29, 43, 83), (126, 37, 83), (0, 135, 81),
    (171, 82, 54), (95, 87, 79), (194, 195, 199), (255, 241, 232),
    (255, 0, 77), (255, 163, 0), (255, 236, 39), (0, 228, 54),
    (41, 173, 255), (131, 118, 156), (255, 119, 168), (255, 204, 170),
)
ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_"
FILES = (
    ("gamepad", "slide_3_gamepad.png"),
    ("video", "slide_5_video.png"),
    ("mesh", "slide_6_mesh.png"),
    ("thinking", "slide_7_thinking.png"),
)
WIDTH = 128
HEIGHT = 72


def nearest_colour(pixel: tuple[int, int, int]) -> int:
    return min(
        range(16),
        key=lambda index: sum((pixel[channel] - PALETTE[index][channel]) ** 2 for channel in range(3)),
    )


def pixels(path: Path) -> list[int]:
    source = Image.open(path).convert("RGB")
    mask = Image.new("1", source.size)
    mask.putdata([max(pixel) > 10 for pixel in source.getdata()])
    bounds = mask.getbbox()
    if bounds is None:
        raise ValueError(f"{path}: no visible pixels")

    source = source.crop(bounds)
    source.thumbnail((104, 68), Image.Resampling.LANCZOS)
    canvas = Image.new("RGB", (WIDTH, HEIGHT))
    canvas.paste(source, ((WIDTH - source.width) // 2, (HEIGHT - source.height) // 2))
    return [nearest_colour(pixel) for pixel in canvas.getdata()]


def encode(values: list[int]) -> str:
    output: list[str] = []
    index = 0
    while index < len(values):
        colour = values[index]
        length = 1
        while index + length < len(values) and values[index + length] == colour and length < 256:
            length += 1
        value = (length - 1) * 16 + colour
        output.append(ALPHABET[value // 64])
        output.append(ALPHABET[value % 64])
        index += length
    return "".join(output)


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: build_story_placeholders.py INPUT_DIR OUTPUT.lua")
    source = Path(sys.argv[1])
    output = Path(sys.argv[2])
    lines = ["-- Generated from ref/scene_0/placeholders. Edit the PNGs, not this file.", "story_placeholder_data={"]
    for name, filename in FILES:
        lines.append(f' {name}="{encode(pixels(source / filename))}",')
    lines.append("}")
    output.write_text("\n".join(lines) + "\n", encoding="ascii")


if __name__ == "__main__":
    main()
