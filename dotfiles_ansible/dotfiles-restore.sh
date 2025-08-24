#!/bin/bash
# Ansible-based Dotfiles Restoration System
# Run as regular user, not root!
#
# This script will:
# 1. Install Ansible if needed
# 2. Run the dotfiles restoration playbook
# 3. Handle hardware detection and user choices
#
# Usage: ./dotfiles-restore.sh [ansible-playbook options]
#   Examples:
#     ./dotfiles-restore.sh --check              # Dry run
#     ./dotfiles-restore.sh --tags packages      # Run only package installation
#     ./dotfiles-restore.sh --skip-tags gpu      # Skip GPU-related tasks

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
	echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
	echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
	echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
	echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running as root
check_not_root() {
	if [[ $EUID -eq 0 ]]; then
		log_error "This script should NOT be run as root!"
		log_info "Run as regular user: ./dotfiles-restore.sh"
		exit 1
	fi
}

# Function to install Ansible and all dependencies
ensure_ansible_installed() {
	# Check if pacman is available
	if ! command -v pacman > /dev/null 2>&1; then
		log_error "pacman not found. This script is designed for Arch Linux."
		exit 1
	fi

	# Check if all packages are installed with a single pacman command
	if pacman -Q ansible python-passlib python-bcrypt wget git openssh gnupg > /dev/null 2>&1; then
		log_success "All dependencies are already installed"
		ansible --version | head -1
		return 0
	fi

	log_info "Installing missing dependencies..."

	# Install everything in one command (--needed skips already installed packages)
	if [[ -n "${ANSIBLE_BECOME_PASS:-}" ]]; then
		# In automated environments (like Docker), use sudo with stdin
		echo "$ANSIBLE_BECOME_PASS" | sudo -S pacman -Sy --needed --noconfirm ansible python-passlib python-bcrypt wget git openssh gnupg
	else
		# In interactive environments, let sudo prompt for password
		sudo pacman -Sy --needed --noconfirm ansible python-passlib python-bcrypt wget git openssh gnupg
	fi

	# Verify Ansible installation
	if command -v ansible-playbook > /dev/null 2>&1; then
		log_success "Ansible and dependencies installed successfully"
		ansible --version | head -1
	else
		log_error "Failed to install Ansible"
		exit 1
	fi
}

# Function to download required Ansible files
ensure_ansible_files() {
	# Skip if files already exist (development mode)
	if [[ -f "dotfiles-playbook.yml" ]]; then
		log_info "Using local Ansible files"
		return 0
	fi

	log_info "Downloading Ansible files from dotfiles repository..."

	local base_url="https://raw.githubusercontent.com/coffebar/dotfiles/main/dotfiles_ansible"
	local files=(
		"dotfiles-playbook.yml"
		"tasks/system-setup.yml"
		"tasks/packages.yml"
		"tasks/dotfiles-repo.yml"
		"tasks/system-config.yml"
		"tasks/services.yml"
		"tasks/development.yml"
		"tasks/security.yml"
		"tasks/hardware-config.yml"
		"tasks/gpg-restore.yml"
		"handlers/main.yml"
	)

	local dir
	for file in "${files[@]}"; do
		dir=$(dirname "$file")
		if [[ "$dir" != "." ]]; then
			mkdir -p "$dir"
		fi

		log_info "Downloading $file..."
		if ! wget -q -O "$file" "$base_url/$file"; then
			log_error "Failed to download $file"
			exit 1
		fi
	done

	log_success "Ansible files downloaded successfully"
}

# Function to setup working directory
setup_working_directory() {
	# Determine script directory
	local script_dir
	script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

	# Check if we're in Docker testing environment
	if [[ "$script_dir" == "/opt/ansible-testing" ]]; then
		cd "$script_dir"
		log_info "Using Docker testing environment: $script_dir"
		return 0
	fi

	# If script is in production testing directory (/opt/testing), stay there
	if [[ "$script_dir" == "/opt/testing" ]]; then
		log_info "Using production testing environment: $script_dir"
		return 0
	fi

	# Check if playbook exists in current directory (development mode)
	if [[ -f "dotfiles-playbook.yml" ]]; then
		log_info "Using current directory (development mode): $PWD"
		return 0
	fi

	# Check if playbook exists in script directory
	if [[ -f "$script_dir/dotfiles-playbook.yml" ]]; then
		cd "$script_dir"
		log_info "Changed to script directory: $script_dir"
		return 0
	fi

	# Neither location has files - will need to download
	log_info "No local Ansible files found, will download from repository"
}

