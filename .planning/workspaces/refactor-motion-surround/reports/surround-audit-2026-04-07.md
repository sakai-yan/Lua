# Surround Audit 2026-04-07

## Scope
- `Code/Logic/Process/Motion/Surround.lua`
- `Code/Logic/Process/Motion/Entry.lua`
- `Code/Logic/Process/Motion/Charge.lua`
- `Reference (not included in the project)/EffectSport/MyFucEffectSportSurround.j`

## Findings

### High: motion completion currently does not clear the live FSM motion slot
- `updateSurround` returns `true` when the surround target becomes invalid or when `dur` expires.
- `Motion.execute` then calls `Motion.cancel(motion)` instead of `Motion.cancel(fsm)`.
- `Motion.cancel` expects an FSM-like table and writes `fsm.motion = nil`, so passing the motion config leaves `fsm.motion` intact.
- Impact on Surround:
  - `dur` completion can keep retriggering every tick.
  - dead-target completion can keep retriggering every tick.
  - `onEnd` and `need_to_des` can therefore fire repeatedly instead of once.
- This is a framework bug in `Motion.Entry`, but it directly breaks Surround termination behavior.

### Medium: legacy `aspd` compatibility is only name-compatible, not unit-compatible
- In the J reference, `this.angle = this.angle + this.aspd` advances once per tick, so `aspd` is effectively degrees per tick.
- In the Lua port, `config.aspd` feeds `angle_spd`, documented as degrees per second, and the update path multiplies by `TICK_DELTA`.
- Any caller that ports old J values verbatim will get orbit speed scaled down by approximately `TICK_DELTA` (for a `0.02` tick, around 50x slower).
- If the intention is true legacy compatibility, `aspd` should be converted on input or documented as a semantic break.

### Medium: the surround target contract is broader than the runtime safety checks
- The Lua API accepts `config.surround` or `config.target` without enforcing a specific runtime type.
- The per-tick guard only stops on `not surround` or `surround.alive == false`.
- This works cleanly for unit-like objects with `x`, `y`, and `alive`, but it is underspecified for effects, missiles, or plain tables that only partially satisfy the contract.
- The J reference is stricter and explicitly uses a living unit target.
- Recommended direction:
  - either narrow the contract to unit targets,
  - or add an explicit target adapter / validation path so liveness and coordinates are well-defined.

## Efficiency And Maintainability Opportunities
- Cache the actor move method during setup instead of recomputing `move_func[DataType_get(actor)]` on every tick.
- Store internal angle state in radians to avoid repeated degree-to-radian conversion during hot-path updates.
- Normalize the running angle periodically (`360` or `2*pi` modulo) so long-duration motions do not accumulate unnecessarily large trig inputs.
- If visual parity with the J reference matters, make facing or yaw updates an opt-in flag rather than paying the cost unconditionally.

## Behavioral Differences Worth Confirming
- `high` is treated as an absolute Z value, not a relative offset from the surround target.
- The Lua version intentionally does not update facing every tick, while the J reference updates effect yaw during the loop.
- Self-surround (`actor == surround`) is not explicitly rejected and would create a drifting center because the orbit center would move with the actor.

## Validation
- Static audit only.
- No runtime harness or map-side repro script was executed in this review pass.
