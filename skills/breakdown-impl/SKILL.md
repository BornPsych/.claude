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

## Output Structure

```
## Problem Breakdown: [Title]

### Classification
Cynefin Domain + reasoning

### Context Discovered
Codebase findings

### Root Cause (if applicable)
5 Whys chain

### MECE Validation
Overlap/gap check

### Components
Each with: tasks, dependencies, verification

### Execution Order
Dependency-aware sequence

### Risks
Risk register with mitigation
```

## Framework Selection Guide

| Framework | Use When |
|-----------|----------|
| Cynefin | First - classify problem type |
| MECE | Ensuring complete coverage |
| 5 Whys | Bugs, incidents, root causes |
| WBS | Deliverable-based breakdown |
| First Principles | Innovation, unconventional solutions |
