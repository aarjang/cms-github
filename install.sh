#!/usr/bin/env bash
# CMS installer
# Usage: curl -fsSL https://raw.githubusercontent.com/aarjang/cms/main/install.sh | bash

set -euo pipefail

REPO="https://raw.githubusercontent.com/aarjang/cms/main"
INSTALL_DIR="${CMS_INSTALL_DIR:-$HOME/bin}"
TEMPLATES_DIR="$HOME/.cms/templates"

GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

echo -e "${BOLD}Installing CMS — Context Management System${RESET}"
echo ""

# Create dirs
mkdir -p "$INSTALL_DIR" "$TEMPLATES_DIR"

# Download cms script
echo -e "${CYAN}→${RESET} Downloading cms..."
curl -fsSL "$REPO/bin/cms" -o "$INSTALL_DIR/cms"
chmod +x "$INSTALL_DIR/cms"

# Download templates
echo -e "${CYAN}→${RESET} Downloading templates..."
for file in CONTEXT.md TASKS.md DECISIONS.md CLAUDE.md; do
  curl -fsSL "$REPO/templates/$file" -o "$TEMPLATES_DIR/$file"
done

# Add to PATH if needed
SHELL_RC=""
if [[ "$SHELL" == *"zsh"* ]]; then
  SHELL_RC="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
  SHELL_RC="$HOME/.bashrc"
fi

if [[ -n "$SHELL_RC" ]]; then
  if ! grep -q 'CMS_TEMPLATES' "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo '# CMS — Context Management System' >> "$SHELL_RC"
    echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$SHELL_RC"
    echo "export CMS_TEMPLATES=\"\$HOME/.cms/templates\"" >> "$SHELL_RC"
    echo -e "${GREEN}✓${RESET} Added to $SHELL_RC"
  fi
fi

echo ""
echo -e "${GREEN}✓ CMS installed!${RESET}"
echo ""
echo "Run: source $SHELL_RC"
echo "Then: cd your-project && cms init"
echo ""
