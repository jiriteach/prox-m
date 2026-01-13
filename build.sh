#!/bin/bash
# ProxMorph SASS Build Script
# Compiles all theme SCSS files to CSS

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SASS_DIR="${SCRIPT_DIR}/sass"
THEMES_DIR="${SCRIPT_DIR}/themes"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}ProxMorph SASS Builder${NC}"
echo ""

# Check if sass is installed
if ! command -v sass &> /dev/null; then
    echo -e "${RED}Error: sass is not installed${NC}"
    echo ""
    echo "Install with one of:"
    echo "  npm install -g sass"
    echo "  apt install sassc"
    echo "  brew install sass/sass/sass"
    exit 1
fi

# Create themes directory if it doesn't exist
mkdir -p "$THEMES_DIR"

# Find and compile all theme SCSS files
theme_count=0
for scss_file in "${SASS_DIR}"/themes/theme-*.scss; do
    if [[ -f "$scss_file" ]]; then
        filename=$(basename "$scss_file" .scss)
        output_file="${THEMES_DIR}/${filename}.css"
        
        echo -e "${YELLOW}Compiling:${NC} ${filename}.scss"
        
        if sass "$scss_file" "$output_file" --style=expanded --no-source-map 2>&1; then
            echo -e "${GREEN}  → ${NC}${output_file}"
            ((theme_count++))
        else
            echo -e "${RED}  Failed to compile ${filename}.scss${NC}"
        fi
    fi
done

echo ""
if [[ $theme_count -eq 0 ]]; then
    echo -e "${YELLOW}No theme files found in ${SASS_DIR}/themes/${NC}"
    echo ""
    echo "To create a new theme:"
    echo "  1. Copy sass/_template.scss to sass/themes/theme-yourname.scss"
    echo "  2. Edit the variables"
    echo "  3. Run this script again"
else
    echo -e "${GREEN}Built ${theme_count} theme(s) successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Review the generated CSS in themes/"
    echo "  2. Run ./install.sh install to apply"
fi
