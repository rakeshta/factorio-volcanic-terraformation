#!/bin/bash

# Factorio Mod Development Script
# Single entrypoint for all development tooling

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFO_JSON="${SCRIPT_DIR}/info.json"

# Read mod metadata from info.json
read_mod_info() {
    if [[ ! -f "${INFO_JSON}" ]]; then
        echo -e "${RED}Error: info.json not found at ${INFO_JSON}${NC}" >&2
        exit 1
    fi

    # Parse JSON manually (no jq dependency)
    MOD_NAME=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "${INFO_JSON}" | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
    MOD_VERSION=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "${INFO_JSON}" | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

    if [[ -z "${MOD_NAME}" ]] || [[ -z "${MOD_VERSION}" ]]; then
        echo -e "${RED}Error: Could not parse mod name or version from info.json${NC}" >&2
        exit 1
    fi

    MOD_FOLDER_NAME="${MOD_NAME}_${MOD_VERSION}"
}

# Get Factorio mods directory based on OS
get_factorio_mods_dir() {
    case "$(uname -s)" in
        Darwin*)
            echo "${HOME}/Library/Application Support/factorio/mods"
            ;;
        Linux*)
            echo "${HOME}/.factorio/mods"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            # Windows (Git Bash/Cygwin)
            if [[ -n "${APPDATA:-}" ]]; then
                echo "${APPDATA}/Factorio/mods"
            else
                echo "${HOME}/AppData/Roaming/Factorio/mods"
            fi
            ;;
        *)
            echo -e "${YELLOW}Warning: Unknown OS. Defaulting to Linux path.${NC}" >&2
            echo "${HOME}/.factorio/mods"
            ;;
    esac
}

# Show help message
show_help() {
    cat << EOF
Usage: ./mod.sh <command> [options]

Commands:
  build              Package the mod into a zip file
  link [options]     Link or copy mod to Factorio mods directory
  help               Show this help message

Link Options:
  --symlink          Create a symbolic link (default)
  --copy             Copy files instead of linking
  --unlink           Remove existing link/copy

Examples:
  ./mod.sh build
  ./mod.sh link
  ./mod.sh link --copy
  ./mod.sh link --unlink

EOF
}

# Build command: Package mod using git archive
cmd_build() {
    read_mod_info

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}Error: Not a git repository. Cannot build package.${NC}" >&2
        exit 1
    fi

    OUTPUT_FILE="${SCRIPT_DIR}/${MOD_FOLDER_NAME}.zip"

    # Remove existing zip if it exists
    if [[ -f "${OUTPUT_FILE}" ]]; then
        echo -e "${YELLOW}Removing existing ${OUTPUT_FILE}${NC}"
        rm -f "${OUTPUT_FILE}"
    fi

    echo -e "${GREEN}Building mod package: ${MOD_FOLDER_NAME}.zip${NC}"
    
    # Create zip archive using git archive
    git archive --format zip --prefix "${MOD_FOLDER_NAME}/" --output "${OUTPUT_FILE}" HEAD

    if [[ -f "${OUTPUT_FILE}" ]]; then
        FILE_SIZE=$(du -h "${OUTPUT_FILE}" | cut -f1)
        echo -e "${GREEN}✓ Successfully created ${MOD_FOLDER_NAME}.zip (${FILE_SIZE})${NC}"
    else
        echo -e "${RED}Error: Failed to create package${NC}" >&2
        exit 1
    fi
}

# Link command: Symlink or copy mod to Factorio mods directory
cmd_link() {
    read_mod_info

    FACTORIO_MODS_DIR=$(get_factorio_mods_dir)
    TARGET_DIR="${FACTORIO_MODS_DIR}/${MOD_FOLDER_NAME}"

    # Parse options
    LINK_MODE="symlink"
    UNLINK=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --symlink)
                LINK_MODE="symlink"
                shift
                ;;
            --copy)
                LINK_MODE="copy"
                shift
                ;;
            --unlink)
                UNLINK=true
                shift
                ;;
            *)
                echo -e "${RED}Error: Unknown option: $1${NC}" >&2
                echo "Use --symlink, --copy, or --unlink"
                exit 1
                ;;
        esac
    done

    # Handle unlink
    if [[ "${UNLINK}" == true ]]; then
        if [[ -e "${TARGET_DIR}" ]] || [[ -L "${TARGET_DIR}" ]]; then
            echo -e "${GREEN}Removing ${TARGET_DIR}${NC}"
            rm -rf "${TARGET_DIR}"
            echo -e "${GREEN}✓ Unlinked successfully${NC}"
        else
            echo -e "${YELLOW}No link/copy found at ${TARGET_DIR}${NC}"
        fi
        return 0
    fi

    # Check if Factorio mods directory exists
    if [[ ! -d "${FACTORIO_MODS_DIR}" ]]; then
        echo -e "${YELLOW}Factorio mods directory not found at: ${FACTORIO_MODS_DIR}${NC}"
        echo -e "${YELLOW}Creating directory...${NC}"
        mkdir -p "${FACTORIO_MODS_DIR}"
    fi

    # Handle existing link/copy
    if [[ -e "${TARGET_DIR}" ]] || [[ -L "${TARGET_DIR}" ]]; then
        echo -e "${YELLOW}Existing link/copy found at ${TARGET_DIR}${NC}"
        read -p "Remove and recreate? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 0
        fi
        rm -rf "${TARGET_DIR}"
    fi

    # Create link or copy
    if [[ "${LINK_MODE}" == "symlink" ]]; then
        echo -e "${GREEN}Creating symbolic link: ${TARGET_DIR} -> ${SCRIPT_DIR}${NC}"
        ln -s "${SCRIPT_DIR}" "${TARGET_DIR}"
        echo -e "${GREEN}✓ Linked successfully${NC}"
    else
        echo -e "${GREEN}Copying mod files to: ${TARGET_DIR}${NC}"
        mkdir -p "${TARGET_DIR}"
        # Copy files excluding .git and other development files
        rsync -av --exclude='.git' --exclude='*.zip' --exclude='.DS_Store' "${SCRIPT_DIR}/" "${TARGET_DIR}/"
        echo -e "${GREEN}✓ Copied successfully${NC}"
    fi

    echo -e "${GREEN}Mod is now available in Factorio mods directory${NC}"
}

# Main command dispatcher
main() {
    # Change to script directory
    cd "${SCRIPT_DIR}"

    # Parse command
    COMMAND="${1:-help}"

    case "${COMMAND}" in
        build)
            shift || true
            cmd_build "$@"
            ;;
        link)
            shift || true
            cmd_link "$@"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}Error: Unknown command: ${COMMAND}${NC}" >&2
            echo
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
