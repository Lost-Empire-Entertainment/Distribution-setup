#!/usr/bin/env bash

set -e

echo "Initializing Full Installer..."
echo

# Set root paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE="$SCRIPT_DIR/engine/install.sh"
HUB="$SCRIPT_DIR/hub/install.sh"
COMPILER="$SCRIPT_DIR/compiler/install.sh"

# Check if assigned paths are valid
check_exists() {
    if [[ ! -f "$1" ]]; then
        echo "Error: Installer path '$1' is not a valid path!"
        read -rp "Press Enter to continue..."
        exit 1
    else
        echo "Success: Found installer '$1'."
    fi
}

check_exists "$ENGINE"
check_exists "$HUB"
check_exists "$COMPILER"

echo "===================================================="
echo "Initialize succeeded!"
echo "===================================================="
echo

# Install engine
if ! bash "$ENGINE" skipwait; then
    echo "Error: Engine installation failed!"
    read -rp "Press Enter to continue..."
    exit 1
fi

# Install hub
if ! bash "$HUB" skipwait; then
    echo "Error: Hub installation failed!"
    read -rp "Press Enter to continue..."
    exit 1
fi

# Install compiler
if ! bash "$COMPILER" skipwait; then
    echo "Error: Compiler installation failed!"
    read -rp "Press Enter to continue..."
    exit 1
fi

echo "===================================================="
echo "Full install succeeded!"
echo "===================================================="
echo

read -rp "Press Enter to exit..."
exit 0
