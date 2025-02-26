#!/usr/bin/env bash

if [[ "$1" != "" && "$1" != "skipwait" ]]; then
    echo "[ERROR] Invalid first parameter! Leave empty or use 'skipwait'."
    read -rp "Press Enter to continue..."
    exit 1
fi

echo "Initializing Elypso Compiler Installer..."
echo

# Set root paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ORIGIN="$SCRIPT_DIR"
INPUT="Elypso-compiler-x64-release-linux"
OUTPUT="Elypso-compiler-x64-release-linux.tar.gz"

# Assigned paths
RELEASE_COMPILER="$ORIGIN/../../Elypso-compiler/out/build/x64-release"
CHANGES="$ORIGIN/../../Elypso-compiler/CHANGES.txt"

# Check if assigned paths/folders exist
check_exists() {
    if [[ ! -e "$1" ]]; then
        echo "Error: Path '$1' is not valid!"
        read -rp "Press Enter to continue..."
        exit 1
    else
        echo "Success: Found path '$1'."
    fi
}

check_exists "$RELEASE_COMPILER"
check_exists "$CHANGES"

echo "===================================================="
echo "Initialize succeeded!"
echo "===================================================="
echo

cd "$ORIGIN" || exit 1

# Clean up old archive if it exists
if [[ -f "$OUTPUT" ]]; then
    rm -f "$OUTPUT"
    echo "Deleted old tar.gz package: $OUTPUT"
    echo
fi

# Delete old 'target' folder if it exists, then create new
if [[ -d "target" ]]; then
    rm -rf "target"
    echo "Removed folder 'target'."
fi
mkdir "target"

echo
cd "target" || exit 1

# Copy Elypso compiler release files into target
cp -rf "$RELEASE_COMPILER"/. "./"
echo "Copied Elypso compiler release files to 'target'."

# Copy changes file into target
cp -f "$CHANGES" ./
echo "Copied changes file to 'target'."

# Clean up useless files from target folder
rm -rf CMakeFiles cmake_install.cmake CMakeCache.txt CPackConfig.cmake CPackSourceConfig.cmake Makefile
echo "Cleaned up 'target'."

echo

cd "$ORIGIN" || exit 1

# Rename 'target' to 'Elypso-compiler-x64-release-linux'
mv "target" "$INPUT"
echo "Renamed 'target' to '$INPUT'."

echo "===================================================="
echo "Setup succeeded!"
echo "===================================================="
echo

# Compress into tar.gz
tar -czvf "$OUTPUT" "$INPUT"

# Remove the uncompressed folder
rm -rf "$INPUT"

echo "===================================================="
echo "Folder successfully compressed to tar.gz file!"
echo "===================================================="
echo

# Pause if skipwait not specified
if [[ "$1" != "skipwait" ]]; then
    read -rp "Press Enter to exit..."
fi

exit 0
