# Markdown to PDF Command

Convert Markdown files to PDF with GitHub-style formatting using the `md2pdf` tool.

## Command Options

- `$ARGUMENTS`: File paths or glob patterns to convert (e.g., `docs/guide.md`, `docs/*.md`)
- `-o FILE`: Custom output path (only valid with a single input file)

## Your task

1. **Determine input files**:
   - If `$ARGUMENTS` are provided, use them as the file paths
   - If no arguments are provided, ask the user which files to convert

2. **Run the conversion**: Execute `md2pdf` with the specified files

3. **Report results**: Confirm which PDFs were generated

## Tool Details

The `md2pdf` tool uses pandoc + weasyprint with GitHub-style CSS. The CSS and script live in dotfiles (`~/dotfiles/bin/.local/bin/`). The `MD2PDF_CSS` environment variable can override the default CSS path.

## Example Usage

```bash
# Convert a single file
/md2pdf docs/guide.md

# Convert multiple files with a glob
/md2pdf docs/qa-handoffs/qa-guide-*.md

# Convert with a custom output name
/md2pdf -o custom-name.pdf docs/guide.md
```
