---
name: validate-research-impl
description: Validate research findings with skeptical parallel agents and alternative hypotheses. Spawns multiple sub-agents to challenge claims, check edge cases, propose 5-10 alternatives, verify version compatibility, redo calculations, and search for untouched code. (user)
allowed-tools: Read, Grep, Glob, Task, WebSearch, WebFetch
---

# Validate Research

Skeptical validation of research/plans using parallel devil's advocate agents.

## Core Philosophy

**Assume the research is WRONG.** Your job is to disprove it, not confirm it.

- Claude often hallucinates or makes confident but incorrect claims
- Previous context may have missed critical files or edge cases
- Calculations may be wrong, versions may be incompatible
- The "obvious" solution often isn't

### Behavioral Lens (cross-cutting, applied by every agent)

Four behavioral checks layered over the skeptical search. Each agent below references them by number where relevant — call them out in findings.

1. **Surfaced assumptions** — Were assumptions named, or silently baked in? When the query had multiple valid interpretations, did the research present them or quietly pick one?
2. **Simplicity** — Is the proposed solution the *minimum* that solves the problem? Flag speculative abstractions, unrequested configurability, error handling for impossible cases, or "200-line solutions that could be 50".
3. **Surgical scope** — Does every changed/recommended line trace directly to the request? Flag adjacent-code "improvements", drive-by refactors, formatting changes, or pre-existing dead code being deleted unprompted.
4. **Verifiable success** — Is the conclusion backed by something *checkable* (a reproducer test, a command output, an observed behavior) rather than "looks right" / "should work"?

## Workflow

### Phase 1: Gather Research to Validate

1. **If research doc provided**: Read it FULLY
2. **If in existing conversation**: Review what was researched/proposed
3. **If starting fresh**: Ask user for research doc path or summary

Extract from research:
- All claims and assertions
- File paths and line numbers referenced
- Any calculations or version numbers
- Proposed solutions or conclusions

### Phase 2: Spawn Skeptical Parallel Agents

Launch 5-11 parallel Task agents, each with a different skeptical lens:

