#!/usr/bin/env bats

# Tests for claude/.claude/skills/_shared/publish-artifact.sh
#
# Focus: the live Pages URL is resolved from the GitHub Pages API `html_url`
# (issue #180), so it is correct for project pages, user/org pages, AND
# custom-domain (CNAME) sites — and the script fails before uploading when
# Pages is not enabled.
#
# `gh` is stubbed by a dispatcher on PATH (see setup). The stub logs every
# call to GH_CALL_LOG and captures any PR comment body to GH_PR_COMMENT_BODY,
# so tests can assert both the printed URL and what reached the PR comment.
# The Pages API is "enabled" only when GH_PAGES_FIXTURE exists on disk — each
# test copies the fixture it wants there (or leaves it absent for the
# Pages-disabled case), which keeps all state on the filesystem and out of the
# per-test subshell environment.

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  save_original_path
  load_dotfiles_variable

  SCRIPT="${DOTFILES}/claude/.claude/skills/_shared/publish-artifact.sh"

  TEST_TMPDIR=$(mktemp -d)
  export GH_CALL_LOG="${TEST_TMPDIR}/gh-calls.log"
  export GH_PR_COMMENT_BODY="${TEST_TMPDIR}/pr-comment-body.md"
  export GH_PAGES_FIXTURE="${TEST_TMPDIR}/active-pages.json"
  : > "${GH_CALL_LOG}"

  # Pages API fixtures — shapes match the real GET /repos/{repo}/pages payload.
  cat > "${TEST_TMPDIR}/pages-cname.json" <<'JSON'
{"cname":"joshukraine.com","html_url":"https://joshukraine.com/","source":{"branch":"main","path":"/"}}
JSON
  cat > "${TEST_TMPDIR}/pages-project.json" <<'JSON'
{"cname":null,"html_url":"https://euroteamoutreach.github.io/qa-walkthroughs/","source":{"branch":"main","path":"/"}}
JSON

  # A minimal HTML artifact to publish.
  HTML="${TEST_TMPDIR}/report.html"
  echo '<!doctype html><title>QA</title>' > "${HTML}"

  # gh stub: dispatches on args, records calls, never touches the network.
  STUB_BIN="${TEST_TMPDIR}/bin"
  mkdir -p "${STUB_BIN}"
  cat > "${STUB_BIN}/gh" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "${GH_CALL_LOG}"

# Upload (create/update file): gh api -X PUT repos/<repo>/contents/<path>
case " $* " in
  *" -X PUT "*) echo '{}'; exit 0 ;;
esac

case "$1" in
  api)
    case "$2" in
      */pages)
        # Pages is "enabled" only when the active fixture exists; otherwise
        # emulate the real 404 from a repo without Pages.
        if [[ -f "${GH_PAGES_FIXTURE}" ]]; then
          cat "${GH_PAGES_FIXTURE}"; exit 0
        fi
        echo "gh: Not Found (HTTP 404)" >&2; exit 1
        ;;
      */contents/*)
        # GET existing file — emulate "not present yet" (new upload).
        exit 1
        ;;
    esac
    ;;
  repo)  echo "test-owner/source-repo"; exit 0 ;;
  pr)
    # Capture the comment body so tests can inspect the live link.
    while [[ $# -gt 0 ]]; do
      if [[ "$1" == "--body-file" ]]; then cp "$2" "${GH_PR_COMMENT_BODY}"; break; fi
      shift
    done
    exit 0
    ;;
esac
exit 0
STUB
  chmod +x "${STUB_BIN}/gh"
  export PATH="${STUB_BIN}:${PATH}"
}

teardown() {
  restore_path
  rm -rf "${TEST_TMPDIR}"
}

# Mark the Pages API as enabled for the active repo, serving the given fixture.
enable_pages() {
  cp "$1" "${GH_PAGES_FIXTURE}"
}

# Write a project CLAUDE.md with a QA Publish Target block for the given
# repo/subfolder, into a fresh project root, and echo that root.
make_project_root() {
  local repo="$1" subfolder="$2"
  local root
  root=$(mktemp -d "${TEST_TMPDIR}/project.XXXXXX")
  cat > "${root}/CLAUDE.md" <<MD
# Project

## QA Publish Target

\`\`\`yaml
repo: ${repo}
subfolder: ${subfolder}
\`\`\`
MD
  echo "${root}"
}

@test "custom-domain (CNAME) repo emits the CNAME-based URL on stdout" {
  enable_pages "${TEST_TMPDIR}/pages-cname.json"
  local root
  root=$(make_project_root "joshukraine/joshukraine.github.io" "qa")

  run "${SCRIPT}" --html "${HTML}" --label "QA Report" --project-root "${root}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "https://joshukraine.com/qa/report.html" ]
  # The github.io host must never appear for a custom-domain site.
  [[ "${output}" != *"github.io"* ]]
}

@test "project-pages repo emits the project-pages URL (unchanged behavior)" {
  enable_pages "${TEST_TMPDIR}/pages-project.json"
  local root
  root=$(make_project_root "euroteamoutreach/qa-walkthroughs" "qa")

  run "${SCRIPT}" --html "${HTML}" --label "QA Report" --project-root "${root}"

  [ "${status}" -eq 0 ]
  [ "${output}" = "https://euroteamoutreach.github.io/qa-walkthroughs/qa/report.html" ]
}

@test "repo without Pages enabled dies with a clear message" {
  # No enable_pages call — the stub emulates a 404 from the Pages API.
  local root
  root=$(make_project_root "joshukraine/dotfiles" "qa")

  run "${SCRIPT}" --html "${HTML}" --label "QA Report" --project-root "${root}"

  [ "${status}" -ne 0 ]
  [[ "${output}" == *"Pages is not enabled"* ]]
}

@test "no upload happens when Pages is not enabled (fail before PUT)" {
  local root
  root=$(make_project_root "joshukraine/dotfiles" "qa")

  run "${SCRIPT}" --html "${HTML}" --label "QA Report" --project-root "${root}"

  [ "${status}" -ne 0 ]
  # The die must happen before any Contents-API upload.
  run grep -F -- "-X PUT" "${GH_CALL_LOG}"
  [ "${status}" -ne 0 ]
}

@test "PR comment links to the CNAME URL" {
  enable_pages "${TEST_TMPDIR}/pages-cname.json"
  local root
  root=$(make_project_root "joshukraine/joshukraine.github.io" "qa")

  run "${SCRIPT}" --html "${HTML}" --label "QA Report" --pr 42 --project-root "${root}"

  [ "${status}" -eq 0 ]
  [ -f "${GH_PR_COMMENT_BODY}" ]
  run grep -F "https://joshukraine.com/qa/report.html" "${GH_PR_COMMENT_BODY}"
  [ "${status}" -eq 0 ]
}
