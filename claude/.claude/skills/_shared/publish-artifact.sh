#!/usr/bin/env bash
# publish-artifact.sh — publish an HTML artifact to the project's QA Publish
# Target and optionally post a PR comment with the live Pages link.
#
# Usage:
#   publish-artifact.sh --html <path> --label <text>
#                       [--pr <N>] [--comment-body <md-path>]
#                       [--md-fallback-only <md-path>]
#                       [--project-root <dir>]
#
# Reads the publish target from <project-root>/CLAUDE.md (## QA Publish Target).
# If no valid target is declared, prints a warning and — when --pr and
# --md-fallback-only are given — posts the Markdown body as a PR comment.
# When a target is valid, uploads the HTML to <repo>/<subfolder>/<basename>
# via the GitHub Contents API (create or update via SHA), prints the Pages
# URL on stdout, and — when --pr is given — posts a PR comment whose first
# line is the live link and whose remaining body is --comment-body (if any).

set -euo pipefail

die() { printf 'publish-artifact: %s\n' "$*" >&2; exit 1; }
warn() { printf 'publish-artifact: %s\n' "$*" >&2; }

html=""
label=""
pr=""
comment_body=""
md_fallback_only=""
project_root="${PWD}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --html) html="$2"; shift 2 ;;
    --label) label="$2"; shift 2 ;;
    --pr) pr="$2"; shift 2 ;;
    --comment-body) comment_body="$2"; shift 2 ;;
    --md-fallback-only) md_fallback_only="$2"; shift 2 ;;
    --project-root) project_root="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,/^set -euo/{/^#/p;}' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) die "unknown flag: $1" ;;
  esac
done

[[ -n "${html}" ]] || die "--html is required"
[[ -f "${html}" ]] || die "html file not found: ${html}"
[[ -n "${label}" ]] || die "--label is required"
[[ -d "${project_root}" ]] || die "project root not a directory: ${project_root}"
# Fail fast on missing optional-flag files — a silent skip hides typos and
# leaves callers thinking the body was posted when it wasn't.
[[ -z "${comment_body}" || -f "${comment_body}" ]] || die "--comment-body file not found: ${comment_body}"
[[ -z "${md_fallback_only}" || -f "${md_fallback_only}" ]] || die "--md-fallback-only file not found: ${md_fallback_only}"

cd "${project_root}"

claude_md="CLAUDE.md"
[[ -f "${claude_md}" ]] || die "no CLAUDE.md in ${project_root}"

# Extract the first ```yaml fence under '## QA Publish Target'.
yaml_block=$(awk '
  /^## QA Publish Target[[:space:]]*$/ { found = 1; next }
  found && /^```yaml[[:space:]]*$/ { in_yaml = 1; next }
  in_yaml && /^```/ { exit }
  in_yaml { print }
' "${claude_md}")

repo=""
subfolder=""
if [[ -n "${yaml_block}" ]]; then
  repo=$(printf '%s\n' "${yaml_block}" | awk -F': *' '/^repo:/ {print $2; exit}' | tr -d '[:space:]')
  subfolder=$(printf '%s\n' "${yaml_block}" | awk -F': *' '/^subfolder:/ {print $2; exit}' | tr -d '[:space:]')
fi

# Treat any placeholder (`<...>`) or invalid pattern as "undeclared".
valid_target=1
[[ -z "${repo}" || -z "${subfolder}" ]] && valid_target=0
[[ "${repo}" == *"<"* || "${repo}" == *">"* ]] && valid_target=0
[[ "${subfolder}" == *"<"* || "${subfolder}" == *">"* ]] && valid_target=0
# Only run the shape checks if the placeholder/empty checks above haven't
# already disqualified the target — otherwise a placeholder value emits both
# the shape warning and the "staying local" warning for the same condition.
if (( valid_target == 1 )); then
  if [[ ! "${repo}" =~ ^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$ ]]; then
    warn "repo '${repo}' is not a valid <owner>/<name> — treating as undeclared"
    valid_target=0
  fi
  if [[ "${subfolder}" == /* || "${subfolder}" == *".."* ]]; then
    warn "subfolder '${subfolder}' is invalid — treating as undeclared"
    valid_target=0
  fi
fi

if (( valid_target == 0 )); then
  warn "no QA Publish Target declared in ${project_root}/CLAUDE.md — staying local"
  if [[ -n "${pr}" && -n "${md_fallback_only}" ]]; then
    gh pr comment "${pr}" --body-file "${md_fallback_only}" >/dev/null
    warn "posted Markdown-only fallback PR comment to PR #${pr}"
  fi
  exit 0
fi

dest_path="${subfolder}/$(basename "${html}")"

# Resolve the live URL from the GitHub Pages API instead of guessing it from
# the repo name. `html_url` is a single source of truth: it already returns
# the correct base for project pages, user/org pages, AND custom-domain
# (CNAME) sites. If Pages isn't enabled we could only print a URL that won't
# resolve, so fail fast — before uploading — rather than publishing an orphan
# file with a dead link.
if ! pages_info=$(gh api "repos/${repo}/pages" 2>/dev/null); then
  die "GitHub Pages is not enabled for ${repo} — enable Pages (or fix the QA Publish Target) before publishing"
fi
pages_base=$(printf '%s' "${pages_info}" | jq -r '.html_url // empty' | sed 's:/*$::')
[[ -n "${pages_base}" ]] || die "GitHub Pages API returned no html_url for ${repo} — cannot derive a live URL"
pages_url="${pages_base}/${dest_path}"

source_repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || echo "unknown")
short_sha=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
commit_msg="publish: ${dest_path} from ${source_repo}@${short_sha}"

existing_sha=""
if existing_json=$(gh api "repos/${repo}/contents/${dest_path}" 2>/dev/null); then
  existing_sha=$(printf '%s' "${existing_json}" | jq -r '.sha // empty')
fi

content_b64=$(base64 < "${html}" | tr -d '\n')

payload_file=$(mktemp)
comment_file=""
cleanup() {
  rm -f "${payload_file}"
  [[ -n "${comment_file}" ]] && rm -f "${comment_file}"
  return 0
}
trap cleanup EXIT

if [[ -n "${existing_sha}" ]]; then
  jq -n \
    --arg message "${commit_msg}" \
    --arg content "${content_b64}" \
    --arg sha "${existing_sha}" \
    '{message: $message, content: $content, sha: $sha}' > "${payload_file}"
else
  jq -n \
    --arg message "${commit_msg}" \
    --arg content "${content_b64}" \
    '{message: $message, content: $content}' > "${payload_file}"
fi

gh api -X PUT "repos/${repo}/contents/${dest_path}" --input "${payload_file}" >/dev/null

echo "${pages_url}"

if [[ -n "${pr}" ]]; then
  comment_file=$(mktemp)
  {
    printf '**[Open %s on Pages →](%s)**\n\n' "${label}" "${pages_url}"
    if [[ -n "${comment_body}" ]]; then
      cat "${comment_body}"
    fi
  } > "${comment_file}"
  gh pr comment "${pr}" --body-file "${comment_file}" >/dev/null
  warn "posted PR comment to PR #${pr}"
fi
