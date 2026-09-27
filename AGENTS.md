# Mesh Quest project instructions

Before changing this project, read `PROJECT_STATUS.md`, `ART_TODO.md`, and
`DEVELOPMENT_WORKFLOW.md`.

- Treat the hand-edited music, sprite sheet and tile/map data in `mesh_quest.p8`
  as user-authored work. Never regenerate or replace them unless the user asks
  explicitly.
- Use `make stage` for normal builds. `make regen-story` is destructive to
  generated story art and must only be used when the user explicitly requests
  regeneration.
- Missing chapter-one illustrations currently use procedural placeholders. The
  user dislikes those placeholders; replace them with the supplied Aseprite PNGs
  as they arrive instead of polishing the code-drawn versions.
- Preserve unrelated and uncommitted changes. This project is intentionally in
  active development.
- Russian dialogue in Lua uses the custom encoding implemented by
  `tools/build_story.py`; do not put raw UTF-8 Russian text into PICO-8 carts.
