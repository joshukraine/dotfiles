# Claude Code Attribution Snippet Explanation

This document explains when and why Claude Code includes attribution snippets in commits, PRs, and issues.

## The Attribution Snippet

The snippet looks like this:

```text
🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## When Attribution IS Added

**Automatic attribution happens for:**

1. **Git commits via Bash tool** - When Claude Code creates commits using the Bash tool (like `git commit -m "..."`), the attribution is automatically appended to commit messages
2. **Pull request creation via `gh pr create`** - When using GitHub CLI through Bash tool, attribution gets added to PR descriptions
3. **Direct GitHub issue creation** - When Claude Code creates new issues via GitHub CLI

## When Attribution IS NOT Added

**No attribution in these cases:**

1. **Manual git operations** - If you run git commands yourself after Claude Code makes changes
2. **Existing workflow continuation** - When Claude Code is working within an established workflow (like the `/resolve-issue` command) where you're driving the process
3. **File editing only** - When Claude Code only edits files but doesn't create the actual commits/PRs
4. **Tool-specific behavior** - Some MCP tools or integrations may have different attribution rules

## Example: Issue #99 Resolution

In the issue #99 resolution, the commits **did not** get the attribution because:

- The commits were made through the **systematic `/resolve-issue` workflow**
- The user explicitly requested the issue resolution, so Claude Code was acting as their agent
- The workflow treats this as **collaborative work** rather than autonomous generation

## Configuration Control

The attribution behavior is controlled by:

- **Global settings** in Claude Code
- **Tool-specific configurations**
- **Context awareness** (collaborative vs autonomous work)

## General Principle

**Autonomous generation** gets attribution, **collaborative workflows** may not.

You can check your Claude Code settings to see if attribution is configurable for different scenarios.
