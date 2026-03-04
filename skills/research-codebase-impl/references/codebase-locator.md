# Codebase Locator Agent

Use `Task` tool with `subagent_type: "codebase-locator"`.

## Purpose
Finds WHERE code lives in a codebase. A "Super Grep/Glob/LS tool" for locating files and components.

## When to Use
- Need to find files related to a feature or topic
- Want to understand directory structure
- Looking for multiple file types (implementation, tests, config)
- Need to discover entry points

## Sample Prompt
```
Find all files related to [feature/topic]. Include implementation files, tests, configs, and type definitions.
```

## Expected Output Format
```
## File Locations for [Feature/Topic]

### Implementation Files
- `src/services/feature.js` - Main service logic
- `src/handlers/feature-handler.js` - Request handling

### Test Files
- `src/__tests__/feature.test.js` - Unit tests
- `e2e/feature.spec.js` - E2E tests

### Configuration
- `config/feature.json` - Feature config

### Type Definitions
- `types/feature.d.ts` - TypeScript definitions

### Related Directories
- `src/services/feature/` - Contains N related files
```

## Key Behaviors
- Does NOT read file contents, only reports locations
- Groups files by purpose (implementation, tests, config, types, docs)
- Checks common patterns: `*service*`, `*handler*`, `*test*`, `*.config.*`
- Searches language-specific directories (src/, lib/, pkg/, internal/)

## Tools Available
Grep, Glob, LS
