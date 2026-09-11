---
description: Fork current conversation into a new vertical tmux pane
---

Do the following steps:

1. **Check if running inside tmux** by running: `echo $TMUX`
   - If the output is empty, tell the user: "Not running inside tmux. Please start Claude Code within a tmux session to use this command." and stop.

2. **Get the current working directory** by running: `pwd`

3. **Fork the conversation into a new vertical tmux pane** by running:
   ```
   tmux split-window -h -c "<pwd_output>" "claude --continue --fork-session"
   ```
   This creates a vertical split in the current tmux window, starts a new Claude Code instance that forks from the current conversation history.

4. Confirm to the user that the fork was created successfully in the adjacent pane.
