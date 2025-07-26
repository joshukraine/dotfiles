# Security Policy

## Supported Versions

This dotfiles repository provides security updates for the current release branch only:

| Version | Supported |
| ------- | --------- |
| Current | ✅        |

## Security Overview

This repository contains personal dotfiles and configuration for development environments. While it doesn't handle sensitive user data directly, security is important for:

- **Dependency management**: Ensuring packages and tools are free from known vulnerabilities
- **Script safety**: Shell scripts and configurations should not introduce security risks
- **Secret management**: Preventing accidental inclusion of secrets or credentials

## Automated Security Measures

### Dependency Scanning

- **Homebrew packages**: Automated vulnerability scanning via GitHub Actions
- **Node.js dependencies**: npm audit integration where applicable
- **Weekly updates**: Automated dependency update PRs with security patches

### Code Scanning

- **Shell script validation**: Comprehensive shellcheck integration
- **Configuration validation**: Multi-validator framework for configuration integrity
- **Repository scanning**: Automated checks for potential secret exposure

## Reporting a Vulnerability

If you discover a security vulnerability in this dotfiles repository, please report it responsibly:

### For Security Issues

1. **DO NOT** create a public GitHub issue for security vulnerabilities
2. **Email**: Send details to the repository maintainer privately
3. **Include**: Detailed description, steps to reproduce, potential impact

### For General Issues

- **GitHub Issues**: Use for non-security bugs and feature requests
- **Pull Requests**: Submit fixes and improvements via standard PR process

## Response Timeline

- **Initial response**: Within 48 hours
- **Severity assessment**: Within 1 week
- **Resolution timeline**: Depends on severity
  - **Critical**: Within 1 week
  - **High**: Within 2 weeks
  - **Medium/Low**: Within 1 month

## Security Best Practices

### For Contributors

- **Never commit secrets**: API keys, tokens, passwords, or sensitive data
- **Use environment variables**: For any configuration requiring sensitive values
- **Review dependencies**: Understand what packages you're adding
- **Test thoroughly**: Ensure changes don't introduce security vulnerabilities

### For Users

- **Review before use**: Understand what these dotfiles do before installing
- **Customize safely**: Add personal configurations in `*.local` files
- **Keep updated**: Use automated update workflows or manual updates regularly
- **Environment separation**: Consider separate configurations for different security contexts

## Dependency Management

### Homebrew Packages

- **Vulnerability scanning**: Automated checks with `brew audit --vulnerabilities`
- **Update process**: Weekly automated updates via GitHub Actions
- **Review required**: All dependency updates are reviewed before merge

### Shell Scripts and Functions

- **Static analysis**: All shell scripts validated with shellcheck
- **Function testing**: Comprehensive test suite for git functions and utilities
- **Safe practices**: Scripts designed to fail safely and avoid destructive operations

## Security Configuration

### Git Configuration

- **Signed commits**: Support for GPG signing (user-configurable)
- **Safe defaults**: Secure git configurations and aliases
- **Personal data**: No personal information committed to repository

### SSH and GPG

- **No private keys**: Repository contains no private keys or certificates
- **Configuration only**: SSH/GPG configurations are templates only
- **User responsibility**: Users must generate and manage their own keys

## Incident Response

### In Case of Compromise

1. **Assess impact**: Determine what may have been exposed
2. **Revoke credentials**: Rotate any potentially compromised secrets
3. **Update repository**: Remove or fix vulnerable configurations
4. **Notify users**: Issue security advisory if user action is required

### Recovery Process

1. **Clean installation**: Backup and clean install of affected configurations
2. **Credential rotation**: Generate new SSH keys, GPG keys, API tokens as needed
3. **Monitoring**: Watch for unusual activity in connected accounts/services

## Contact Information

- **Repository**: [github.com/joshukraine/dotfiles](https://github.com/joshukraine/dotfiles)
- **Issues**: Use GitHub issues for non-security matters
- **Security**: Contact repository maintainer directly for security issues

## Updates to This Policy

This security policy may be updated periodically. Major changes will be communicated via:

- Repository release notes
- Commit messages using conventional commit format
- Updated documentation

---

**Note**: This repository is personal dotfiles for development environment setup. While security is taken seriously, this is not a production application or service. Use at your own discretion and customize for your security requirements.

_Last updated: 2025-07-22_
