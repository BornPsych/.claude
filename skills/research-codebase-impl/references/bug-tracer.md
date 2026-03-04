# Bug Tracer Agent

Use `Task` tool with `subagent_type: "bug-tracer"`.

## Purpose
Investigates bugs, errors, and problems by tracing data flow, identifying failure points, and finding root causes with precise code references.

## When to Use
- User reports a bug or error
- Stack trace needs investigation
- Data flow issue needs tracing
- Performance problem needs analysis
- Unexpected behavior needs explanation

## Sample Prompts

**For error investigation:**
```
Trace why [function] returns null when [condition]. Start from [entry point] and follow the data flow.
```

**For stack trace analysis:**
```
Investigate this error: [error message]. The stack trace shows [file:line]. Find what causes this and trace back to the source.
```

**For data flow issues:**
```
Trace how data flows from [input] to [output]. Identify where [problem] occurs.
```

## Expected Output Format
```
## Bug Investigation: [Issue Summary]

### Error/Symptom
[What's failing and how it manifests]

### Traced Execution Path
1. Entry: `api/handler.ts:23` - Request received
2. Validation: `validators/input.ts:45` - Passes validation
3. Processing: `services/processor.ts:67` - Data transformed
4. **FAILURE**: `db/query.ts:89` - Query returns null
5. Return: `api/handler.ts:34` - Null propagates up

### Root Cause
**Location**: `db/query.ts:89-95`
**Issue**: [Specific problem identified]
**Evidence**:
\`\`\`typescript
// Line 89-95: The problematic code
const result = await db.find({ id }); // Missing null check
return result.data; // Fails when result is null
\`\`\`

### Contributing Factors
- `services/processor.ts:45` - No validation before DB call
- `types/index.ts:12` - Type allows undefined but not handled

### Data State at Failure
- Input: [What was passed in]
- Expected: [What should happen]
- Actual: [What happened]

### Suggested Fixes
1. **Quick fix** (`db/query.ts:89`): Add null check before access
2. **Proper fix** (`services/processor.ts:45`): Validate input earlier
3. **Defensive** (`api/handler.ts:23`): Add try-catch with proper error

### Related Code
- Similar pattern at `other/query.ts:34` (handles null correctly)
- Test coverage at `__tests__/query.test.ts:56`
```

## Investigation Strategy

### For Errors:
1. Parse error message and stack trace
2. Start at the failure point
3. Trace backwards to find source
4. Trace forwards to understand impact
5. Find similar patterns (working vs broken)

### For Performance:
1. Identify slow operation
2. Trace data volume at each step
3. Look for N+1 queries, loops, blocking calls
4. Find caching opportunities

### For Data Issues:
1. Identify expected vs actual data
2. Trace transformations step-by-step
3. Find where data changes unexpectedly
4. Check validation/sanitization points

## Key Behaviors
- Always provides file:line references
- Traces both success and failure paths
- Identifies not just WHAT failed but WHY
- Suggests actionable fixes with locations
- Finds similar working patterns for comparison

## Tools Available
Read, Grep, Glob, LS