```
Task 1 - Alternative Hypothesis Hunter:
"The research claims X. Generate 5-10 alternative explanations that could
also explain the symptoms. For each alternative:
- What evidence would support it?
- What code paths would be involved?
- Why might this be more likely than the proposed explanation?"

Task 2 - Missing Code Finder:
"The research analyzed these files: [list]. Search for OTHER files that:
- Import or are imported by these files
- Have similar names or patterns
- Might affect the same functionality
- Were NOT mentioned in the research but should have been"

Task 3 - Edge Case Validator:
"For the proposed solution/conclusion, identify:
- What edge cases could break it?
- What error conditions weren't considered?
- What race conditions or timing issues exist?
- What happens with null/empty/malformed inputs?"

Task 4 - Version Compatibility Checker:
"For all packages/dependencies mentioned:
- What version is actually installed? (check package.json, go.mod, etc)
- Are there known breaking changes between versions?
- Do the claimed APIs actually exist in installed versions?
- Search web for '[package] breaking changes [version]'"

Task 5 - Calculation Verifier:
"Redo ALL calculations from scratch:
- Line counts, file counts, any arithmetic
- Logic flow steps (count them manually)
- Time/performance estimates
- Memory/size calculations
Show your work step by step."

Task 6 - Reference Tracer:
"For each file:line reference in the research:
- Does the file exist at that path?
- Does line N contain what was claimed?
- Has the file changed since research? (git log -1)
- Are there similar patterns elsewhere that contradict?"

Task 7 - Contradiction Finder:
"Search the codebase for evidence that CONTRADICTS the research:
- Code comments that suggest different behavior
- Tests that assume different behavior
- Config files that override assumed defaults
- Documentation that states otherwise"

Task 8 - Assumption Challenger (Lens #1 — Surfaced Assumptions):
"List every assumption in the research — both STATED and SILENTLY MADE.
Silent assumptions are the dangerous ones: an interpretation picked when multiple were
valid, a file naming convention assumed, a scope boundary implicitly drawn, a
'how the user meant it' chosen without asking.
For each assumption:
- Is it actually true? Verify with code.
- What if the opposite were true?
- What evidence would disprove it?
- Was there a moment where the research should have STOPPED and asked the user
  instead of picking silently?
- Did the research push back when the request was ambiguous or overcomplicated,
  or did it just execute?"

Task 9 - Dead Code, Reuse & Surgical-Scope Auditor (Lens #3 — Surgical Scope):
"For the proposed changes/solution:
- Does this duplicate logic that already exists elsewhere? Search for similar patterns.
- Will this change leave behind dead code (unused functions, orphaned imports, unreachable branches)?
- Are there existing utilities, helpers, or abstractions that should be reused instead of writing new code?
- Could any existing code be consolidated with the proposed changes?
- Search for functions/methods that will become unused after the change.

Surgical-scope check (every changed line must trace to the request):
- Are there adjacent-code 'improvements' — refactors, renames, formatting,
  comment cleanup — that weren't asked for?
- Is pre-existing dead code being deleted as part of this change without being
  explicitly requested? (Cleaning your own orphans is fine; cleaning others' is scope creep.)
- Does the proposal change style or conventions in files it touches, instead of
  matching the existing style?"

Task 10 - Interface & Contract Reviewer:
"Examine all interfaces, types, APIs, and contracts touched by the research/plan:
- Are there OLD interfaces that should be removed or deprecated as part of this change?
- Are new interfaces being introduced? For each: is it necessary, or does an existing one suffice?
- Do new interfaces follow existing naming conventions and patterns in the codebase?
- Are any interfaces over-engineered (too many methods, too abstract)?
- Will interface changes break downstream consumers? List all callers/implementors.
- Are there interface segregation violations (forcing implementors to depend on methods they don't use)?"

Task 11 - Simplicity, Efficiency & Shortcut Detector (Lens #2 — Simplicity First):
"Critically examine the proposed approach for:

Simplicity audit (the headline check):
- Would a senior engineer call this overcomplicated? If yes, what's the 50-line
  version of the 200-line solution?
- Are there abstractions introduced for code that has exactly ONE caller?
- Is there 'flexibility', configurability, or generality that wasn't requested?
- Is there error handling for scenarios that can't actually happen given upstream
  guarantees?
- Are there speculative features added 'just in case' or for hypothetical future
  requirements?

Shortcut & efficiency check:
- Are there shortcuts that will cause problems later? (TODOs, hardcoded values, magic numbers, suppressed errors, swallowed exceptions)
- Is the approach efficient? Check for: unnecessary allocations, N+1 queries, redundant iterations, unneeded copying
- Are there performance implications not addressed? (memory, CPU, network, database load)

Compatibility & rollout:
- Does this need backward compatibility? If the research doesn't address this, FLAG IT as an open question.
- Are migrations needed? Are they reversible?
- Will this break existing clients, APIs, config files, or data formats?
- Are feature flags or gradual rollout needed for safe deployment?"

Task 12 - Success Criteria Verifier (Lens #4 — Verifiable Success):
"Does the research define success as something CHECKABLE, or as a vibe?
- For a bug: is there a reproducer (failing test, exact command, exact input) that
  proves the diagnosed root cause? 'Confidence: High' without a reproducer is a guess.
- For a feature/refactor: is success stated as 'test X passes', 'command Y outputs Z',
  or 'observable behavior W' — not 'make it work' / 'looks right'?
- For each verifiable check the research proposes: does the check actually exercise
  the claimed change, or is it tangential?
- Could a different person, given only the success criteria, independently confirm
  the work is done? If not, the criteria are too weak."
```

### Phase 3: Wait and Synthesize

**CRITICAL**: Wait for ALL agents to complete before synthesizing.

For each agent's findings:
- Did it find contradictory evidence?
- Did it identify gaps in the original research?
- What new questions arose?

### Phase 4: Generate Validation Report (Pyramid Style)

