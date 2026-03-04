# Prompt Anti-Patterns

Common mistakes to avoid when enhancing prompts.

---

## Vagueness

### ❌ Bad
```
Make this better
```

### ✅ Good
```xml
<task>Improve this code for readability</task>

<improvements_needed>
- Add descriptive variable names
- Extract complex logic into named functions
- Add docstrings to public methods
- Remove dead code
</improvements_needed>
```

**Why it fails**: "Better" is subjective and undefined. The model doesn't know what dimension to optimize.

---

## Information Overload

### ❌ Bad
```
Here's everything about our company, all our products, our history since 1985,
every policy we have, the complete employee handbook, and now I need you to
write a tweet about our new product launch.
```

### ✅ Good
```xml
<task>Write a tweet announcing our new product</task>

<product>
- Name: CloudSync Pro
- Key feature: Real-time collaboration
- Target audience: Remote teams
</product>

<brand_voice>
Professional but friendly, innovative
</brand_voice>

<constraints>
- 280 characters max
- Include product name
- No hashtags
</constraints>
```

**Why it fails**: Irrelevant context confuses the model and wastes tokens.

---

## Conflicting Instructions

### ❌ Bad
```
Write a detailed technical explanation. Keep it brief.
Be creative. Follow the template exactly.
Use casual language. This is for executives.
```

### ✅ Good
```xml
<task>Write a technical explanation for executives</task>

<requirements>
- Length: 200-300 words (executive summary length)
- Tone: Professional, accessible
- Technical depth: High-level concepts, no implementation details
- Structure: Follow the template below
</requirements>
```

**Why it fails**: Contradictory instructions force the model to guess which to prioritize.

---

## Missing Context

### ❌ Bad
```
Fix the bug in the function
```

### ✅ Good
```xml
<task>Fix the bug in this function</task>

<code>
[actual code here]
</code>

<bug_description>
- Expected: Returns user object when ID exists
- Actual: Returns null even for valid IDs
- Error message: [if any]
</bug_description>

<environment>
Python 3.11, SQLAlchemy 2.0
</environment>
```

**Why it fails**: Without seeing the code and understanding the bug, no fix is possible.

---

## Ambiguous Pronouns

### ❌ Bad
```
Compare React and Vue. Which one is better? Use it for my project.
It should have good performance. Make sure it works with the other thing.
```

### ✅ Good
```xml
<task>Recommend a frontend framework for my project</task>

<options>React, Vue</options>

<project_requirements>
- E-commerce site with ~50 pages
- Must integrate with existing Django backend
- Team has React experience
- Performance critical for product pages
</project_requirements>

<evaluation_criteria>
1. Learning curve given team experience
2. Performance for large product catalogs
3. Django integration ease
</evaluation_criteria>
```

**Why it fails**: "It," "the other thing," and unclear references create ambiguity.

---

## Negative Framing

### ❌ Bad
```
Don't use complicated words.
Don't make it too long.
Don't forget the examples.
Don't use passive voice.
```

### ✅ Good
```xml
<style_requirements>
- Use simple, clear vocabulary (8th grade reading level)
- Keep under 500 words
- Include 2-3 concrete examples
- Use active voice throughout
</style_requirements>
```

**Why it fails**: The model focuses on what not to do instead of what to do. Positive instructions are clearer.

---

## Implicit Assumptions

### ❌ Bad
```
Write the email
```

### ✅ Good
```xml
<task>Write a follow-up email to a job interview</task>

<context>
- Interview was yesterday for Senior Engineer role
- Met with hiring manager Sarah and two team members
- Discussion topics: System design, team culture, growth plans
- I expressed interest in the infrastructure projects
</context>

<email_requirements>
- Thank them for their time
- Reinforce interest in the role
- Reference specific discussion point
- Professional but warm tone
- 150-200 words
</email_requirements>
```

**Why it fails**: The model cannot read minds. Context that seems "obvious" must be stated.

---

## Asking for Impossible Precision

### ❌ Bad
```
Predict exactly how the stock market will move tomorrow.
Tell me exactly what users will think of this design.
Calculate the precise ROI of this marketing campaign.
```

### ✅ Good
```xml
<task>Analyze potential market scenarios for tomorrow</task>

<context>
[Relevant market data and news]
</context>

<output_format>
Provide:
1. 2-3 possible scenarios with reasoning
2. Key factors that could drive each scenario
3. Confidence level for each (with caveats)
4. What signals to watch
</output_format>

<disclaimer>
Acknowledge this is analysis, not prediction.
Include appropriate uncertainty statements.
</disclaimer>
```

**Why it fails**: Asking for certainty on inherently uncertain topics produces false confidence.

---

## Format-Content Mismatch

### ❌ Bad
```
Give me a detailed analysis in a tweet.
Write a comprehensive guide in one paragraph.
Explain quantum physics simply but include all the math.
```

### ✅ Good
```xml
<task>Create a thread explaining quantum physics basics</task>

<format>
- Twitter thread format (280 chars per tweet)
- 5-7 tweets total
- Use analogies instead of math
- Each tweet should stand alone but connect
</format>

<audience>
Curious non-scientists, no physics background
</audience>
```

**Why it fails**: The format constrains what content is possible. Match them appropriately.

---

## Skipping Success Criteria

### ❌ Bad
```
Write a good product description
```

### ✅ Good
```xml
<task>Write a product description for our new headphones</task>

<success_criteria>
A good description will:
- [ ] Lead with the primary benefit (noise cancellation)
- [ ] Include 3-5 key features with benefits
- [ ] Address target audience pain points (commuters)
- [ ] End with clear call-to-action
- [ ] Be 150-200 words
- [ ] Use sensory language
</success_criteria>
```

**Why it fails**: "Good" is undefined. Explicit criteria enable evaluation.

---

## One-Size-Fits-All

### ❌ Bad
Using the same prompt template for every task regardless of complexity or domain.

### ✅ Good
Match prompt complexity to task complexity:

**Simple task** → Simple prompt:
```
Translate to Spanish: "Hello, how are you?"
```

**Complex task** → Structured prompt:
```xml
<task>Translate this legal document to Spanish</task>
<requirements>
- Maintain legal terminology precision
- Flag terms with no direct translation
- Preserve document structure
- Note regional variations (Spain vs Latin America)
</requirements>
```

**Why it fails**: Over-engineering simple tasks wastes effort; under-engineering complex tasks produces poor results.
