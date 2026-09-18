#!/usr/bin/env python3
"""Compile a human-readable UTF-8 .story file into PICO-8-safe Lua."""

from __future__ import annotations

import re
import sys
from pathlib import Path


GLYPH_IDS = dict(zip(
    "абвгдеёжзийклмнопрстуфхцчшщъыьэюя",
    "abcdefghijklmnopqrstuvwxyzABCDEFG",
))

UNICODE_REPLACEMENTS = {
    "…": "...",
    "—": "-",
    "–": "-",
    "«": '"',
    "»": '"',
    " ": " ",
}

HEADER = re.compile(r"^@([a-z0-9_]+)(?:\s+(.*))?$")
SAFE_ASCII = set(" 0123456789.,!?-:;()/+%")


def encode_text(text: str, source: Path) -> str:
    encoded: list[str] = []

    for original in text:
        character = UNICODE_REPLACEMENTS.get(original, original)

        if len(character) > 1:
            encoded.append(character)
            continue

        lowered = character.lower()
        if lowered in GLYPH_IDS:
            encoded.append(GLYPH_IDS[lowered])
        elif character in SAFE_ASCII:
            encoded.append(character)
        elif character.isascii() and character.isspace():
            encoded.append(" ")
        elif character.isascii() and character.isalpha():
            raise ValueError(
                f"{source}: Latin text is not supported inside story prose: "
                f"{character!r}. Write the word in Russian."
            )
        else:
            raise ValueError(
                f"{source}: unsupported character {character!r} in story text"
            )

    return "".join(encoded)


def lua_quote(value: str) -> str:
    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'


def parse_options(raw: str | None, source: Path, line_number: int) -> dict[str, object]:
    options: dict[str, object] = {}
    if not raw:
        return options

    for part in raw.split():
        if "=" not in part:
            raise ValueError(f"{source}:{line_number}: expected key=value, got {part!r}")

        key, value = part.split("=", 1)
        if key in {"speed", "auto"}:
            options["auto_after" if key == "auto" else key] = int(value)
        elif key == "instant":
            options[key] = value.lower() in {"1", "true", "yes"}
        else:
            raise ValueError(f"{source}:{line_number}: unknown slide option {key!r}")

    return options


def parse_story(source: Path) -> tuple[str, list[dict[str, object]]]:
    next_scene = "menu"
    slides: list[dict[str, object]] = []
    current: dict[str, object] | None = None
    body: list[str] = []

    def finish_slide() -> None:
        nonlocal current, body
        if current is None:
            return

        prose = " ".join(" ".join(body).split())
        if not prose:
            raise ValueError(f"{source}: slide @{current['art']} has no text")

        current["text"] = encode_text(prose, source)
        slides.append(current)
        current = None
        body = []

    for line_number, raw_line in enumerate(source.read_text(encoding="utf-8").splitlines(), 1):
        line = raw_line.strip()

        if not line or line.startswith("#"):
            continue

        if line.startswith("!next "):
            if current is not None:
                raise ValueError(f"{source}:{line_number}: !next must appear before slides")
            next_scene = line.removeprefix("!next ").strip()
            continue

        match = HEADER.match(line)
        if match:
            finish_slide()
            current = {
                "art": match.group(1),
                **parse_options(match.group(2), source, line_number),
            }
            continue

        if current is None:
            raise ValueError(f"{source}:{line_number}: text must follow an @art header")

        body.append(line)

    finish_slide()

    if not slides:
        raise ValueError(f"{source}: no slides found")

    return next_scene, slides


def render_lua(story_id: str, next_scene: str, slides: list[dict[str, object]]) -> str:
    output = [
        "-- Generated from story/intro.story. Edit the .story file, not this file.",
        "story_content=story_content or {}",
        f"story_content.{story_id}={{",
        f" next_scene={lua_quote(next_scene)},",
        " slides={",
    ]

    for slide in slides:
        fields = [
            f"art={lua_quote(str(slide['art']))}",
            f"text={lua_quote(str(slide['text']))}",
        ]
        if "speed" in slide:
            fields.append(f"speed={slide['speed']}")
        if "auto_after" in slide:
            fields.append(f"auto_after={slide['auto_after']}")
        if slide.get("instant"):
            fields.append("instant=true")
        output.append("  {" + ",".join(fields) + "},")

    output.extend([" }", "}", ""])
    return "\n".join(output)


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: build_story.py INPUT.story OUTPUT.lua")

    source = Path(sys.argv[1])
    destination = Path(sys.argv[2])
    next_scene, slides = parse_story(source)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(
        render_lua(source.stem, next_scene, slides),
        encoding="ascii",
    )


if __name__ == "__main__":
    main()
