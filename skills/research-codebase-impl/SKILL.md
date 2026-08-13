---
name: research-codebase-impl
description: INVESTIGATE codebase - find files, trace data flow, understand architecture, debug errors. Triggers - "where is", "how does X work", "find the code for", "trace this error", "why is X happening". Does NOT plan or structure - use breakdown for that. (user)
allowed-tools: Read, Grep, Glob, Task, WebSearch, AskUserQuestion
---

# Research Codebase

Universal research tool for investigating ANY codebase query - bugs, problems, errors, architecture, features, or general exploration.

## Query Types Supported

| Query Type | Examples |
|------------|----------|
| **Bugs/Errors** | "Why is X returning null?", "Error: cannot read property", stack traces |
| **Problems** | "The API is slow", "Memory leak in component X", "Tests failing" |
| **Understanding** | "How does auth work?", "What's the data flow for Y?" |
| **Architecture** | "How are services connected?", "What patterns are used?" |
| **Features** | "Where is feature X implemented?", "How to add Y?" |
| **Performance** | "Why is this slow?", "Where are the bottlenecks?" |

## Workflow

### Phase 0: Classify Research Type

Before starting, determine the research category. **Auto-classify** if `$ARGUMENTS` clearly indicates a type:
- Error messages, stack traces, "why is X failing/returning null" → **Bug Research**
- "How to add/implement X", "what's needed for Y" → **Feature Research**
- "How does X work?", "walk me through", "understand the architecture" → **Codebase Exploration**
- Technology comparisons, concepts, best practices, "X vs Y" → **Academic/Domain Research**

**If auto-classified:** State the classification (e.g., "This looks like a **Bug Research** query.") and **default to Terminal output** — skip the output format question and proceed immediately. Only ask if the user explicitly requests a file.

**If ambiguous:** Use `AskUserQuestion` to prompt classification only (output defaults to Terminal):
```
AskUserQuestion({
  questions: [{
    question: "What type of research is this?",
    header: "Category",
    options: [
      { label: "Feature Research", description: "Investigate feasibility, architecture impact, edge cases for a new/modified feature" },
      { label: "Bug Research", description: "Debug errors, trace failures, find root causes, assess blast radius" },
      { label: "Codebase Exploration", description: "Understand how code works, map architecture, trace data flow" },
      { label: "Academic/Domain Research", description: "Compare technologies, research concepts, evaluate best practices" }
    ],
    multiSelect: false
  }]
})
```

### Output Format Handling

**Default: Terminal.** Print the full report directly in the conversation. Do not create a file unless the user explicitly asks for one (e.g., "save to file", "write an MD").

- **Terminal** (default): Print the full report directly in the conversation. Do not create a file.
- **MD File** (only if requested): Write the full report to `.claude/<topic>-research-<date>-<time-IST>.md` in the current directory. Print only the file path in the terminal.
- **Both** (only if requested): Write the full report to `.claude/<topic>-research-<date>-<time-IST>.md` AND print a concise summary (key findings, recommendation, next steps) + file path in the terminal.

### Phase 0 → Routing

Based on classification, `Read` the appropriate protocol and follow it **instead of** the Generic Workflow below:

| Category | Protocol File |
|----------|--------------|
| Feature Research | `Read` [references/feature-research.md](references/feature-research.md) → Follow its 8 phases |
| Bug Research | `Read` [references/bug-research.md](references/bug-research.md) → Follow its 6 phases |
| Codebase Exploration | `Read` [references/codebase-exploration.md](references/codebase-exploration.md) → Follow its 5 phases |
| Academic/Domain Research | `Read` [references/academic-research.md](references/academic-research.md) → Follow its 5 phases |
| Custom (free text) | Fall through to **Generic Workflow** below |

---

## Generic Workflow (Custom / Fallback)

Used when no specialized category applies, or when the user selects "Custom".

### 1. Analyze the Query
Classify the query type and extract:
- **Keywords**: Technical terms, function/class names, error messages
- **Scope**: Specific file, component, or system-wide
- **Intent**: Debug, understand, find, trace, or explain

