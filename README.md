# .claude

My user-level [Claude Code](https://claude.com/claude-code) configuration: custom skills and slash commands, installed at `~/.claude/`.

## Install

```bash
git clone https://github.com/BornPsych/.claude.git
cp -r .claude/skills .claude/commands ~/.claude/
```

Skills load automatically; commands become available as `/breakdown`, `/research`, etc.

## Skills

| Skill | What it does |
|---|---|
| [adhd](skills/adhd/SKILL.md) | Rephrase the last message for a reader with ADHD — next action first, numbered steps, no preamble |
| [breakdown-impl](skills/breakdown-impl/SKILL.md) | Structure problems without solving them — MECE decomposition, Cynefin classification, 5 Whys, WBS |
| [bro](skills/bro/SKILL.md) | Re-explain the previous answer the way a friend would say it out loud — zero jargon, short and warm |
| [catch-up-impl](skills/catch-up-impl/SKILL.md) | Onboard to a codebase — recent commits, project structure, development patterns |
| [chirp](skills/chirp/SKILL.md) | Manage sessions, projects and epics through the xirp CLI — resume sessions, launch background agents, manage worktrees |
| [commit](skills/commit/SKILL.md) | Split staged/unstaged changes into N well-structured commits on a fresh branch and open a PR |
| [create-plan-impl](skills/create-plan-impl/SKILL.md) | Create phased implementation plans with success criteria through research and iteration |
| [design-an-interface](skills/design-an-interface/SKILL.md) | Generate radically different interface designs for a module using parallel sub-agents |
| [easy-explain](skills/easy-explain/SKILL.md) | Explain anything in simple words, plain paragraphs, no analogies, within a line budget |
| [ecdsafail-cli](skills/ecdsafail-cli/SKILL.md) | Drive the ecdsafail CLI for the ECDSA Fail benchmark — setup, runs, submissions |
| [enhance-prompt-impl](skills/enhance-prompt-impl/SKILL.md) | Optimize prompts for Claude — XML structure, chain-of-thought, few-shot examples |
| [find-skills](skills/find-skills/SKILL.md) | Discover and install agent skills when looking for new capabilities |
| [grill-me](skills/grill-me/SKILL.md) | Relentlessly interview you about a plan or design until every branch of the decision tree is resolved |
| [humanizer](skills/humanizer/SKILL.md) | Remove signs of AI-generated writing from text, based on Wikipedia's "Signs of AI writing" guide |
| [improve-codebase-architecture](skills/improve-codebase-architecture/SKILL.md) | Find architectural improvements that make a codebase more testable by deepening shallow modules |
| [meeting-save](skills/meeting-save/SKILL.md) | Archive Wispr Flow meeting audio + transcripts before the app's 24-hour purge; outputs a fused-mono main track and a denoised, silence-trimmed mic-only track |
| [research-codebase-impl](skills/research-codebase-impl/SKILL.md) | Investigate a codebase — find files, trace data flow, understand architecture, debug errors |
| [tdd](skills/tdd/SKILL.md) | Test-driven development with a red-green-refactor loop and interface-design references |
| [tutor](skills/tutor/SKILL.md) | Interactive tutor for deeply learning any material, with persistent resumable study notes |
| [validate-research-impl](skills/validate-research-impl/SKILL.md) | Validate research findings with skeptical parallel agents and alternative hypotheses |

## Commands

Slash commands are thin wrappers that invoke the matching skill (most pin the model to Opus):

| Command | Skill it runs |
|---|---|
| `/breakdown` | breakdown-impl |
| `/catch-up` | catch-up-impl |
| `/create-plan` | create-plan-impl |
| `/enhance-prompt` | enhance-prompt-impl |
| `/fork-tmux` | standalone — forks the current conversation into a new vertical tmux pane |
| `/pr-describe` | standalone — generates a PR description with AI disclosure (text only, no git commands) |
| `/research` | research-codebase-impl |
| `/validate-research` | validate-research-impl |
