# Claude-Specific Optimizations

Techniques unique to Claude based on Anthropic's official documentation.

---

## Performance Benchmarks

**Few-Shot Improvements (Anthropic data):**
- Claude 3 Sonnet: 16% → 52% accuracy with just 3 examples
- Claude 3 Haiku: 11% → 75% accuracy with 3 examples

**Takeaway**: Always include 3-5 examples for complex tasks.

---

## XML Tags (Claude's Superpower)

Claude is **specifically trained** to recognize XML tags as semantic boundaries.

**Why it works for Claude:**
- Fine-tuned to pay attention to XML structure
- Eliminates ambiguity in instruction boundaries
- Like functions and scopes in programming

**Best Tag Names:**
```xml
<instructions>   <!-- Task description -->
<context>        <!-- Background info -->
<data>           <!-- Input to process -->
<examples>       <!-- Few-shot examples -->
<constraints>    <!-- Limitations -->
<output_format>  <!-- Expected structure -->
<thinking>       <!-- Reasoning space -->
<answer>         <!-- Final output -->
```

**Referencing Tags:**
```xml
Using the data in <data> tags, analyze according to <instructions>.
```

---

## Prefilling Responses (API Feature)

Start Claude's response to control format and skip preambles.

**JSON Prefill:**
```python
messages=[
    {"role": "user", "content": "Extract info: {{TEXT}}"},
    {"role": "assistant", "content": "{"} # Forces JSON output
]
```

**Result**: Skips "Here's the extracted information..." → outputs pure JSON

**Character Prefill:**
```python
messages=[
    {"role": "user", "content": "What do you deduce?"},
    {"role": "assistant", "content": "[Sherlock Holmes]"}
]
```

**Note**: Prefilling NOT available with extended thinking mode.

---

## Extended Thinking Mode

For complex reasoning tasks, enable extended thinking:

```python
response = client.messages.create(
    model="claude-sonnet-4-5",
    thinking={
        "type": "enabled",
        "budget_tokens": 10000
    },
    messages=[...]
)
```

**Best for:**
- Complex multi-step reasoning
- Mathematical proofs
- Strategic planning
- Deep code analysis

---

## System Prompts vs User Messages

**System Parameter (API):**
```python
client.messages.create(
    model="claude-sonnet-4-5",
    system="You are a senior CFO at a Fortune 500 tech company.",
    messages=[{"role": "user", "content": "Analyze Q2 data..."}]
)
```

**In Prompt (When no API access):**
```xml
<role>
You are a senior CFO at a Fortune 500 tech company.
Your approach emphasizes:
- Risk-adjusted returns
- Cash flow optimization
- Strategic growth opportunities
</role>

<task>
Analyze this Q2 financial data...
</task>
```

---

## Stop Sequences

Control where Claude stops generating:

```python
response = client.messages.create(
    model="claude-sonnet-4-5",
    stop_sequences=["</analysis>", "\n\n---"],
    messages=[...]
)
```

**Use case**: Stop after specific XML tag or delimiter.

---

## Long Context Tips (200K Tokens)

Claude supports up to 200K tokens. Optimize with:

1. **Document Position**: Place long docs at the **beginning**
2. **Query Position**: Put instructions/questions at the **end**
3. **XML Delineation**: Use tags to separate document sections

**Example:**
```xml
<document name="contract_2024">
{{LONG_CONTRACT_TEXT}}
</document>

<document name="amendments">
{{AMENDMENT_TEXT}}
</document>

Based on the documents above, answer:
1. What are the termination conditions?
2. How have they changed in the amendments?
```

---

## Structured Outputs (Tool Use)

For guaranteed JSON schema:

```python
response = client.messages.create(
    model="claude-sonnet-4-5",
    tools=[{
        "name": "record_user",
        "description": "Record user information",
        "input_schema": {
            "type": "object",
            "properties": {
                "name": {"type": "string"},
                "age": {"type": "number"},
                "email": {"type": "string", "format": "email"}
            },
            "required": ["name", "email"]
        }
    }]
)
```

---

## Prompt Chaining Pattern

Anthropic recommends breaking complex tasks:

```
Prompt 1: Extract Data
    ↓
Prompt 2: Validate & Structure
    ↓
Prompt 3: Analyze
    ↓
Prompt 4: Generate Insights
    ↓
Prompt 5: Create Report
```

**Benefits:**
- Each step is focused and testable
- Can cache intermediate results
- Easier to debug failures
- Better accuracy than single mega-prompt

---

## Role Specificity Matters

**Generic role:**
```
You are a data scientist.
```
→ Surface-level analysis

**Specific role:**
```
You are a data scientist specializing in customer insight analysis
for Fortune 500 e-commerce companies. You have 10 years of experience
with cohort analysis and lifetime value modeling.
```
→ Deep, actionable expert insights

---

## Quick Wins Summary

| Technique | Improvement |
|-----------|-------------|
| Add XML tags | +20-30% accuracy |
| Include 3 examples | +30-40% consistency |
| Specific output format | Eliminate parsing errors |
| Prefill for JSON | Skip preambles |
| Specific role | Deep expertise |

---

## Official Resources

- **Prompt Engineering Docs**: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview
- **Interactive Tutorial**: https://github.com/anthropics/prompt-eng-interactive-tutorial
- **Prompt Library**: https://docs.anthropic.com/en/prompt-library/library
