# Save Knowledge Command

Save valuable insights, commands, or information discovered during Claude Code
sessions to a personal knowledge base.

## Command Usage

```bash
/save-knowledge [topic] [--session-note]
```

## Arguments

- `topic` (optional): Category for the knowledge (e.g., "troubleshooting",
  "development", "commands")
- `--session-note` (optional): Save as a session note with timestamp instead
  of categorized knowledge

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
   - Scan content for tagging keywords and patterns

3. **Choose save method**:
   - **If `--session-note`**: Save to `sessions/YYYY-MM-DD-brief-description.md`
   - **If topic provided**: Save to `topics/{topic}/brief-description.md`
   - **If no topic**: Analyze content and suggest/choose appropriate topic

4. **Create structured markdown**:
   - Clear title describing the knowledge
   - YAML frontmatter with auto-generated metadata
   - Context section (what problem/question led to this)
   - Solution/insight section
   - Commands/code examples if applicable
   - Auto-generate tags based on content analysis

5. **File management**:
   - Use descriptive filenames with timestamps
   - Avoid overwriting existing files
   - Update `index.md` with new entries (if it exists)

## Knowledge Base Structure

```text
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
---
title: "Descriptive Title"
created: YYYY-MM-DD
source: "Claude Code session"
category: troubleshooting # or development, commands, tools, insights
tags: [auto-generated, based-on-content, technology-keywords]
difficulty: beginner # or intermediate, advanced
---

# Descriptive Title

## Context

Brief description of what led to this discovery.

## Solution/Insight

The key information, commands, or insights.

## Commands/Examples

```bash
# Relevant commands or code
```
````

## Automated Tag Generation

The command will automatically generate tags by analyzing:

- **Technology keywords**: Extract from content (git, docker, npm, python, etc.)
- **Command patterns**: Detect tools used in code blocks
- **Problem types**: Identify common patterns (error, setup, configuration, debug)
- **Topic category**: Include the chosen topic as a base tag
- **Difficulty level**: Infer from complexity of solution

### Example Auto-Generated Tags

```yaml
# For a Docker troubleshooting entry:
tags: [docker, troubleshooting, permissions, linux, containers]

# For a Git workflow entry:
tags: [git, development, workflow, branching, collaboration]

# For a Vim configuration entry:
tags: [vim, configuration, plugins, productivity, editor]
```

## Tag Generation Implementation

When creating entries, analyze the content and auto-generate tags from these categories:

### **Technology Keywords**

```text
git, docker, kubernetes, npm, yarn, python, node, ruby, bash, zsh, fish, vim, neovim,
tmux, postgres, mysql, redis, nginx, apache, linux, macos, ubuntu, debian, aws,
github, gitlab, ssh, ssl, dns, api, rest, graphql, json, yaml, markdown, html, css,
javascript, typescript, react, vue, angular, rails, django, flask, express
```

### **Command Patterns**

Detect tools from code blocks: `git`, `docker`, `npm`, `curl`, `ssh`, etc.

### **Problem Types**

```text
troubleshooting, debugging, error, setup, configuration, installation, deployment,
performance, security, backup, migration, optimization, automation, workflow, tips
```

### **Difficulty Assessment**

- **Beginner**: Basic commands, simple setup, common solutions
- **Intermediate**: Multi-step processes, configuration changes, tool integration
- **Advanced**: Complex debugging, system administration, custom solutions

## Related

- Links to related knowledge base entries
- External resources

## Setup Requirements

1. **Environment variable**: Set `$CLAUDE_KB_PATH` in shell configuration
2. **Directory structure**: Auto-created on first use
3. **Git repository**: Initialize knowledge base as private GitHub repo for backup

## Integration Notes

- Works from any Claude Code session regardless of current working directory
- Automatically creates knowledge base structure on first use
- Suggests topics based on content analysis
- Maintains searchable index of all saved knowledge