```markdown
## Validation Report

### Status: [VALIDATED / CONCERNS / INVALID]
**Post-validation confidence:** [H/M/L] (was [original] → now [revised])

### Top Concerns (ranked by severity)
1. **[Most critical concern]** — [evidence + impact] — Severity: High
2. **[Second concern]** — [evidence + impact] — Severity: Medium
3. **[Third concern]** — [evidence + impact] — Severity: Low
(Skip this section entirely if status is VALIDATED with no concerns)

### Behavioral Lens Snapshot
| Lens | Verdict | Note |
|------|---------|------|
| Surfaced assumptions | ✓ / ⚠ / ✗ | [one line — what was silently picked, if anything] |
| Simplicity | ✓ / ⚠ / ✗ | [one line — overcomplication / speculative scope] |
| Surgical scope | ✓ / ⚠ / ✗ | [one line — adjacent-code changes / scope creep] |
| Verifiable success | ✓ / ⚠ / ✗ | [one line — is there a reproducer / checkable criterion?] |
(Skip rows that are ✓ if all four pass — just write "All four lenses pass.")

### What Holds Up
- [Claim that checks out] ✓
- [Claim that checks out] ✓
- [Claim that checks out] ✓

### Action Items
1. [Most important re-investigation or fix]
2. [Second priority action]
3. [What can be accepted as-is]

---
## Deep Dives

### Claims Review
| # | Claim | Status | Evidence |
|---|-------|--------|----------|
| 1 | [Claim] | Validated/Challenged/Disproven | [Brief evidence] |
| 2 | [Claim] | Validated/Challenged/Disproven | [Brief evidence] |

### Alternative Hypotheses
For each challenged conclusion:
1. [Original claim]
   - Alt A: [description] — Likelihood: [H/M/L]
   - Alt B: [description] — Likelihood: [H/M/L]

### Missing Files/Code Found
- `path/to/missed/file.ts` — [Why it matters]

### Edge Cases Not Considered
- [Edge case 1] — Impact: [severity]

### Version/Compatibility Issues
- [Package]: Claimed v[X], Actual v[Y] — [Impact]
(Skip if none found)

### Calculation Errors Found
- [Original] → [Corrected]
(Skip if none found)

### Reference Verification
- [X/Y] references verified as accurate
- Broken refs: [list]

### Contradictory Evidence
- `file:line` — [What contradicts research]
(Skip if none found)

### Dead Code & Reuse Issues
- [Dead code that will be left behind] — `file:line`
- [Existing utility that should be reused instead] — `file:line`
- [Duplicated logic found at] — `file:line`
(Skip if none found)

### Interface Review
| Interface | Status | Issue |
|-----------|--------|-------|
| [Old interface] | Should remove / Should deprecate | [Why] |
| [New interface] | Justified / Over-engineered / Duplicates existing | [Details] |
(Skip if none found)

### Efficiency & Shortcuts Concerns
- [Shortcut taken] — Impact: [severity] — `file:line`
- [Efficiency issue] — Impact: [severity]
(Skip if none found)

### Backward Compatibility
- **Status**: [Addressed / Not addressed / Not applicable]
- Breaking changes: [list or "none"]
- Migration needed: [yes/no] — Reversible: [yes/no]
- Open question: [If not addressed, flag what needs answering]
(Skip if not applicable)

### Unverified Assumptions
| # | Assumption | Status |
|---|-----------|--------|
| 1 | [Assumption] | verified/unverified/false |

### Open Questions
- [Questions that still need answers]
```

## Agent Prompting Tips

When spawning agents, emphasize:
- "Find evidence that DISPROVES the claim"
- "What would make this conclusion WRONG?"
- "Search for code NOT mentioned in the research"
- "Assume the research missed something important"

## Validation Checklist

Always verify:
- [ ] All file:line references are accurate
- [ ] Package versions match what's claimed
- [ ] Calculations are correct (redo them)
- [ ] No relevant code was missed
- [ ] Edge cases were considered
- [ ] Assumptions are stated and verified
- [ ] Alternative explanations were explored
- [ ] Contradictory evidence was searched for
- [ ] No dead code will be left behind by the change
- [ ] Existing utilities/helpers are reused instead of reinventing
- [ ] Old/obsolete interfaces are cleaned up, not left dangling
- [ ] New interfaces are justified (not over-engineered or duplicating existing ones)
- [ ] No shortcuts taken (no swallowed errors, hardcoded values, suppressed warnings)
- [ ] Backward compatibility impact is addressed or explicitly flagged
- [ ] Efficiency is considered (no N+1 queries, redundant iterations, unnecessary allocations)
- [ ] Migration path is reversible if applicable
- [ ] **Lens #1 — Assumptions**: silent interpretations were surfaced (or the research stopped to ask)
- [ ] **Lens #2 — Simplicity**: a senior engineer would not call this overcomplicated; no speculative abstractions or unrequested flexibility
- [ ] **Lens #3 — Surgical scope**: every changed line traces to the request; no drive-by refactors of adjacent code
- [ ] **Lens #4 — Verifiable success**: success is defined as a checkable test / command / observable behavior, not "make it work"

## When to Use

- After `/research` or `/create-plan` in same or new context
- Before implementing a plan
- When a solution "feels too easy"
- When debugging hasn't found root cause
- Before committing to architectural decisions
- Whenever you doubt Claude's confidence

## Output Format

Pyramid style — reader gets the verdict in 30 seconds:
- **Layer 1**: Status + Top Concerns (ranked) + What Holds Up + Action Items
- **Layer 2** (after `---`): Claims table, alternative hypotheses, agent findings, full evidence
- Skip sections with no findings — never output empty headers
- Don't just confirm — actively try to disprove
