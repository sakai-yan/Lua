# Lua Closure Benchmark - 2026-04-03

## Environment
- Project runtime: `.tools/lua53/bin/lua.exe`
- Lua version: `5.3.6`
- Benchmark script: `.planning/tmp/lua_closure_bench.lua`

## What was measured
- Retained closures:
  - allocate `500000` function references or closures into a table
  - release the table
  - run full GC
- Ephemeral callback-like loop:
  - run `2000000` synchronous callback calls
  - compare reusing one callback vs allocating a new closure every iteration
  - compare normal auto GC vs paused GC

## Key findings
- In this Lua `5.3.6` runtime, a no-upvalue anonymous function at the same lexical position is cached and reused.
- Identity check result:
  - `builder() == builder()` is `true` for `function(x) return x + 1 end`
  - `builder2(1) == builder2(1)` is `false` for closures that capture locals
- Retained closure memory cost is mainly from captured upvalues:
  - `1` upvalue closure: about `72 bytes` extra per closure
  - `3` upvalues closure: about `152 bytes` extra per closure
- Full GC cost scales with the amount of captured-closure garbage:
  - `500000` retained closures with `1` upvalue: about `42.33 MB`, full GC about `19-30 ms`
  - `500000` retained closures with `3` upvalues: about `80.48 MB`, full GC about `46-48 ms`
- Short-lived closure creation is noticeably slower than reusing a callback, but the main risk is GC pressure, not the raw creation instruction itself.

## Representative numbers

### Retained closures
| Scenario | Create | Alloc | Extra per closure | Full GC |
| --- | ---: | ---: | ---: | ---: |
| same function ref | `13-14 ms` | `8.00 MB` | `0 B` | `~0 ms` |
| no-upvalue anonymous function | `15-16 ms` | `8.00 MB` | `0 B` | `~0 ms` |
| closure with 1 upvalue | `47-48 ms` | `42.33 MB` | `72 B` | `19-30 ms` |
| closure with 3 upvalues | `88-89 ms` | `80.48 MB` | `152 B` | `46-48 ms` |

### Ephemeral callback-like loop
| Scenario | Loop | Relative to reuse | Heap growth | Full GC after loop |
| --- | ---: | ---: | ---: | ---: |
| reuse callback | `78-83 ms` | `1.0x` | `~0 MB` | `~0 ms` |
| new closure, 1 upvalue, auto GC | `219-221 ms` | `~2.7x` | `~0.03-0.04 MB` | `~0 ms` |
| new closure, 3 upvalues, auto GC | `372-381 ms` | `~4.7x` | `~0.02-0.07 MB` | `~0 ms` |
| new closure, 1 upvalue, GC paused | `246-343 ms` | `~3.1-4.1x` | `137.33 MB` | `103-140 ms` |

## Collision.lua takeaway
- Current `Collision.lua` uses file-local callbacks like `collideUnit` and passes context as parameters.
- This avoids per-execution captured-closure allocation.
- For a hot path such as collision enumeration, the current pattern is the safer high-frequency choice.
- Rewriting it to inline closures that capture `fsm` would add allocation and GC pressure for little benefit.

## Practical rule
- Safe:
  - reuse local functions
  - pass state by parameters when the callback is synchronous
  - use anonymous functions without captured locals only when readability benefits, because in this runtime they are effectively cheap
- Be careful:
  - allocating closures with captured locals inside per-frame loops
  - storing many closures in tables or queues
  - bursty creation patterns when GC may be delayed
