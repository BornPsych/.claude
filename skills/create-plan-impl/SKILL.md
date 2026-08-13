---
name: create-plan-impl
description: CREATE implementation plans through research + iteration. Phased plans with success criteria. Triggers - "plan this", "how should I implement", "design the approach", "create a plan for". For detailed implementation strategy after problem is understood.
allowed-tools: Read, Grep, Glob, Task, Write, AskUserQuestion
---

# Create Plan

Interactive implementation planning with thorough codebase research and iterative refinement.

## Quick Start

**With parameters:**
```
/plan add user authentication to the API
/plan fix memory leak in WebSocket handler - see error.log
/plan refactor the payment module for better testability
```

**Without parameters** - prompts for details:
```
I'll help create a detailed implementation plan. Please provide:
1. Task description or ticket reference
2. Relevant context, constraints, requirements
3. Related files or previous implementations
```

## Planning Workflow

### Phase 1: Context Gathering

1. **Read mentioned files FULLY** (no limit/offset)
2. **Spawn parallel research agents:**

| Agent | Purpose |
|-------|---------|
| `codebase-locator` | Find relevant files |
| `codebase-analyzer` | Understand current implementation |
| `codebase-pattern-finder` | Find similar patterns to follow |
| `web-search-researcher` | External docs if needed |

3. **Present understanding + focused questions:**
```
Based on my research, I understand we need to [summary].

I've found:
- [Current implementation detail] (`file:line`)
- [Pattern to follow] (`file:line`)
- [Constraint discovered]

Questions my research couldn't answer:
- [Technical decision needing human input]
- [Business logic clarification]
```

### Phase 2: Design Options

After clarifications, present options:
```
**Current State:**
- [Key discovery about existing code]
- [Pattern or convention to follow]

**Design Options:**
1. [Option A] - pros/cons
2. [Option B] - pros/cons

Which approach aligns best?
```

### Phase 3: Plan Structure

Get approval on outline before details:
```
## Proposed Structure:

1. [Phase 1] - [what it accomplishes]
2. [Phase 2] - [what it accomplishes]
3. [Phase 3] - [what it accomplishes]

Does this phasing make sense?
```

### Phase 4: Write Detailed Plan (Pyramid Style)

Use the plan template (see [references/plan-template.md](references/plan-template.md)):

**File naming:** `.claude/plans/YYYY-MM-DD-description.md`
- Example: `.claude/plans/2025-01-08-user-authentication.md`

**Pyramid structure — reader should get the gist in 30 seconds:**
- Verdict (1-sentence what + why)
- Key Decisions (top 3 design choices)
- Scope (in/out) + Phases at a Glance (table)
- Desired End State
- `---` divider → Phase Details, Appendix (testing, migration, security, refs)

### Phase 5: Review & Iterate

```
I've created the plan at: `.claude/plans/YYYY-MM-DD-description.md`

Please review:
- Are phases properly scoped?
- Are success criteria specific enough?
- Any missing edge cases?
```

## Agent Usage

Spawn agents via `Task` tool (see [references/agents.md](references/agents.md) for full specs):

```
Task(subagent_type="codebase-locator", prompt="Find all files related to [feature]")
Task(subagent_type="codebase-analyzer", prompt="Analyze how [component] works")
Task(subagent_type="codebase-pattern-finder", prompt="Find examples of [pattern]")
```

**Run in parallel** when researching different aspects.

## Guidelines

| Principle | Description |
|-----------|-------------|
| **Be Skeptical** | Question vague requirements, verify with code |
| **Be Interactive** | Get buy-in at each step, don't write full plan in one shot |
| **Be Thorough** | Include file:line refs, measurable success criteria |
| **Be Practical** | Incremental changes, consider migration/rollback |
| **No Open Questions** | Resolve all uncertainties before finalizing |

## Success Criteria Format

Always separate automated vs manual:

```markdown
### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `npm test`
- [ ] Type check: `npm run typecheck`
- [ ] Lint passes: `npm run lint`

#### Manual Verification:
- [ ] Feature works in UI
- [ ] Performance acceptable
- [ ] Edge cases handled
```

## References

- [plan-template.md](references/plan-template.md) - Full plan template
- [agents.md](references/agents.md) - Agent specifications
- [patterns.md](references/patterns.md) - Common implementation patterns
