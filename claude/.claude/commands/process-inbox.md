# Process Inbox Command

Process unorganized content from the knowledge base inbox into properly categorized topics.

## Command Usage

```bash
/process-inbox [--auto-approve]
```

## Arguments

- `--auto-approve` (optional): Automatically approve suggested categorizations without prompting

## Your Task

1. **Scan inbox directories**:
   - Check `$CLAUDE_KB_PATH/inbox/web-articles/` for article summaries
   - Check `$CLAUDE_KB_PATH/inbox/videos/` for video summaries
   - Check `$CLAUDE_KB_PATH/inbox/documents/` for document summaries
   - Check root of knowledge base for any uncategorized `.md` files

2. **Analyze each unprocessed item**:
   - **Content type**: Article summary, video notes, technical document, etc.
   - **Topic classification**: Determine best topic category (development, troubleshooting, tools, insights, commands)
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
   - Add proper frontmatter if missing

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

```
{descriptive-topic}-{source-type}-YYYY-MM-DD.md

Examples:
- dhh-ai-programming-insights-2025-08-01.md
- react-19-features-summary-2025-08-01.md
- kubernetes-troubleshooting-guide-2025-08-01.md
```

## Metadata Preservation

Ensure processed files maintain:

- **Source attribution**: Original URL, author, publication
- **Processing date**: When content was captured and processed
- **Content type**: Article summary, video notes, etc.
- **Tags**: Searchable keywords and themes

## Quality Standards

Only process content that:

- Has clear value for future reference
- Is well-structured with headings and sections
- Includes proper source attribution
- Contains actionable insights or knowledge

## Integration Notes

- Works with existing `/save-knowledge` command workflow
- Supports batch processing of multiple inbox items
- Maintains knowledge base consistency and structure
- Provides clear audit trail of processing decisions
