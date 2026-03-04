# Codebase Exploration Protocol

Category-specific protocol for understanding unfamiliar codebases or specific subsystems: "How does auth work?", "Help me understand the API layer", "What's the architecture?"

## When This Protocol Applies
- Onboarding to a new codebase or module
- Understanding how a subsystem works end-to-end
- Mapping architecture and dependencies
- "Walk me through how X works"

---

## Anti-Hallucination Rules

These rules apply to ALL phases. Borrowed from Trail of Bits audit methodology:
1. **Never speculate** — Every claim must have a `file:line` reference
2. **Mark unknowns** — Use `[UNVERIFIED]` for anything inferred but not confirmed
3. **Update mental model** — When evidence contradicts an assumption, say so explicitly
4. **Distinguish "not found" from "doesn't exist"** — "I didn't find X" ≠ "X doesn't exist"
5. **Quote, don't paraphrase** — When code behavior matters, show the actual code

---

## Phase 1: Initial Orientation

Read these files (if they exist) to build a top-level mental model:

1. `README.md` / `README` — Project purpose, setup, high-level architecture
2. `package.json` / `Cargo.toml` / `go.mod` / `pyproject.toml` — Dependencies, scripts, entry points
3. Top-level directory listing — Module organization

```
Task(subagent_type="Explore", prompt="List the top-level directory structure. Read README and the main package manifest. Identify: project purpose, language/framework, build system, entry points, test framework.")
```

**Produce:** 5-line project summary + tech stack + entry points list.

## Phase 2: Architecture Mapping

Map the high-level architecture:

```
Task(subagent_type="codebase-locator", prompt="Find the main architectural layers: entry points (routes/handlers/CLI), business logic (services/controllers), data layer (models/repositories/queries), and shared utilities. Group by layer.")

Task(subagent_type="codebase-analyzer", prompt="Trace ONE representative request/operation end-to-end: from entry point through business logic to data layer and back. Show the full call chain with file:line refs.")
```

**Produce:**

| Layer | Purpose | Key Files |
|-------|---------|-----------|
| Entry | Routes, handlers, CLI commands | `file:line` |
| Logic | Services, controllers, use cases | `file:line` |
| Data | Models, repositories, queries | `file:line` |
| Shared | Utils, helpers, types, config | `file:line` |

+ One traced request path as a numbered sequence.

## Phase 3: Dependency & Flow Analysis

Map how modules connect:

```
Task(subagent_type="codebase-analyzer", prompt="For [target module/area], identify: (1) What it imports (fan-out), (2) What imports it (fan-in), (3) Key data types passed between modules. Focus on the public API surface.")
```

**Produce:**
- **Fan-out** (what this module depends on): list with purpose
- **Fan-in** (what depends on this module): list of consumers
- **Key data types**: Interfaces/types that cross module boundaries
- **Data flow paths**: How data moves through the system (input → transform → output)

Flag high fan-in modules as **critical coupling points**.

## Phase 4: Pattern Recognition

```
Task(subagent_type="codebase-pattern-finder", prompt="Identify recurring patterns in the codebase: (1) Design patterns (factory, repository, middleware, etc.), (2) Error handling conventions, (3) Test patterns and coverage approach, (4) Naming conventions and code organization rules.")
```

**Produce:**

| Pattern | Where Used | Example |
|---------|-----------|---------|
| [Pattern name] | [Scope] | `file:line` |

Also note:
- Error handling strategy (exceptions? result types? error codes?)
- Logging approach and levels
- Configuration management pattern
- Test organization and conventions

## Phase 5: Deep Module Analysis

**Only if the user scoped to a specific area.** Skip for broad "understand the whole codebase" queries.

```
Task(subagent_type="codebase-analyzer", prompt="Deep-dive into [specific module]. Map: (1) Internal file structure, (2) Public API / exported functions, (3) Internal state management, (4) Error handling specifics, (5) Test coverage and gaps.")
```

**Produce:**
- Module internal structure diagram
- Public API surface (exported functions/classes with signatures)
- Internal state: what's mutable, what's shared
- Coupling assessment: tightly coupled to what? Loosely coupled where?

---

## Output Template

```markdown
## Codebase Exploration: [Area/Topic]

### Confidence: [High/Medium/Low]
- High: Read and traced actual code paths
- Medium: Inferred from patterns and naming
- Low: Limited evidence, marked [UNVERIFIED]

### Project Overview
[5-line summary from Phase 1]

### Tech Stack
- Language: [X]
- Framework: [X]
- Build: [X]
- Test: [X]
- Key deps: [X, Y, Z]

### Architecture
[Layer table from Phase 2]

### Representative Request Trace
1. `file:line` — [Step description]
2. `file:line` — [Step description]
...

### Module Dependencies
[Fan-in/fan-out from Phase 3]

### Patterns & Conventions
[Pattern table from Phase 4]

### [Deep Dive: Module Name] (if applicable)
[Phase 5 results]

### Unknowns & Gaps
- [UNVERIFIED] [Things inferred but not confirmed]
- [NOT FOUND] [Things looked for but not located]

### Next Steps
- [ ] [Areas worth deeper investigation]
- [ ] [Questions for the team/maintainers]
```
