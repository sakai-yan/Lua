# Step Plan

## Current Step
- Name: Flatten and validate the Bezier3 config contract
- Parent phase: Phase 1 refinement
- Why now: the user explicitly rejected the point-table API and asked for a `Charge.lua`-style scalar interface.

## Step Objective
- Remove point-table config support from `Bezier3.lua`, preserve the useful runtime behavior, and align nearby source comments with the new contract.

## Requirement Alignment
- Match `Charge.lua` more closely.
- Prefer flat scalar fields over grouped coordinate tables.
- Keep the tick path efficient and allocation-light.
- Keep production behavior changes inside `Bezier3.lua`, with only comment alignment in `Entry.lua`.

## Planned Technical Route
- Replace `start_point` / `end_point` / `control_one` / `control_two` with flat scalar fields.
- Remove the point-table reader helper.
- Keep fixed-endpoint and lock-on-target motion entry points.
- Update the in-file Chinese usage docs to match the new scalar API.
- Align the Bezier field list comment in `Entry.lua`.

## Framework Compatibility Review
- The route still fits `Motion.set`, `Motion.execute`, and `move_func`.
- `Entry.lua` remains a compatibility note surface only; no shared runtime behavior changes are required.

## Standards / Bug Avoidance Applied
- No per-tick table allocation.
- No compatibility shim that keeps the old table path alive.
- No drift into a wider Motion framework refactor.
- No hidden fallback semantics beyond documented defaults.

## Validation
- `.\.tools\lua53\bin\luac.exe -p Code\Logic\Process\Motion\Bezier3.lua`
- `.\.tools\lua53\bin\luac.exe -p Code\Logic\Process\Motion\Entry.lua`
- `.\.tools\lua53\bin\lua.exe -e "assert(loadfile(...))"`
- Static source review for endpoint completion and lock-on behavior
