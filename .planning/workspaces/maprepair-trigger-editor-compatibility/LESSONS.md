# Lessons

## Candidate Lessons
- 2026-04-05: In YDWE audits, do not treat `war3map.j` parser or optimizer presence as evidence of GUI reconstruction; prove whether the path actually reaches `frontend_wtg/backend_wtg`.
- 2026-04-04: For editor-side compatibility, keep structured GUI inside base-compatible vocabulary unless matching embedded map-local extension metadata is also carried.
- 2026-04-04: YDWE debug helpers that walk `war3map.wtg` must follow `frontend_wtg.lua`'s inserted-call byte layout; lighter checker scans can produce false positives.
- 2026-04-04: For acceptance-sensitive MapRepair validation, prefer source-backed `dotnet run` or the real-map harness over prebuilt workspace binaries that may lag current source.
- 2026-04-05: `w3x2lni` `NEED_YDWE_ASSOCIATE` warnings can come from TriggerData root discovery drift rather than from malformed repaired trigger data; verify the environment path probe before reopening reconstruction work.
- 2026-04-05: Whole-trigger `custom-text` fallback must preserve direct local helper-function closure and source order; validator-clean `war3map.wtg` output can still leave editor-hostile `war3map.wct` text if those helpers are omitted.
- 2026-04-05: Root-condition-guard pseudo-GUI can remain editor-hostile even in the `5`-`7` action band; the previous `8`-`11` compact control-heavy cutoff was too high for the front-loaded `baoxiang` cluster.
- 2026-04-06: Custom-text closure must also preserve generic inline callback references such as `ForForce(..., function Trig_*_Func...)`; fixing only direct `Trig_*()` calls still leaves real trigger text incomplete.
- 2026-04-06: When `.tools/YDWE` drifts or disappears, switch the task to `.canon/YDWE` immediately; do not keep inferring behavior from historical repo-local YDWE mirrors.
- 2026-04-06: If checker, `wtgloader`, `frontend_trg`, and `frontend_wtg` all pass and the canon editor reaches `triggerdata` / `triggerstrings`, the remaining bug sits above the headless parse chain and the next work should stay in early trigger-shape survivors instead of reopening byte-layout or metadata plumbing.
- 2026-04-07: For real editor survival checks, enforce at least a `15`-second window and watch the actual shell-associated editor process tree; the first wrapper PID and the `-loadfile` path can both be misleading.
- 2026-04-07: When a restored prefix fails but an immediate re-open of the same map passes, keep the original first-fail result and use complementary subset maps to distinguish sequence-sensitive prefix failures from true single-trigger poison.
- 2026-04-07: Startup-only triggers can hide one helper call below `main`; if we do not trace `main -> helper -> ConditionalTriggerExecute/TriggerExecute`, recoverable `MapInitializationEvent` triggers stay in a riskier eventless shape.
- 2026-04-07: Very large single-timer structured GUI triggers can still be safer as whole-trigger custom-text even when they contain no custom-script lines.
- 2026-04-07: String-heavy single-timer quest bulletin triggers (`CreateQuestBJ` bursts with very large constant payloads) can still be editor-hostile even with zero custom-script or control-flow lines; treat them as whole-trigger custom-text earlier.

## Bug Avoidance Candidates
- Do not treat validator-compatible pseudo-GUI as automatically editor-safe.
- Do not reintroduce repo-level YDWE extension nodes as structured GUI without proving editor compatibility.
- Do not trust sample-side missing GUI aliases as proof that `war3map.j` still contains the corresponding semantics.

## Debug Lessons
- Small structural audit tools such as `maprepair_wtg_inspect` and `maprepair_sample_compare` are high-leverage when repaired WTG output passes validators but still looks editor-hostile.
- Manual editor validation remains a separate gate from source-backed checker validation.

## Repeated Patterns
- The hardest regressions came from trigger-tree shape and GUI vocabulary, not from binary layout alone.
- Safer trigger recovery often means collapsing risky pseudo-GUI back to bounded custom-text sooner.

## Promote Next
- Promote the validator-backed compatibility gate into a stable principle if it repeats across future MapRepair tasks.
- Consider a dedicated editor-load regression harness if more trigger compatibility iterations are expected.
