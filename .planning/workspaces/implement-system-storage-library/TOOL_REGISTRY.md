# Tool Registry

## Project-Local Tools
- None

## Shared or External Tools
- Name: `rg`
  - Source: repo / machine-installed
  - Purpose: inspect code, locate relevant modules, and avoid broad file reads
  - Invocation: `rg ...`
  - When to use: code search, task-surface discovery, style anchor discovery
  - Limits / Safety notes: search results still need source inspection before code decisions
- Name: repo-local Lua parser
  - Source: `.tools/lua53/bin/luac.exe`
  - Purpose: fast syntax validation for Lua modules
  - Invocation: `.tools/lua53/bin/luac.exe -p Code/Logic/System/Storage.lua`
  - When to use: post-edit parse validation
  - Limits / Safety notes: syntax only; does not validate runtime behavior
- Name: repo-local Lua runtime
  - Source: `.tools/lua53/bin/lua.exe`
  - Purpose: small standalone smoke scripts for isolated module invariants
  - Invocation: `.tools/lua53/bin/lua.exe -`
  - When to use: quick library-level behavior checks without engine integration
  - Limits / Safety notes: must bootstrap package path and any required base globals manually

## Usage Notes
- Prefer repo-local Lua binaries for quick validation before considering broader engine tests.

## Gaps
- No reusable project-local harness exists yet for storage-like library smoke tests.

