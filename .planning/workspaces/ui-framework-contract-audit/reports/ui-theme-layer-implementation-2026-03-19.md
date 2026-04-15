# UI Theme Layer Implementation
Date: 2026-03-19

## Scope
- Deliver a first-class `Code/Core/UI/Theme.lua`.
- Keep the current framework shape intact instead of redesigning it into a browser runtime.
- Make Theme an application-layer config normalizer owned by `Component(...)`, not a dependency of `Frame` or `Style`.

## Implemented Surface
- Added `Theme.define(name, definition)` and `Theme.get(name)` for project-local theme registration.
- Added `Theme.resolve(theme_like)` for inherited theme expansion through `extends`.
- Added `Theme.apply(config, class_hint)` as a tree-aware config preprocessor.
- Kept `Theme.reapply(config, class_hint)` as a convenience alias to re-run normalization.
- Added token resolution with CSS-like `var(--token)` syntax.
- Added node-scoped variable overrides through `vars` / `theme_vars`.
- Restricted theme authoring to explicit object-style syntax; `rules` no longer accept array-style entries.
- Added single-node selector matching for:
- type selectors such as `Panel`
- class selectors such as `.card`
- id selectors such as `#confirm`
- compound selectors such as `Panel.card.primary`

## Integration Points
- `Component.__call` now applies Theme first, then runs `Style.applyLayout(...)`, then passes the standardized config into `Frame` creation.
- `Component.create` now applies Theme normalization to the copied config before invoking the registered factory/class.
- Direct constructors such as `Panel({...})` intentionally do not consume Theme.
- `Style.applyLayout(...)` intentionally does not consume Theme on its own.

## Validation
- `.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Theme.lua`
- `.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Frame.lua`
- `.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Style.lua`
- `.\.tools\lua53\bin\luac.exe -p .planning\tools\ui_framework_remaining_smoke.lua`
- `.\.tools\lua53\bin\lua.exe .planning\tools\ui_framework_remaining_smoke.lua .`
- Smoke summary after the round:
- `pass=8`
- `fail=0`
- `blocker=0`

## New Findings
- In the current bounded local smoke, `Component({...})` now returns a frame instance; the older authoring-gap claim that it always returns `nil` is no longer current code truth.
- The clean layering is better when Theme stays in `Component` as config normalization, instead of leaking into `Frame` or `Style`.

## Remaining Gaps
- No descendant selectors, sibling selectors, or combinators.
- No pseudo classes such as `:hover`, `:active`, or `:focus`.
- No media-query or breakpoint dispatcher.
- No automatic runtime theme hot-swap for already created frame trees.
- `display = "none"` still does not become real CSS-equivalent hide-and-remove-from-layout behavior.
- The framework still does not provide browser-like cascade, DOM querying, or automatic style recomputation.

## Recommended Next Steps
- Decide whether selector support should stay intentionally shallow or grow toward descendant/cascade semantics.
- Decide whether runtime theme switching matters enough to bind theme state back onto live frame trees.
- Repair `display:none` semantics before claiming stronger CSS parity.
