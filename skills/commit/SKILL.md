---
name: commit
description: Split staged/unstaged changes into N well-structured commits on a fresh branch and open a PR. Usage - /commit <number>. Reads recent commit history to match message style. No co-author, no commit descriptions.
---

# Commit & PR Skill

Split current changes into N commits on a new branch and open a PR.

**Input:** `$ARGUMENTS` = number of commits (e.g., `6`). If missing or non-numeric, ask via `AskUserQuestion`.

## Workflow

### Step 1: Parse Arguments

Extract the number `N` from `$ARGUMENTS`. If `$ARGUMENTS` is empty or not a number, use `AskUserQuestion` to ask:
```
question: "How many commits should the changes be split into?"
header: "Commits"
options: [
  { label: "2", description: "Split into 2 commits" },
  { label: "3", description: "Split into 3 commits" },
  { label: "5", description: "Split into 5 commits" }
]
```

### Step 2: Ask for Base Branch

Use `AskUserQuestion` to ask which branch to use as the base:
```
question: "Which branch should be the base branch?"
header: "Base branch"
options: [
  { label: "main", description: "Use main as base (Recommended)" },
  { label: "master", description: "Use master as base" },
  { label: "develop", description: "Use develop as base" }
]
```
The user can also type a custom branch name via "Other".

### Step 3: Prepare the Branch

1. **Stash current changes** (if any uncommitted work exists):
   ```bash
   git stash --include-untracked
   ```

2. **Checkout and pull the base branch:**
   ```bash
   git checkout <base_branch>
   git pull origin <base_branch>
   ```

3. **Create a new branch** from the base branch. Name it descriptively based on the stashed changes (e.g., `feat/short-description` or `fix/short-description`). Use `git stash show` to understand what changed and pick a good branch name. If you can't determine a good name, use `AskUserQuestion` to ask.
   ```bash
   git checkout -b <new_branch_name>
   ```

4. **Pop the stash:**
   ```bash
   git stash pop
   ```

### Step 4: Read Commit Style

Read the last 15 commit messages from the base branch to understand the project's commit message convention:
```bash
git log <base_branch> --oneline -15
```

Analyze the style:
- Are they conventional commits (`feat:`, `fix:`, `chore:`)?
- Are they imperative (`Add feature`) or past tense (`Added feature`)?
- Do they use prefixes, scopes, ticket numbers?
- What's the typical length and casing?

**You MUST follow the same style** for the new commits.

### Step 5: Create N Commits

Review all current changes (`git diff` and `git status`) and intelligently split them into exactly N logical commits.

**Rules:**
- Each commit should be a logical, atomic unit of work
- Group related file changes together
- Order commits so each builds on the previous (no broken intermediate states)
- Commit messages MUST follow the style detected in Step 4
- **NO extended description/body** in commit messages — title only (single line)
- **NO `Co-Authored-By` line** — never add Claude as co-author
- Use `git add <specific files>` for each commit (never `git add -A` or `git add .`)
- Use HEREDOC format for commit messages:
  ```bash
  git commit -m "$(cat <<'EOF'
  <commit message here — single line, no body>
  EOF
  )"
  ```

If there aren't enough distinct logical changes to split into N commits, do your best to find meaningful boundaries. If truly impossible (e.g., all changes are in one line), explain and use fewer commits.

### Step 6: Verify

Run `git log --oneline <base_branch>..HEAD` to show the user all new commits.

### Step 7: Create PR

1. **Print a push summary** before pushing:
   - Branch name
   - Number of commits
   - One-liner per commit
   - Co-author: No

2. **Ask for confirmation** using `AskUserQuestion`:
   ```
   question: "Push <N> commits to origin/<branch> and create PR to <base>?"
   header: "Push & PR"
   options: [
     { label: "Yes, push & create PR", description: "Push the branch and open a pull request" },
     { label: "Just push, no PR", description: "Push the branch only, skip PR creation" },
     { label: "Cancel", description: "Don't push anything" }
   ]
   ```

3. If approved, push and create the PR:
   ```bash
   git push -u origin <new_branch_name>
   ```

4. Create the PR using `gh pr create`. The PR description should:
   - Have a `## Summary` section with bullet points describing the changes
   - Have a `## Commits` section listing all commit messages
   - **NO co-author mention anywhere**
   - **NO `Co-Authored-By` line**
   - Use HEREDOC for the body:
   ```bash
   gh pr create --title "<PR title matching commit style>" --body "$(cat <<'EOF'
   ## Summary
   - <bullet points>

   ## Commits
   - <list of commit messages>
   EOF
   )"
   ```

5. Print the PR URL when done.

## Important Constraints

- NEVER add `Co-Authored-By` to any commit or PR
- NEVER add extended descriptions/body to commits — title only
- ALWAYS match the existing commit message style from the repo
- ALWAYS ask before pushing (show summary first)
- ALWAYS use specific file paths in `git add` (no wildcards, no `-A`)
- If the stash pop has conflicts, alert the user and stop
