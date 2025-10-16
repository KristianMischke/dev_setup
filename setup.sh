#!/bin/bash

set -e

echo "🔧 Setting up environment..."

OS="$(uname)"
echo "🖥 Detected OS: $OS"

# Set paths depending on OS
if [[ "$OS" == "Darwin" ]]; then
    # macOS
    VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
    JETBRAINS_CONFIG_BASE="$HOME/Library/Application Support/JetBrains"
elif [[ "$OS" == "Linux" ]]; then
    # Linux
    VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
    JETBRAINS_CONFIG_BASE="$HOME/.config/JetBrains"
elif [[ "$OS" =~ MINGW|MSYS|CYGWIN ]]; then
    # Windows (via Git Bash, WSL, etc.)
    VSCODE_SETTINGS="$APPDATA/Code/User/settings.json"
    JETBRAINS_CONFIG_BASE="$APPDATA/JetBrains"
else
    echo "❌ Unsupported OS."
    exit 1
fi

# ---------- Vim & IdeaVim ----------
echo "📄 Installing .vimrc and .ideavimrc..."
cp vim/.vimrc "$HOME/.vimrc"
cp vim/.ideavimrc "$HOME/.ideavimrc"

# ---------- VSCode ----------
if command -v code >/dev/null 2>&1; then
    echo "📦 Installing VSCode extensions..."
    while read -r extension; do
        code --install-extension "$extension" || echo "⚠️ Failed to install $extension"
    done < vscode/vscode-extensions.txt

    echo "📄 Installing VSCode settings..."
    mkdir -p "$(dirname "$VSCODE_SETTINGS")"
    cp vscode/settings.json "$VSCODE_SETTINGS"
else
    echo "⚠️ VSCode not installed or 'code' command not in PATH."
fi

# ---------- JetBrains ----------
echo "📝 JetBrains plugin list saved in jetbrains/jetbrains-plugins.txt"
echo "⚠️ Automatic JetBrains plugin restore not yet implemented."
echo "👉 Please install plugins manually or refer to the notes in 'jetbrains/notes.txt'"

echo "✅ Setup complete."
