---
name: catch-up-impl
description: ONBOARD to codebase - understand recent commits, project structure, folder organization, development patterns. Triggers - "catch me up", "what's happening", "onboard me", "project overview". For context gathering and understanding progress. (user)
allowed-tools: Read, Grep, Glob, Bash, Task, WebFetch
---

# Catch Up - Codebase Onboarding

Rapid onboarding tool for understanding codebase state, recent progress, and project organization.

## Invocation

```
/catch-up [commit_count]
```

- Default: 20 commits
- Optional: specify number (e.g., `/catch-up 40`)

## Workflow

### Phase 1: Gather Git Context

Run these in parallel:

```bash
# Recent commits with stats
git log --oneline --stat -n {count}

# Contributors in recent commits
git shortlog -sn --no-merges -n {count}

# Current branch info
git branch -vv

# Recent tags/releases
git tag --sort=-creatordate | head -5
```

### Phase 2: Analyze Commit Patterns

Group commits by:
1. **Feature work** - new functionality, enhancements
2. **Bug fixes** - corrections, patches
3. **Refactoring** - cleanup, restructuring
4. **Infra/Config** - CI, deps, config changes
5. **Docs** - documentation updates

Extract:
- Most changed files
- Active areas of development
- Recent focus areas

### Phase 3: Read Project Config

Check these files (if exist):

| File | Purpose |
|------|---------|
| `README.md` | Project overview |
| `CLAUDE.md` | AI-specific context |
| `package.json` / `Cargo.toml` / `pyproject.toml` | Deps & scripts |
| `tsconfig.json` / `biome.json` / `.eslintrc` | Code style |
| `docker-compose.yml` | Services |
| `.env.example` | Env vars needed |

### Phase 4: Map Directory Structure

Use `Glob` to identify:
- Source code locations (`src/`, `lib/`, `app/`)
- Test locations (`test/`, `__tests__/`, `*.test.*`)
- Config locations
- Build outputs

Create mental map of:
```
project/
├── [entry points]
├── [core logic]
├── [utilities]
├── [tests]
└── [config]
```

### Phase 5: Identify Key Patterns

Look for:
- API routes/endpoints
- Database models
- Component structure
- State management
- Authentication patterns

### Phase 6: Spawn Sub-Agents (if needed)

For deeper analysis, spawn parallel agents:

```
Task(subagent_type="Explore", prompt="Find main entry points and API routes")
Task(subagent_type="Explore", prompt="Identify database models and schema")
Task(subagent_type="Explore", prompt="Find test patterns and coverage")
```

## Output Format (Pyramid Style)

```markdown
## Catch-Up: {project_name}
**Branch**: {current_branch} | **Commits**: {count} | **Generated**: {date}

### What's Happening (30-second summary)
1. **[Biggest theme]** — {description} ({X commits})
2. **[Second theme]** — {description} ({X commits})
3. **[Third theme]** — {description} ({X commits})

### Current State
- **In progress**: {what's actively being worked on}
- **Recently shipped**: {what just landed}
- **Next up**: {inferred next steps}

### Quick Start
```bash
{dev command}     # start dev
{test command}    # run tests
```

### Key Entry Points
1. **Main App**: `{file:line}` — {description}
2. **API Routes**: `{folder}` — {pattern}
3. **DB Models**: `{file}` — {tables/models}

---
## Deep Dives

### Active Areas
| Area | Files Changed | Nature of Changes |
|------|---------------|-------------------|
| {area1} | {count} | {what's happening} |
| {area2} | {count} | {what's happening} |

### Recent Contributors
- {name}: {focus areas}

### Project Structure
```
{directory tree with descriptions}
```

### Folder Guide
| Folder | Purpose | Key Files |
|--------|---------|-----------|
| `src/` | {what lives here} | `{important files}` |
| `lib/` | {what lives here} | `{important files}` |

### Tech Stack
| Category | Technology |
|----------|------------|
| Framework | {framework} |
| Database | {db} |
| Testing | {test framework} |

### All Development Commands
```bash
# Start dev
{command}

# Run tests
{command}

# Build
{command}

# Lint
{command}
```
```

## Guidelines

- **Be concise**: Dense info, minimal fluff
- **Prioritize recent**: Focus on what's actively changing
- **Practical output**: Include runnable commands
- **File references**: Always include `file:line` for code refs
- **Patterns over exhaustive lists**: Identify patterns, don't list everything

## Customization

Based on commit count:
- **10-20**: Quick status check
- **30-50**: Medium onboarding
- **50+**: Deep historical context

## Error Handling

If not a git repo:
- Skip commit analysis
- Focus on structure and config files
- Note limitation in output
