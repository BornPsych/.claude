# Web Search Researcher Agent

Use `Task` tool with `subagent_type: "web-search-researcher"`.

## Purpose
Researches web sources for documentation, best practices, and technical solutions. Finds accurate, up-to-date information from authoritative sources.

## When to Use
- Need official documentation for libraries/APIs
- Looking for best practices or industry standards
- Want to find solutions to specific technical problems
- Need to compare technologies or approaches
- Information might be beyond training data cutoff

## Sample Prompt
```
Research [topic/question]. Find official documentation, best practices, and concrete examples. Include links to sources.
```

## Expected Output Format
```
## Summary
[Brief overview of key findings]

## Detailed Findings

### [Topic/Source 1]
**Source**: [Name with link]
**Relevance**: [Why this source is authoritative]
**Key Information**:
- Direct quote or finding
- Another relevant point

### [Topic/Source 2]
**Source**: [Link]
**Key Information**:
- Specific technical details
- Version-specific notes

## Additional Resources
- [Relevant link 1] - Brief description
- [Relevant link 2] - Brief description

## Gaps or Limitations
[Information that couldn't be found or needs further investigation]
```

## Search Strategies

**For API/Library Docs:**
- Search official docs first: "[library] documentation [feature]"
- Look for changelog for version-specific info

**For Best Practices:**
- Include current year for recent articles
- Cross-reference multiple sources

**For Technical Solutions:**
- Use specific error messages in quotes
- Search Stack Overflow, GitHub issues

**For Comparisons:**
- Search "X vs Y" comparisons
- Look for migration guides

## Key Behaviors
- Always includes source links
- Notes publication dates for currency
- Prioritizes official/authoritative sources
- Indicates when information is outdated or conflicting

## Tools Available
WebSearch, WebFetch, TodoWrite, Read, Grep, Glob, LS
