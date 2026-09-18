#!/usr/bin/env python3
"""Build the story scene's slow two-chord ambient guitar wash."""

from __future__ import annotations

import sys
from pathlib import Path


SPEED = 36
SILENCE = "00000"


def note(pitch: int, waveform: int, volume: int, effect: int = 5) -> str:
    return f"{pitch:02x}{waveform:x}{volume:x}{effect:x}"


def phrase(events: dict[int, tuple[int, int, int, int]]) -> str:
    rows = [SILENCE] * 32
    for row, values in events.items():
        rows[row] = note(*values)
    return f"00{SPEED:02x}0000" + "".join(rows)


def voice(
    pitches: list[tuple[int, int]],
    waveform: int,
    volume: int,
    effect: int = 5,
) -> str:
    return phrase({row: (pitch, waveform, volume, effect) for row, pitch in pitches})


def blank_sfx() -> str:
    return "00010000" + SILENCE * 32


# E(add9) and C#m7 alternate as soft fields rather than a melody. Channel 2
# repeats the guitar voice later and quieter to imitate a long reverb tail.
SFX = (
    voice([(0, 16), (8, 16), (16, 16), (24, 16)], 0, 2),
    voice([(0, 28), (8, 35), (16, 42), (24, 32)], 7, 3),
    voice([(4, 28), (12, 35), (20, 42), (28, 32)], 7, 1),
    voice([(0, 13), (8, 13), (16, 13), (24, 13)], 0, 2),
    voice([(0, 25), (8, 32), (16, 35), (24, 40)], 7, 3),
    voice([(4, 25), (12, 32), (20, 35), (28, 40)], 7, 1),
    voice([(0, 16), (8, 16), (16, 16), (24, 16)], 0, 2),
    voice([(0, 35), (8, 40), (16, 39), (24, 32)], 7, 3),
    voice([(4, 35), (12, 40), (20, 39), (28, 32)], 7, 1),
    voice([(0, 11), (8, 11), (16, 13), (24, 13)], 0, 2),
    voice([(0, 32), (8, 35), (16, 40), (24, 35)], 7, 3),
    voice([(4, 32), (12, 35), (20, 40), (28, 35)], 7, 1),
)

MUSIC = (
    "01 10111240",
    "00 13141540",
    "00 16171840",
    "02 191a1b40",
)


def patch_cartridge(cartridge: Path) -> None:
    lines = cartridge.read_text(encoding="ascii").splitlines()
    sfx_header = lines.index("__sfx__")
    music_header = lines.index("__music__")
    label_header = lines.index("__label__")

    sfx = lines[sfx_header + 1:music_header]
    while len(sfx) < 16 + len(SFX):
        sfx.append(blank_sfx())
    sfx[16:16 + len(SFX)] = SFX

    lines[sfx_header + 1:music_header] = sfx
    music_header = lines.index("__music__")
    label_header = lines.index("__label__")
    lines[music_header + 1:label_header] = MUSIC
    cartridge.write_text("\n".join(lines) + "\n", encoding="ascii")


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("usage: build_music.py CARTRIDGE.p8")
    patch_cartridge(Path(sys.argv[1]))


if __name__ == "__main__":
    main()
