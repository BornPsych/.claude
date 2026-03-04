# Domain-Specific Prompt Patterns

Templates optimized for specific domains.

---

## Code Generation

```xml
<task>Write [language] code to [objective]</task>

<context>
- Language/Framework: [specify]
- Environment: [node version, python version, etc.]
- Dependencies available: [list or "standard library only"]
- Existing code context: [if integrating with existing code]
</context>

<requirements>
- Follow [style guide/conventions]
- Include error handling for [specific cases]
- Optimize for [readability/performance/memory]
- Add [type hints/docstrings/comments] as appropriate
</requirements>

<constraints>
- Do NOT use [deprecated APIs/specific libraries]
- Must be compatible with [versions/environments]
- Maximum complexity: [if applicable]
</constraints>

<output_format>
1. Implementation with inline comments for complex logic
2. Brief usage example
3. Note any assumptions made
</output_format>
```

---

## Code Review

```xml
<task>Review this code for [quality/security/performance]</task>

<code>
[code to review]
</code>

<review_focus>
- [ ] Logic correctness
- [ ] Error handling
- [ ] Security vulnerabilities
- [ ] Performance issues
- [ ] Code style/readability
- [ ] Test coverage gaps
</review_focus>

<output_format>
## Summary
[1-2 sentence overall assessment]

## Issues Found
### Critical
- [Issue]: [Location] - [Why it matters] - [Suggested fix]

### Improvements
- [Suggestion]: [Location] - [Benefit]

## Positive Aspects
- [What's done well]
</output_format>
```

---

## Technical Writing

```xml
<task>Write [documentation type] for [subject]</task>

<context>
- Audience: [developer/end-user/mixed]
- Technical level: [beginner/intermediate/expert]
- Format: [README/API docs/tutorial/guide]
</context>

<content_requirements>
- Cover: [specific topics to include]
- Tone: [formal/conversational/technical]
- Include: [examples/diagrams/code snippets]
</content_requirements>

<structure>
1. [Section 1 requirement]
2. [Section 2 requirement]
3. [Section 3 requirement]
</structure>

<output_format>
Use markdown with:
- Clear headings hierarchy
- Code blocks with language tags
- Bullet points for lists
- Tables for comparisons
</output_format>
```

---

## Data Analysis

```xml
<task>Analyze [data type] to [objective]</task>

<data>
[data or data description]
</data>

<analysis_requirements>
- Identify: [patterns/trends/anomalies]
- Calculate: [specific metrics]
- Compare: [dimensions to compare]
- Visualize: [chart types if applicable]
</analysis_requirements>

<context>
- Domain: [business context]
- Time period: [if relevant]
- Known constraints: [data limitations]
</context>

<output_format>
## Key Findings
[Top 3-5 insights]

## Detailed Analysis
[Section per analysis dimension]

## Recommendations
[Actionable next steps]

## Methodology Notes
[How analysis was conducted]
</output_format>
```

---

## Creative Writing

```xml
<task>Write [content type] about [subject]</task>

<specifications>
- Length: [word count/pages]
- Tone: [serious/humorous/inspirational/etc.]
- Style: [descriptive/concise/poetic/etc.]
- Audience: [target reader]
</specifications>

<content_guidance>
- Theme: [central theme or message]
- Include: [elements to incorporate]
- Avoid: [elements to exclude]
- Inspiration: [reference works or styles]
</content_guidance>

<constraints>
- Must include: [required elements]
- Must avoid: [prohibited content]
- Format: [structure requirements]
</constraints>
```

---

## Problem Solving / Debugging

```xml
<task>Debug/solve [problem description]</task>

<problem>
[Detailed problem description]
</problem>

<context>
- Environment: [system/framework/language]
- Error messages: [exact errors if any]
- What was tried: [previous attempts]
- Expected behavior: [what should happen]
- Actual behavior: [what happens instead]
</context>

<constraints>
- Cannot change: [fixed elements]
- Must preserve: [requirements]
</constraints>

<output_format>
## Root Cause
[What's causing the issue]

## Solution
[Step-by-step fix]

## Explanation
[Why this works]

## Prevention
[How to avoid in future]
</output_format>
```

---

## Comparison / Decision Making

```xml
<task>Compare [options] for [use case]</task>

<options>
1. [Option A]
2. [Option B]
3. [Option C - if applicable]
</options>

<evaluation_criteria>
- [Criterion 1]: weight [high/medium/low]
- [Criterion 2]: weight [high/medium/low]
- [Criterion 3]: weight [high/medium/low]
</evaluation_criteria>

<context>
- Use case: [specific scenario]
- Constraints: [budget/time/technical]
- Priorities: [what matters most]
</context>

<output_format>
## Quick Recommendation
[1-sentence recommendation]

## Comparison Matrix
| Criterion | Option A | Option B | Option C |
|-----------|----------|----------|----------|
| [Crit 1]  | [score]  | [score]  | [score]  |

## Detailed Analysis
[Per-option breakdown]

## Recommendation
[Final recommendation with reasoning]
</output_format>
```

---

## Summarization

```xml
<task>Summarize [content type]</task>

<content>
[content to summarize]
</content>

<requirements>
- Length: [word limit or format]
- Focus: [what to emphasize]
- Audience: [who will read this]
- Purpose: [why summarizing]
</requirements>

<output_format>
- Format: [bullet points/paragraphs/executive summary]
- Include: [quotes/statistics/key terms]
- Structure: [chronological/thematic/importance]
</output_format>
```
