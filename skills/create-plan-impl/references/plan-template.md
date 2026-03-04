# Implementation Plan Template

Use this template when writing detailed implementation plans.

## File Location

Save plans to: `.claude/plans/YYYY-MM-DD-description.md`

Examples:
- `.claude/plans/2025-01-08-user-authentication.md`
- `.claude/plans/2025-01-08-fix-memory-leak.md`
- `.claude/plans/2025-01-08-refactor-payment-module.md`

---

## Template

```markdown
# [Feature/Task Name] Implementation Plan

## Overview

[Brief description of what we're implementing and why - 2-3 sentences]

## Current State Analysis

[What exists now, what's missing, key constraints discovered]

### Key Discoveries:
- [Important finding with file:line reference]
- [Pattern to follow]
- [Constraint to work within]

## Desired End State

[Specification of the end state after this plan is complete]

### How to Verify:
- [Concrete way to verify success]
- [Observable behavior change]

## What We're NOT Doing

[Explicitly list out-of-scope items to prevent scope creep]

- NOT: [Out of scope item 1]
- NOT: [Out of scope item 2]

## Implementation Approach

[High-level strategy and reasoning for the chosen approach]

---

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes - 1-2 sentences]

### Changes Required:

#### 1. [Component/File Group]
**File**: `path/to/file.ext`
**Changes**: [Summary of changes]

```[language]
// Specific code to add/modify
// Include enough context for implementation
```

#### 2. [Another Component]
**File**: `path/to/another.ext`
**Changes**: [Summary]

### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `[test command]`
- [ ] Type check passes: `[typecheck command]`
- [ ] Lint passes: `[lint command]`
- [ ] Build succeeds: `[build command]`

#### Manual Verification:
- [ ] [Specific behavior to verify manually]
- [ ] [Edge case to test]
- [ ] [Performance check]

**Checkpoint**: Pause for manual confirmation before proceeding to Phase 2.

---

## Phase 2: [Descriptive Name]

### Overview
[What this phase accomplishes]

### Changes Required:

#### 1. [Component]
**File**: `path/to/file.ext`
**Changes**: [Summary]

```[language]
// Code changes
```

### Success Criteria:

#### Automated Verification:
- [ ] [Automated checks]

#### Manual Verification:
- [ ] [Manual checks]

---

## Phase 3: [Descriptive Name]

[Continue pattern as needed...]

---

## Testing Strategy

### Unit Tests:
- [What to test]
- [Key edge cases]
- [Mocking strategy]

### Integration Tests:
- [End-to-end scenarios]
- [API contract tests]

### Manual Testing Steps:
1. [Specific step to verify feature]
2. [Another verification step]
3. [Edge case to test manually]

## Performance Considerations

[Any performance implications or optimizations needed]

- [Consideration 1]
- [Consideration 2]

## Migration Notes

[If applicable, how to handle existing data/systems]

- [Migration step 1]
- [Rollback plan]

## Security Considerations

[If applicable, security implications]

- [Security consideration 1]
- [Input validation needed]

## References

- Related files: `[file:line]`
- Similar implementation: `[file:line]`
- External docs: [link]
```

---

## Tips for Good Plans

1. **Be Specific**: Include actual file paths and line numbers
2. **Be Testable**: Every phase should have verifiable success criteria
3. **Be Incremental**: Each phase should be independently valuable
4. **Be Explicit**: List what you're NOT doing to prevent scope creep
5. **Be Complete**: No open questions - resolve before finalizing
