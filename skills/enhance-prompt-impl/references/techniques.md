# Advanced Prompting Techniques

Techniques for complex or specialized prompts.

---

## Chain-of-Thought (CoT)

**When to use**: Reasoning, math, logic, multi-step problems

**Pattern**:
```xml
<instructions>
Think through this step-by-step:

1. First, identify the key information
2. Then, determine what approach to use
3. Next, work through the solution
4. Finally, verify your answer

Show your complete reasoning process before giving the final answer.
</instructions>
```

**Variant - Structured CoT**:
```xml
<thinking_structure>
## Understanding
[Restate the problem in your own words]

## Approach
[Explain your strategy]

## Execution
[Show work step-by-step]

## Verification
[Check the answer]

## Final Answer
[Clear, concise answer]
</thinking_structure>
```

---

## Few-Shot Learning

**When to use**: Pattern matching, format learning, style imitation

**Pattern**:
```xml
<examples>
<example id="1">
<input>Customer: The product arrived damaged</input>
<output>I sincerely apologize for the damaged product. Let me arrange an immediate replacement and provide a return label for the damaged item. Would you prefer expedited shipping for the replacement?</output>
<reasoning>Acknowledged issue, offered solution, gave options</reasoning>
</example>

<example id="2">
<input>Customer: I was charged twice</input>
<output>I apologize for the billing error. I can see the duplicate charge and have initiated a refund that will appear within 3-5 business days. Is there anything else I can help resolve?</output>
<reasoning>Validated concern, took immediate action, provided timeline</reasoning>
</example>
</examples>

<task>
Now respond to: [new input]
Following the same pattern demonstrated above.
</task>
```

---

## Self-Consistency

**When to use**: High-stakes decisions, when you need confidence

**Pattern**:
```xml
<instructions>
Analyze this problem using three different approaches:

## Approach 1: [Method A]
[Analysis and conclusion]

## Approach 2: [Method B]
[Analysis and conclusion]

## Approach 3: [Method C]
[Analysis and conclusion]

## Synthesis
Compare the results from all approaches. Note where they agree and disagree.
Provide your final answer based on the convergent findings.
</instructions>
```

---

## Persona / Role Assignment

**When to use**: Expertise needed, specific perspective required

**Basic Pattern**:
```xml
<role>
You are a [specific expert type] with [years] of experience in [domain].
Your expertise includes [specific areas].
You are known for [distinctive qualities or approach].
</role>
```

**Advanced Pattern with Constraints**:
```xml
<role>
You are a senior security engineer at a Fortune 500 company.

Your approach:
- Always consider threat modeling first
- Prioritize practical, implementable solutions
- Balance security with usability
- Cite specific frameworks (OWASP, NIST) when relevant

Your communication style:
- Direct and technical with peers
- Clear explanations for non-technical stakeholders
- Always include severity assessments
</role>
```

---

## Output Structuring

**When to use**: Complex outputs, specific format requirements

**JSON Output**:
```xml
<output_format>
Return a JSON object with this exact structure:
{
  "summary": "string - 1-2 sentence overview",
  "items": [
    {
      "name": "string",
      "priority": "high|medium|low",
      "details": "string"
    }
  ],
  "metadata": {
    "confidence": "number 0-1",
    "sources": ["string array"]
  }
}

Return ONLY the JSON, no markdown code blocks or explanation.
</output_format>
```

**Markdown with Sections**:
```xml
<output_format>
Structure your response with these exact sections:

# [Title]

## Executive Summary
[2-3 sentences max]

## Analysis
### [Subtopic 1]
[Content]

### [Subtopic 2]
[Content]

## Recommendations
1. [First recommendation]
2. [Second recommendation]

## Next Steps
- [ ] [Action item 1]
- [ ] [Action item 2]
</output_format>
```

---

## Constraints and Guardrails

**When to use**: Sensitive topics, specific requirements

**Pattern**:
```xml
<constraints>
MUST:
- Stay within [scope]
- Use only [approved sources/methods]
- Include [required elements]

MUST NOT:
- [Prohibited action 1]
- [Prohibited action 2]
- Make claims about [restricted topics]

IF UNCERTAIN:
- State uncertainty explicitly
- Provide caveats
- Suggest verification steps
</constraints>
```

---

## Iterative Refinement

**When to use**: Complex creative work, quality-critical outputs

**Pattern**:
```xml
<instructions>
## Draft Phase
Create an initial version focusing on [core requirement].

## Review Phase
Evaluate the draft against these criteria:
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]

## Refinement Phase
Based on the review, improve:
- [Specific aspect 1]
- [Specific aspect 2]

## Final Output
Present the refined version.
</instructions>
```

---

## Meta-Prompting

**When to use**: When you need the model to design its own approach

**Pattern**:
```xml
<task>
Before answering, design your approach:

1. What type of problem is this?
2. What information do I need to gather?
3. What method or framework applies?
4. What are potential pitfalls?
5. How will I verify my answer?

Then execute your designed approach.
</task>
```

---

## Decomposition

**When to use**: Complex, multi-part tasks

**Pattern**:
```xml
<task>[Complex task description]</task>

<approach>
Break this into subtasks:

### Subtask 1: [Name]
- Goal: [Specific goal]
- Output: [What this produces]

### Subtask 2: [Name]
- Goal: [Specific goal]
- Depends on: [Subtask 1 output]
- Output: [What this produces]

### Subtask 3: [Name]
- Goal: [Specific goal]
- Depends on: [Previous outputs]
- Output: [Final deliverable]

Execute each subtask in order, showing work for each.
</approach>
```
