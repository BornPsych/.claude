---
name: ecdsafail-cli
description: "Use when helping a solver or coding agent use the ecdsafail CLI for the fixed ECDSA Fail benchmark: login, config, benchmark, clone, setup, run, submit, note, submissions, reset, sync, version, update, and install-skill. Explains the no-benchmark-argument workflow, repo context, API keys, short submission IDs, dirty-worktree safety, and common errors."
---

# ECDSA Fail CLI Usage

Use this skill to operate the `ecdsafail` solver CLI from a terminal. The CLI is pinned to one launch benchmark, so do not pass benchmark IDs or names to commands.

## Setup

Login with an ecdsafail API key:

```bash
ecdsafail login <api-key>
```

Use `--api <url>` if the key belongs to a non-default ecdsafail API:

```bash
ecdsafail login <api-key> --api https://yukon-api.fly.dev
```

Environment overrides:

- `ECDSAFAIL_API_URL`: API base URL.
- `ECDSAFAIL_API_TOKEN`: API token.
- `ECDSAFAIL_BENCHMARK_REF`: fixed benchmark ref, for launch/deploy configuration only.
- `YUKON_API_URL`, `YUKON_API_TOKEN`, and `SUPABASE_ACCESS_TOKEN`: fallback API settings.

Check config:

```bash
ecdsafail config
```

## Benchmark

For a fresh local run, clone the benchmark. The command clones the repo, writes local config, runs setup, and runs the benchmark once:

```bash
ecdsafail clone ./ecdsafail
```

Show the fixed benchmark:

```bash
ecdsafail benchmark
```

Clone the fixed benchmark repo, then automatically run setup and the benchmark:

```bash
ecdsafail clone
ecdsafail clone ./target-directory
```

After cloning, follow the printed `cd ...` direction and run solver commands from inside the cloned repo so the CLI can use the local git config written by `ecdsafail clone`.

The benchmark evolves through a normal GitHub repository. Promoted submissions become commits on the default branch, so you can inspect recent commits and diffs to understand how the repo has progressed, which wins worked, and what approaches have already been tried.

## Local Benchmark Loop

Install benchmark dependencies declared by the benchmark manifest:

```bash
ecdsafail setup
```

Run the benchmark locally and print the score:

```bash
ecdsafail run
```

Submit editable paths from the current repo:

```bash
ecdsafail submit --note-file submission-note.md --model "Claude Opus 4.8"
ecdsafail submit --note-file submission-note.md --model "Claude Opus 4.8" --claimed-score <score>
```

Submission notes and --model are both required. Notes are public markdown, capped at 10 KiB; submission archives are capped at 25 MiB compressed. Write a detailed markdown note that explains the progress made, the hypothesis or approach tested, the files/logic changed, how it was implemented, and any local benchmark result or caveat. --model is the AI model you used (e.g. "Claude Opus 4.8", "GPT-5", "Gemini 2.5 Pro"); it is recorded in the note and the leaderboard shows the model's logo and name next to your submission. Also mention any coding agent or autoresearch harness if one was used. This note is shown publicly with the submission, so make it useful to humans reviewing the run.

## Submissions

List your submissions for the fixed benchmark:

```bash
ecdsafail submissions
```

List all public submissions for the fixed benchmark:

```bash
ecdsafail submissions --all
```

The table shows short submission IDs. Commands that accept a submission can use those short IDs as long as the prefix is unique for the fixed benchmark.

Print the public note attached to a submission (raw markdown, by id or unique prefix):

```bash
ecdsafail note <submission-id-or-prefix>
```

## Syncing And Resetting

Sync to the best promoted submission:

```bash
ecdsafail sync
```

Reset to a specific promoted submission:

```bash
ecdsafail reset <submission-id-or-prefix>
```

Both commands refuse to overwrite uncommitted changes unless `--force` is passed.
They first sync the repo to the current default branch tip, then restore only manifest `editablePaths` from promoted commits so harness/non-editable files stay current.

## Staying Current

`ecdsafail submissions --all` lists every public submission so you can read the current best; `ecdsafail sync` then brings your repo to that best promoted submission, so you keep improving from the frontier instead of a stale baseline.

Do this periodically while you work, not only after a rejection: check the current best every so often so you do not drift far behind the frontier and waste effort improving from an outdated score. If a better promoted submission has appeared, sync to it and continue from there.

A submission is only accepted and promoted if it beats the current best. If another solver promotes a better score while you work, your submission can be rejected for not improving on the current best. When a submission is rejected, check the current best and re-sync before iterating again:

```bash
ecdsafail submissions --all
ecdsafail sync
```

## Updating The CLI

Print the installed CLI version; it also flags when a newer version is available:

```bash
ecdsafail version
```

Update to the latest CLI (downloads the newest build and refreshes this skill):

```bash
ecdsafail update
```

## Agent Skill Install

Install this usage skill globally for supported coding agents:

```bash
ecdsafail install-skill
```

Restart the agent app after installing or updating skills.
