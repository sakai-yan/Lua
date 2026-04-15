# UI Theme Runtime Extension
Date: 2026-03-20

## Scope
- Add a runtime theme-switching interface for already created frame trees.
- Rename Theme selector metadata from `className` to `label`.
- Remove declaration-time `children` compatibility so declaration trees use `tree`.
- Add builtin preset themes for convenient web-like authoring.

## Implemented Surface
- Added `Theme.applyRuntime(frame, theme_like)` to rebuild a temporary Theme/layout tree from live `frame.childs`, then commit the result back onto the live frame tree.
- Added `Theme.set(frame, theme_like)` as the direct runtime theme-switch API.
- Added `Theme.refresh(frame)` and `Theme.reapplyRuntime(frame)` as convenience reapply APIs.
- Each created frame now stores a per-node Theme declaration snapshot in `frame.__theme_decl__`, so runtime theme switching no longer depends on an external retained config tree.
- Declaration-time Theme traversal now uses `tree` only.
- Theme selector metadata now uses `label` instead of `className`.
- Added builtin preset themes:
- `builtin.web.light`
- `builtin.web.dark`
- `builtin.web.dashboard`
- `builtin.web.console`

## Performance Route
- Kept declaration-time Theme merge generic so theme rules can still target arbitrary config fields.
- Moved runtime performance tightening into a fixed-property live commit path:
- size / position
- common frame attributes such as `alpha`, `is_show`, `level`, `scale`
- common visual attributes such as `image`, `color`, `blend_mode`
- method-backed text properties such as `font` and `align`
- This avoids turning Theme preprocessing itself into a hard whitelist merge.

## Integration Notes
- Theme ownership remains in `Component(...)` for declaration-time application.
- Runtime theme switching is explicit: the user must call `Theme.set(...)` / `Theme.applyRuntime(...)`.
- Live runtime traversal uses `frame.childs`.
- Temporary rebuild/compile still uses a generated `tree` so Theme and `Style.applyLayout(...)` can reuse their existing declarative logic.

## Validation
- `.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Theme.lua`
- `.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Frame.lua`
- `.\.tools\lua53\bin\luac.exe -p .planning\tools\ui_framework_remaining_smoke.lua`
- `.\.tools\lua53\bin\lua.exe .planning\tools\ui_framework_remaining_smoke.lua .`
- Smoke summary after the round:
- `pass=8`
- `fail=0`
- `blocker=0`

## New Findings
- Runtime Theme switching can be added without moving Theme into `Frame` or `Style`; the cleanest contract is still “Theme owns preprocessing, runtime switching explicitly replays that preprocessing over a live tree”.
- `label` is a better selector-facing name than `className` for this framework’s current naming direction.
- The most practical place for fixed-property optimization is the live runtime commit stage, not Theme’s generic declaration-time merge.

## Remaining Gaps
- No descendant selectors, sibling selectors, or full CSS cascade.
- Runtime hot-swap still uses a bounded fixed property commit set rather than a class-complete runtime styling surface.
- `display = "none"` still does not become real CSS-equivalent hide-and-remove-from-layout behavior.
- Browser-like DOM querying and automatic recomputation are still absent.
