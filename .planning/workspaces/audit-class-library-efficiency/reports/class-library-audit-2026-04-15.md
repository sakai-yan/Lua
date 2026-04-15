# Class Library Audit

## Scope
- Primary surface: `Code/Lib/Base/Class.lua`
- Targeted caller inspection only: `Code/Core/Entity/Unit.lua`, `Code/Core/UI/Theme.lua`, `Code/Logic/Process/Unit/Exp.lua`
- Constraint: keep changes low-risk and avoid broad refactors

## Implemented Fixes
- Fixed dynamic recompilation of instance metamethods to write back with `rawset(..., "__index"/"__newindex", ...)`.
- Fixed `Class.static(...)` debug behavior so documented special hook names `__index__` and `__newindex__` are accepted.
- Cached `Class.modify_field(...)` backing-field names.

## Confirmed Root Cause
- Dynamic `__newindex` behavior could fail after class creation because normal assignment to `class.__newindex` may be redirected into `class.__data__` once the class-table metatable exists.
- Lua instance writes only consult the raw `__newindex` slot on the metatable, so the dynamically recompiled metamethod was not actually active in those cases.

## Validation
- `luac -p Code/Lib/Base/Class.lua`
- Isolated Lua smoke test for `Class.static(..., "__index__", ...)`
- Isolated Lua smoke test for `Class.static(..., "__newindex__", ...)`
- Isolated Lua smoke test for `Class.attribute(...)` on a class that initially had no instance `__newindex`

## Watch Items
- `Code/Core/UI/Theme.lua` appears to expect `Class.getAttributeNames(...)` to return attribute descriptor tables, while the current Class API returns attribute-name strings.
- `Code/Logic/Process/Unit/Exp.lua` contains a suspicious `Class("Event_Unit_Exp", Class.get("Event"), Class.get("Event"))` call that does not match the observed constructor contract.
