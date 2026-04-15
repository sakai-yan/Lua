# xlik Buff Study Report

## Deliverable

- Main document: `doc/xlik-buff系统学习与本项目落地方案.md`

## Scope

- Studied `Reference (not included in the project)/xlik-jade-main` with focus on:
  - runtime Buff object model
  - state stacking and rollback
  - attribute-duration Buff conversion
  - Buff UI loading path and tooltip surface
  - adaptation route for this repository

## Key Findings

- xlik separates `slk_buff(...)` from runtime `Buff({...})`; they should not be conflated.
- Runtime Buffs in xlik are lifecycle objects with paired `purpose/rollback`, not plain timer records.
- `superposition` is the core reason xlik can safely stack control states such as stun, silence, disarm, pause, invisibility, and invulnerability.
- Timed attribute changes in xlik are elevated into Buff objects automatically through `library/class/vast/_vast.lua`, which is the most valuable pattern to emulate locally.
- The provided reference tree does not include `war3mapUI/xlik_buff/main.lua` / `main.fdf`, so Buff UI layout specifics cannot be sourced directly; the final document explicitly marks inferred portions.
- This repository already has enough primitives to implement an xlik-style Buff system without importing xlik wholesale:
  - Buff core
  - Event system
  - Timer system
  - Attribute pipeline
  - Custom UI framework

## Recommended Next Step

- Upgrade `Code/Core/Entity/Buff.lua` into a queryable, rollback-safe Buff core and then build a minimal BuffBar using the existing UI framework.
