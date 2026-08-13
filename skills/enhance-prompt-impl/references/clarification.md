# Clarification Protocol — Worked Examples

When an incoming prompt is ambiguous, the enhanced prompt should direct the model to ask via `AskUserQuestion` with concrete multiple-choice options rather than silently guessing. Below are 5 recurring ambiguity patterns observed across the user's projects, with realistic option sets.

Use these as templates when designing the `<clarification_protocol>` block for a coding prompt.

---

## How to use this file

1. When enhancing a prompt that produces code, scan the input for any of the five patterns below.
2. If a pattern matches, copy the corresponding `AskUserQuestion` shape into the `<clarification_protocol>` block of your enhanced prompt.
3. Always phrase options as 2–4 concrete choices with one **(Recommended)** — never an open-ended "what do you want?".
4. The cost-of-guessing column tells you *why* the question is worth asking; include a one-line version of it in the enhanced prompt so the model understands the stakes.

---

## Pattern 1 — Behavior-Tradeoff Ambiguity

**Trigger phrasing:** "add notifications / alerts / logs / events for X", "track Y", "report on Z" — feature requests where *which events* and *how loud* are unstated.

**Why it's ambiguous:** the data exists; the question is "how much signal vs. noise does the user want".

**AskUserQuestion shape:**
```
Question: "Which events should trigger <feature>?"
Header: "Event scope"
Options:
  - Critical-only (Recommended) — failures and high-value successes. Low noise, low chance of fatigue.
  - All events — every success, failure, skip, and retry. Maximum visibility, risk of alert fatigue.
  - Configurable per-event — ship a settings surface. More work now, more flexibility later.
```

**Cost of guessing wrong:** silent failures (user never learns a critical event fired) OR notification fatigue (user mutes the channel and misses real alerts). Both end with the feature being effectively off.

---

## Pattern 2 — Migration / Backward-Compatibility Ambiguity

**Trigger phrasing:** "change the behavior of X", "switch to <new mode>", "make X required", "deprecate Y" — changes that have an existing-user / existing-state population.

**Why it's ambiguous:** the prompt specifies the new state but not what happens to records, configs, or sessions created before the change.

**AskUserQuestion shape:**
```
Question: "How should existing <records/configs/sessions> behave after this change?"
Header: "Migration"
Options:
  - Auto-upgrade preserving prior behavior (Recommended) — old entities keep working as-is; new entities use the new behavior. Safest default.
  - Force-migrate all to new behavior — uniform state, simpler code, but surprises existing users.
  - One-time prompt on next interaction — high-touch, requires UX surface, best when the change is consequential (e.g., security/privacy).
```

**Cost of guessing wrong:** users' automated flows silently break (auto-migrate that was meant to preserve), OR you ship a code path that has to support two modes forever (preserve when you meant to migrate).

---

## Pattern 3 — Display / Representation Ambiguity (Fast vs. Polished)

**Trigger phrasing:** "show X in the UI / message / log", "include X in the output", "format Y" — when the raw value exists but the human-readable form requires extra work (API lookup, formatting library, cache).

**Why it's ambiguous:** there's a real ship-fast-vs.-ship-right tradeoff and the prompt doesn't pick a side.

**AskUserQuestion shape:**
```
Question: "How should <field> appear in <surface>?"
Header: "Display form"
Options:
  - Raw value now, resolve later (Recommended) — ships immediately with the ID/hash/code. Schedule a follow-up to resolve the human-readable form.
  - Block on resolving the human-readable form — slower release, better UX on day one.
  - Hybrid: resolved if cached, raw fallback — best UX-per-effort, more code paths.
```

**Cost of guessing wrong:** v1 ships with `0xabc123…` instead of "Polymarket: Will X happen by Y?" (users can't read it), OR v1 slips two weeks waiting on a Gamma-style API integration that wasn't in scope.

---

## Pattern 4 — Scope / Duplication Ambiguity

**Trigger phrasing:** "refactor X", "consolidate Y", "extract Z", "implement X in two places" — when shared logic could be DRY'd OR kept inline, and the prompt doesn't say which.

**Why it's ambiguous:** premature extraction creates the wrong abstraction; obvious duplication invites future drift. The right answer depends on whether the two call sites are *truly* the same shape or merely similar today.

**AskUserQuestion shape:**
```
Question: "Two call sites need this logic. Extract to a shared helper, or keep duplicated?"
Header: "Shape"
Options:
  - Extract to shared helper (Recommended only if shape is identical) — DRY, single source of truth, larger diff.
  - Keep duplicated for now — smaller diff, faster review, risk of drift. Flag for revisit when a third caller appears.
  - Extract after both paths ship — defer the abstraction decision until both behaviors are stable.
```

**Cost of guessing wrong:** premature factory becomes a misfit when the two callers diverge (forced into options-bag hell), OR the duplicated branches silently drift and a bug fix in one is forgotten in the other.

---

## Pattern 5 — Onboarding / Setup-Flow Ambiguity

**Trigger phrasing:** "add a setup dialog / first-run / onboarding for X", "ask the user about Y the first time" — UX surfaces where *how blocking* the prompt should be is unstated.

**Why it's ambiguous:** mandatory modals guarantee configuration but slow onboarding; optional prompts respect user time but are often skipped; settings-only paths never annoy anyone but never get discovered.

**AskUserQuestion shape:**
```
Question: "How should the <setup/onboarding> surface for <feature> behave on first run?"
Header: "First-run UX"
Options:
  - Mandatory modal — blocks the first action until configured. Best when default-off would be unsafe (privacy, security, billing).
  - Optional prompt with Skip (Recommended for most cases) — surfaces the feature without blocking. Persist Skip so the user isn't re-prompted.
  - Settings-only, no prompt — discoverable only on demand. Use when the feature is power-user.
```

**Cost of guessing wrong:** mandatory when it should have been optional → users churn at first launch; optional when it should have been mandatory → users start using the product in an unsafe state and don't know it; settings-only when discovery matters → feature ships and nobody uses it.

---

## General rules for clarification questions

- **2–4 options, never more.** More options = decision paralysis = the user picks the first one.
- **Lead with the recommendation** and mark it `(Recommended)`. Most users want a default, not a quiz.
- **One sentence per option** explaining the tradeoff. Not "Option A" — say what A gets you and what it costs.
- **Ask once, not iteratively.** Bundle related questions into one `AskUserQuestion` call (the tool accepts up to 4 questions).
- **Skip the question if the prompt already disambiguates.** A `<clarification_protocol>` block that always fires is just friction.
- **Never ask "what do you want?"** — the user already told you what they want, they just didn't say *how*. Your job is to enumerate the hows.
