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

**If auto-classified:** State the classification (e.g., "This looks like a **Bug Research** query.") and ask output format only:
```
AskUserQuestion({
  questions: [{
    question: "Where should I output the research results?",
    header: "Output",
    options: [
      { label: "MD File", description: "Save full report to a .md file in .claude/" },
      { label: "Terminal", description: "Print full report directly in the conversation" },
      { label: "Both", description: "Save full report to .md file + print summary in terminal" }
    ],
    multiSelect: false
  }]
})
```

**If ambiguous:** Use `AskUserQuestion` to prompt both classification AND output format:
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
  }, {
    question: "Where should I output the research results?",
    header: "Output",
    options: [
      { label: "MD File", description: "Save full report to a .md file in .claude/" },
      { label: "Terminal", description: "Print full report directly in the conversation" },
      { label: "Both", description: "Save full report to .md file + print summary in terminal" }
    ],
    multiSelect: false
  }]
})
```

### Output Format Handling

**This question is mandatory — always ask before starting research.**

- **MD File**: Write the full report to `.claude/<topic>-research-<date>-<time-IST>.md` in the current directory. Print only the file path in the terminal.
- **Terminal**: Print the full report directly in the conversation. Do not create a file.
- **Both**: Write the full report to `.claude/<topic>-research-<date>-<time-IST>.md` AND print a concise summary (key findings, recommendation, next steps) + file path in the terminal.

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

### 5. Synthesize Findings

Structure output based on query type:

**For Bugs/Problems:**
```markdown
## Problem Analysis: [Issue]

### Confidence: [High/Medium/Low]
- High: Direct evidence with file:line refs
- Medium: Inferred from patterns, needs verification
- Low: Speculation based on naming/structure

### Root Cause
[What's causing the issue with file:line refs]

### Evidence
- `file.ts:45` - [What was found]
- `other.ts:123` - [Related code]

### Data Flow
1. Request enters at `api/route.ts:12`
2. Processed by `service.ts:34`
3. Fails at `handler.ts:56` because [reason]

### Potential Fixes
1. [Fix option 1 with code location]
2. [Fix option 2 with trade-offs]

### Related Code
- Similar patterns at `other/file.ts:78`
- Tests at `__tests__/file.test.ts:90`

### Next Steps
- [ ] [Suggested follow-up investigation]
- [ ] [Areas needing human verification]
- [ ] [Tests to run or write]
```

**For Understanding Queries:**
```markdown
## Research: [Topic]

### Confidence: [High/Medium/Low]
- High: Read and traced actual code
- Medium: Inferred from patterns/naming
- Low: Based on limited evidence

### Summary
[High-level explanation]

### How It Works
1. [Step 1] (`file:line`)
2. [Step 2] (`file:line`)

### Key Components
- `component.ts` - [Purpose]
- `helper.ts` - [Purpose]

### Architecture
[Patterns, design decisions found]

### Code References
- `path/file.ts:123` - [Description]

### Next Steps
- [ ] [Deeper areas to explore]
- [ ] [Related systems to investigate]
- [ ] [Questions for domain experts]
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

- **Always parallel**: Run independent agents concurrently
- **File:line precision**: Every claim needs a code reference
- **Query-driven**: Tailor output format to query type
- **Actionable**: For bugs, provide fix suggestions with locations
- **Complete**: Wait for ALL agents before synthesizing
