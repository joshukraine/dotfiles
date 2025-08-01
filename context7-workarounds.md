# Context7 MCP Workarounds

This document provides workaround strategies for using Context7 while dealing with the Claude Code MCP session bug (issue #3323).

## Problem Summary

Context7 MCP server works fine in new Claude Code sessions but fails after ~1 minute due to a Claude Code session lifecycle management bug. Restarting Claude Code fixes it temporarily but loses conversation context.

## 🎯 **Best Workarounds (Context Preserved)**

### **Option 1: Use Context7 in a Separate Claude Code Session** ⭐ **RECOMMENDED**

- Keep your main session running for ongoing project work
- Open a new terminal/tmux split when you need Context7
- Start a fresh Claude Code session just for Context7 queries
- Copy/paste results back to main session

**Commands:**

```bash
# In your main tmux session (keep this running)
# Continue your project work here

# When you need Context7:
tmux split-window -h    # or -v for vertical split
claude                  # Start fresh Claude Code session
# Use Context7 here, then copy results back
```

**Pros:**

- Zero context loss in main session
- Context7 works perfectly in fresh session
- Can keep Context7 session as long as needed (~1 minute)

**Cons:**

- Bit of extra work switching between sessions
- Need to copy/paste results

### **Option 2: Batch Context7 Queries**

- When you need Context7, restart your main Claude Code session
- Do all your Context7 research at once while it's working
- Copy important results into files or save in conversation
- Continue your main work after Context7 session fails

**Workflow:**

1. Document current state before restarting
2. Restart Claude Code
3. Immediately use Context7 for all planned queries
4. Save/document results
5. Continue main work (Context7 will fail but you have what you need)

**Pros:**

- Efficient use of working Context7 time
- All Context7 work done in one batch

**Cons:**

- Have to plan Context7 usage ahead of time
- Interrupts workflow

## 🔄 **Context Recovery Options**

### **Option 3: Export/Resume Pattern**

Claude Code may have session export/resume capabilities:

```bash
# Before restarting (if available)
/save-session project-work-session

# After restart
/load-session project-work-session
```

**Note:** Check if these commands are available in your Claude Code version.

### **Option 4: Document Current State**

Before restarting Claude Code, quickly document where you are:

- Current task/issue you're working on
- Files being modified
- Next steps planned
- Important conversation context

Save this in a file or note-taking app, then reference it after restart.

## 💡 **Recommended Workflow**

**Primary Strategy: Option 1 (Separate Sessions)**

1. **Main Session**: Keep running for project work, conversations, file editing
2. **Context7 Session**: Open in new tmux split when needed
3. **Results Transfer**: Copy/paste findings back to main session
4. **Session Management**: Context7 session can be short-lived and disposable

**Example tmux layout:**

```
┌─────────────────┬─────────────────┐
│                 │                 │
│  Main Claude    │  Context7       │
│  Code Session   │  Claude Code    │
│                 │  Session        │
│  (Long-running) │  (As needed)    │
│                 │                 │
└─────────────────┴─────────────────┘
```

## 🔧 **Quick Reference Commands**

```bash
# Split tmux for Context7 session
tmux split-window -h        # Horizontal split
tmux split-window -v        # Vertical split

# Navigate between tmux panes
Ctrl+b + arrow keys         # Move between panes
Ctrl+b + z                  # Zoom/unzoom current pane

# Start fresh Claude Code in new pane
claude

# Close Context7 session when done
exit
```

## Status

- **Bug Status**: Reported in Claude Code issue #3323, assigned to Anthropic engineer
- **Workaround Status**: Option 1 tested and working
- **Expected Fix**: Unknown timeline, monitor issue #3323 for updates