### 1a. Surface Assumptions Before Searching

Before any tool call, write down what you're *assuming* about the query — these are the silent inferences that cause wrong answers later:

- **Terminology** — am I assuming "auth" means OAuth, JWT, session, or something project-specific?
- **Scope** — did the user mean *this* component, *this* repo, or *this* feature end-to-end?
- **Interpretation** — if the query has more than one valid reading, present them and ask. Do NOT silently pick one.
- **Pushback** — if the request feels overcomplicated (e.g., "audit every file" when one file is the answer), name that observation before executing.

Only proceed once each assumption is either verified by reading, or surfaced to the user. Carry the unverified ones into the final "Assumptions Made" section of the report.

### 2. Read Mentioned Context First
If user provides:
- Error messages/stack traces → Extract file paths and line numbers
- Specific files → Read them FULLY (no limit/offset)
- Log snippets → Identify relevant components

### 3. Create Research Plan
Use TodoWrite to track:
```
1. [in_progress] Locate relevant files
2. [pending] Analyze core implementation
3. [pending] Find related patterns/usages
4. [pending] Synthesize findings
```

### 4. Spawn Parallel Sub-Agents

Use `Task` tool with these specialized agents:

| Agent | Best For | Use When |
|-------|----------|----------|
| `Explore` | Quick searches | Simple "where is X?" - faster than full agents |
| `codebase-locator` | Finding files | Need to discover WHERE code lives |
| `codebase-analyzer` | Deep analysis | Need to understand HOW code works |
| `codebase-pattern-finder` | Examples | Need similar implementations |
| `bug-tracer` | Bug investigation | Tracing errors, data flow issues |
| `web-search-researcher` | External info | Need docs, solutions from web |

**For Simple Queries (use Explore first):**
```
Task(subagent_type="Explore", prompt="Find files related to [topic]")
```

**For Bug/Problem Queries:**
```
Task(subagent_type="codebase-locator", prompt="Find files related to [error component]")
Task(subagent_type="bug-tracer", prompt="Trace the data flow for [problematic feature]")
Task(subagent_type="codebase-analyzer", prompt="Analyze error handling in [file:line]")
```

**For Understanding Queries:**
```
Task(subagent_type="codebase-locator", prompt="Find all [feature] related files")
Task(subagent_type="codebase-analyzer", prompt="Explain how [component] works")
Task(subagent_type="codebase-pattern-finder", prompt="Find usage examples of [pattern]")
```

**Run agents in parallel** when searching different aspects.

### 5. Synthesize Findings (Pyramid Style)

**ALL output uses progressive disclosure: Verdict → Key Details → Appendix.**

**For Bugs/Problems:**
```markdown
## Problem Analysis: [Issue]

### Verdict
**Root cause:** [1-sentence what's wrong] at `file:line`. Confidence: [H/M/L]

### Key Findings
1. **[Most critical finding]** — `file:line` — [what + why it matters]
2. **[Second finding]** — `file:line` — [what + implication]
3. **[Third finding]** — `file:line` — [what + implication]

### Recommended Fix
[Best fix option with code location and trade-off in 2-3 sentences]

### Verifiable Reproducer
[Exact failing test, command, input, or observable behavior that proves the root cause. If no reproducer can be constructed, lower confidence and say so — "Confidence: High" without a reproducer is a guess.]

### Assumptions Made
- [Each silent inference that wasn't verified by reading — e.g., "Assumed `auth` refers to the session middleware, not the OAuth flow"]
(Skip if all assumptions were verified)

### Next Steps
- [ ] [Most important follow-up]
- [ ] [Second priority]

---
## Deep Dives

### Execution Trace
1. Request enters at `api/route.ts:12`
2. Processed by `service.ts:34`
3. **FAILURE**: `handler.ts:56` — [detailed reason]

### All Evidence
- `file.ts:45` — [What was found]
- `other.ts:123` — [Related code]

### Alternative Fix Options
| # | Fix | Location | Regression Risk | Effort |
|---|-----|----------|----------------|--------|
| 1 | [Quick fix] | `file:line` | L/M/H | S/M/L |
| 2 | [Proper fix] | `file:line` | L/M/H | S/M/L |

### Related Code
- Similar patterns at `other/file.ts:78`
- Tests at `__tests__/file.test.ts:90`
```

