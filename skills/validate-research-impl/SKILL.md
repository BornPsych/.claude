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

Launch 5-8 parallel Task agents, each with a different skeptical lens:

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

Task 8 - Assumption Challenger:
"List every assumption in the research (stated or implied).
For each assumption:
- Is it actually true? Verify with code.
- What if the opposite were true?
- What evidence would disprove it?"
```

### Phase 3: Wait and Synthesize

**CRITICAL**: Wait for ALL agents to complete before synthesizing.

For each agent's findings:
- Did it find contradictory evidence?
- Did it identify gaps in the original research?
- What new questions arose?

### Phase 4: Generate Validation Report

```markdown
## Validation Report

### Validation Status: [VALIDATED / CONCERNS / INVALID]

### Original Claims Reviewed
1. [Claim] → [Validated/Challenged/Disproven]
2. [Claim] → [Validated/Challenged/Disproven]

### Alternative Hypotheses
For each major conclusion, alternatives that could also be true:
1. [Original claim]
   - Alt A: [description] - Likelihood: [H/M/L]
   - Alt B: [description] - Likelihood: [H/M/L]
   - Alt C: [description] - Likelihood: [H/M/L]

### Missing Files/Code Found
Files that should have been analyzed but weren't:
- `path/to/missed/file.ts` - [Why it matters]

### Edge Cases Not Considered
- [Edge case 1] - Impact: [severity]
- [Edge case 2] - Impact: [severity]

### Version/Compatibility Issues
- [Package]: Claimed v[X], Actual v[Y] - [Impact]

### Calculation Errors Found
- [Original calculation] → [Corrected calculation]

### Reference Verification
- [X/Y] references verified as accurate
- Broken/incorrect refs: [list]

### Contradictory Evidence
- `file:line` - [What it says that contradicts research]

### Unverified Assumptions
1. [Assumption] - [Status: verified/unverified/false]

### Confidence Assessment
- Original research confidence: [claimed or implied]
- Post-validation confidence: [H/M/L]
- Confidence delta: [+/-/unchanged]

### Recommendations
1. [What needs re-investigation]
2. [What needs additional testing]
3. [What should be accepted as validated]

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

## When to Use

- After `/research` or `/create-plan` in same or new context
- Before implementing a plan
- When a solution "feels too easy"
- When debugging hasn't found root cause
- Before committing to architectural decisions
- Whenever you doubt Claude's confidence

## Output Format

Keep it actionable:
- Clear VALIDATED/CONCERNS/INVALID status
- Specific file:line refs for issues found
- Concrete next steps if concerns found
- Don't just confirm - actively try to disprove
