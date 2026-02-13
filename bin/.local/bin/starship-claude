#!/usr/bin/env bash
#
# starship-claude - Use Starship for your Claude Code status line
#
# This script parses the claude code status line data to provide
# environment variables you can use in a standard Starship prompt.
#
# Formatted values (for display):
# - `CLAUDE_MODEL` - Short model name with icon (haiku/sonnet/opus)
# - `CLAUDE_MODEL_NERD` - Model with version (e.g., "󱚦 opus 4.5")
# - `CLAUDE_CONTEXT` - Context window usage percentage (left-padded, e.g., "15%")
# - `CLAUDE_COST` - Formatted session cost (e.g., "$0.71")
# - `CLAUDE_SUMMARY` - Session summary extracted from transcript
# - `CLAUDE_STAR` - Star character for prompt decoration
#
# Raw values (direct from JSON):
# - `CLAUDE_SESSION_ID` - Session UUID
# - `CLAUDE_TRANSCRIPT_PATH` - Path to session transcript JSONL
# - `CLAUDE_CWD` - Current working directory from session
# - `CLAUDE_WORKSPACE_CURRENT_DIR` - workspace.current_dir
# - `CLAUDE_WORKSPACE_PROJECT_DIR` - workspace.project_dir
# - `CLAUDE_VERSION` - Claude Code version
# - `CLAUDE_OUTPUT_STYLE` - Output style name
# - `CLAUDE_MODEL_ID` - Full model identifier (e.g., "claude-sonnet-4-5-20250929")
# - `CLAUDE_MODEL_DISPLAY_NAME` - Model display name (e.g., "Sonnet 4.5")
# - `CLAUDE_COST_RAW` - Raw cost in USD (number)
# - `CLAUDE_TOTAL_DURATION_MS` - Total session duration in ms
# - `CLAUDE_API_DURATION_MS` - Total API call duration in ms
# - `CLAUDE_LINES_ADDED` - Total lines added
# - `CLAUDE_LINES_REMOVED` - Total lines removed
# - `CLAUDE_TOTAL_INPUT_TOKENS` - Cumulative input tokens
# - `CLAUDE_TOTAL_OUTPUT_TOKENS` - Cumulative output tokens
# - `CLAUDE_CONTEXT_SIZE` - Context window size (e.g., 200000)
# - `CLAUDE_EXCEEDS_200K` - Whether session exceeds 200k tokens ("true"/"false")
# - `CLAUDE_INPUT_TOKENS` - Current usage input tokens
# - `CLAUDE_OUTPUT_TOKENS` - Current usage output tokens
# - `CLAUDE_CACHE_CREATION` - Cache creation input tokens
# - `CLAUDE_CACHE_READ` - Cache read input tokens
#
# Computed values:
# - `CLAUDE_CURRENT_TOKENS` - Sum of input + cache tokens (for context %)
# - `CLAUDE_PERCENT_RAW` - Raw percentage number (no padding)
#
# Also prints OSC 9;4 ConEmu terminal progress bar for context usage (optional)
#
# Repository: https://github.com/martinemde/starship-claude
#
# Usage:
#   Add to ~/.claude/settings.json:
#   {
#     "statusLine": {
#       "type": "command",
#       "command": "~/.local/bin/starship-claude"
#     }
#   }
#
# Options can be added to the above command:
#   --config PATH      Use custom Starship config file location
#   --path PATH        Override the path context for starship prompt
#   --no-progress      Disable terminal context progress bar
#
# MIT License
# Copyright (c) 2026 Martin Emde
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
set -o errexit -o nounset -o pipefail

# Configuration: context window progress thresholds
# I use Dex Horthy's dumb zone at 40% context usage
PROGRESS_COMPACT=80 # Percentage at which Claude Code compacts context
PROGRESS_YELLOW=40  # Warning threshold for progress bar
PROGRESS_RED=60     # Error threshold for progress bar

# Configuration: model display names
# NerdFont icons used below which may not render (esp not on GitHub)
HAIKU=" haiku"
SONNET="󰚩 sonnet"
OPUS="󱚦 opus"

# The star can help visually differentiate from other prompts.
# FYI: Official UI guidelines indicate #D97757 as Claude Orange
export CLAUDE_STAR=""

