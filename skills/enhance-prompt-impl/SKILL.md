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

If intent or domain is genuinely ambiguous (e.g., "make this prompt better" with no context, or a prompt that could target code OR prose), ask the user via `AskUserQuestion` with 2–4 concrete options before enhancing. Do not silently pick an interpretation — a wrong guess wastes the whole enhancement.

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

#### Coding Behavior Lens (For Code Generation / Refactor / Bug-Fix Prompts)

When the prompt will produce code, ALWAYS bake in these guardrails. They reduce the four most common LLM coding failures: silent assumptions, overcomplication, scope creep, and "make it work" success criteria.

```xml
<constraints>
1. Think before coding. State your assumptions explicitly before writing code.
   If the request has multiple valid interpretations, ask the user via the
   AskUserQuestion tool — do not pick silently. If something is unclear, stop
   and name what's confusing, then ask.

2. Simplicity first. Write the minimum code that solves the problem.
   - No features, abstractions, or configurability that weren't asked for.
   - No error handling for scenarios that can't actually happen.
   - If you write 200 lines and it could be 50, rewrite it.

3. Surgical changes. Every changed line must trace to the request.
   - Don't refactor, reformat, or "improve" adjacent code.
   - Match existing style even if you'd write it differently.
   - Clean up only orphans YOUR change creates — leave pre-existing dead code alone.

4. Goal-driven execution. Treat success as a checkable criterion (see below),
   not "make it work". Loop until the criterion is met.
</constraints>

<clarification_protocol>
Before coding, if ANY of the following are true, ask the user via AskUserQuestion
rather than guessing:
- The request has more than one valid interpretation.
- A required input (language, file path, expected shape, constraint) is missing
  and cannot be inferred safely.
- The simplest solution conflicts with something stated in the prompt.

Phrase questions as 2–4 concrete options the user can pick from, with one
recommended. Do not ask open-ended questions when a multiple-choice will do.
</clarification_protocol>

<success_criteria>
[Concrete and checkable — e.g., "test file X passes", "running `Y` outputs Z",
"endpoint /foo returns 200 with body matching schema". NOT "works correctly".]
</success_criteria>
```

**When to include**: any prompt that asks for code (new code, edits, refactors, bug fixes, migrations). Skip for pure-explanation prompts or non-code tasks.

### 4. Apply Quality Checks

Before outputting, verify:
- [ ] **Clarity**: Is every instruction unambiguous?
- [ ] **Completeness**: Is all needed context provided?
- [ ] **Structure**: Are sections logically organized?
- [ ] **Specificity**: Are success criteria measurable?
- [ ] **Gaps marked**: Use `_____` for missing info

**For coding prompts, additionally verify:**
- [ ] **Behavior lens applied**: `<constraints>` block included (assumptions, simplicity, surgical changes, goal-driven)
- [ ] **Verifiable success**: success defined as a test/command/observable behavior — not "works correctly" or "make it work"
- [ ] **Surgical scope**: edit/refactor prompts state the change boundary explicitly (which files, which behavior — and what's off-limits)
- [ ] **Ask-don't-guess**: the model is told to use `AskUserQuestion` (with concrete options) when interpretation is ambiguous or required input is missing — not to silently guess

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
- [references/clarification.md](references/clarification.md) - 5 recurring ambiguity patterns with worked `AskUserQuestion` option sets (behavior tradeoffs, migration, display, scope/duplication, onboarding UX)

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
**Enhanced** (note the `<constraints>` and `<clarification_protocol>` blocks — included because this is a coding prompt):
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

<constraints>
1. State your assumptions about language, input source, and JSON structure
   before writing code. If any of the three are still `_____`, ask via
   AskUserQuestion with concrete options — don't pick silently.
2. Write the minimum code that parses the documented structure. No generic
   "flexible" parser, no support for shapes that weren't specified.
3. Surgical scope: produce only the parser and its usage example. Do not add
   unrelated utilities, config loaders, or schema validators unless asked.
4. Success = the usage example runs and produces the documented output for
   one valid input and one malformed input.
</constraints>

<clarification_protocol>
Before writing code, if Language / Input source / JSON structure is unspecified,
ask the user via AskUserQuestion. Phrase as multiple-choice with a recommended
default. Example: "Which language?" → [Python (Recommended), TypeScript, Go].
Do not proceed until the gaps are filled or explicitly waived.
</clarification_protocol>

<success_criteria>
- Given a valid input matching the structure above, the function returns the parsed object.
- Given a malformed input, the function raises/returns the documented error — does not crash.
</success_criteria>

<output_format>
Provide:
1. Assumptions made (or questions if input is still ambiguous)
2. The implementation code
3. Brief usage example showing both a valid and a malformed input
</output_format>
```
