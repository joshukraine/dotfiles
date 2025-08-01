# Claude Code Knowledge Base Setup

A personal knowledge management system for capturing valuable insights from Claude Code sessions.

## 🎯 **System Overview**

**The Problem**: You discover useful information during Claude Code sessions, but it's hard to save and reference later, especially in tmux environments where copy/paste is cumbersome.

**The Solution**: A `/save-knowledge` slash command that automatically captures insights into a structured, searchable knowledge base.

## 🚀 **Quick Setup**

1. **Initialize the knowledge base**:

   ```bash
   setup-knowledge-base
   ```

2. **Restart your shell** (or source config):

   ```bash
   # Zsh
   source ~/.zshrc

   # Fish
   exec fish
   ```

3. **Test the system**:

   ```bash
   cdkb  # Should navigate to your knowledge base
   ```

4. **Create GitHub repository** (optional but recommended):

   ```bash
   # Create private repo on GitHub called 'claude-knowledge-base'
   cd ~/claude-knowledge-base
   git remote add origin git@github.com:yourusername/claude-knowledge-base.git
   git push -u origin main
   ```

## 📋 **Usage Examples**

### **In Any Claude Code Session**

```bash
# Save troubleshooting insights
/save-knowledge troubleshooting

# Save development tips
/save-knowledge development

# Save as timestamped session note
/save-knowledge --session-note

# Auto-detect topic
/save-knowledge
```

### **Quick Access**

```bash
cdkb                    # Go to knowledge base root
cdkb topics             # Go to topics directory
cdkb sessions           # Go to session notes
cdkb topics/development # Go to specific topic
```

## 📁 **Directory Structure**

```
~/claude-knowledge-base/
├── README.md
├── index.md (auto-generated)
├── topics/
│   ├── development/     # Development tips and solutions
│   ├── troubleshooting/ # Problem-solving insights
│   ├── commands/        # Useful commands and CLI tools
│   ├── tools/          # Tool configurations
│   └── insights/       # General learnings
└── sessions/
    └── 2025-08-01-context7-debugging.md
```

## 🔍 **Searching Your Knowledge**

```bash
# Search all knowledge
cd ~/claude-knowledge-base
rg "search term" --type md

# Search specific topic
rg "docker" topics/development/ --type md

# Search recent sessions
rg "bug fix" sessions/ --type md
```

## ⚙️ **How It Works**

1. **Environment Variable**: `$CLAUDE_KB_PATH` points to your knowledge base
2. **Slash Command**: `/save-knowledge` analyzes recent conversation and saves insights
3. **Auto-categorization**: Suggests appropriate topics based on content
4. **Structured Format**: Consistent markdown templates with metadata
5. **Git Integration**: Version control for your knowledge evolution

## 🎨 **Customization**

### **Custom Topics**

Add new topic directories:

```bash
mkdir -p ~/claude-knowledge-base/topics/security
mkdir -p ~/claude-knowledge-base/topics/databases
```

### **Environment Variable**

Change the knowledge base location:

```bash
# In your shell config
export CLAUDE_KB_PATH="/path/to/your/knowledge-base"
```

## 🔧 **Integration with Dotfiles**

**Files Added/Modified**:

- `claude/.claude/commands/save-knowledge.md` - Slash command definition
- `shared/environment.sh` - Environment variable
- `shared/environment.fish` - Fish environment variable
- `shared/abbreviations.yaml` - `cdkb` abbreviation
- `bin/setup-knowledge-base` - Setup script
- `zsh/.config/zsh/functions/cdkb` - Zsh navigation function
- `fish/.config/fish/functions/cdkb.fish` - Fish navigation function

## 💡 **Pro Tips**

1. **Session-based workflow**: Use `--session-note` for exploratory sessions, then organize insights into topics later

2. **Cross-reference**: Link related knowledge entries for better discoverability

3. **Tag system**: Use consistent tags in your knowledge entries for better searching

4. **Backup strategy**: Keep the knowledge base in a private GitHub repo for access across devices

5. **Regular review**: Periodically review and consolidate similar insights

## 🎯 **Example Workflow**

```bash
# During Claude Code session - discover something useful
"That Context7 debugging technique is brilliant!"
/save-knowledge troubleshooting

# Later, want to reference it
cdkb
rg "Context7" --type md
# Opens relevant file with saved insights
```

## 🚨 **Troubleshooting**

**Knowledge base not found**:

```bash
setup-knowledge-base  # Re-run setup
```

**cdkb command not found**:

```bash
source ~/.zshrc  # or exec fish
```

**Slash command not working**:

- Ensure you're in a Claude Code session
- Check that the command file exists: `ls ~/.claude/commands/save-knowledge.md`

Your knowledge base is now ready! Use `/save-knowledge` in any Claude Code session to start building your personal AI-assisted knowledge repository.
