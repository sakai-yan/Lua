# Lua 5.3.6 vs Python 3.14.0 Project-Like Benchmarks

## Notes

- Lua runs actual repo modules: `Class`, `Struct`, `LinkedList`, `Point`, and `Panel`.
- `Panel` uses a local JASS stub, so it measures Lua framework overhead rather than Warcraft host cost.
- `Struct` results reflect the current worktree version of `Code/Lib/Base/Struct.lua`.
- This project-like suite uses smaller sample sizes than the generic suite: 40k object rows, 80k points, and 50k memory samples.

## Time

| Scenario | Lua 5.3.6 | Python 3.14.0 | Python/Lua |
| --- | ---: | ---: | ---: |
| Class instance create | 18.000 ms | 8.057 ms | 0.45x |
| Class method update | 4.000 ms | 5.310 ms | 1.33x |
| Attribute-style update | 21.000 ms | 12.191 ms | 0.58x |
| Struct lifecycle | 15.000 ms | 18.559 ms | 1.24x |
| Callback dispatch | 8.000 ms | 8.864 ms | 1.11x |
| Point pack/unpack | 100.000 ms | 58.599 ms | 0.59x |
| Panel create/destroy | 1722.000 ms | 251.757 ms | 0.15x |

## Memory

| Scenario | Lua 5.3.6 | Python 3.14.0 | Python/Lua |
| --- | ---: | ---: | ---: |
| Class instance avg | 184.0 B | 119.7 B | 0.65x |
| Attribute instance avg | 184.0 B | 119.7 B | 0.65x |
| Packed Point 50k | 48.0 B | 1.621 MiB | 35400.50x |
| xy point table 50k | 5.722 MiB | 3.051 MiB | 0.53x |
| Struct/SOA 50k | 3.002 MiB | 4.353 MiB | 1.45x |

## Python Details

| Structure | Value |
| --- | ---: |
| `SlotsNode` shallow instance | 56.0 B |
| `PropertyNode` shallow instance | 56.0 B |
| packed `int` shallow object | 32.0 B |
| tuple point shallow object | 64.0 B |

## Readout

- These numbers are closer to this repo's real hotspots than the generic arithmetic-only suite.
- Heavy use of `Class.__attributes__` style getters/setters has a visible hot-path cost versus direct fields.
- Packed `Point` values are usually much more memory-efficient than `{x=..., y=...}` point tables.
