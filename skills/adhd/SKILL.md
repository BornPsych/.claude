---
name: adhd
description: 'Rephrase the last message for a reader with ADHD: next action first, numbered steps, no preamble or tangents, state and wins made visible. One-shot rewrite, not a persistent mode. Usage - /adhd (rewrites my last response) or /adhd <text> (rewrites that text).'
argument-hint: "[text to rephrase]"
disable-model-invocation: true
license: MIT
metadata:
  source: "Adapted from https://github.com/ayghri/i-have-adhd (MIT)"
  tags: "ADHD, Rephrase, Output Style, Formatting"
---

# adhd

The reader has ADHD. Rewrite ONE message so an ADHD brain can act on it.

This is a one-shot rewrite, not a mode. It applies to this response only. Return to the default
style on the next turn unless `/adhd` is sent again.

Input: $ARGUMENTS

## What to rewrite

Resolve the target in this order. Do not ask which one was meant; pick by this order and rewrite.

1. **Input above is non-empty** → rewrite that text.
2. **Otherwise** → rewrite your most recent message in this conversation: the answer, plan, diff
   summary, or error report the reader just saw.
3. **No prior message from you** → rewrite the reader's own last message into a clear, structured
   version of what they asked for: goal first, then numbered points.

## Fidelity: this is a rewrite, not a new answer

- Keep every command, path, line number, flag, error string, and number exactly as in the source.
- Add nothing the source did not say. No new steps, facts, or suggestions.
- Drop nothing the reader needs in order to act. Cut only preamble, recaps, pleasantries,
  empty hedges, and tangents.
- Keep real uncertainty. If the source said "probably", the rewrite says "probably". Deleting a
  hedge manufactures confidence.
- Do not do new work, run tools, or extend the answer. If the source was incomplete, the rewrite
  is incomplete too; say so in one line at the end.

## Why the shape matters

1. Working memory is small. Anything not on screen is forgotten. Never write "keep in mind X".
2. Knowing the answer is not doing it. The gap between "got it" and "done it" is where work dies.
3. Starting is the hardest step. The first action must be obvious, small, and doable now.
4. Vague time estimates register the same as no estimate.
5. Dopamine is scarce. Buried wins do not register.

## Rules for the rewrite

### 1. Lead with the next action

The first line is something the reader can do. Not context. Not a plan. If the source contains a
command, path, or snippet, it goes first. Prose comes after, if at all.

Bad: "Let's think about this. Your auth flow has a few moving pieces..."
Good: "Run `npm install jsonwebtoken`, then edit `src/auth.ts:42`."

### 2. Number multi-step work

More than one step → numbered list. One bounded action per step. No step contains "and then"
twice. Fold trivial steps into the one before. A short path finished beats a complete path
abandoned.

Aim for 5 steps or fewer per group. If the source has more, group them under short headers, most
relevant group first.

Bad: "First open the file, find the function, swap it out, then run the tests."

Good:
```
1. Open `src/auth.ts`
2. Replace `verifyToken` (lines 42 to 58) with the snippet below
3. Run `npm test -- auth.spec.ts`
```

### 3. End with one concrete next action

If anything is left open, name ONE thing doable in under two minutes. Even "open the file" counts.

Bad: "Hope that helps. Let me know if you want to dig deeper."
Good: "Next: run `npm test` and paste the first failing line."

### 4. Move tangents out of the way

Finish the main point. Anything the source raised on the side goes in ONE line at the end:
"Separately: <thing>. Want that next?"

### 5. Make state visible

If the source is mid-task, say where things stand in one line.

Bad: "Done. Ready for the next part?"
Good: "Step 3 of 5 done: schema updated. Next: backfill the new column."

### 6. Time estimates: concrete or absent

Replace vague estimates from the source ("some work", "a while") with concrete units only when the
source or visible context supports a number. Otherwise delete the vague phrase. Never invent a
number.

Bad: "This will take some work."
Good: "About 15 minutes if tests already cover this. An afternoon if not."

### 7. Make completed work visible

If the source reports finished work, state what now works in concrete, testable terms.

Bad: "I've made some changes to the auth flow. Among other things..."
Good: "Login now works with magic links. Try: `npm run dev`, open `/login`."

### 8. Errors: cause, then fix

Never "Uh oh", "Oh no", or "There seems to be a problem". Format: where it fails, why, what to do.

Good: "Test fails at `auth.spec.ts:42`: expected 200, got 401. Cause: missing auth header.
Fix: add `Authorization: Bearer ${token}` to the request."

### 9. No preamble, recap, or closer

Delete openers: "Great question", "Sure!", "Let me...", "I'll...", "Looking at your...".
Delete recaps: "I've now done X, Y, and Z, which means...".
Delete closers: "Hope this helps", "Let me know if...", "Happy to clarify".

Start with the answer. End when the answer ends.

## Output format

- Output the rewritten message only. No "Here is the rephrased version:", no quoting the
  original, no notes about what changed.
- Same language as the source.
- If harness or user instructions require a trailing section (for example `## Explore Next`),
  keep it, cap it at 3 items, one line each.

## When the shape bends

- **Source is an explanation** (reader asked to "explain" or "walk me through"): keep the full
  body, add short headers for skimming, still no preamble or closer.
- **Source lists options**: keep 2 to 4 ranked options with one-line trade-offs, recommendation
  first. The options are the answer.
- **Source asks a real clarifying question**: keep it as the single last line.
- **Source warns about a destructive action** (force push, `rm -rf`, schema migration, dropping a
  table): keep the warning at the top, above the first action.

## Pre-send check

Delete:

1. The first sentence if it announces what the message is about to do.
2. The last sentence if it recaps or asks "anything else?".
3. Any "by the way" sidebar not already moved to the "Separately:" line.
4. Any hedging adverb adding no information. Keep a hedge that carries real uncertainty.
5. Any idiom or figurative phrase ("circle back", "get the ball rolling"). Replace with the
   literal action.

Then verify: reading only the first line and the last line, does the reader know (a) what to do
next and (b) what just happened? If yes, send.
