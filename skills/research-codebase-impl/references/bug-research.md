# Bug Research Protocol

Category-specific protocol for investigating bugs, errors, and unexpected behavior: "Why is X returning null?", "Error: cannot read property", stack traces, failing tests.

## When This Protocol Applies
- User reports a bug, error, or unexpected behavior
- Stack trace or error message provided
- Tests failing unexpectedly
- Performance degradation or data corruption
- "It used to work but now it doesn't"

---

## Phase 1: Problem Definition

Extract and document before any investigation:

| Field | Value |
|-------|-------|
| **Symptom** | What the user observes |
| **Expected behavior** | What should happen |
| **Actual behavior** | What happens instead |
| **Repro conditions** | Steps / environment / inputs |
| **Error message** | Exact text if available |
| **Stack trace** | File:line refs extracted |
| **Since when** | Known working version / commit? |
| **Frequency** | Always / intermittent / specific conditions |

If user provides file paths or line numbers, `Read` those files FIRST before spawning agents.

## Phase 2: Evidence Gathering

**Spawn 3 parallel agents:**

```
Task(subagent_type="bug-tracer", prompt="Trace the execution path for [operation]. Start at [entry point], follow data flow through to [failure point]. Identify where behavior diverges from expected.")

Task(subagent_type="codebase-locator", prompt="Find all files related to [failing component]. Include implementation, tests, configs, types, and recent changes.")

Task(subagent_type="codebase-analyzer", prompt="Analyze error handling and edge cases in [file:line range]. Check for null checks, type coercions, missing validations, race conditions.")
```

**If error references external libraries/APIs:**
```
Task(subagent_type="web-search-researcher", prompt="Search for '[exact error message]' in [library] issues, docs, and changelogs. Find known causes and fixes.")
```

## Phase 3: Hypothesis Generation

Generate 3–5 hypotheses. For each:

| # | Hypothesis | Confidence | Supporting Evidence | Contradicting Evidence |
|---|-----------|------------|--------------------|-----------------------|
| 1 | [What might cause this] | H/M/L | [What supports it] | [What argues against] |
| 2 | ... | | | |

### Analytical Frameworks

**5 Whys** — Chain from symptom to root cause:
1. Why does [symptom] happen? → Because [cause 1]
2. Why does [cause 1] happen? → Because [cause 2]
3. Why does [cause 2] happen? → Because [cause 3]
4. Why does [cause 3] happen? → Because [cause 4]
5. Why does [cause 4] happen? → Because [root cause]

**Change Analysis** — What changed recently:
```
Task(subagent_type="Explore", prompt="Run git log --oneline -20 on files in [affected directory]. Identify recent changes to [component].")
```
- Recent commits touching affected files
- Dependency version bumps
- Config changes
- Environment changes

**Fishbone / Ishikawa Diagram** — Categorize potential causes:

| Category | Potential Causes |
|----------|-----------------|
| **Code** | Logic error, missing null check, wrong comparison |
| **Config** | Wrong env var, missing config, stale cache |
| **Data** | Corrupt input, schema mismatch, encoding issue |
| **Environment** | Version mismatch, missing dependency, OS difference |
| **Dependencies** | Breaking update, deprecated API, incompatible versions |
| **Timing** | Race condition, timeout, order-of-operations |

## Phase 4: Regression & Impact (Blast Radius)

Assess the scope of the bug's impact:

**Direct impact:**
- How many callers invoke the failing code? (use Grep for function references)
- Which user-facing features are affected?

**Transitive impact:**
- What depends on the output of the failing code?
- Could corrupted state propagate to other components?
- Are there downstream consumers (queues, caches, other services)?

**Blast radius summary:**

| Scope | Affected | Severity |
|-------|----------|----------|
| Direct callers | N files/functions | |
| Transitive consumers | N components | |
| User-facing features | [List] | |
| Data integrity risk | [Assessment] | |

## Phase 5: Related Bug Search

Look for patterns that suggest systemic issues:

```
Task(subagent_type="codebase-pattern-finder", prompt="Find TODO, FIXME, HACK, XXX, WARN comments in [affected module]. Also find similar code patterns to [buggy code] elsewhere in the codebase.")
```

Check:
- Same bug pattern exists in other files?
- Previous fixes to the same component (git log)
- Known workarounds already in place
- Open issues mentioning similar symptoms

## Phase 6: Structured Report (Pyramid Style)

```markdown
## Bug Research: [Issue Summary]

### Verdict
**Root cause:** [1-sentence root cause] at `file:line`. Confidence: [H/M/L]

### Key Findings
1. **[Root cause]** — `file:line` — [why this breaks things]
2. **[Blast radius]** — [N callers / N features affected] — [severity]
3. **[Recommended fix]** — `file:line` — [what to change + effort S/M/L]

### 5 Whys → Root Cause
1. → [Why 1]
2. → [Why 2]
3. → [Why 3]
4. → [Why 4]
5. → **Root Cause**: [Why 5]

### Recommended Fix
| Fix | Location | Regression Risk | Effort |
|-----|----------|----------------|--------|
| [Best fix] | `file:line` | L/M/H | S/M/L |

### Next Steps
- [ ] [Most important verification]
- [ ] [Tests to add]

---
## Deep Dives

### Problem Definition
[Table from Phase 1]

### Hypotheses (ranked by confidence)
| # | Hypothesis | Confidence | Supporting Evidence | Contradicting Evidence |
|---|-----------|------------|--------------------|-----------------------|
| 1 | [Hypothesis] | H/M/L | [Evidence] | [Counter-evidence] |

### Full Execution Trace
1. `file.ts:line` — [What happens]
2. `file.ts:line` — [What happens]
3. **FAILURE**: `file.ts:line` — [Where it breaks and why]

### Blast Radius Detail
| Scope | Affected | Severity |
|-------|----------|----------|
| Direct callers | N files/functions | |
| Transitive consumers | N components | |
| User-facing features | [List] | |

### All Evidence
- `file.ts:45` — [What was found]
- `file.ts:123` — [Related code]

### All Fix Options
| # | Fix | Location | Regression Risk | Effort |
|---|-----|----------|----------------|--------|
| 1 | [Quick fix] | `file:line` | L/M/H | S/M/L |
| 2 | [Proper fix] | `file:line` | L/M/H | S/M/L |
| 3 | [Defensive fix] | `file:line` | L/M/H | S/M/L |

### Related Bugs & Patterns
[Findings from Phase 5]
```
