# Task Workspace

## Task Identity
- Task label: Design Motion Vertical
- Task slug: design-motion-vertical
- Matching rule: Reuse this workspace only when a later request still targets the vertical-motion leaf module in `Code/Logic/Process/Motion/Vertical.lua`, its API family, or its immediate validation/documentation.
- Split rule: Create a sibling task workspace when the request becomes a shared Motion runtime refactor, a cross-module API migration, or a broader movement-framework redesign.

## Scope Snapshot
- Current normalized objective: Maintain the vertical-motion library in `Code/Logic/Process/Motion/Vertical.lua`, including the current motion family, library naming, and detailed Chinese interface documentation, while preserving the direct, low-overhead style learned from `Charge.lua`, `Bezier3.lua`, and `Surround.lua`.
- Primary surfaces: `Code/Logic/Process/Motion/Vertical.lua` and this task workspace's planning artifacts.
- Explicit exclusions: Do not modify `Charge.lua`, `Bezier3.lua`, `Surround.lua`, `Entry.lua`, or the shared Motion runtime behavior. Do not turn this task into general 3D path motion, collision work, or a legacy J compatibility layer.

## Continuation Signals
- Reuse this workspace when: later requests still focus on vertical motion entries such as `vertical`, `up`, `down`, `jump`, `hover`, their runtime models, or follow-up runtime verification.
- Create a new sibling workspace when: the request expands into non-vertical motion families, shared Motion lifecycle changes, or large-scale caller migration.

## Workspace Paths
- Project root: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Project playbook: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical
- Task-local tools directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical/tools
- Project toolset directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical reference directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon
- Reports directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical/reports

## Notes
- This workspace owns `PLAN.md`, `STEP_PLAN.md`, `TASKS.md`, `SESSION.md`, `PROJECT_SUMMARY.md`, and related execution artifacts for this task only.
- Task-only helpers can live in `D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical/tools`; reusable mutable project tools can move to `D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools`.
- Treat `D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon` as canonical read-only input unless the task is explicitly about maintaining reference material.
- Cross-task knowledge should be promoted intentionally into `D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/PROJECT_PLAYBOOK.md` instead of being mixed here by default.
