---
name: bro
description: Re-explain the previous answer (or any subject) the way a friend would say it out loud - zero jargon, everyday words, short and warm. Usage - /bro [subject]. With no subject it re-explains whatever was just said. Triggers - "explain like a friend", "say that normally", "what does that actually mean", "in human words", "bro what".
argument-hint: "[subject - optional, defaults to the last answer]"
---

# Bro

Take what was just said and say it again the way one person explains something to a friend
across a table. No technical words. No formatting. Just talk.

Input: $ARGUMENTS

## What to explain

- **Nothing given** → re-explain your own last message: the answer, the plan, the error, the diff,
  whatever it was. If several things were in it, pick the one the person most likely got stuck on
  and open by naming it, so a wrong guess is easy to correct.
- **A subject given** → explain that. If it looks like a file path or a name from the code, read or
  search for the real thing first and explain what actually exists, not the general idea.
- **Nothing above and nothing given** → say so in one line and ask what they want explained.

## How to say it

**No jargon. This is the whole point.**
Do not use technical words, acronyms, product names for concepts, or insider shorthand. Every time
one shows up in the original, swap it for plain words that say what the thing *does* or what it
*means for the person*. "The token expired" becomes "your login ran out and it needs you to sign
in again". "Race condition" becomes "two things tried to change the same thing at the same moment
and one of them lost". The only exception: a word the person used themselves in their question.
They already know that one, so it is fine to reuse it.

**Talk, don't write.**
Plain sentences in a row, the way you would say it out loud. Contractions are fine. "Okay so" is
fine. No headers, no bullet points, no tables, no bold labels, no numbered steps unless the thing
really is a sequence of actions they have to take in order. No code unless it is a command they
literally have to type, and then it goes in a code block by itself.

**Lead with the point.**
First sentence is the thing itself: what happened, what it is, or what they should do. No warm-up,
no "great question", no "let me explain", no repeating what they asked.

**Then the why, then the what-now.**
After the point, say why it matters to them in a sentence or two. If the original answer had an
action in it, end with what to do next in plain words. If there is a catch, say "the one catch
is..." and keep it to one sentence.

**Simplify the words, not the truth.**
Easier language must not become wrong language. If a detail matters and the simple version would
lose it, keep the detail and say it simply. If you are not sure about something, say "I'm not
sure about this part" and say what would settle it.

**Comparisons only if they really help.**
One everyday comparison is fine when it makes the idea click. Do not stack them, and always follow
it with what actually happens, so the picture does not replace the fact.

**Keep it short.**
Aim for roughly the length of something you would say in one breath and a half - about eight to
twelve lines. If the honest answer needs more, take it, but never pad.

## What to leave out

- The `## Explore Next` trailer. This skill overrides that global rule. The answer ends when the
  explanation ends.
- Confidence scores, decompose/verify scaffolding, `---` dividers, and any other output structure
  from the global reasoning rules. Do the thinking, show none of the machinery.
- Any mention of this skill, the previous answer being "technical", or that you are simplifying.
  Just explain it.
