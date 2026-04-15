# Retrospective

## Planned vs Actual
- Planned: produce a static-first, evidence-backed audit plus roadmap.
- Actual: matched the plan closely; the only notable deviation was spending extra effort on bundle-structure compliance after validation surfaced missing template headings.
- Follow-up implementation also stayed close to the audit: the round focused on high-leverage contract fixes instead of broad churn.

## What Worked
- Building the audit around framework contracts produced clearer conclusions than treating the task as a loose file review.
- Cross-checking code, docs, and bootstrap surfaces quickly exposed the most expensive design debt.
- Rewriting the core contract files (`Frame`, `Builder`, `Watcher`) was faster and clearer than continuing to patch accumulated drift.

## What Hurt
- The modern abstraction layer looks more mature in documentation than in repo adoption, which can mislead future implementation choices if not called out explicitly.
- Multiple issues stem from the same root contract drift, so bug-by-bug fixing would hide the architectural pattern.
- Large legacy comments with encoding noise made exact text-based patching less reliable than code-first rewrites.

## Principle Updates
- Added active principles around ownership normalization, destroy as the authoritative teardown boundary, and explicit truth models for cached state.

## Tooling Updates
- No new tool was built.
- A tool backlog was created for UI contract linting and bootstrap-surface comparison.

## Debugging Improvements
- Keep using repo-wide search counts to distinguish aspirational framework layers from adopted runtime surfaces.
- Keep comparing docs and bootstrap surfaces directly whenever the framework claims new platform capabilities.

## Summary Updates
- The project summary now records that the framework is strongest as a low-level wrapper with promising but not yet cohesive modern abstractions.
- The summary also records ownership, lifecycle, and cached-state semantics as the three primary watch areas.

## Next-Time Changes
- If the next round implements V1 fixes, start with the ownership and destroy contracts before touching Builder ergonomics or broader declarative adoption.
- Once those fixes land, align docs immediately so the repo does not reintroduce code-doc drift.
