# UI Theme Runtime Boundary Cleanup Report

## Goal
- Preserve runtime theme switching while removing Theme-owned runtime state from `Frame`.

## Trigger
- The user clarified that runtime theme changes must operate over the standardized live `childs` tree, but Theme must not pollute the lower-level `Frame` library.

## Changes
- Added Theme-owned weak runtime declaration storage in `Code/Core/UI/Theme.lua`.
- Added `Theme.attach(frame, config)` to bind declaration-time Theme authoring snapshots onto a created live frame tree.
- Updated `Code/Core/UI/Component.lua` so both `Component.create(...)` and `Component(...)` call `Theme.attach(...)` after frame creation.
- Removed Theme-specific declaration cloning and `__theme_decl__` / `label` / `id` writes from `Code/Core/UI/Frame.lua`.
- Extended `.planning/tools/ui_framework_remaining_smoke.lua` to assert both runtime theme replay success and the absence of Theme runtime metadata on frame instances.

## Resulting Architecture
- Declaration-time:
- `Theme.apply(config, class_hint)`
- optional `Style.applyLayout(config)`
- frame creation
- post-create bind:
- `Theme.attach(frame, config)`
- runtime replay:
- `Theme.applyRuntime(frame, theme_like)`
- live traversal source:
- `frame.childs`
- runtime declaration ownership:
- Theme-owned weak tables

## Why This Boundary Is Better
- `Frame` stays a lower-level UI primitive instead of becoming aware of application-layer Theme concerns.
- Runtime theme replay still has access to declaration-time selector metadata and inline authoring values.
- The bind step now lives exactly where declaration config turns into a live frame tree: `Component`.
- Weak storage avoids long-lived retention pressure from Theme runtime metadata.

## Validation
- `.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Theme.lua`
- `.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Component.lua`
- `.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Frame.lua`
- `.\.tools\lua53\bin\luac.exe -p .planning\tools\ui_framework_remaining_smoke.lua`
- `.\.tools\lua53\bin\lua.exe .planning\tools\ui_framework_remaining_smoke.lua .`
- Result: `pass=8 / fail=0 / blocker=0`

## Remaining Follow-Ups
- Decide whether manual `Theme.attach(...)` should stay as the low-level public hook or be wrapped by a higher-level application API.
- Decide whether runtime replay should expand beyond the current fixed property commit list.
- Continue with deeper CSS-like behavior only after the layering remains stable.
