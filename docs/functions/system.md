# System Functions Documentation

System utilities and command wrappers that enhance everyday terminal operations.

## Overview

System functions provide enhanced versions of common commands, file system
utilities, and macOS-specific operations. These functions improve usability
while maintaining familiar command patterns.

## Enhanced Command Wrappers

### File and Content Display

#### `cat` - Enhanced File Display

Replaces standard `cat` with `bat` for syntax highlighting and enhanced display.

```bash
# Display file with syntax highlighting
cat script.sh

# Display multiple files
cat *.md

# Read from stdin with enhanced formatting
echo "console.log('hello')" | cat
```

**Features:**

- Syntax highlighting for code files
- Line numbers and git integration
- Automatic paging for long files
- Preserves all standard `cat` functionality

#### `l`, `ll`, `la` - Enhanced Directory Listing

Modern directory listing with enhanced formatting and git status.

```bash
# Basic enhanced listing
l

# Long format with details
ll

# Show all files including hidden
la
```

**Features:**

- Uses `eza`/`exa` for enhanced output
- Git status indicators
- File type icons (with nerd fonts)
- Color-coded file types

### System Monitoring

#### `htop` - Process Viewer with Sudo

Automatically runs `htop` with elevated privileges for complete system visibility.

```bash
# Launch htop with sudo privileges
htop
```

**Features:**

- Full system process visibility
- No manual `sudo` required
- Complete process management capabilities

### Network Utilities

#### `pi` - Smart Ping Utility

Ping utility with sensible defaults and optional target override.

```bash
# Ping default target (1.1.1.1)
pi

# Ping specific target (Fish shell only)
pi google.com
pi 192.168.1.1
```

**Features:**

- Default target: Cloudflare DNS (1.1.1.1)
- Limited to 5 pings with audible alerts
- Fish version accepts custom targets
- Zsh version uses fixed target

## File System Utilities

### File Operations

#### `fs` - File/Directory Size

Cross-platform utility to determine file or directory sizes.

```bash
# Get size of current directory
fs

# Get size of specific files/directories
fs file.txt
fs directory/
fs *.log
```

**Features:**

- Cross-platform compatibility (Linux/macOS)
- Human-readable output
- Handles both files and directories

#### `dsx` - Remove .DS_Store Files

Recursively remove macOS .DS_Store files from current directory.

```bash
# Remove all .DS_Store files recursively
dsx
```

**Features:**

- Uses `fd` for fast file finding
- Shows count of removed files
- Safe operation with clear feedback

#### `sha256` - Checksum Verification

Verify file checksums against expected SHA256 values.

```bash
# Verify file checksum
sha256 expected_hash filename.zip
```

**Features:**

- Compares expected vs actual hash
- Clear success/failure output
- Handles file reading errors gracefully

### macOS Specific

#### `saf` / `haf` - Finder Hidden Files

Toggle visibility of hidden files in macOS Finder.

```bash
# Show all files in Finder
saf

# Hide hidden files in Finder
haf
```

**Features:**

- Automatically restarts Finder
- System-wide effect
- Alternative to Cmd+Shift+. keyboard shortcut

## Development Tools

### Shell Management

#### `src` - Reload Shell Configuration

Reload shell configuration for immediate effect of changes.

```bash
# Reload current shell
src
```

**Implementation:**

- **Fish**: `exec fish` (replaces current shell)
- **Zsh**: `source ~/.zshrc` (reloads configuration)

### Version Management

#### `rlv` - List Ruby Versions

Display available Ruby versions for installation via asdf.

```bash
# List installable Ruby versions
rlv
```

**Features:**

- Filters to show only stable numeric versions
- Excludes preview/RC releases
- Works with asdf version manager

### Path Utilities

#### `path` - Display PATH Entries

Display PATH environment variable in readable format.

```bash
# Show all PATH entries with line numbers
path
```

**Output Example:**

```text
1  /opt/homebrew/bin
2  /opt/homebrew/sbin
3  /usr/local/bin
4  /usr/bin
5  /bin
```

**Use Cases:**

- Debug PATH configuration issues
- Verify directory order in PATH
- Find duplicate entries

### Git Utilities

#### `g` - Smart Git Wrapper

Intelligent git command wrapper with smart defaults.

```bash
# Show git status (no arguments)
g

# Run any git command
g log --oneline
g commit -m "message"
g push origin main
```

**Behavior:**

- No arguments → `git status`
- With arguments → `git [arguments]`

## Cross-Shell Compatibility

### Implementation Details

| Function | Fish | Zsh | Implementation |
|----------|------|-----|----------------|
| `cat` | ✅ | ❌ | Fish function only |
| `htop` | ✅ | ❌ | Fish function only |
| `l`, `ll`, `la` | ✅ | ❌ | Fish functions only |
| `src` | ✅ | ✅ | Different implementations |
| `pi` | ✅ | ✅ | Different argument handling |
| `rlv` | ✅ | ✅ | Slightly different asdf syntax |
| `fs` | ✅ | ✅ | Both shells, different logic |
| `dsx` | ✅ | ✅ | Both shells |
| `path` | ✅ | ✅ | Both shells |
| `g` | ✅ | ✅ | Shared script |
| `sha256` | ✅ | ✅ | Shared script |
| `saf`/`haf` | ✅ | ❌ | Fish functions only |

### Shell-Specific Notes

**Fish-only functions** (`cat`, `htop`, `l`/`ll`/`la`, `saf`/`haf`):

- Enhanced command wrappers with modern tools
- Available when using Fish as primary shell

**Cross-shell differences**:

- `pi`: Fish accepts arguments, Zsh uses fixed target
- `src`: Fish uses `exec`, Zsh uses `source`
- `rlv`: Different asdf command syntax

## Usage Examples

### Daily Development Workflow

```bash
# Check project structure
ll                     # Enhanced directory listing

# View configuration files
cat config.yml         # Syntax highlighted display

# Monitor system resources
htop                   # Process monitor with sudo

# Check network connectivity
pi                     # Quick connectivity test

# Clean up project directory
dsx                    # Remove .DS_Store files

# Check PATH configuration
path                   # Debug environment
```

### File Management Tasks

```bash
# Analyze disk usage
fs *.log              # Check log file sizes
fs downloads/         # Check download directory size

# Verify downloaded files
sha256 abc123... file.zip  # Verify checksum

# Clean up macOS artifacts
dsx                   # Remove .DS_Store files
```

### Development Environment

```bash
# Configure shell
nvim ~/.config/fish/config.fish
src                   # Reload configuration

# Check Ruby versions
rlv                   # List available versions

# Git workflow
g                     # Check status
g add .
g commit -m "update"
```

## Troubleshooting

### Common Issues

1. **Command not found errors**

   ```bash
   # Check if function exists
   which function_name
   # Check PATH configuration
   path
   ```

2. **Fish-only functions in Zsh**

   ```bash
   # Switch to Fish shell or use alternatives
   fish
   # Or use standard commands
   /bin/cat file.txt    # Use system cat
   sudo /usr/bin/htop   # Use system htop
   ```

3. **Permission issues with system functions**

   ```bash
   # htop automatically uses sudo
   htop
   # For manual operations
   sudo command
   ```

## Related Abbreviations

System functions work with these abbreviations:

| Abbreviation | Expansion | Category |
|--------------|-----------|----------|
| `pi` | `pi` | Network |
| `path` | `path` | System |
| `src` | `src` | Shell |

See [abbreviations reference](../abbreviations.md) for complete list.

---

*System functions enhance everyday terminal operations with modern tools and
sensible defaults. They maintain familiar command patterns while providing
improved functionality.*
