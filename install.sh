#!/usr/bin/env bash
# ato installer — AI Token Optimizer for Claude Code
# Usage: curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash

set -euo pipefail

REPO="https://raw.githubusercontent.com/aarjang/ato/main"
INSTALL_DIR="${ATO_INSTALL_DIR:-$HOME/bin}"
TEMPLATES_DIR="$HOME/.ato/templates"

GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

echo -e "${BOLD}Installing ato — AI Token Optimizer for Claude Code${RESET}"
echo ""

# Create dirs
mkdir -p "$INSTALL_DIR" "$TEMPLATES_DIR"

# Download ato script
echo -e "${CYAN}→${RESET} Downloading ato..."
curl -fsSL "$REPO/bin/ato" -o "$INSTALL_DIR/ato"
chmod +x "$INSTALL_DIR/ato"

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
  if ! grep -q 'ATO_TEMPLATES' "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo '# ato — AI Token Optimizer' >> "$SHELL_RC"
    echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$SHELL_RC"
    echo "export ATO_TEMPLATES=\"\$HOME/.ato/templates\"" >> "$SHELL_RC"
    echo -e "${GREEN}✓${RESET} Added to $SHELL_RC"
  fi
fi

echo ""
echo -e "${GREEN}✓ ato installed!${RESET}"
echo ""
echo "Run: source $SHELL_RC"
echo "Then: cd your-project && ato init"
echo ""
