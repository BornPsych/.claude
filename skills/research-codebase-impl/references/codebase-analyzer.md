# Codebase Analyzer Agent

Use `Task` tool with `subagent_type: "codebase-analyzer"`.

## Purpose
Analyzes HOW code works. Understands implementation details, traces data flow, explains technical workings with precise file:line references.

## When to Use
- Need to understand implementation details of specific files/components
- Want to trace data flow through the system
- Need to identify architectural patterns in use
- Require precise code references for documentation

## Sample Prompt
```
Analyze how [component/feature] works. Trace the data flow from entry to exit, identify key functions and patterns used.
```

## Expected Output Format
```
## Analysis: [Feature/Component]

### Overview
[2-3 sentence summary of how it works]

### Entry Points
- `api/routes.js:45` - POST /endpoint
- `handlers/handler.js:12` - handleRequest() function

### Core Implementation

#### 1. Request Validation (`handlers/handler.js:15-32`)
- Validates input using schema
- Returns 400 if validation fails

#### 2. Data Processing (`services/processor.js:8-45`)
- Transforms data at line 23
- Queues for async processing at line 40

### Data Flow
1. Request arrives at `api/routes.js:45`
2. Routed to `handlers/handler.js:12`
3. Processing at `services/processor.js:8`

### Key Patterns
- **Factory Pattern**: Created via factory at `factories/x.js:20`
- **Repository Pattern**: Data access in `stores/x-store.js`

### Configuration
- Settings from `config/settings.js:5`
- Feature flags at `utils/features.js:23`
```

## Key Behaviors
- Always includes file:line references for all claims
- Reads files thoroughly before making statements
- Traces actual code paths, never assumes
- Focuses on "how" not "what" or "why"
- Documents without critiquing or suggesting improvements

## Tools Available
Read, Grep, Glob, LS
