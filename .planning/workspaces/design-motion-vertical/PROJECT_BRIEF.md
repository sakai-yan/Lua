# Project Brief

## Problem
- The vertical-motion library now needs one more round of polish: rename the library file from `Down.lua` to `Vertical.lua`, and upgrade the source comments from brief English notes to detailed Chinese function documentation and usage guidance.
- The library still has to follow the same style constraints learned from `Charge`, `Bezier3`, and `Surround`: direct APIs, runtime state on `config`, setup-heavy / tick-light logic, and no edits to sibling motion libraries.

## Project Context
- Brownfield internal library work inside an existing motion framework.
- The route must fit the existing `Motion.Entry` contract and sibling-module style while keeping the entire blast radius inside one leaf module.

## Project-Local Workspace
- Project root: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Project playbook: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical
- Task slug: design-motion-vertical
- Task-local tools directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical/tools
- Project toolset directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical reference directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon
- Reports directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical/reports

## Goals
- Keep `Motion.vertical` as the base direct rise/fall solver and retain the already added vertical motion family.
- Rename the production library file to `Vertical.lua`.
- Add detailed Chinese function comments and usable calling examples for both internal structure and public APIs.
- Keep the implementation compact, allocation-free in hot paths, and constrained to the renamed vertical-motion file.

## Normalized Requirements
- Reuse the style learned from `Charge`, `Bezier3`, `Surround`, and prior task memory.
- Maintain the high-efficiency, low-consumption bias by keeping runtime models simple and caching setup results on `config`.
- Do not modify sibling motion modules or shared Motion runtime code.
- Keep the expanded vertical family, but move it under the clearer library filename `Vertical.lua`.
- Replace the current brief English comments with detailed Chinese function notes and usage instructions.

## Non-Goals
- General 3D path motion or another Bezier-style library.
- Collision, knockback, or gameplay-resolution logic.
- A wide legacy-compatibility API layer for old J signatures.
- Exotic vertical profiles such as bounce chains, spring simulation, or authored multi-keyframe curves unless a later caller justifies them.

## Constraints
- The module must work through the existing `Motion.set` / `Motion.execute` flow and `move_func` actor adapters.
- The hot path of each solver should stay arithmetic-only plus one `setPosition` call.
- Shared helpers should stay few and high-value; the file should still read directly.
- The public API should not explode into many aliases; new entries must represent real motion families, not naming variations.

## Existing Knowledge Inputs
- `.planning/PROJECT_PLAYBOOK.md` for current motion-leaf standards and red flags.
- `.planning/workspaces/implement-motion-bezier3/PROJECT_SUMMARY.md` for the strongest recent style constraints.
- `.planning/workspaces/design-motion-vertical/PROJECT_SUMMARY.md` for the already-approved direct vertical route and risk notes.
- Code references: `Code/Logic/Process/Motion/Charge.lua`, `Code/Logic/Process/Motion/Bezier3.lua`, `Code/Logic/Process/Motion/Surround.lua`.
- Historical behavior reference: `Reference (not included in the project)/EffectSport/EffectSportDown.j`.
- Motion design notes in `doc/运动器与碰撞框架设计.md` indicating that vertical motion and full parabolic displacement are different concerns.

## Audit / Debug Focus
- Separate truly common vertical motion families from mere wrapper names.
- Keep the family organized by runtime model so the file does not become a pile of one-off update loops.
- Verify that no new solver introduces avoidable per-tick allocation or heavy branching.

## Stakeholders / Surface
- `Code/Logic/Process/Motion/Vertical.lua`
- Future callers that need vertical rise/fall, hop/jump, or floating hover on units, effects, or missiles

## Success Signals
- `Vertical.lua` exposes a compact but clearly broader vertical-motion API family.
- The renamed file contains clear Chinese interface notes that can serve as direct usage reference.
- Each solver has a short, direct hot path and setup-time normalization.
- Static Lua syntax/load validation passes.
- Task memory accurately records the broadened route and follow-up extension boundary.

## Open Questions
- Which motions count as "common vertical motion" without bloating the API?
- The chosen answer for this round is: monotonic rise/fall, thin `up/down` convenience over it, timed jump/hop, and hover/floating oscillation.
