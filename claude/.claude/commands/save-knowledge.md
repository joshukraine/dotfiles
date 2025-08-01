# Save Knowledge Command

Save valuable insights, commands, or information discovered during Claude Code sessions to a personal knowledge base.

## Command Usage

```bash
/save-knowledge [topic] [--session-note]
```

## Arguments

- `topic` (optional): Category for the knowledge (e.g., "troubleshooting", "development", "commands")
- `--session-note` (optional): Save as a session note with timestamp instead of categorized knowledge

## Examples

```bash
# Save to a specific topic
/save-knowledge troubleshooting

# Save as a session note
/save-knowledge --session-note

# Prompt for topic selection
/save-knowledge
```

## Your Task

1. **Determine save location**:
   - Check if `$CLAUDE_KB_PATH` environment variable is set
   - Default to `~/claude-knowledge-base/` if not set
   - Create directory structure if it doesn't exist

2. **Analyze recent conversation**:
   - Look at the last 3-5 exchanges to identify key insights
   - Extract commands, solutions, explanations, or discoveries
   - Identify the most valuable information to save

3. **Choose save method**:
   - **If `--session-note`**: Save to `sessions/YYYY-MM-DD-brief-description.md`
   - **If topic provided**: Save to `topics/{topic}/brief-description.md`
   - **If no topic**: Analyze content and suggest/choose appropriate topic

4. **Create structured markdown**:
   - Clear title describing the knowledge
   - Context section (what problem/question led to this)
   - Solution/insight section
   - Commands/code examples if applicable
   - Tags for searchability

5. **File management**:
   - Use descriptive filenames with timestamps
   - Avoid overwriting existing files
   - Update `index.md` with new entries (if it exists)

## Knowledge Base Structure

```
$CLAUDE_KB_PATH/
├── README.md
├── topics/
│   ├── development/
│   ├── troubleshooting/
│   ├── commands/
│   ├── tools/
│   └── insights/
├── sessions/
│   └── YYYY-MM-DD-description.md
└── index.md (auto-generated)
```

## Template for Knowledge Entries

````markdown
# Title

**Created**: YYYY-MM-DD
**Source**: Claude Code session
**Tags**: tag1, tag2, tag3

## Context

Brief description of what led to this discovery.

## Solution/Insight

The key information, commands, or insights.

## Commands/Examples

```bash
# Relevant commands or code
```
````

## Related

- Links to related knowledge base entries
- External resources

```

## Setup Requirements

1. **Environment variable**: Set `$CLAUDE_KB_PATH` in shell configuration
2. **Directory structure**: Auto-created on first use
3. **Git repository**: Initialize knowledge base as private GitHub repo for backup

## Integration Notes

- Works from any Claude Code session regardless of current working directory
- Automatically creates knowledge base structure on first use
- Suggests topics based on content analysis
- Maintains searchable index of all saved knowledge
```
