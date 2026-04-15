# Principles

## Active Principles
- Motion-family expansion should add distinct runtime models before it adds more public names.
  Scope and checks: applies to motion leaf modules; check whether a proposed new entry introduces a new tick model or only renames an existing one.
- Thin wrappers are acceptable only when they fully reuse an existing solver and do not duplicate its runtime logic.
  Scope and checks: applies to helper entries like `up` / `down`; verify that they normalize input and delegate immediately.

## Deprecated Principles
- None.
