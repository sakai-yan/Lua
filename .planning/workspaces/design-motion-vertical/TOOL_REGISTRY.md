# Tool Registry

## Project-Local Tools
- Name:
  - None added in this task.

## Shared or External Tools
- Name:
  - Lua 5.3 syntax validator
  - Source: `D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools/lua53/bin/luac.exe`
  - Purpose: Parse-check Lua leaf modules quickly.
  - Invocation: `.\.tools\lua53\bin\luac.exe -p <path>`
  - When to use: After editing a Lua module and before finalizing task delivery.
  - Limits / Safety notes: Syntax-only; does not execute code paths.
- Name:
  - Lua 5.3 load validator
  - Source: `D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools/lua53/bin/lua.exe`
  - Purpose: Confirm a file can be loaded by the Lua parser.
  - Invocation: `.\.tools\lua53\bin\lua.exe -e "assert(loadfile('<path>'))"`
  - When to use: After syntax validation when a quick parse-level second check is helpful.
  - Limits / Safety notes: `loadfile` parses but does not execute module runtime behavior.

## Usage Notes
- Prefer the repo-local Lua toolchain for fast static validation of leaf-module work.
- Treat `.canon/` as read-only baseline input, not as a location for live tool edits.

## Gaps
- No repeated tool shortage appeared in this task.
