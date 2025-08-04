# Test Drive Command

Create a test drive guide for newly implemented features, showing what's new and providing copy-paste commands to try out the functionality.

## Command Usage

```bash
/test-drive [feature-name]
```

## Arguments

- `feature-name` (optional): Name of the feature to test drive. If not provided, will be inferred from the current context.

## Examples

```bash
# Create test drive for a specific feature
/test-drive lazyvim-knowledge-search

# Auto-detect feature from current work
/test-drive
```

## Your Task

Create a comprehensive test drive markdown file in the appropriate scratchpads directory that includes:

### 1. **High-Level Feature Overview**

- Brief explanation of what's new
- Key benefits and improvements
- Problem solved

### 2. **Step-by-Step Test Commands**

- Copy-paste ready commands to try the feature
- Expected outputs and results
- Different usage scenarios

### 3. **Files Changed Summary**

- New files created
- Existing files modified
- Installation or setup steps

### 4. **Behind the Scenes**

- Technical implementation details
- Architecture decisions
- Integration points

Follow this structure and format, using the existing test-drive.md as a reference for style and comprehensiveness.

**File Location**: Create the test drive file in `scratchpads/notes/test-drive-[feature-name]-[timestamp].md`

**Important**: Make the guide immediately actionable - someone should be able to follow it step-by-step to fully experience the new feature.
