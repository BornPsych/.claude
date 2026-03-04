# Planning Agents Reference

Agents to use during the planning research phase.

## Agent Overview

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| `codebase-locator` | Find files | Discovering WHERE code lives |
| `codebase-analyzer` | Understand code | Learning HOW code works |
| `codebase-pattern-finder` | Find examples | Finding patterns to follow |
| `web-search-researcher` | External docs | Library docs, best practices |

---

## codebase-locator

**Purpose**: Finds WHERE code lives in the codebase.

**Use When**:
- Starting research on a new area
- Need to discover all related files
- Finding tests, configs, types for a feature

**Sample Prompt**:
```
Find all files related to [feature/component]. Include:
- Implementation files
- Test files
- Configuration
- Type definitions
```

**Expected Output**:
```
## File Locations for [Feature]

### Implementation Files
- `src/services/auth.ts` - Main auth logic
- `src/handlers/login.ts` - Login handler

### Test Files
- `src/__tests__/auth.test.ts` - Unit tests

### Configuration
- `config/auth.json` - Auth settings
```

---

## codebase-analyzer

**Purpose**: Understands HOW code works with precise references.

**Use When**:
- Need to understand implementation details
- Tracing data flow
- Identifying patterns in use

**Sample Prompt**:
```
Analyze how [component] works. Trace the data flow from entry point to output. Include file:line references for all key functions.
```

**Expected Output**:
```
## Analysis: [Component]

### Entry Points
- `api/routes.ts:45` - POST /login endpoint

### Core Implementation
1. Request validation (`handlers/login.ts:15-32`)
2. Auth check (`services/auth.ts:67-89`)
3. Token generation (`utils/jwt.ts:23-45`)

### Data Flow
1. Request → `routes.ts:45`
2. Validate → `handlers/login.ts:15`
3. Authenticate → `services/auth.ts:67`
4. Response → `handlers/login.ts:45`
```

---

## codebase-pattern-finder

**Purpose**: Finds similar implementations to use as templates.

**Use When**:
- Need examples to follow
- Looking for established patterns
- Finding test patterns

**Sample Prompt**:
```
Find examples of [pattern/feature] in the codebase. Show concrete code snippets with file:line references.
```

**Expected Output**:
```
## Pattern Examples: [Pattern]

### Example 1: User Service
**File**: `src/services/user.ts:23-45`
```typescript
// Actual code example
export class UserService {
  async create(data: CreateUserDTO) {
    // ... implementation
  }
}
```

### Example 2: Product Service
**File**: `src/services/product.ts:34-56`
[Similar pattern...]

### Testing Pattern
**File**: `src/__tests__/user.test.ts:12-34`
[Test example...]
```

---

## web-search-researcher

**Purpose**: Researches external documentation and best practices.

**Use When**:
- Need library documentation
- Looking for best practices
- External API integration

**Sample Prompt**:
```
Research [library/topic]. Find:
- Official documentation for [specific feature]
- Best practices for [use case]
- Common pitfalls to avoid
```

**Expected Output**:
```
## Research: [Topic]

### Official Documentation
**Source**: [Link]
- [Key finding 1]
- [Key finding 2]

### Best Practices
- [Practice 1] - [Source]
- [Practice 2] - [Source]

### Pitfalls
- [Pitfall 1] - [How to avoid]
```

---

## Parallel Agent Spawning

For efficient research, spawn multiple agents in parallel:

```python
# Launch concurrently
Task(subagent_type="codebase-locator", prompt="Find auth-related files")
Task(subagent_type="codebase-analyzer", prompt="Analyze current auth flow")
Task(subagent_type="codebase-pattern-finder", prompt="Find middleware patterns")
```

**Important**: Wait for ALL agents to complete before synthesizing findings.
