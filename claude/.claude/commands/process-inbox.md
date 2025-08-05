# Process Inbox Command

Process unorganized content from the knowledge base inbox into properly
categorized topics.

## Command Usage

```bash
/process-inbox [--auto-approve]
```

## Arguments

- `--auto-approve` (optional): Automatically approve suggested
  categorizations without prompting

## Your Task

1. **Scan inbox directories**:
   - Check `$PKB_PATH/inbox/web-articles/` for article summaries
   - Check `$PKB_PATH/inbox/videos/` for video summaries
   - Check `$PKB_PATH/inbox/documents/` for document summaries
   - Check root of knowledge base for any uncategorized `.md` files

2. **Analyze each unprocessed item**:
   - **Content type**: Article summary, video notes, technical document, etc.
   - **Topic classification**: Determine best topic category (development,
     troubleshooting, tools, insights, commands)
   - **Metadata extraction**: Source URL, author, date, key themes
   - **Quality assessment**: Ensure content is well-structured and valuable

3. **Suggest categorization**:
   - **Primary topic**: Best-fit topic directory
   - **Filename**: Descriptive name with date suffix
   - **Tags**: Relevant tags for searchability
   - **Rationale**: Brief explanation of categorization choice

4. **Process and organize**:
   - Move files to appropriate `topics/{category}/` directory
   - Rename with consistent naming pattern: `descriptive-name-YYYY-MM-DD.md`
   - Preserve original source metadata and attribution
   - Add YAML frontmatter with auto-generated metadata
   - Auto-generate tags based on content analysis

5. **Update knowledge base index**:
   - Add new entries to "Recent Additions" section
   - Categorize under appropriate topic section
   - Include descriptive summary of content
   - Maintain chronological order

## Content Analysis Criteria

### Article Summaries

- **Insights category**: Industry perspectives, thought leadership, philosophy
- **Development category**: Technical tutorials, coding practices, frameworks
- **Tools category**: Tool reviews, comparisons, configuration guides

### Video Summaries

- **Insights category**: Conference talks, interviews, discussions
- **Development category**: Technical tutorials, live coding sessions
- **Troubleshooting category**: Debug sessions, problem-solving videos

### Document Summaries

- **Development category**: Technical papers, API documentation
- **Insights category**: Research papers, white papers, industry reports

## Processing Workflow

1. **Discovery**: Find all unprocessed content in inbox and root directory
2. **Analysis**: Analyze content type, themes, and value
3. **Categorization**: Suggest appropriate topic and filename
4. **User confirmation**: Present suggestions (unless `--auto-approve`)
5. **Organization**: Move files and update structure
6. **Indexing**: Update knowledge base index with new entries
7. **Cleanup**: Remove empty inbox directories

## File Naming Convention

```text
{descriptive-topic}-{source-type}-YYYY-MM-DD.md

Examples:
- dhh-ai-programming-insights-2025-08-01.md
- react-19-features-summary-2025-08-01.md
- kubernetes-troubleshooting-guide-2025-08-01.md
```

## YAML Frontmatter Template

Processed files should use this structured metadata:

```yaml
---
title: "Descriptive Title"
created: YYYY-MM-DD
source: "Original URL or source"
category: insights # or development, commands, tools, troubleshooting
tags: [auto-generated, based-on-content, technology-keywords]
difficulty: beginner # or intermediate, advanced
content_type: "article-summary" # or video-notes, document-summary
author: "Original Author"
processed: YYYY-MM-DD
---
```

## Metadata Preservation

Ensure processed files maintain:

- **Source attribution**: Original URL, author, publication
- **Processing date**: When content was captured and processed
- **Content type**: Article summary, video notes, etc.
- **Auto-generated tags**: Technology keywords and problem types

## Quality Standards

Only process content that:

- Has clear value for future reference
- Is well-structured with headings and sections
- Includes proper source attribution
- Contains actionable insights or knowledge

## Automated Tag Generation

The command will automatically generate tags by loading configuration from `$PKB_PATH/.config/tagging.yaml` and analyzing:

- **Technology keywords**: Extract from configured technology and tools lists
- **Command patterns**: Detect tools used in code blocks
- **Problem types**: Identify patterns from relevant domain categories
- **Content types**: Classify using configured content_types
- **Source information**: Extract domain or platform tags (github, youtube, medium)
- **Domain matching**: Apply appropriate domain-specific tag collections

### Tag Configuration Reference

Tags are dynamically loaded from `$PKB_PATH/.config/tagging.yaml`. The configuration supports:

#### **Multi-Domain Support**

```yaml
domains:
  technical:
    primary_tags: [development, programming, devops]
  personal:
    primary_tags: [personal-growth, research, study]
  fitness:
    primary_tags: [health, exercise, nutrition, recovery]
  biblical:
    primary_tags: [scripture, theology, devotional, study]
```

#### **Flexible Content Types**

```yaml
content_types:
  [
    article-summary,
    video-notes,
    document-summary,
    tutorial,
    guide,
    research,
    interview,
    conference-talk,
    blog-post,
  ]
```

#### **Extensible Technology Lists**

```yaml
technology:
  languages: [python, javascript, ruby, bash]
  tools: [git, docker, vim, tmux]
  platforms: [linux, macos, aws, github]
```

### Processing Benefits

- **Domain-aware tagging**: Automatically applies relevant tag collections
- **User customization**: Each KB can define its own tag vocabulary
- **Consistent classification**: Same tagging system as `/save-knowledge`
- **Easy maintenance**: Add new domains/tags without updating commands

## Configuration Setup

On first use, if `$PKB_PATH/.config/tagging.yaml` doesn't exist:

1. **Create default configuration** with basic technical tags
2. **Prompt user** to customize for their domains (fitness, biblical study, etc.)
3. **Provide examples** of domain-specific configurations

## Integration Notes

- Works with existing `/save-knowledge` command workflow
- Supports batch processing of multiple inbox items
- Maintains knowledge base consistency and structure
- Provides clear audit trail of processing decisions
- Uses same YAML frontmatter and tagging system as `/save-knowledge`
- **Shared configuration**: Both commands reference same `tagging.yaml` file
