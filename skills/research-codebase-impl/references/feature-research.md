# Feature Research Protocol

Category-specific protocol for investigating feature-related queries: "How to add X?", "What's needed for Y?", "Can we implement Z?"

## When This Protocol Applies
- User wants to add or extend a feature
- Investigating feasibility of a new capability
- Understanding what it takes to implement something
- Comparing implementation approaches for a feature

---

## Phase 1: Codebase Context

**Spawn 3 parallel agents:**

```
Task(subagent_type="codebase-locator", prompt="Find all files related to [feature area]. Include implementation, tests, configs, types, and migration files.")

Task(subagent_type="codebase-analyzer", prompt="Analyze the module closest to [feature area]. Trace entry points, data flow, and key abstractions.")

Task(subagent_type="codebase-pattern-finder", prompt="Find existing patterns for [similar feature type] — how are similar features structured, tested, and configured?")
```

**Collect:** File map, architecture overview, existing conventions.

## Phase 2: Related Features & Precedents

Using Phase 1 results:
- Identify 2–3 features most similar to the proposed one
- Note their structure: files created, patterns used, tests written
- Check if a plugin/extension system exists that the feature should use
- Look for shared utilities the feature can leverage

**Key question:** Is there a "template" in the codebase for adding this type of feature?

## Phase 3: Architecture Impact

Assess which layers the feature touches:

| Layer | Impact | Files |
|-------|--------|-------|
| API/Routes | New endpoint? Modified existing? | `file:line` |
| Business Logic | New service? Extended existing? | `file:line` |
| Data Layer | Schema changes? New queries? | `file:line` |
| UI/Frontend | New components? Modified views? | `file:line` |
| Config | New env vars? Feature flags? | `file:line` |

Check:
- New dependencies required? Version constraints?
- Schema/migration changes needed?
- Cross-cutting concerns: auth, logging, caching, rate limiting

## Phase 4: Edge Cases & Constraints

Systematically identify:

**Input boundaries:**
- Empty/null/undefined inputs
- Maximum size/length limits
- Invalid format or encoding
- Concurrent/duplicate submissions

**State edge cases:**
- Feature enabled mid-operation
- Partial failure / rollback scenarios
- Cache invalidation timing
- Race conditions with parallel requests

**Integration constraints:**
- API rate limits on external services
- Database transaction boundaries
- Message queue ordering guarantees
- File system permissions

## Phase 5: Breaking Changes Assessment

| Check | Status | Details |
|-------|--------|---------|
| Public API surface changed? | | |
| Existing behavior altered? | | |
| Database schema backward-compatible? | | |
| Config format changed? | | |
| Semver implication (major/minor/patch)? | | |
| Migration path for existing users? | | |

If breaking changes exist, draft a migration guide outline.

## Phase 6: Optimization Opportunities

Look for:
- **Caching**: Can results be cached? What invalidation strategy?
- **Query optimization**: Can DB queries be batched or indexed?
- **Shared logic extraction**: Does this duplicate existing code?
- **Lazy loading**: Can parts be deferred?
- **Bulk operations**: Does the feature need batch support?

## Phase 7: Test Strategy

Assess current coverage and gaps:
- **Unit tests needed**: Core logic, edge cases, error paths
- **Integration tests**: API endpoints, database operations
- **E2E tests**: Full user flows if applicable
- **Performance tests**: If feature is latency-sensitive

Find existing test patterns to follow:
```
Task(subagent_type="codebase-pattern-finder", prompt="Find test patterns for [similar feature]. Show test setup, mocking approach, and assertion style.")
```

## Phase 8: Mini Feature Breakdown

Produce an ordered task list:

| # | Task | Complexity | Dependencies | Files |
|---|------|-----------|--------------|-------|
| 1 | [Task description] | S/M/L | None | `file.ts` |
| 2 | [Task description] | S/M/L | #1 | `file.ts` |
| ... | | | | |

Complexity guide: **S** = < 1 hour, single file. **M** = 1–4 hours, 2–5 files. **L** = 4+ hours, cross-cutting.

---

## Risk Assessment Matrix

| Dimension | Rating (L/M/H) | Notes |
|-----------|----------------|-------|
| **Complexity** | | How many systems touched, new patterns needed |
| **Breaking Change** | | API/schema/behavior changes |
| **Performance** | | Latency, memory, query count impact |
| **Security** | | Auth, input validation, data exposure |
| **Test Gap** | | Uncovered paths, missing integration tests |

---

## Output Template

```markdown
## Feature Research: [Feature Name]

### Summary
[2-3 sentence overview of feasibility and approach]

### Confidence: [High/Medium/Low]

### Codebase Context
[Key files, patterns, and architecture relevant to this feature]

### Recommended Approach
[Approach with rationale, referencing existing patterns]

### Architecture Impact
[Table from Phase 3]

### Edge Cases
[Key edge cases from Phase 4]

### Breaking Changes
[Assessment from Phase 5, or "None expected"]

### Risk Assessment
[Matrix from above]

### Implementation Breakdown
[Task table from Phase 8]

### Open Questions
- [ ] [Questions needing human decision]

### Next Steps
- [ ] [Suggested follow-up actions]
```
