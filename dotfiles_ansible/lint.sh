#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

echo "==================================="
echo "Ansible Linter - Auto-fix Mode"
echo "==================================="

if ! command -v ansible-lint &> /dev/null; then
    echo "❌ ansible-lint not found. Installing..."
    
    if command -v pip3 &> /dev/null; then
        pip3 install --user ansible-lint
    elif command -v pip &> /dev/null; then
        pip install --user ansible-lint
    else
        echo "❌ pip not found. Please install ansible-lint manually:"
        echo "  Ubuntu/Debian: sudo apt install python3-pip && pip3 install ansible-lint"
        echo "  MacOS: brew install ansible-lint"
        exit 1
    fi
    
    export PATH="$HOME/.local/bin:$PATH"
    
    if ! command -v ansible-lint &> /dev/null; then
        echo "❌ Failed to install ansible-lint"
        exit 1
    fi
    
    echo "✅ ansible-lint installed successfully"
fi

if [[ ! -f .ansible-lint ]]; then
    echo "📝 Creating default .ansible-lint configuration..."
    
    cat > .ansible-lint << 'EOF'
---
profile: production
strict: true
offline: false
parseable: true
quiet: false
verbosity: 1

kinds:
  - playbook: '*.yml'
  - playbook: '*.yaml'
  - playbook: 'playbooks/*.yml'
  - playbook: 'playbooks/*.yaml'
  - tasks: 'tasks/*.yml'
  - tasks: 'tasks/*.yaml'
  - handlers: 'handlers/*.yml'
  - handlers: 'handlers/*.yaml'
  - vars: 'vars/*.yml'
  - vars: 'vars/*.yaml'
  - defaults: 'defaults/*.yml'
  - defaults: 'defaults/*.yaml'
  - meta: 'meta/*.yml'
  - meta: 'meta/*.yaml'

exclude_paths:
  - .cache/
  - .github/
  - tests/
  - molecule/
  - .ansible-lint
  - requirements.yml

warn_list:
  - experimental
  - role-name[path]
  - schema[meta]

skip_list:
  - yaml[line-length]
  - name[template]
  - fqcn[action-core]

enable_list:
  - args
  - empty-string-compare
  - no-log-password
  - no-same-owner

mock_modules:
  - community.general.ufw
  - community.general.timezone
  - community.general.locale_gen

mock_roles: []
EOF
    
    echo "✅ Configuration created"
fi

echo ""
echo "🔧 Running ansible-lint with --fix to auto-correct issues..."
echo "-----------------------------------"

set +e
ansible_lint_output=$(ansible-lint --fix 2>&1)
lint_exit_code=$?
set -e

echo "$ansible_lint_output"

echo ""
echo "==================================="
echo "LINTING RESULTS"
echo "==================================="

if [[ $lint_exit_code -eq 0 ]]; then
    echo "✅ SUCCESS: All checks passed!"
    echo ""
    echo "Your Ansible code is clean and follows best practices."
else
    echo "❌ ERRORS FOUND: Some issues could not be auto-fixed"
    echo ""
    
    error_count=$(echo "$ansible_lint_output" | grep -c "^[^:]*:[0-9]*:" || echo "0")
    warning_count=$(echo "$ansible_lint_output" | grep -c "WARNING" || echo "0")
    
    echo "Summary: $error_count errors, $warning_count warnings"
    echo ""
    echo "Next steps:"
    echo "  1. Review the errors above"
    echo "  2. Fix them manually in your playbooks/tasks"
    echo "  3. Run this script again to verify"
    echo ""
    echo "For less strict checks, you can modify .ansible-lint"
    echo "and change 'profile: production' to 'profile: basic'"
fi

exit $lint_exit_code