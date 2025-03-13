#!/usr/bin/env bash

if [[ "$1" != "" && "$1" != "skipwait" ]]; then
    echo "[ERROR] Invalid first parameter! Leave empty or use 'skipwait'."
    read -rp "Press Enter to continue..."
    exit 1
fi

echo "Initializing Elypso Engine Installer..."
echo

# Set root paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ORIGIN="$SCRIPT_DIR"
INPUT="Elypso-engine-x64-release-linux"
OUTPUT="Elypso-engine-x64-release-linux.tar.gz"

# Assigned paths
ENGINE="$ORIGIN/../../Elypso-engine/Engine"
ENGINE_LIB="$ORIGIN/../../Elypso-engine/Engine library/out/build/x64-release/libElypso engine.a"
EXTERNAL_SHARED="$ORIGIN/../../Elypso-engine/_external_shared"
INCLUDE="$ORIGIN/../../Elypso-engine/Engine/include"
RELEASE_ENGINE="$ORIGIN/../../Elypso-engine/Engine/out/build/x64-release"
RELEASE_HUB="$ORIGIN/../../Elypso-hub/out/build/x64-release"
SOURCE_GAME="$ORIGIN/../../Elypso-engine/Game"

# Individual files
LINUX_PREREQUISITES_TXT="$ORIGIN/../../Elypso-engine/Linux_prerequisites.txt"
README="$ORIGIN/../../Elypso-engine/README.md"
LICENSE="$ORIGIN/../../Elypso-engine/LICENSE.md"
LIBRARIES="$ORIGIN/../../Elypso-engine/LIBRARIES.md"
SECURITY="$ORIGIN/../../Elypso-engine/SECURITY.md"
CHANGES="$ORIGIN/../../Elypso-engine/CHANGES.txt"

# Check if assigned paths/folders exist
check_exists() {
    if [[ ! -e "$1" ]]; then
        echo "Error: Path '$1' is not valid!"
        echo
        read -rp "Press Enter to continue..."
        exit 1
    else
        echo "Success: Found path '$1'."
    fi
}

check_exists "$ENGINE"
check_exists "$ENGINE_LIB"
check_exists "$EXTERNAL_SHARED"
check_exists "$INCLUDE"
check_exists "$RELEASE_ENGINE"
check_exists "$RELEASE_HUB"
check_exists "$SOURCE_GAME"
check_exists "$LINUX_PREREQUISITES_TXT"
check_exists "$README"
check_exists "$LICENSE"
check_exists "$LIBRARIES"
check_exists "$SECURITY"
check_exists "$CHANGES"

echo "===================================================="
echo "Initialize succeeded!"
echo "===================================================="
echo

cd "$ORIGIN" || exit 1

# Clean up old archive if it exists
if [[ -f "$OUTPUT" ]]; then
    rm -f "$OUTPUT"
    echo "Deleted old tag.gz package: $OUTPUT"
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

# Copy Linux_prerequisites into target
cp -f "$LINUX_PREREQUISITES_TXT" ./
echo "Copied linux prerequisites file to 'target'."

# Copy documentation files
cp -f "$README" ./
echo "Copied readme to 'target'."
cp -f "$LICENSE" ./
echo "Copied license to 'target'."
cp -f "$LIBRARIES" ./
echo "Copied libraries to 'target'."
cp -f "$SECURITY" ./
echo "Copied security to 'target'."
cp -f "$CHANGES" ./
echo "Copied changes file to 'target'."

echo

# Copy external shared libraries
mkdir "_external_shared"
cp -rf "$EXTERNAL_SHARED"/. "_external_shared/"
rm -rf "_external_shared/Copy-dll-files.exe"
echo "Copied external shared libraries to '_external_shared'."

echo

# Copy engine release files & library
mkdir "Engine"
cp -rf "$RELEASE_ENGINE"/. "Engine/"
echo "Copied engine release files to 'Engine'."
cp -f "$ENGINE_LIB" "Engine/"
echo "Copied engine library to 'Engine'."

# Copy include files
mkdir "Engine/include"
cp -rf "$INCLUDE"/. "Engine/include/"
echo "Copied include files to 'Engine/include'."

# Clean up useless files in Engine
cd "Engine" || exit 1
rm -rf CMakeFiles cmake_install.cmake CMakeCache.txt CPackConfig.cmake CPackSourceConfig.cmake Makefile
echo "Cleaned up 'Engine'."
cd ..

echo

# Copy Hub release files, clean up
mkdir "Hub"
cp -rf "$RELEASE_HUB"/. "Hub/"
echo "Copied hub release files to 'Hub'."
cd "Hub" || exit 1
rm -rf CMakeFiles cmake_install.cmake CMakeCache.txt CPackConfig.cmake CPackSourceConfig.cmake Makefile
echo "Cleaned up 'Hub'."
cd ..

echo

# Copy Game source files, clean up
mkdir "Game"
cp -rf "$SOURCE_GAME"/. "Game/"
echo "Copied game source files to 'Game'."
cd "Game" || exit 1
rm -rf out "libElypso engine.a" "libElypso engineD.a"
echo "Cleaned up 'Game'."
cd ..

echo

# Rename 'target' to 'Elypso-engine-x64-release-linux'
cd "$ORIGIN" || exit 1
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
