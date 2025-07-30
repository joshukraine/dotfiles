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

3. **Verify setup**:
   - Run `ls -la scratchpads/` to confirm structure
   - Run `git status` to confirm scratchpads are ignored

4. **Explain the structure** to the user:

   ```text
   scratchpads/
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

✅ Added to .gitignore (will not be committed)

📝 Use timestamped filenames like: pr-review-123-20250721-211241.md
```
