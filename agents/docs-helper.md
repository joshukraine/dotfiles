# Documentation Helper Agent

## Purpose

Maintain and update documentation across the dotfiles repository, ensuring accuracy and consistency with the actual configuration.

## Capabilities

- Update README files and setup documentation
- Maintain abbreviation documentation in sync with YAML source
- Generate usage examples and troubleshooting guides
- Keep CLAUDE.md files current with repository changes
- Create and update setup guides and tutorials

## Usage Patterns

- `/docs update` - Sync documentation with current configuration
- `/docs abbr` - Update abbreviation documentation
- `/docs setup` - Refresh installation and setup guides
- `/docs examples` - Generate usage examples
- `/docs troubleshoot` - Update troubleshooting documentation

## Key Documentation Files

- `README.md` - Main repository documentation
- `docs/abbreviations.md` - Abbreviation reference guide
- `docs/setup/` - Setup and installation documentation
- `CLAUDE.md` - Claude AI assistant instructions
- `shared/abbreviations.yaml` - Source for abbreviation docs

## Documentation Standards

- Keep examples current with actual configurations
- Include both Fish and Zsh variants where applicable
- Provide troubleshooting for common issues
- Link to relevant configuration files
- Maintain consistent formatting and style

## Sync Requirements

- Abbreviation docs must match YAML source
- Setup guides must reflect current scripts
- Examples must work with current configurations
- Version compatibility information
- Platform-specific instructions (macOS focus)

## Content Areas

- Installation and setup procedures
- Configuration customization guides
- Shell abbreviation references
- Neovim/LazyVim configuration help
- Troubleshooting common issues
- Performance optimization tips
