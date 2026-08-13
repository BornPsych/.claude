---
name: breakdown-impl
description: STRUCTURE problems WITHOUT solving. MECE decomposition, Cynefin classification, 5 Whys root cause, WBS breakdown. Triggers - "break this down", "decompose", "structure the approach", "how should I think about". For PLANNING not implementation. Does NOT investigate codebase - use research-codebase for that. (user)
allowed-tools: Read, Grep, Glob, AskUserQuestion
---

# Problem Breakdown

Systematic problem decomposition using consulting and engineering frameworks.

## Invocation

```
/breakdown "your problem statement here"
```

## Core Principle

**DO NOT SOLVE THE PROBLEM.** Only decompose and plan.

## Integrated Framework Methodology

### Phase 1: Classify (Cynefin Framework)

Determine problem type before decomposing:

| Domain | Cause & Effect | Approach |
|--------|----------------|----------|
| **Clear** | Obvious | Sense → Categorize → Respond |
| **Complicated** | Requires analysis | Sense → Analyze → Respond |
| **Complex** | Unknown unknowns | Probe → Sense → Respond |
| **Chaotic** | No patterns | Act → Sense → Respond |

### Phase 2: Explore Context

Search codebase for:
- Keywords from problem statement
- Affected files and modules
- Existing patterns and structures
- Dependencies and relationships

### Phase 3: Root Cause (5 Whys)

For bugs/issues, trace causation:
```
Problem → Why 1 → Why 2 → Why 3 → Why 4 → Why 5 (Root)
```

Rules:
- Never blame people
- Ask "What process allowed this?"
- May need more or fewer than 5

### Phase 4: Clarify

Ask 3-5 questions before decomposing:
1. Scope boundaries
2. Constraints
3. Dependencies
4. Success criteria
5. Prior attempts

**Breaking changes gate** — also ask these when relevant (skip if clearly N/A):
- Does this need backward compatibility with existing data/APIs/formats? (e.g., old manifests, DB schemas, config files)
- Can existing callers/consumers break? Or must old behavior be preserved?
- Are there persisted artifacts (files on disk, DB rows, serialized formats) that would become invalid?
- Is a migration path needed, or is a clean break acceptable?
- Will this change any public CLI flags, config keys, or output formats?

These questions can surface "no, just break it" answers early — which dramatically simplifies the breakdown. Flag any question where the answer is "no" as a simplification opportunity.

**Wait for answers before proceeding.**

### Phase 5: MECE Decomposition

Apply McKinsey's MECE principle:
- **Mutually Exclusive**: No overlapping categories
- **Collectively Exhaustive**: 100% coverage, no gaps

Common MECE splits for software:
- By layer: Frontend / Backend / Database / Infra
- By flow: Input / Processing / Output / Errors
- By CRUD: Create / Read / Update / Delete

### Phase 6: Hierarchical Breakdown (WBS)

```
Level 1: Problem Goal
├── Level 2: Major Components (2-5)
│   ├── Level 3: Sub-tasks
│   │   └── Level 4: Atomic Actions
```

**100% Rule**: Breakdown must capture entire scope.

### Phase 7: First Principles Check

For each component:
- What assumptions exist?
- What are fundamental truths?
- Could this be done differently?

## Output Structure (Pyramid Style)

```
## Problem Breakdown: [Title]

### Verdict
**[Cynefin domain]: [1-sentence problem classification].** [N] components, highest risk: [1-liner].

### Key Components (ranked by priority)
1. **[Component 1]** — [what + why it's first] — Complexity: S/M/L
2. **[Component 2]** — [what + dependency] — Complexity: S/M/L
3. **[Component 3]** — [what] — Complexity: S/M/L

### Execution Order
[Component 1] → [Component 2] → [Component 3]
(with dependency arrows showing what blocks what)

### Top Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| [Risk 1] | H/M/L | H/M/L | [1-liner] |
| [Risk 2] | H/M/L | H/M/L | [1-liner] |

---
## Deep Dives

### Classification Detail
Cynefin Domain: [domain] — [reasoning for this classification]

### Root Cause (if applicable)
1. → [Why 1]
2. → [Why 2]
3. → [Why 3]
4. → [Why 4]
5. → **Root Cause**: [Why 5]

### Context Discovered
[Codebase findings with file:line refs]

### MECE Validation
- Split type: [by layer / by flow / by CRUD / custom]
- Overlap check: [any overlaps found]
- Gap check: [any gaps found]

### Component Details
Each with: sub-tasks, dependencies, verification criteria

### First Principles Check
[Assumptions challenged, alternative approaches considered]
```

## Framework Selection Guide

| Framework | Use When |
|-----------|----------|
| Cynefin | First - classify problem type |
| MECE | Ensuring complete coverage |
| 5 Whys | Bugs, incidents, root causes |
| WBS | Deliverable-based breakdown |
| First Principles | Innovation, unconventional solutions |
