#!/usr/bin/env python3
"""Build a code-only chapter cart while preserving the intro cart audio."""

from __future__ import annotations

import sys
from pathlib import Path

from build_game_cart import section


def main() -> None:
    if len(sys.argv) != 4:
        raise SystemExit("usage: build_code_cart.py SOURCE_CART INTRO_CART OUTPUT")

    source_path, intro_path, output_path = map(Path, sys.argv[1:])
    source = source_path.read_text(encoding="ascii").rstrip()
    intro = intro_path.read_text(encoding="ascii")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        source + "\n" + section(intro, "sfx") + "\n" + section(intro, "music") + "\n",
        encoding="ascii",
    )


if __name__ == "__main__":
    main()
