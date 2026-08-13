---
name: easy-explain
description: Explain something in simple words, in plain paragraphs, with NO analogies, within a line budget. Usage - /easy-explain [lines] [subject]. Subject can be omitted (re-explains what was just discussed), a topic name, a file path, or a symbol. Triggers - "explain simply", "I didn't follow that", "in easy words", "what does this actually do", "ELI5 but no analogies".
---

# Easy Explain

Explain one thing, plainly, short, no analogies.

## Arguments

`/easy-explain [lines] [subject]`

- **`lines`** — optional leading integer. Target length of the explanation body in lines. **Default 10.**
  Treat it as a target, not a hard cap: land within roughly ±20%. If the honest answer needs more,
  spend the extra lines and say nothing about having done so.
- **`subject`** — everything after the number. Resolve in this order:
  1. **Empty** → explain whatever was just discussed: the previous answer, plan, diff, or error.
     If several things were in play, pick the one the user most likely stumbled on and name it in
     the first sentence so a wrong guess is obvious and cheap to correct.
  2. **A path, or a path-like token** (`src/eval.rs`, `eval.rs:120`, `foo/`) → read it, then explain
     what it does and why it exists.
  3. **A symbol or identifier** that plausibly lives in the repo (`InterpreterError`, `eval_match`)
     → search for it first. Explain the real code, not the general concept, if it is found.
  4. **Anything else** → a general topic. Explain it from scratch, assuming no background.

## Rules

**No analogies. This is the point of the skill.**
No "think of it like", no "similar to", no metaphors, no comparisons to cooking, plumbing, traffic,
mail, libraries, or any other unrelated domain. Describe the actual thing in literal terms. If you
catch yourself reaching for a comparison, the fix is a more concrete description of the real
mechanism, not a better comparison.

**Plain paragraphs.**
Continuous prose. Short sentences. No headers, no bullet lists, no tables, no bold-label runs, no
numbered steps unless the subject is genuinely a sequence. One idea per sentence.

**Keep the real term, gloss it once.**
Use the correct technical word, then define it inline in a few words the first time it appears —
"a witness, meaning the private inputs the prover knows". After that, just use the term. Do not
invent softer substitute words; the user needs vocabulary that maps back to the docs and the code.

**Anchor to code whenever the subject touches this repo.**
Cite `file.rs:120` inline in the prose for the specific place a claim comes from. Anchors are what
make the explanation checkable, so prefer one real citation over three vague sentences. Verify the
path and line before citing — never guess at a location. For general topics with no repo behind
them, skip this.

**Lead with the answer.**
First sentence states the thing directly. No preamble, no restating the question, no "great
question", no "let me break this down", no summary of what you are about to say.

**Say when you do not know.**
One sentence, plainly, and name what would settle it. Do not fill a line budget with hedged prose.

## Length discipline

**Suppress the `## Explore Next` trailer.** This skill overrides the global instruction that
requires it. The answer ends when the explanation ends — no follow-up section, no next-steps list,
no offer to go deeper. A trailer would outweigh the answer at these lengths and reintroduces exactly
the scanning cost the skill exists to remove.

If the subject is too large for the budget, explain the single most load-bearing part properly and
end with one sentence naming what you left out. Never compress by turning the whole thing into a
list of fragments — a shallow outline is worse than a deep answer to a smaller question.
