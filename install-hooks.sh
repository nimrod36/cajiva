#!/bin/bash

# Git Hooks Installer Script
# Automates the installation of Git hooks into a local repository
# Based on BDD specification in specs/git-hooks-installer/git-hooks-installer.feature

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory (where hooks are stored)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="${SCRIPT_DIR}/hooks"

# Target directory for hooks
GIT_DIR="${SCRIPT_DIR}/.git"
GIT_HOOKS_DIR="${GIT_DIR}/hooks"

# Hooks to install
HOOKS=("pre-commit" "pre-push")

# Print error message and exit
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Print success message
success_msg() {
    echo -e "${GREEN}$1${NC}"
}

# Print warning message
warning_msg() {
    echo -e "${YELLOW}$1${NC}"
}

# Check if .git directory exists
check_git_directory() {
    if [ ! -d "$GIT_DIR" ]; then
        error_exit "Repository does not contain a .git directory. Please run this script from the root of a Git repository."
    fi
}

# Check if hooks library exists and contains required hooks
check_hooks_library() {
    if [ ! -d "$HOOKS_DIR" ]; then
        error_exit "Hooks library directory not found at: $HOOKS_DIR"
    fi

    for hook in "${HOOKS[@]}"; do
        if [ ! -f "${HOOKS_DIR}/${hook}" ]; then
            error_exit "Hooks library does not contain required script: $hook"
        fi
    done
}

# Check write permissions
check_permissions() {
    if [ ! -w "$GIT_HOOKS_DIR" ]; then
        error_exit "Insufficient permissions to write to .git/hooks/ directory"
    fi
}

# Check if any hooks already exist
check_existing_hooks() {
    local existing_hooks=()
    
    for hook in "${HOOKS[@]}"; do
        if [ -f "${GIT_HOOKS_DIR}/${hook}" ]; then
            existing_hooks+=("$hook")
        fi
    done
    
    if [ ${#existing_hooks[@]} -gt 0 ]; then
        warning_msg "The following hooks already exist: ${existing_hooks[*]}"
        echo -n "Do you want to overwrite them? (y/N): "
        read -r response
        
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Installation aborted by user."
            exit 0
        fi
    fi
}

# Install hooks
install_hooks() {
    echo "Installing Git hooks..."
    
    for hook in "${HOOKS[@]}"; do
        cp "${HOOKS_DIR}/${hook}" "${GIT_HOOKS_DIR}/${hook}"
        chmod +x "${GIT_HOOKS_DIR}/${hook}"
        success_msg "✓ Installed and made executable: $hook"
    done
}

# Main installation process
main() {
    echo "Git Hooks Installation Script"
    echo "=============================="
    echo ""
    
    # Perform pre-installation checks
    check_git_directory
    check_hooks_library
    check_permissions
    check_existing_hooks
    
    # Install the hooks
    install_hooks
    
    echo ""
    success_msg "✓ Git hooks installed successfully!"
    echo "The following hooks are now active:"
    for hook in "${HOOKS[@]}"; do
        echo "  - $hook"
    done
    echo ""
    echo "Note: To skip hooks temporarily, use: SKIP_HOOKS=1 git commit"
}

# Run main function
main
