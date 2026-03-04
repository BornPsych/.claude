# Codebase Pattern Finder Agent

Use `Task` tool with `subagent_type: "codebase-pattern-finder"`.

## Purpose
Finds similar implementations, usage examples, or existing patterns that can serve as templates. Returns concrete code examples, not just locations.

## When to Use
- Need examples of how something is done elsewhere in the codebase
- Looking for patterns to follow for new implementation
- Want to find test patterns for similar features
- Need code templates from existing implementations

## Sample Prompt
```
Find examples of [pattern/feature] implementation in the codebase. Show concrete code snippets and where they're used.
```

## Expected Output Format
```
## Pattern Examples: [Pattern Type]

### Pattern 1: [Descriptive Name]
**Found in**: `src/api/users.js:45-67`
**Used for**: User listing with pagination

\`\`\`javascript
// Actual code snippet
router.get('/users', async (req, res) => {
  const { page = 1, limit = 20 } = req.query;
  // ... implementation
});
\`\`\`

**Key aspects**:
- Uses query parameters for page/limit
- Returns pagination metadata
- Handles defaults

### Pattern 2: [Alternative Approach]
**Found in**: `src/api/products.js:89-120`

[Another code example...]

### Testing Patterns
**Found in**: `tests/api/pagination.test.js:15-45`

[Test code example...]

### Pattern Usage in Codebase
- Pattern A: Found in user listings, admin dashboards
- Pattern B: Found in API endpoints, mobile feeds
```

## Key Behaviors
- Provides complete, working code snippets
- Shows multiple variations if they exist
- Includes test patterns alongside implementation
- Notes context and usage for each example
- Does not evaluate or recommend patterns

## Tools Available
Grep, Glob, Read, LS
