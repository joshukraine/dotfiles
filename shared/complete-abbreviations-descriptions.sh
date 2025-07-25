#!/usr/bin/env bash
#
# Complete all abbreviation descriptions in abbreviations.yaml
# This script will add meaningful descriptions to all remaining abbreviations
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YAML_FILE="${SCRIPT_DIR}/abbreviations.yaml"

echo "Adding descriptions to all abbreviations in ${YAML_FILE}..."

# Create a backup
cp "${YAML_FILE}" "${YAML_FILE}.backup"

# Use yq to transform the file
yq eval '
# Function to generate description based on command
def generate_description(abbr; cmd):
  if cmd == null then abbr
  elif cmd | startswith("git ") then
    if cmd == "git add" then "Stage files for commit"
    elif cmd == "git add --all" then "Stage all changes for commit"
    elif cmd == "git add --patch" then "Interactively stage changes"
    elif cmd == "git branch" then "List or manage branches"
    elif cmd == "git branch --all" then "List all branches (local and remote)"
    elif cmd == "git branch -m" then "Rename current branch"
    elif cmd == "git branch --remote" then "List remote branches"
    elif cmd == "git commit --amend" then "Amend the last commit"
    elif cmd == "git clone" then "Clone a repository"
    elif cmd == "git cm" then "Custom commit with template"
    elif cmd == "git checkout" then "Switch branches or restore files"
    elif cmd == "git checkout -b" then "Create and switch to new branch"
    elif cmd == "git cherry-pick" then "Apply commit from another branch"
    elif cmd == "git diff" then "Show changes between commits"
    elif cmd == "git diff --cached" then "Show staged changes"
    elif cmd == "git difftool" then "Show changes using external diff tool"
    elif cmd == "git fetch" then "Download changes from remote"
    elif cmd == "git fetch --all" then "Fetch from all remotes"
    elif cmd == "git fetch --prune" then "Fetch and remove deleted remote branches"
    elif cmd == "git fetch upstream" then "Fetch from upstream remote"
    elif cmd == "git l" then "Show compact log (custom alias)"
    elif cmd == "git lg" then "Show graph log (custom alias)"
    elif cmd | startswith("git log --graph") then "Show detailed graph log with formatting"
    elif cmd == "git push" then "Upload changes to remote"
    elif cmd == "git pull" then "Download and merge changes from remote"
    elif cmd == "git push --force-with-lease" then "Force push with safety checks"
    elif cmd == "git push --tags" then "Push tags to remote"
    elif cmd == "git publish" then "Publish branch (custom command)"
    elif cmd == "git push -u origin" then "Push and set upstream to origin"
    elif cmd == "git remote add" then "Add a remote repository"
    elif cmd == "git rebase" then "Reapply commits on top of another base"
    elif cmd == "git rebase --abort" then "Cancel current rebase operation"
    elif cmd == "git rebase --continue" then "Continue rebase after resolving conflicts"
    elif cmd == "git rebase -i" then "Interactive rebase"
    elif cmd == "git reset" then "Reset current HEAD to specified state"
    elif cmd == "git remote set-url origin" then "Change origin remote URL"
    elif cmd == "git remote set-url" then "Change remote URL"
    elif cmd == "git remote add upstream" then "Add upstream remote"
    elif cmd == "git remote -v" then "Show remote repositories with URLs"
    elif cmd == "git status" then "Show working tree status"
    elif cmd == "git show" then "Show various types of objects"
    elif cmd == "git stash" then "Temporarily save changes"
    elif cmd == "git stash apply" then "Apply stashed changes"
    elif cmd == "git stash drop" then "Delete a stash"
    elif cmd == "git stash list" then "List all stashes"
    elif cmd == "git stash pop" then "Apply and remove stash"
    elif cmd == "git stash save" then "Save changes to stash with message"
    elif cmd == "git status --short" then "Show status in short format"
    elif cmd == "git tag" then "Create, list, or verify tags"
    else cmd | sub("^git "; "Git: ")
    end
  elif cmd | startswith("docker") then
    if cmd == "docker" then "Docker container management"
    elif cmd == "docker compose" then "Manage multi-container applications"
    elif cmd == "docker compose up" then "Start Docker Compose services"
    elif cmd == "docker compose up -d" then "Start services in background"
    elif cmd == "docker compose up --build" then "Build and start services"
    elif cmd == "docker compose up --build -d" then "Build and start services in background"
    elif cmd == "docker compose down" then "Stop and remove containers"
    elif cmd == "docker compose down -v" then "Stop containers and remove volumes"
    elif cmd == "docker compose exec" then "Execute command in running container"
    elif cmd == "docker compose restart" then "Restart Docker Compose services"
    elif cmd == "docker logs" then "Show container logs"
    elif cmd == "docker images" then "List Docker images"
    elif cmd == "docker network" then "Manage Docker networks"
    elif cmd == "docker ps" then "List running containers"
    elif cmd == "docker ps -a" then "List all containers"
    elif cmd == "docker system prune --all" then "Remove all unused Docker objects"
    elif cmd == "docker build" then "Build Docker image"
    elif cmd == "docker compose logs" then "Show logs for services"
    elif cmd == "docker compose logs -f" then "Follow logs for services"
    elif cmd == "docker compose ps" then "List containers for project"
    elif cmd == "docker compose pull" then "Pull latest images"
    elif cmd == "docker compose rm" then "Remove stopped containers"
    elif cmd == "docker compose start" then "Start existing containers"
    elif cmd == "docker compose stop" then "Stop running containers"
    elif cmd == "docker exec" then "Execute command in container"
    elif cmd == "docker exec -i" then "Execute interactive command"
    elif cmd == "docker exec -it" then "Execute interactive terminal session"
    elif cmd == "docker pull" then "Download Docker image"
    elif cmd == "docker rm" then "Remove containers"
    elif cmd == "docker rmi" then "Remove Docker images"
    elif cmd == "docker run" then "Create and start new container"
    elif cmd == "docker start" then "Start stopped containers"
    elif cmd == "docker stop" then "Stop running containers"
    else cmd | sub("^docker "; "Docker: ")
    end
  elif cmd | startswith("npm ") then
    cmd | sub("^npm "; "NPM: ")
  elif cmd | startswith("yarn ") then
    cmd | sub("^yarn "; "Yarn: ")
  elif cmd | startswith("bundle ") or cmd | startswith("bin/") then
    if cmd | startswith("bin/rails") then cmd | sub("^bin/rails "; "Rails: ")
    elif cmd | startswith("bin/bundle") then cmd | sub("^bin/bundle "; "Bundle: ")
    elif cmd | startswith("bundle exec") then cmd | sub("^bundle exec "; "Bundle exec: ")
    else cmd | sub("^bundle "; "Bundle: ")
    end
  elif cmd | startswith("brew ") then
    cmd | sub("^brew "; "Homebrew: ")
  elif cmd | startswith("asdf ") then
    cmd | sub("^asdf "; "ASDF: ")
  elif cmd | startswith("tmux ") then
    cmd | sub("^tmux "; "Tmux: ")
  elif cmd | startswith("tmuxinator ") then
    cmd | sub("^tmuxinator "; "Tmuxinator: ")
  elif cmd | startswith("gem ") then
    cmd | sub("^gem "; "Gem: ")
  elif cmd | startswith("pg_ctl ") then
    cmd | sub("^pg_ctl "; "PostgreSQL: ")
  elif cmd | startswith("psql ") then
    cmd | sub("^psql "; "PostgreSQL: ")
  elif cmd | startswith("defaults write") then
    "Configure macOS system setting"
  elif cmd | startswith("markdownlint") then
    cmd | sub("^markdownlint[^ ]* "; "Markdown lint: ")
  else abbr
  end;

# Transform all abbreviations
walk(
  if type == "object" and has("command") and has("description") then
    .
  elif type == "object" and (keys | length > 0) and (keys[0] | test("^[a-z0-9_]+$")) then
    to_entries | map(
      if .value | type == "string" then
        .value = {
          "command": .value,
          "description": generate_description(.key; .value)
        }
      elif .value | type == "object" and has("command") and (has("description") | not) then
        .value.description = generate_description(.key; .value.command)
      else
        .
      end
    ) | from_entries
  else
    .
  end
)
' "${YAML_FILE}" > "${YAML_FILE}.tmp"

# Replace the original file
mv "${YAML_FILE}.tmp" "${YAML_FILE}"

echo "✅ Added descriptions to all abbreviations"
echo "💾 Backup saved as: ${YAML_FILE}.backup"
echo "🔄 Run './generate-all-abbr.sh' to regenerate all files"
