#!/bin/bash

set -e

echo "💾 Backing up development environment..."

OS="$(uname)"
echo "🖥 Detected OS: $OS"

# Determine paths based on OS
if [[ "$OS" == "Darwin" ]]; then
    VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
    JETBRAINS_PLUGINS_BASE="$HOME/Library/Application Support/JetBrains"
elif [[ "$OS" == "Linux" ]]; then
    VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
    JETBRAINS_PLUGINS_BASE="$HOME/.config/JetBrains"
elif [[ "$OS" =~ MINGW|MSYS|CYGWIN ]]; then
    VSCODE_SETTINGS="$APPDATA/Code/User/settings.json"
    JETBRAINS_PLUGINS_BASE="$APPDATA/JetBrains"
else
    echo "❌ Unsupported OS."
    exit 1
fi

# ---------- Vim & IdeaVim ----------
echo "📄 Backing up .vimrc and .ideavimrc..."
mkdir -p vim
cp "$HOME/.vimrc" vim/.vimrc 2>/dev/null || echo "⚠️ No .vimrc found"
cp "$HOME/.ideavimrc" vim/.ideavimrc 2>/dev/null || echo "⚠️ No .ideavimrc found"

# ---------- VSCode ----------
if command -v code >/dev/null 2>&1; then
    echo "📦 Exporting VSCode extensions..."
    mkdir -p vscode
    code --list-extensions > vscode/vscode-extensions.txt

    echo "📄 Backing up VSCode settings..."
    if [ -f "$VSCODE_SETTINGS" ]; then
        cp "$VSCODE_SETTINGS" vscode/settings.json
    else
        echo "⚠️ VSCode settings.json not found at $VSCODE_SETTINGS"
    fi
else
    echo "⚠️ VSCode not found or 'code' CLI not in PATH."
fi

# ---------- JetBrains Plugins ----------
echo "📋 Listing JetBrains plugins..."
mkdir -p jetbrains
find "$JETBRAINS_PLUGINS_BASE" -type d -name "plugins" 2>/dev/null | while read -r plugin_dir; do
    echo "🔍 Found plugin directory: $plugin_dir"
    ls "$plugin_dir" >> jetbrains/jetbrains-plugins.txt
done

echo "✅ Backup complete. Files saved in:"
echo " - vim/"
echo " - vscode/"
echo " - jetbrains/"
