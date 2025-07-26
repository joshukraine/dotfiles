# Tmux Functions Documentation

Complete guide to tmux session management functions for efficient terminal multiplexing.

## Overview

These functions provide a comprehensive workflow for tmux session management, from creation and attachment to configuration reloading. All functions work seamlessly whether you're inside or outside of tmux.

## Session Management Functions

### Core Session Functions

#### `tat` - Smart Session Attach/Create

The most versatile tmux function for session management.

```bash
# Create/attach session named after current directory
tat

# Create/attach session with custom name
tat myproject

# Works from any directory, handles existing sessions gracefully
```

**Features:**

- Automatic session naming from current directory (dots → dashes)
- Works both inside and outside tmux
- Creates session if it doesn't exist, attaches if it does
- Switches between sessions when already in tmux

#### `tna` - Simplified Session Attach/Create

Streamlined version of `tat` for quick session management.

```bash
# Create/attach session for current directory
tna
```

**Features:**

- Always uses current directory name
- Simpler implementation than `tat`
- No custom session name option

### Session Control Functions

#### `ta` - Attach to Existing Session

Attach to a specific existing session by name.

```bash
# Attach to existing session
ta work-project
ta personal
```

**Behavior:** Fails if session doesn't exist (use `tat`/`tna` to create)

#### `tn` - Create New Session

Create a new session with a specific name.

```bash
# Create new session
tn project-alpha
tn debugging-session
```

**Behavior:** Fails if session with same name already exists

#### `tk` - Kill Specific Session

Remove a specific tmux session by name.

```bash
# Kill specific session
tk old-project
tk completed-work
```

**Behavior:** Terminates session and all its windows, fails gracefully if session doesn't exist

#### `tka` - Kill All Sessions

Remove all active tmux sessions.

```bash
# Kill all sessions
tka
```

**Behavior:** Safely handles case when no sessions exist, effectively stops tmux server

### Configuration Management

#### `tsrc` - Reload Configuration

Reload tmux configuration without restarting.

```bash
# Reload tmux config
tsrc
```

**Behavior:** Sources `~/.tmux.conf` for current session, applies changes immediately

## Workflow Examples

### Development Project Workflow

```bash
# Start working on a project
cd ~/projects/my-app
tat                    # Create/attach session for "my-app"

# Work in multiple windows/panes
# ... development work ...

# Switch to different project
cd ~/projects/other-app
tat                    # Switch to "other-app" session

# End of day cleanup
tka                    # Kill all sessions
```

### Session Management Workflow

```bash
# Create multiple named sessions
tn work
tn personal
tn learning

# List active sessions
tmux list-sessions

# Switch between sessions
ta work
ta personal

# Kill specific completed session
tk learning

# Kill all when done
tka
```

### Configuration Update Workflow

```bash
# Edit tmux configuration
nvim ~/.tmux.conf

# Reload configuration without restart
tsrc

# Changes take effect immediately
```

## Function Comparison

| Function | Purpose              | Arguments     | Creates Session | Inside Tmux Behavior  |
| -------- | -------------------- | ------------- | --------------- | --------------------- |
| `tat`    | Smart attach/create  | Optional name | Yes             | Switches to session   |
| `tna`    | Simple attach/create | None          | Yes             | Attaches to session   |
| `ta`     | Attach only          | Required name | No              | Attaches to session   |
| `tn`     | Create only          | Required name | Yes             | Creates and attaches  |
| `tk`     | Kill session         | Required name | No              | N/A                   |
| `tka`    | Kill all sessions    | None          | No              | N/A                   |
| `tsrc`   | Reload config        | None          | No              | Reloads configuration |

## Related Abbreviations

The following abbreviations complement tmux functions:

| Abbreviation | Expansion           | Description   |
| ------------ | ------------------- | ------------- |
| `tl`         | `tmux ls`           | List sessions |
| `tlw`        | `tmux list-windows` | List windows  |

See [abbreviations reference](../abbreviations.md) for complete list.

## Integration with Tmuxinator

For complex session layouts, these functions work alongside tmuxinator:

```bash
# Tmuxinator abbreviations
mux                    # tmuxinator command
ms project-name       # tmuxinator start

# Standard session functions
tat project-name      # Simple session for same project
tk project-name       # Clean up when done
```

## Troubleshooting

### Common Issues

1. **Session already exists error with `tn`**

   ```bash
   # Use tat instead for attach/create behavior
   tat session-name
   ```

2. **Can't find session with `ta`**

   ```bash
   # List sessions to see available names
   tmux list-sessions
   # Or use tat to create if needed
   tat session-name
   ```

3. **Configuration changes not taking effect**

   ```bash
   # Reload configuration
   tsrc
   # Or restart tmux completely
   tka && tmux
   ```

## Advanced Usage

### Session Naming Conventions

```bash
# Project-based naming
tat api-server
tat frontend-app
tat database-work

# Feature-based naming
tat user-auth
tat payment-integration
tat bug-fixes

# Environment-based naming
tat dev-env
tat staging-tests
tat prod-monitoring
```

### Scripted Session Management

```bash
#!/bin/bash
# Daily startup script

# Kill any existing sessions
tka

# Start main work sessions
tat main-project
tat side-project
tat monitoring

# Attach to primary session
ta main-project
```

---

_Tmux functions provide a complete session management workflow. For tmux configuration and advanced features, see the main tmux documentation._
