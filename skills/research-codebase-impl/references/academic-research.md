# Academic / Domain Research Protocol

Category-specific protocol for researching topics that are primarily external/conceptual: "Compare Redis vs Memcached", "How does OAuth2 PKCE work?", "Best practices for rate limiting", technology evaluations.

## When This Protocol Applies
- Comparing technologies, libraries, or approaches
- Understanding protocols, standards, or specifications
- Researching best practices or industry patterns
- Domain knowledge questions (security, performance, architecture concepts)
- "How does X work?" where X is a concept, not codebase-specific

---

## Phase 1: Scope & Outline

Before any searching, define the research boundaries:

1. **Core question**: Restate the user's query as a precise question
2. **Sub-questions** (3–5): Break the core question into specific, searchable sub-questions
3. **Scope boundaries**: What's explicitly IN and OUT of scope
4. **Success criteria**: What would a complete answer look like?

Example:
```
Core: "How should we implement rate limiting?"
Sub-questions:
1. What are the standard rate limiting algorithms (token bucket, sliding window, etc.)?
2. Where should rate limiting be applied (API gateway, middleware, application)?
3. What are the trade-offs of each approach for our use case?
4. How do popular frameworks/libraries handle this?
5. What are the operational concerns (distributed state, monitoring)?
```

## Phase 2: Parallel Deep Investigation

Spawn 3–5 `web-search-researcher` agents, one per sub-question:

```
Task(subagent_type="web-search-researcher", prompt="Research: [sub-question 1]. Find official documentation, RFCs, and authoritative technical explanations. Include specific details, not just overviews.")

Task(subagent_type="web-search-researcher", prompt="Research: [sub-question 2]. Find comparative analyses, benchmarks, and real-world case studies. Prioritize sources from 2024-2026.")

Task(subagent_type="web-search-researcher", prompt="Research: [sub-question 3]. Find best practices, common pitfalls, and production lessons learned. Look for conference talks, engineering blog posts from known companies.")
```

**If user's query has codebase relevance** (e.g., "best rate limiter for our Express app"):
```
Task(subagent_type="codebase-pattern-finder", prompt="Find any existing rate limiting, throttling, or similar middleware patterns in the codebase. Check package.json for related dependencies.")
```

## Phase 3: Source Credibility Assessment

Rate each source found:

| Source | Authority | Recency | Relevance | Priority |
|--------|-----------|---------|-----------|----------|
| [Source name + link] | H/M/L | [Date] | H/M/L | 1-5 |

**Priority hierarchy:**
1. Official documentation / specs / RFCs
2. Peer-reviewed papers / formal standards
3. Authoritative engineering blogs (company tech blogs, known experts)
4. Community resources (well-voted SO answers, popular tutorials)
5. Individual blog posts / opinions

Flag and deprioritize:
- Outdated sources (> 2 years for fast-moving topics)
- Sources without author credentials
- Marketing content disguised as technical analysis
- Single-viewpoint sources on contentious topics

## Phase 4: Cross-Reference & Synthesis

Analyze findings across all sub-questions:

**Consensus:** What do multiple authoritative sources agree on?

**Contradictions:** Where do sources disagree? Why?
- Different contexts / use cases?
- Outdated information in one source?
- Genuinely contested topic?

**Single-source claims:** Flag any finding that comes from only one source as `[SINGLE SOURCE]`.

**Gaps:** What sub-questions weren't fully answered? What's still unknown?

Produce a synthesis that:
- Leads with consensus findings
- Presents contradictions transparently with both sides
- Clearly marks confidence level for each claim

## Phase 5: Practical Application

Connect findings to the user's actual context:

**Trade-offs table:**

| Approach | Pros | Cons | Best When |
|----------|------|------|-----------|
| [Option A] | | | |
| [Option B] | | | |
| [Option C] | | | |

**Recommendation** (if appropriate):
- What fits the user's stated constraints?
- What's the simplest approach that works?
- What should they avoid and why?

**Next steps:**
- Concrete actions the user can take
- Further research needed for specific sub-topics
- Prototyping / POC suggestions

---

## Output Template (Pyramid Style)

```markdown
## Research: [Topic]

### Verdict
**[1-sentence recommendation / answer].** Confidence: [H/M/L]

### Key Findings
1. **[Most important finding]** — [source] — [so-what for our context]
2. **[Second finding]** — [source] — [so-what]
3. **[Third finding]** — [source] — [so-what]

### Recommendation
[2-3 sentences: what to do, why, what to avoid]

### Trade-offs
| Approach | Pros | Cons | Best When |
|----------|------|------|-----------|
| [Option A] | | | |
| [Option B] | | | |

### Next Steps
- [ ] [Most important follow-up]
- [ ] [Prototyping suggestion]

---
## Deep Dives

### [Sub-topic 1]
[Detailed findings with source references]

### [Sub-topic 2]
[Detailed findings with source references]

### [Sub-topic 3]
[Detailed findings with source references]

### Contradictions & Caveats
- [Where sources disagree and why]
- [SINGLE SOURCE] [Claims from only one source]

### Source Assessment
| Source | Authority | Recency | Relevance | Priority |
|--------|-----------|---------|-----------|----------|
| [Source + link] | H/M/L | [Date] | H/M/L | 1-5 |

### All Sources
- [Source 1](link) — [Brief description]
- [Source 2](link) — [Brief description]
```
