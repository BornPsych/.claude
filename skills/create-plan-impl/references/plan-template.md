# Implementation Plan Template

Use this template when writing detailed implementation plans.

## File Location

Save plans to: `.claude/plans/YYYY-MM-DD-description.md`

Examples:
- `.claude/plans/2025-01-08-user-authentication.md`
- `.claude/plans/2025-01-08-fix-memory-leak.md`
- `.claude/plans/2025-01-08-refactor-payment-module.md`

---

## Template (Pyramid Style)

```markdown
# [Feature/Task Name] Implementation Plan

## Verdict
**[1-sentence: what we're building and why].** [N] phases, highest risk: [1-sentence risk].

## Key Decisions
1. **[Most important design decision]** — [rationale]
2. **[Second decision]** — [rationale]
3. **[Third decision]** — [rationale]

## Scope
- **Building:** [what's in scope — 2-3 bullets]
- **NOT building:** [what's explicitly out of scope]

## Phases at a Glance
| # | Phase | What it does | Key files |
|---|-------|-------------|-----------|
| 1 | [Name] | [1-liner] | `file.ext` |
| 2 | [Name] | [1-liner] | `file.ext` |
| 3 | [Name] | [1-liner] | `file.ext` |

## Desired End State
[How to verify success — concrete observable behaviors]

---
## Phase Details

### Phase 1: [Descriptive Name]
[What this phase accomplishes — 1-2 sentences]

**Changes:**

#### 1. [Component/File Group]
**File**: `path/to/file.ext`
**Changes**: [Summary]

```[language]
// Specific code to add/modify
```

#### 2. [Another Component]
**File**: `path/to/another.ext`
**Changes**: [Summary]

**Success Criteria:**
- [ ] `[test/build command]` passes
- [ ] [Manual verification step]

**Checkpoint**: Pause for confirmation before Phase 2.

---

### Phase 2: [Descriptive Name]
[What this phase accomplishes]

**Changes:**

#### 1. [Component]
**File**: `path/to/file.ext`
**Changes**: [Summary]

**Success Criteria:**
- [ ] [Automated check]
- [ ] [Manual check]

---

### Phase 3: [Descriptive Name]
[Continue pattern as needed...]

---
## Appendix

### Current State Analysis
[What exists now, key constraints discovered]
- [Finding with `file:line`]
- [Pattern to follow]

### Testing Strategy
- **Unit**: [What to test, key edge cases]
- **Integration**: [E2E scenarios]
- **Manual**: [Steps to verify]

### Performance Considerations
[Only if applicable — skip if none]

### Migration Notes
[Only if applicable — include rollback plan]

### Security Considerations
[Only if applicable]

### References
- `[file:line]` — [description]
- [External link] — [description]

### Unresolved Questions
- [ ] [Questions that still need answers]
```

---

## Tips for Good Plans

1. **Be Specific**: Include actual file paths and line numbers
2. **Be Testable**: Every phase should have verifiable success criteria
3. **Be Incremental**: Each phase should be independently valuable
4. **Be Explicit**: List what you're NOT doing to prevent scope creep
5. **Be Complete**: No open questions - resolve before finalizing
