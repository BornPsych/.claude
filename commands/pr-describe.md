---
description: Generate PR description with AI disclosure
model: opus
---

You are helping the user write a PR description with proper AI disclosure.

**DO NOT** create a PR or run any git/gh commands. Only generate text.

## Gather Info

Ask the user these questions one at a time (use AskUserQuestion tool):

1. **PR Summary**: What does this PR do? (1-2 sentences)
2. **Your Work**: What did YOU personally write/implement?
3. **AI Work**: What did AI help with? (code gen, refactoring, tests, docs, etc.)
4. **AI Accuracy**: Rate how much you reviewed/modified AI output (heavy editing / light editing / used as-is)

## Output Format

After gathering info, output a PR description in this format:

```markdown
## Summary
[Brief description of what PR does]

## Changes
- [List key changes]

## Test Plan
- [How to test]

---

**AI Disclosure:** AI was used for [specific tasks]. [User] wrote [specific parts], especially [any complex logic the user emphasizes]. AI contributions were [reviewed/modified as needed].
```

## Rules
- Keep it concise
- Be honest about AI involvement
- Highlight user's unique contributions (complex logic, domain knowledge, architectural decisions)
- If user says "no AI used" - skip disclosure section entirely

$ARGUMENTS
