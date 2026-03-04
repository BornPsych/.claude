---
name: enhance-prompt-impl
description: OPTIMIZE prompts for Claude. XML structure, CoT, few-shot examples. Triggers - "improve this prompt", "optimize prompt", "rewrite for better results", "make this prompt better". Invoke with `/enhance-prompt <text>`.
allowed-tools: Read, WebSearch
---

# Enhance Prompt

Transform rough ideas into well-structured, effective prompts using proven techniques.

## Quick Reference

| Mode | When to Use | Output |
|------|-------------|--------|
| **Quick** | Simple tasks, clear intent | Structured with XML tags |
| **Thorough** | Complex tasks, ambiguous input | Full analysis + enhanced prompt |
| **Domain** | Coding, writing, analysis | Domain-optimized patterns |

## Enhancement Workflow

### 1. Analyze Intent
Identify:
- **Task type**: Generation, analysis, transformation, Q&A
- **Domain**: Code, writing, data, general
- **Complexity**: Simple (single step) vs complex (multi-step)
- **Output needs**: Format, length, style requirements

### 2. Select Enhancement Strategy

**Simple tasks** → Quick enhancement:
- Add clear structure with XML tags
- Clarify success criteria
- Output directly

**Complex tasks** → Thorough enhancement:
- Decompose into sub-tasks
- Add chain-of-thought scaffolding
- Include examples if beneficial
- Define output format precisely

**Domain-specific** → Use specialized patterns:
- See [references/patterns.md](references/patterns.md) for domain templates

### 3. Apply Core Techniques

#### XML Structure (Always Apply)
```xml
<task>Primary objective</task>

<context>
Background information the model needs
</context>

<instructions>
Step-by-step guidance
</instructions>

<output_format>
Expected response structure
</output_format>
```

#### Chain-of-Thought (For Reasoning Tasks)
```xml
<instructions>
Think through this step-by-step:
1. First, identify [aspect 1]
2. Then, analyze [aspect 2]
3. Finally, synthesize [conclusion]

Show your reasoning before the final answer.
</instructions>
```

#### Few-Shot Examples (For Pattern Tasks)
```xml
<examples>
<example>
<input>Example input 1</input>
<output>Example output 1</output>
</example>
<example>
<input>Example input 2</input>
<output>Example output 2</output>
</example>
</examples>
```

#### Role Assignment (For Expertise Tasks)
```xml
<role>
You are an expert [domain] specialist with deep knowledge of [specific areas].
Your approach emphasizes [key qualities].
</role>
```

### 4. Apply Quality Checks

Before outputting, verify:
- [ ] **Clarity**: Is every instruction unambiguous?
- [ ] **Completeness**: Is all needed context provided?
- [ ] **Structure**: Are sections logically organized?
- [ ] **Specificity**: Are success criteria measurable?
- [ ] **Gaps marked**: Use `_____` for missing info

## Output Format

**Always output ONLY the enhanced prompt in triple backticks:**

```
[Enhanced prompt here]
```

No explanations, no commentary, no analysis outside the backticks.

## Performance Impact (Anthropic Data)

| Technique | Improvement |
|-----------|-------------|
| Add XML tags | +20-30% accuracy |
| Include 3 examples | +30-40% consistency |
| Specific output format | Eliminate parsing errors |
| Specific role | Deep expertise vs surface-level |

## References

For complex enhancements, see:
- [references/patterns.md](references/patterns.md) - Domain-specific templates (code, writing, analysis)
- [references/techniques.md](references/techniques.md) - Advanced methods (CoT, few-shot, meta-prompting)
- [references/anti-patterns.md](references/anti-patterns.md) - Common mistakes to avoid
- [references/claude-specific.md](references/claude-specific.md) - Claude API optimizations (prefill, extended thinking)

## Quick Examples

**Input**: "summarize this article"
**Enhanced**:
```xml
<task>Summarize the provided article</task>

<article>
_____
</article>

<instructions>
Create a concise summary that:
1. Captures the main thesis in 1-2 sentences
2. Lists 3-5 key points as bullet points
3. Notes any significant conclusions or implications
</instructions>

<output_format>
## Summary
[1-2 sentence thesis]

## Key Points
- [Point 1]
- [Point 2]
- [Point 3]

## Implications
[Brief note on significance]
</output_format>
```

**Input**: "write code to parse json"
**Enhanced**:
```xml
<task>Write code to parse JSON data</task>

<context>
Language: _____
Input source: _____
Expected JSON structure: _____
</context>

<requirements>
- Handle malformed JSON gracefully
- Include error handling
- Add type hints/documentation
</requirements>

<output_format>
Provide:
1. The implementation code
2. Brief usage example
3. Error handling notes
</output_format>
```