# Parse command line options
show_progress=1
starship_config=""
starship_path=""
while [ $# -gt 0 ]; do
  case "$1" in
  --no-progress)
    show_progress=0
    shift
    ;;
  --config)
    if [ $# -lt 2 ]; then
      echo "Error: --config requires a path argument" >&2
      exit 1
    fi
    starship_config="$2"
    shift 2
    ;;
  --path)
    if [ $# -lt 2 ]; then
      echo "Error: --path requires a path argument" >&2
      exit 1
    fi
    starship_path="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1" >&2
    exit 1
    ;;
  esac
done

payload="$(cat || true)"

if command -v jq >/dev/null 2>&1 && [ -n "$payload" ]; then
  #
  # Extract all values from JSON in a SINGLE jq call for performance
  # Output format: newline-separated values in a known order
  #
  jq_output="$(printf '%s' "$payload" | jq -r '
    [
      # Raw values (indexes 0-17)
      (.transcript_path // ""),                                    # 0
      (.cwd // ""),                                                 # 1
      (.workspace.current_dir // ""),                               # 2
      (.workspace.project_dir // ""),                               # 3
      (.version // ""),                                             # 4
      (.output_style.name // ""),                                   # 5
      (.model.id // ""),                                            # 6
      (.model.display_name // ""),                                  # 7
      (.cost.total_cost_usd // ""),                                 # 8
      (.cost.total_duration_ms // ""),                              # 9
      (.cost.total_api_duration_ms // ""),                          # 10
      (.cost.total_lines_added // ""),                              # 11
      (.cost.total_lines_removed // ""),                            # 12
      (.context_window.total_input_tokens // ""),                   # 13
      (.context_window.total_output_tokens // ""),                  # 14
      (if .exceeds_200k_tokens == null then "" else .exceeds_200k_tokens | tostring end), # 15
      (.session_id // ""),                                          # 16
      (.context_window.context_window_size // ""),                  # 17
      # Current usage tokens (indexes 18-21) - empty if current_usage is null
      (if .context_window.current_usage == null then "" else (.context_window.current_usage.input_tokens // 0) end), # 18
      (if .context_window.current_usage == null then "" else (.context_window.current_usage.output_tokens // 0) end), # 19
      (if .context_window.current_usage == null then "" else (.context_window.current_usage.cache_creation_input_tokens // 0) end), # 20
      (if .context_window.current_usage == null then "" else (.context_window.current_usage.cache_read_input_tokens // 0) end), # 21
      # Computed values (indexes 22-23)
      (.model.display_name // .model.id // ""),                     # 22 - raw_model
      (.workspace.current_dir // .workspace.project_dir // .cwd // "") # 23 - dir
    ] | .[]
  ')"

  # Parse jq output into an array (one element per line)
  # Initialize with defaults to handle partial/failed jq output
  values=("" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "")

  # Only parse if jq produced output
  if [ -n "$jq_output" ]; then
    if command -v mapfile >/dev/null 2>&1; then
      mapfile -t values <<<"$jq_output"
    else
      # Fallback for shells without mapfile (zsh, older bash)
      i=0
      while IFS= read -r line; do
        values[i]="$line"
        i=$((i + 1))
      done <<<"$jq_output"
    fi
  fi

  # Export raw values (use :- to handle missing array indices)
  export CLAUDE_TRANSCRIPT_PATH="${values[0]:-}"
  export CLAUDE_CWD="${values[1]:-}"
  export CLAUDE_WORKSPACE_CURRENT_DIR="${values[2]:-}"
  export CLAUDE_WORKSPACE_PROJECT_DIR="${values[3]:-}"
  export CLAUDE_VERSION="${values[4]:-}"
  export CLAUDE_OUTPUT_STYLE="${values[5]:-}"
  export CLAUDE_MODEL_ID="${values[6]:-}"
  export CLAUDE_MODEL_DISPLAY_NAME="${values[7]:-}"
  export CLAUDE_COST_RAW="${values[8]:-}"
  export CLAUDE_TOTAL_DURATION_MS="${values[9]:-}"
  export CLAUDE_API_DURATION_MS="${values[10]:-}"
  export CLAUDE_LINES_ADDED="${values[11]:-}"
  export CLAUDE_LINES_REMOVED="${values[12]:-}"
  export CLAUDE_TOTAL_INPUT_TOKENS="${values[13]:-}"
  export CLAUDE_TOTAL_OUTPUT_TOKENS="${values[14]:-}"
  export CLAUDE_EXCEEDS_200K="${values[15]:-}"
  export CLAUDE_SESSION_ID="${values[16]:-}"
  export CLAUDE_CONTEXT_SIZE="${values[17]:-}"
  export CLAUDE_INPUT_TOKENS="${values[18]:-}"
  export CLAUDE_OUTPUT_TOKENS="${values[19]:-}"
  export CLAUDE_CACHE_CREATION="${values[20]:-}"
  export CLAUDE_CACHE_READ="${values[21]:-}"

  raw_model="${values[22]:-}"
  dir="${values[23]:-}"

  # cd into workspace dir
  if [ -n "$dir" ] && [ -d "$dir" ]; then
    cd "$dir"
  fi

  #
  # Short model name: haiku / sonnet / opus (pure bash, no external commands)
  #
  if [ -n "$raw_model" ]; then
    # Lowercase using bash parameter expansion (bash 4+) or tr fallback
    if [[ "${BASH_VERSINFO[0]:-0}" -ge 4 ]]; then
      lower_model="${raw_model,,}"
    else
      lower_model="$(printf '%s' "$raw_model" | tr '[:upper:]' '[:lower:]')"
    fi

    case "$lower_model" in
    *haiku*) short_model="$HAIKU" ;;
    *sonnet*) short_model="$SONNET" ;;
    *opus*) short_model="$OPUS" ;;
    *) short_model="$raw_model" ;;
    esac

    export CLAUDE_MODEL="$short_model"
    export CLAUDE_MODEL_NERD="$short_model"

    # Extract version number using bash regex (no sed/grep)
    if [[ "$raw_model" =~ ([0-9]+)\.([0-9]+) ]]; then
      export CLAUDE_MODEL_NAME="$short_model ${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
    else
      export CLAUDE_MODEL_NAME="$short_model"
    fi
  fi

  #
  # Cost: format as $X.XX (only if we have a value)
  #
  raw_cost="${values[8]:-}"
  if [ -n "$raw_cost" ]; then
    export CLAUDE_COST="$(printf '$%.2f' "$raw_cost")"
  fi

  #
  # Session summary from transcript JSONL file
  #
  export CLAUDE_SUMMARY=""
  transcript_path="${values[0]:-}"
  if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
    summary="$(jq -rs '[.[] | select(.type == "summary")] | last | .summary // empty' "$transcript_path")"
    if [ -n "$summary" ]; then
      # Sanitize: replace newlines with spaces, collapse whitespace, trim
      summary="${summary//$'\n'/ }" # newlines to spaces
      summary="${summary//  / }"    # collapse double spaces (basic)
      summary="${summary# }"        # trim leading
      summary="${summary% }"        # trim trailing
      export CLAUDE_SUMMARY="$summary"
    fi
  fi

  #
  # Context window usage percentage
  #
  context_size="${values[17]:-}"
  input_tokens="${values[18]:-}"
  cache_creation="${values[20]:-}"
  cache_read="${values[21]:-}"

  if [ -n "$context_size" ] && [ "$context_size" != "null" ] && [ -n "$input_tokens" ]; then
    # Use 0 defaults for arithmetic when values exist but individual fields might be missing
    current_tokens=$((${input_tokens:-0} + ${cache_creation:-0} + ${cache_read:-0}))
    export CLAUDE_CURRENT_TOKENS="$current_tokens"

    if [ "$current_tokens" -gt 0 ]; then
      percent_used=$((current_tokens * 100 / context_size))
      export CLAUDE_PERCENT_RAW="$percent_used"
      export CLAUDE_CONTEXT="$(printf '%3s' "${percent_used}%")"
    else
      export CLAUDE_CONTEXT="  %"
    fi
  else
    export CLAUDE_CONTEXT="  %"
  fi
fi

# Allow overriding starship command for testing
# Set STARSHIP_CMD to use a custom command (e.g., 'env' for testing)
starship_cmd="${STARSHIP_CMD:-starship}"

# Determine Starship config path
# Priority: --config flag > default location
if [ -z "$starship_config" ]; then
  starship_config="$HOME/.claude/starship.toml"
fi

# Build starship prompt arguments
starship_args="prompt"
if [ -n "$starship_path" ]; then
  starship_args="$starship_args --path $starship_path"
fi

# Force non-zsh-style output so we don't get %{%} markers
STARSHIP_CONFIG="$starship_config" \
  STARSHIP_SHELL=sh \
  $starship_cmd $starship_args

# Terminal progress bar (OSC 9;4) - sent AFTER starship to avoid render conflicts
# Can be disabled via --no-progress flag
if [ "$show_progress" = "1" ]; then
  if [ -n "${percent_used:-}" ]; then
    # Scale progress bar: 0-PROGRESS_COMPACT% context maps to 0-100% progress
    # Claude compacts at PROGRESS_COMPACT%, so treat that as "full"
    if [ "$percent_used" -ge "$PROGRESS_COMPACT" ]; then
      progress_percent=100
    else
      progress_percent=$((percent_used * 100 / PROGRESS_COMPACT))
    fi

    # OSC 9;4 progress bar: ESC ] 9 ; 4 ; <state> ; <progress> BEL
    # State based on actual context usage:
    # 0-PROGRESS_YELLOW%: normal (state 1), PROGRESS_YELLOW-PROGRESS_RED%: warning (state 4), PROGRESS_RED%+: error (state 2)
    if [ "$percent_used" -ge "$PROGRESS_RED" ]; then
      progress_state=2 # Error
    elif [ "$percent_used" -ge "$PROGRESS_YELLOW" ]; then
      progress_state=4 # Warning
    else
      progress_state=1 # Normal
    fi
    printf '\033]9;4;%d;%d\a' "$progress_state" "$progress_percent" >/dev/tty 2>/dev/null || true
  fi
  # Don't clear progress bar when data is missing - just leave it alone
fi
