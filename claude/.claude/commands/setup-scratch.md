# Setup Scratchpad Command

Initialize standardized scratchpad directories for temporary files, notes, and
debugging across all projects.

## Your task

1. **Create directory structure**:

   ```bash
   mkdir -p scratchpads/{pr-reviews,planning,debugging,notes}
   ```

2. **Update .gitignore**:

   ```bash
   echo "# Scratchpads for temporary files, notes, and debugging" >> .gitignore
   echo "scratchpads/" >> .gitignore
   ```

3. **Create CLAUDE.md for AI agent context**:

   Create a file named `scratchpads/CLAUDE.md` with the following content:

   ```markdown
   # Scratchpads Directory Guide

   This directory contains temporary files that are git-ignored and never committed.

   ## Directory Purpose

   - **pr-reviews/**: Pull request reviews and analysis
   - **planning/**: Brainstorming, rough ideas, and meeting notes
   - **debugging/**: Debug sessions and troubleshooting
   - **notes/**: General development notes and research

   ## When Agent OS is Present

   If this project also has a `.agent-os/` directory:

   - **Use scratchpads/planning/** for:
     - Initial brainstorming and ideation
     - Rough drafts and exploration
     - Meeting notes and discussions
     - Ideas that may not become formal specs

   - **Use .agent-os/specs/** for:
     - Formal feature specifications
     - Structured development plans
     - Committed, trackable documentation
     - Specs ready for execution

   ## Workflow

   | Temporary             | →   | Permanent        | →   | Code           |
   | --------------------- | --- | ---------------- | --- | -------------- |
   | scratchpads/planning/ | →   | .agent-os/specs/ | →   | implementation |

   ## File Naming

   Always use descriptive, timestamped filenames:

   - `auth-system-brainstorm-20250809.md`
   - `meeting-notes-api-design-20250809.md`
   - `pr-review-123-20250809-142300.md`
   ```

4. **Verify setup**:
   - Run `ls -la scratchpads/` to confirm structure
   - Confirm CLAUDE.md was created in scratchpads/
   - Run `git status` to confirm scratchpads are ignored

5. **Explain the structure** to the user:

   ```text
   scratchpads/
   ├── CLAUDE.md       # AI agent context and guidelines
   ├── pr-reviews/     # Pull request reviews and analysis
   ├── planning/       # Project planning and roadmaps
   ├── debugging/      # Debug sessions and troubleshooting
   └── notes/         # General development notes and research
   ```

## Naming Convention

Explain to users that scratchpad files should follow these patterns:

- **Include timestamps**: `pr-review-123-20250721-211241.md`
- **Use descriptive names**: `phase-3-planning-20250721.md`
- **Keep organized** by date and purpose

## Benefits

- **Safe**: Never accidentally committed (ignored by git)
- **Organized**: Consistent structure across all projects
- **Discoverable**: Easy to find previous work and context
- **Collaborative**: Clear convention when working with others

## Integration Notes

- This command is automatically referenced by other workflows
- Should be offered after basic project initialization
- Works seamlessly with existing git repositories
- Can be run multiple times safely (idempotent)

## Example Output

Show the user what was created:

```text
✅ Scratchpad directories created:
   - scratchpads/pr-reviews/
   - scratchpads/planning/
   - scratchpads/debugging/
   - scratchpads/notes/

✅ CLAUDE.md created with AI agent guidelines

✅ Added to .gitignore (will not be committed)

📝 Use timestamped filenames like: pr-review-123-20250721-211241.md
```
