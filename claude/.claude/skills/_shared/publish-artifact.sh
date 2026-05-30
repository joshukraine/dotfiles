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
if [[ -n "${repo}" && ! "${repo}" =~ ^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$ ]]; then
  warn "repo '${repo}' is not a valid <owner>/<name> — treating as undeclared"
  valid_target=0
fi
if [[ "${subfolder}" == /* || "${subfolder}" == *".."* ]]; then
  warn "subfolder '${subfolder}' is invalid — treating as undeclared"
  valid_target=0
fi

if (( valid_target == 0 )); then
  warn "no QA Publish Target declared in ${project_root}/CLAUDE.md — staying local"
  if [[ -n "${pr}" && -n "${md_fallback_only}" && -f "${md_fallback_only}" ]]; then
    gh pr comment "${pr}" --body-file "${md_fallback_only}" >/dev/null
    warn "posted Markdown-only fallback PR comment to PR #${pr}"
  fi
  exit 0
fi

dest_path="${subfolder}/$(basename "${html}")"
owner="${repo%%/*}"
repo_name="${repo#*/}"

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

pages_url="https://${owner}.github.io/${repo_name}/${dest_path}"
echo "${pages_url}"

if [[ -n "${pr}" ]]; then
  comment_file=$(mktemp)
  {
    printf '**[Open %s on Pages →](%s)**\n\n' "${label}" "${pages_url}"
    if [[ -n "${comment_body}" && -f "${comment_body}" ]]; then
      cat "${comment_body}"
    fi
  } > "${comment_file}"
  gh pr comment "${pr}" --body-file "${comment_file}" >/dev/null
  warn "posted PR comment to PR #${pr}"
fi
