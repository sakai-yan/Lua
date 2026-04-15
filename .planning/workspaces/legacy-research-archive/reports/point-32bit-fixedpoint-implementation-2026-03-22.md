# Point 32+32 Bit Fixed-Point Implementation

## Decision

- Keep Point as one packed numeric value.
- Replace the old Cantor-style pairing with signed `int32/int32` packing.
- Support `4` decimal places through fixed-point scaling by `10000`.

## Contract

- Encode:
  - `x_int = round(x * 10000)`
  - `y_int = round(y * 10000)`
  - `packed = ((x_int & 0xFFFFFFFF) << 32) | (y_int & 0xFFFFFFFF)`
- Decode:
  - high `32` bits -> signed `x_int`
  - low `32` bits -> signed `y_int`
  - divide both by `10000`

## Supported Range

- Per axis:
  - min: `-214748.3648`
  - max: `214748.3647`

Values outside that range now fail fast instead of silently distorting.

## Validation

- Syntax:
  - `.\.tools\lua53\bin\luac.exe -p Code\FrameWork\Manager\Point.lua`
  - `.\.tools\lua53\bin\luac.exe -p .planning\tools\ui_framework_remaining_smoke.lua`
- Real Lua samples:
  - `Point(0.3, 0.15)`
  - `Point(-1, 2)`
  - `Point(0, -0.01)`
  - `Point(214748.3647, -214748.3648)`
  - overflow sample `Point(214748.3648, 0)` must fail
- Smoke:
  - `strict.point` now validates integers, decimals, negatives, range edges, and overflow failure

## Notes

- The broader `ui_framework_remaining_smoke.lua` still contains unrelated failures in other UI areas.
- This Point slice intentionally changes the contract from “invalid arbitrary-number pairing” to “explicit bounded fixed-point packing”.
