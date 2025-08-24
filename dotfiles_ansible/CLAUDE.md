# Claude Code Instructions

## Project Overview
This is an Ansible project for managing dotfiles and system configuration.

## Important: Linting Requirements

**ALWAYS run the linter after creating or modifying ANY Ansible files:**

```bash
./lint.sh
```

This script will:
- Auto-fix common issues with `--fix` flag
- Report any remaining errors that need manual fixing
- Ensure code follows Ansible best practices (production profile)

## Linting Rules

The project uses strict production-level linting with:
- Production profile for enterprise-ready code
- Auto-fixing enabled for common issues
- Best practice enforcement for security and maintainability

## Required Actions

1. **After creating any new playbook, task, or role:** Run `./lint.sh`
2. **After editing existing Ansible files:** Run `./lint.sh`
3. **Before considering any task complete:** Ensure `./lint.sh` passes with no errors

## File Structure

- Playbooks should go in the root directory or `playbooks/` directory
- Tasks should go in `tasks/` directory
- Variables should go in `vars/` directory
- Handlers should go in `handlers/` directory
- Defaults should go in `defaults/` directory

## Notes

- The linter configuration is in `.ansible-lint`
- The linter uses the production profile for strict checking
- Some rules like line length and templated names are relaxed
- Core Ansible modules can use short form (fqcn not required)