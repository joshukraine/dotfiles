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
   - Create directory structure if it doesn't exist using:

   ```bash
   mkdir -p "$CLAUDE_KB_PATH"/{.config,inbox/{web-articles,videos,documents},topics/{development,troubleshooting,commands,tools,insights},sessions}
   ```

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
├── .config/
│   └── tagging.yaml          # Tag configuration
├── README.md                 # Knowledge base overview
├── CLAUDE.md                 # Claude Code instructions
├── SETUP.md                  # Setup and configuration guide
├── inbox/                    # Unprocessed content
│   ├── web-articles/         # Article summaries to process
│   ├── videos/               # Video notes to process
│   └── documents/            # Document summaries to process
├── topics/                   # Categorized knowledge
│   ├── development/          # Programming and dev topics
│   ├── troubleshooting/      # Problem-solving entries
│   ├── commands/             # Command references
│   ├── tools/                # Tool guides and reviews
│   └── insights/             # General insights
├── sessions/                 # Session-based notes
│   └── YYYY-MM-DD-description.md
└── index.md                  # Auto-generated content index
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

The command will automatically generate tags by loading configuration from `$CLAUDE_KB_PATH/.config/tagging.yaml` and analyzing:

- **Technology keywords**: Extract from configured technology and tools lists
- **Command patterns**: Detect tools used in code blocks
- **Problem types**: Identify patterns from relevant domain categories
- **Content types**: Classify using configured content_types
- **Topic category**: Include the chosen topic as a base tag
- **Difficulty level**: Infer from complexity using configured difficulty levels

### Example Auto-Generated Tags

```yaml
# For a Docker troubleshooting entry:
tags: [docker, troubleshooting, permissions, linux, containers]

# For a Git workflow entry:
tags: [git, development, workflow, branching, collaboration]

# For a Vim configuration entry:
tags: [vim, configuration, plugins, productivity, editor]
```

## Tag Generation Configuration

Tags are loaded from `$CLAUDE_KB_PATH/.config/tagging.yaml` which should contain:

### Configuration Structure

```yaml
# Knowledge Base Tagging Configuration
version: "1.0"

# Technology & Tools
technology:
  languages: [python, javascript, typescript, ruby, bash, zsh, fish]
  tools: [git, docker, kubernetes, vim, neovim, tmux]
  platforms: [linux, macos, aws, github, gitlab]

# Content Classification
content_types: [tutorial, guide, research, troubleshooting, reference]

# Problem/Activity Types
problem_types:
  technical: [debugging, configuration, deployment, performance]
  personal: [bible-study, fitness-research, life-organization]

# Difficulty Levels
difficulty: [beginner, intermediate, advanced]

# Domain-specific Collections
domains:
  technical:
    primary_tags: [development, programming, devops]
  personal:
    primary_tags: [personal-growth, research, study]
  biblical:
    primary_tags: [scripture, theology, devotional]
```

### Tag Generation Process

1. **Load configuration**: Read `tagging.yaml` from knowledge base `.config/` directory
2. **Content analysis**: Scan content for technology keywords and patterns
3. **Domain matching**: Identify relevant domain based on content themes
4. **Tag selection**: Combine relevant tags from multiple configuration sections
5. **Difficulty assessment**: Classify complexity using configured levels

### Configuration Setup

If `tagging.yaml` doesn't exist, create it with default technical tags. Users can extend with personal domains (fitness, biblical study, etc.) as needed.

## Related

- Links to related knowledge base entries
- External resources

## Setup Requirements

1. **Environment variable**: Set `$CLAUDE_KB_PATH` in shell configuration
2. **Directory structure**: Auto-created on first use including `.config/` directory
3. **Tagging configuration**: Create `$CLAUDE_KB_PATH/.config/tagging.yaml` with desired tag vocabulary
4. **Git repository**: Initialize knowledge base as private GitHub repo for backup

## Integration Notes

- Works from any Claude Code session regardless of current working directory
- Automatically creates knowledge base structure on first use
- Suggests topics based on content analysis
- Maintains searchable index of all saved knowledge
