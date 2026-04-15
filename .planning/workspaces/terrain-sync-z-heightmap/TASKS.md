# Tasks

## Active
- No active coding work remains in this slice; waiting on runtime smoke validation or follow-up user requests.

## Ready
- Run in-game smoke checks on representative flat ground, cliff edges, and water-adjacent cells to confirm parity on this map.
- If startup cost later matters, evaluate adding optional pre-baked height-map import support inside `Terrain.lua`.

## Blocked
- Local runtime execution is blocked in this workspace because no Lua interpreter or Warcraft test harness is exposed here.

## Done
- Audited `doc/HeightMapZ.j`, the old `Terrain.lua`, `Unit.lua`, and init sequencing files.
- Rewrote `Code/FrameWork/GameSetting/Terrain.lua` to build a synchronous height map and serve numeric terrain Z queries.
- Preserved existing `Unit` compatibility without editing any non-`Terrain` file.
- Recorded the static validation path and remaining runtime risk in the planning workspace.
