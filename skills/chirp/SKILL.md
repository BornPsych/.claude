---
name: chirp
description: 'Manage sessions, projects, and epics through the xirp CLI (chirp in a source checkout). Use when the user wants to copy or resume a local Coding Agent session in the desktop app, launch background agents, manage worktrees, or orchestrate multi-session work.'
contributions:
  enabled: true
  repository: git@ghe.spotify.net:backstage-external/chirp.git
  plugin: chirp
  skill_path: skills/chirp
  notice: 'After completing this skill, suggest the user run /improve-skill to propose improvements. Install skills-contrib if needed: claude plugin marketplace add git@ghe.spotify.net:ai-tools/claude-plugins.git && claude plugin install skills-contrib'
---

This CLI drives a local orchestrator for background Coding Agent sessions. Each session runs in its own git worktree with a dedicated agent.

## The command name

The desktop app installs the CLI at `~/.local/bin/xirp` (`~/.local/bin/chirp-core` for the Chirp Core edition). A source checkout links it as `chirp`. Examples below use `xirp`; substitute whichever of the three is on `PATH`.

Run `xirp --help` for the complete and up-to-date command list. The sections below cover the most common workflows.

## Import this terminal's Coding Agent session

When the user asks to import, move, open, continue, or resume the Coding Agent session running in this terminal, first run the local-only, non-mutating preview:

```bash
xirp session import --preview --json
```

If a long-running terminal inherited an older command earlier on `PATH`, or the bare command does not expose `session import`, retry the preview with the absolute `~/.local/bin/xirp`. Never run `xirp update` to recover from a missing or outdated command: packaged-app updates and CLI repair are owned by the desktop app.

Claude Code, Codex, and Cursor expose native session IDs that the preview detects automatically. Gemini and pi do not, so the preview cannot tell it is running inside one; retry it naming the agent, for example `xirp session import --source-harness pi --preview --json`. Keep the successful `--source-harness` option on the final import command below. Squab resolves that agent's newest session for the current directory, so do not invent a session ID. Snipe cannot import its own sessions yet, but it can run this skill to import any of the other five.

Use the preview metadata and the conversation context to propose a short, descriptive session name. Prefer an existing meaningful native/tab name when the preview has one; otherwise improve its deterministic folder/harness/ID suggestion based on the task. The local project is inferred from the current directory and the real import registers it automatically when needed: do not run `xirp project add`, list local projects, or ask the user to select one.

The preview must stay local and must not inspect Portal. Ask one concise confirmation question for the proposed session name. Let the user approve it or supply another name.

After the name is confirmed, import and open the local session:

```bash
# to file the session away
xirp session import --name "<confirmed name>" --open
# to carry the conversation on in the app
xirp session import --name "<confirmed name>" --open --resume
```

Use `--resume` when the user asked to continue or resume the conversation rather than only file it away. The session then opens running under the agent it was imported from, instead of stopped behind a Resume button. Say that this terminal's own agent still holds the same transcript, so the user should end it here before continuing in the desktop app.

Codex command sandboxes may block loopback WebSocket access. If a command fails with `Could not connect to Chirp daemon` while the configured localhost port is expected to be running, retry that same command with localhost/network approval. Do not remove the worktree port override or switch to an installed desktop daemon as a workaround; the selected worktree daemon owns the code and state under test.

`--open` asks the OS to launch the custom protocol because chat renderers may not make `web+chirp://` links clickable. Relay the direct desktop URI as a fallback, outside a code block.

Import registers the existing transcript as a managed session; it does not launch or attach a Coding Agent, so this terminal keeps running untouched. Without `--resume` the imported session arrives stopped and resumable — continue it in the desktop app, or from a terminal with `xirp session attach <session-id>`.

## Sessions

Create a session:

```bash
xirp session new --goal "fix auth bug" --new-branch jd/fix-auth
```

Options:

- `--goal <text>` — prompt for the agent (required)
- `--project <path-or-id>` — target project (default: `$CHIRP_PROJECT_ID` or CWD)
- `--name <text>` — custom session name
- `--new-branch <name>` — create a worktree on a named branch (default: auto-generated)
- `--base-branch <name>` — base for new branch (default: project's default branch)
- `--worktree <id>` — reuse an existing worktree
- `--no-worktree` — run on the project root (no worktree)
- `--foreground` — auto-focus the new session
- `--no-terminal` — use SDK mode instead of terminal
- `--depends-on [id]` — link as child session (default: `$CHIRP_SESSION_ID`)
- `--epic <epicId>` — associate with an epic
- `--tag <key:val>` — add tag (repeatable)
- `--harness <agent>` — pick the Coding Agent
- `--model <name>` — model override (requires `--harness`)
- `--profile <name>` — Codex configuration profile (requires `--harness codex`)
- `--json` — output JSON

Other session commands:

```bash
xirp session list                    # list all sessions
xirp session list --status running   # filter by status
xirp session list --search "auth"    # search name/goal/branch across all projects
xirp session list --status running,idle --limit 5  # multi-status + limit
xirp session get <id>                # show session details
xirp session stop <id>               # stop a running session
xirp session delete <id>             # permanently remove
xirp session update <id> --name "title"     # rename session
xirp session message <id> <text>     # send text to session (submits it); --no-enter types only
xirp session attach <id>             # continue a stopped session in this terminal
xirp session upload --project <slug> # upload the transcript to a Portal workspace
```

Tip: use `/rename <title>` as a shortcut to rename the current session.

## Projects

```bash
xirp project add /path/to/repo --name "My Project"
xirp project list
xirp project edit <id> --name "New Name"
xirp project remove <id>
```

## Epics

Epics decompose large tasks into multiple sessions:

```bash
xirp epic list
xirp epic update <id>
xirp epic relaunch <id>
xirp epic chunk <id>
xirp epic finalize-proposal <id>
xirp epic add-chunk <id>
xirp epic set-proposal-meta <id>
```

## Backlog

File a "look into this later" note to yourself, or manage the dashboard's Backlog panel, without leaving the session:

```bash
xirp backlog add --content "Investigate slow query in X"   # --project defaults to $CHIRP_PROJECT_ID
xirp backlog list                                            # list backlog items
xirp backlog list --status in-progress                       # filter by column: backlog, in-progress, done
xirp backlog edit <id> --content "text"                      # or --priority <n>
xirp backlog move <id> --status done                         # move between columns
xirp backlog rm <id> --yes                                   # remove
xirp backlog start <id>                                      # convert into a running session
```

## Auth

```bash
xirp auth login       # authenticate with Backstage via browser
xirp auth status      # show current auth status
```

## Source checkouts only

The desktop app owns its own lifecycle, so the packaged `xirp` refuses these. They work only from a source checkout, where the command is `chirp`:

```bash
chirp start [--open]   # start Chirp in the background
chirp stop             # stop Chirp
chirp status           # check if running
chirp dev              # run in foreground with live reload
chirp logs             # tail logs
chirp doctor           # diagnose version mismatches
chirp backup           # dump database to ~/.chirp/backups/
chirp restore <file>   # restore from backup
```

## Tips

- Use `--new-branch` with Linear's `gitBranchName` so Linear auto-links: `xirp session new --goal "..." --new-branch <user>/wsn-123-fix-thing`
- Sessions run in isolated worktrees by default — safe to launch multiple in parallel.
- Use `--depends-on` to chain sessions so child waits for parent to finish.
- Use `--foreground` to auto-focus, otherwise sessions run in the background.
- Inside a managed session, `$CHIRP_SESSION_ID` and `$CHIRP_PROJECT_ID` are set automatically.