**For Understanding Queries:**
```markdown
## Research: [Topic]

### Verdict
[1-sentence answer to the user's question]. Confidence: [H/M/L]

### Key Findings
1. **[Most important thing to know]** — `file:line`
2. **[Second most important]** — `file:line`
3. **[Third most important]** — `file:line`

### How It Works (short)
1. [Step 1] (`file:line`)
2. [Step 2] (`file:line`)
3. [Step 3] (`file:line`)

### Assumptions Made
- [Each silent inference not verified by reading — e.g., "Assumed 'the auth system' means the code under `src/auth/`, not the third-party SSO integration"]
(Skip if all assumptions were verified)

### Next Steps
- [ ] [Deeper areas to explore]
- [ ] [Questions for domain experts]

---
## Deep Dives

### Key Components
- `component.ts` — [Purpose]
- `helper.ts` — [Purpose]

### Architecture & Patterns
[Design decisions, conventions found]

### All Code References
- `path/file.ts:123` — [Description]
```

### 6. Generate Permalinks (If Applicable)
For main branch commits:
```
https://github.com/{owner}/{repo}/blob/{commit}/{file}#L{line}
```

### 7. Refine If Needed

If initial search is insufficient:
1. **Expand scope**: component → module → system-wide
2. **Try alternate keywords**: synonyms, related terms, different naming conventions
3. **Spawn additional agents** for newly discovered areas
4. **Report gaps honestly**: don't over-promise, note areas needing more investigation

## Agent Quick Reference

See [references/](references/) for full agent specs:
- [codebase-locator.md](references/codebase-locator.md) - File discovery
- [codebase-analyzer.md](references/codebase-analyzer.md) - Implementation analysis
- [codebase-pattern-finder.md](references/codebase-pattern-finder.md) - Pattern/example finding
- [bug-tracer.md](references/bug-tracer.md) - Bug/error investigation
- [web-search-researcher.md](references/web-search-researcher.md) - External research

### Category Protocols
- [feature-research.md](references/feature-research.md) - 8-phase feature investigation
- [bug-research.md](references/bug-research.md) - 6-phase bug investigation (5 Whys, blast radius)
- [codebase-exploration.md](references/codebase-exploration.md) - 5-phase codebase understanding
- [academic-research.md](references/academic-research.md) - 5-phase domain/concept research

## Guidelines

- **Pyramid first**: Verdict + 3 key bullets above the fold, details in appendix
- **Always parallel**: Run independent agents concurrently
- **File:line precision**: Every claim needs a code reference
- **Skip empty sections**: Never output template headers with no content
- **Actionable**: For bugs, provide fix suggestions with locations
- **Complete**: Wait for ALL agents before synthesizing

### Behavioral Guardrails (apply throughout research)

- **State assumptions, don't bury them.** Every silent inference (terminology, scope, file-naming convention, "which X they meant") is a hidden risk. Surface them in §1a *before* searching, and list any unverified ones in the final "Assumptions Made" section.
- **Present interpretations, don't pick silently.** If the query has more than one valid reading, present them and ask — don't guess one and execute.
- **Push back on overcomplicated framings.** If the user asks for a deep system trace and the answer is a single config line, say so plainly. Don't perform work just because it was requested.
- **Investigate surgically.** Answer what was asked. If you stumble onto adjacent issues, *note* them in "Next Steps" — don't quietly expand scope into them.
- **Verifiable findings for bugs.** A diagnosed root cause needs a reproducer (test, command, exact input). Without one, lower the confidence and say so. "Confidence: High" with no reproducer is a guess dressed up.
