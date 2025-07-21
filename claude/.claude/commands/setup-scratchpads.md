Set up standardized scratchpad directories for temporary files, notes, and debugging.

1. **Create directories**: `mkdir -p scratchpads/{pr-reviews,planning,debugging,notes}`

2. **Update .gitignore**:
   - `echo "# Scratchpads for temporary files, notes, and debugging" >> .gitignore`
   - `echo "scratchpads/" >> .gitignore`

3. **Verify setup**:
   - `ls -la scratchpads/`
   - `git status` (confirm scratchpads ignored)

4. **Confirm completion**:
   - Show directory structure created
   - Note: Use timestamped filenames like `pr-review-123-20250721.md`