# Function to validate playbook exists
validate_playbook() {
	local playbook_path="dotfiles-playbook.yml"

	if [[ ! -f "$playbook_path" ]]; then
		log_error "Playbook not found: $playbook_path"
		log_info "This should have been downloaded or should exist locally"
		exit 1
	fi

	log_success "Found playbook: $playbook_path"
}

# Function to run syntax check
syntax_check() {
	log_info "Running syntax check..."
	if ansible-playbook --syntax-check dotfiles-playbook.yml; then
		log_success "Syntax check passed"
	else
		log_error "Syntax check failed"
		exit 1
	fi
}

# Main function
main() {
	echo "=========================================="
	echo "  Dotfiles Restoration System (Ansible) "
	echo "=========================================="
	echo

	# Safety checks
	check_not_root

	# Install Ansible and all dependencies
	ensure_ansible_installed

	# Setup working directory context
	setup_working_directory

	# Download Ansible files if needed
	ensure_ansible_files

	# Validate playbook
	validate_playbook

	# Run syntax check unless --skip-syntax-check is passed
	if [[ ! " $* " =~ " --skip-syntax-check " ]]; then
		syntax_check
	fi

	# Show pre-run information
	log_info "About to run dotfiles restoration with the following settings:"
	log_info "  - Hardware will be auto-detected"
	log_info "  - You'll be prompted for encryption password if needed"
	log_info "  - Package installation will be conditional based on hardware"
	log_info "  - Services will be enabled based on detected components"
	echo

	# Prompt for confirmation unless --yes is passed
	if [[ ! " $* " =~ " --yes " ]] && [[ ! " $* " =~ " --check " ]]; then
		read -p "Continue with dotfiles restoration? [y/N]: " -n 1 -r
		echo
		if [[ ! $REPLY =~ ^[Yy]$ ]]; then
			log_info "Cancelled by user"
			exit 0
		fi
	fi

	# Run the Ansible playbook
	log_info "Starting Ansible playbook execution..."
	echo "=========================================="

	# Filter out custom flags and pass remaining args to ansible-playbook
	ansible_args=()
	skip_next=false
	for arg in "$@"; do
		if [[ "$skip_next" == true ]]; then
			skip_next=false
			continue
		fi
		case $arg in
			--skip-syntax-check | --yes | --skip-credentials)
				# Skip these custom flags
				;;
			--github-username)
				# Skip this flag and its value
				skip_next=true
				;;
			*)
				ansible_args+=("$arg")
				;;
		esac
	done

	# Execute the playbook
	if ansible-playbook \
		--inventory localhost, \
		--connection local \
		--ask-become-pass \
		"${ansible_args[@]}" \
		dotfiles-playbook.yml; then

		echo
		echo "=========================================="
		log_success "Dotfiles restoration completed successfully!"
		log_info "Consider logging out and back in, or rebooting to apply all changes."
		echo "=========================================="
	else
		echo
		echo "=========================================="
		log_error "Dotfiles restoration failed!"
		log_info "Check the output above for error details."
		log_info "You can re-run with --check flag to see what would be changed."
		echo "=========================================="
		exit 1
	fi
}

# Show help if requested
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
	echo "Ansible-based Dotfiles Restoration System"
	echo
	echo "Usage: $0 [OPTIONS]"
	echo
	echo "OPTIONS:"
	echo "  --help, -h               Show this help message"
	echo "  --check                  Run in check mode (dry run)"
	echo "  --yes                    Skip confirmation prompt"
	echo "  --skip-syntax-check      Skip playbook syntax validation"
	echo "  --tags TAGS              Run only tasks with specific tags"
	echo "  --skip-tags TAGS         Skip tasks with specific tags"
	echo "  --limit HOSTS            Limit execution to specific hosts"
	echo "  --verbose, -v            Verbose output"
	echo
	echo "Examples:"
	echo "  $0                       # Interactive run with all features"
	echo "  $0 --check              # Dry run to see what would change"
	echo "  $0 --tags packages       # Install packages only"
	echo "  $0 --skip-tags gpu       # Skip GPU-related tasks"
	echo "  $0 --yes --verbose       # Non-interactive with detailed output"
	echo
	exit 0
fi

# Run main function
main "$@"