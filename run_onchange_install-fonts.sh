#!/bin/bash
# ============================================================================
# Install Nerd Fonts (MesloLGS)
# This script runs automatically when it changes
# ============================================================================

echo "→ Installing MesloLGS Nerd Font..."

# Create fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# Download and install MesloLGS
cd ~/.local/share/fonts

# Check if already installed
if [[ -f "MesloLGS NF Regular.ttf" ]]; then
    echo "✓ MesloLGS Nerd Font already installed"
else
    echo "  Downloading MesloLGS Nerd Font..."
    wget --show-progress https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip

    if [[ $? -eq 0 ]]; then
        echo "  Extracting fonts..."
        unzip -o -q Meslo.zip
        rm Meslo.zip
        echo "  Refreshing font cache..."
        fc-cache -fv > /dev/null 2>&1
        echo "✅ MesloLGS Nerd Font installed successfully"
    else
        echo "❌ Failed to download MesloLGS Nerd Font"
        exit 1
    fi
fi
