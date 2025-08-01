# Context7 MCP Server Connection Issues

This document explains how to troubleshoot Context7 MCP server connection failures in Claude Code.

## Problem Description

The Context7 MCP server shows as "failed" in the `/mcp` interface after working in Claude Code for a while. Restarting Claude Code fixes the issue temporarily, but it returns after extended usage.

## Most Common Causes

1. **Memory/Resource Issues**: Long-running sessions can cause memory leaks or resource exhaustion in the MCP server
2. **Connection Timeout**: The server may have timeout settings that disconnect after periods of inactivity
3. **Node.js Process Issues**: If Context7 is Node.js-based, the process might be crashing due to unhandled errors
4. **File Handle Limits**: Extended usage might exhaust available file descriptors

## Troubleshooting Steps

### 1. Check MCP Server Logs

```bash
# Follow the tip shown in Claude Code interface
claude --debug

# Or check the log files directly
ls -la ~/Library/Caches/claude-cli-nodejs/*Users*dotfiles*/
```

### 2. Restart Just the MCP Server

Instead of restarting all of Claude Code, try:

```bash
# From the /mcp interface, select the failed server and restart it
# Or use Claude CLI if available:
claude mcp restart context7
```

### 3. Check Context7 Configuration

Look at your MCP configuration (likely in `.claude/config.json` or similar):

- Verify connection settings
- Check for timeout configurations
- Look for memory/resource limits

### 4. Monitor Resource Usage

```bash
# Check if Context7 process is still running
ps aux | grep context7

# Monitor memory usage during Claude Code sessions
top -o mem | grep context7
```

## Potential Solutions

1. **Add automatic restart logic** to your MCP configuration
2. **Increase timeout values** if they're too aggressive
3. **Monitor and report** this to Context7 maintainers as a bug
4. **Use connection keepalive** settings if available

## Next Steps

The logs from `claude --debug` will be most helpful in diagnosing the exact failure reason. Examine the log files for:

- Error messages when Context7 disconnects
- Memory usage patterns
- Connection timeout warnings
- Process crash indicators

## Log Analysis - FINDINGS

### Primary Issues Identified

1. **Authentication Problems**:
   - `"No token data found"` repeatedly throughout sessions
   - `"Dynamic client registration failed: HTTP 404"` errors
   - `"SDK auth error"` when trying to connect to Context7

2. **Connection Instability**:
   - `"transport closed"` errors after ~60 seconds of connection
   - `"SSE stream disconnected: TypeError: terminated"` indicating stream failures

3. **Session Management Issues**:
   - Multiple connection attempts within same session
   - Connection succeeds but then fails quickly

### Pattern Analysis

**Timeline Pattern:**

- Initial connection succeeds (~900ms-1000ms)
- Runs for approximately 1 minute
- Then fails with "transport closed" or SSE disconnection
- Repeated authentication failures when trying to reconnect

**Critical Error:**

```
"SSE stream disconnected: TypeError: terminated"
at file:///Users/joshukraine/.asdf/installs/nodejs/23.11.0/lib/node_modules/@anthropic-ai/claude-code/cli.js
```

### Immediate Action Items

**UPDATED ANALYSIS**: Context7 works in new sessions but fails in long-running ones - this is a **session lifecycle issue**.

1. **Test Token Refresh**: Try removing and re-adding Context7 in the same session:

   ```bash
   claude mcp remove context7
   claude mcp add --transport http context7 https://mcp.context7.com/mcp
   ```

2. **Monitor Session Duration**: Time exactly when Context7 fails (likely ~60 seconds)

3. **Test Alternative Transport**: Try WebSocket transport instead of HTTP:

   ```bash
   claude mcp remove context7
   # Check Context7 docs for WebSocket endpoint if available
   ```

4. **Report to Context7**: This appears to be a token TTL issue in their HTTP MCP implementation

### Test Results - CONFIRMED BUG

- ✅ Context7 service is healthy (works in new sessions)
- ❌ Authentication tokens expire after ~1 minute in long sessions
- ❌ Claude Code doesn't properly refresh expired Context7 tokens
- **🚨 CRITICAL**: Removing/re-adding Context7 externally doesn't fix failed connections in running Claude Code sessions
- **🚨 CONFIRMED**: This is a Claude Code session state management bug, not a Context7 issue

### Bug Report Summary

**Issue**: Claude Code MCP sessions don't refresh expired authentication tokens or reload external MCP configuration changes.

**Evidence**:

1. Context7 works perfectly in new Claude Code sessions
2. Connections fail after ~60 seconds (token expiry)
3. External MCP reconfigurations don't affect running sessions
4. Only restarting Claude Code fixes the issue

**Recommendation**: Add findings to existing issue #3323 in Claude Code repository.

### GitHub Comment Template for Issue #3323

```markdown
I'm experiencing the same issue with additional findings:

**Key differences:**

- My timeout is ~1 minute (vs 10 minutes reported)
- Removing/re-adding Context7 externally doesn't fix failed connections in running sessions

**Evidence of Claude Code session state bug:**

- Context7 works perfectly in new Claude Code sessions
- External `claude mcp remove/add` doesn't affect running sessions
- `/mcp` shows cached "failed" state even after external reconfig
- Only restarting Claude Code fixes the issue

This confirms it's a Claude Code session lifecycle management bug, not a Context7 issue.
```
