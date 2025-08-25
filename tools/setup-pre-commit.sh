#!/usr/bin/env bash
# setup-pre-commit.sh
#
# Sets up pre-commit hooks for rad-prompt-hub contributors.
# This script installs pre-commit and configures the last_updated enforcement hook.

set -euo pipefail

echo "Setting up pre-commit hooks for rad-prompt-hub..."

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not installed."
    exit 1
fi

# Check if pip is available
if ! command -v pip3 &> /dev/null && ! python3 -m pip --version &> /dev/null; then
    echo "Error: pip is required but not available."
    exit 1
fi

# Install pre-commit if not already installed
if ! command -v pre-commit &> /dev/null; then
    echo "Installing pre-commit..."
    if command -v pip3 &> /dev/null; then
        pip3 install pre-commit
    else
        python3 -m pip install pre-commit
    fi
else
    echo "pre-commit is already installed."
fi

# Install the pre-commit hooks
echo "Installing pre-commit hooks..."
pre-commit install

echo ""
echo "✓ Pre-commit hooks installed successfully!"
echo ""
echo "The following hooks are now active:"
echo "  - check-last-updated: Ensures last_updated field is current when prompt content changes"
echo ""
echo "To test the hooks manually:"
echo "  pre-commit run --all-files"
echo ""
echo "The hooks will automatically run before each commit to validate your changes."