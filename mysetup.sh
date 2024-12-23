#!/bin/bash

# -------------------------------------------------------
# Complete macOS Setup Script
# -------------------------------------------------------
# This script automates the setup of a development environment
# on macOS, including:
# - Installing Homebrew
# - Installing and configuring Git
# - Installing applications (VS Code, Chrome, Firefox, Bitwarden, Docker, iTerm2, Spotify, Steam)
# - Installing ASDF for runtime management (Python and Go)
# - Installing VS Code extensions
# - Adding useful terminal functions via myfunctions.sh
# - Creating a Projects directory
# -------------------------------------------------------

# Function to display error messages and exit
error_exit() {
    echo "❌ Error: $1"
    exit 1
}

# Function to install Homebrew if not already installed
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "🚀 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error_exit "Homebrew installation failed."
    else
        echo "✅ Homebrew is already installed."
    fi
}

# Function to update PATH in ~/.zshrc if necessary
update_path() {
    if ! grep -q 'export PATH="/opt/homebrew/bin:$PATH"' ~/.zshrc; then
        echo "🔧 Updating PATH in ~/.zshrc..."
        echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
        source ~/.zshrc || error_exit "Failed to apply changes to ~/.zshrc."
    else
        echo "✅ PATH is already set in ~/.zshrc."
    fi
}

# Function to install a Homebrew package if not already installed
install_brew_package() {
    PACKAGE=$1
    if ! brew list "$PACKAGE" &>/dev/null; then
        echo "📦 Installing $PACKAGE..."
        brew install "$PACKAGE" || error_exit "Installation of $PACKAGE failed."
    else
        echo "✅ $PACKAGE is already installed."
    fi
}

# Function to install a Homebrew Cask application if not already installed
install_cask_app() {
    APP=$1
    if ! brew list --cask "$APP" &>/dev/null; then
        echo "🖥️ Installing $APP..."
        brew install --cask "$APP" || error_exit "Installation of $APP failed."
    else
        echo "✅ $APP is already installed."
    fi
}

# Function to configure Git if not already configured
configure_git() {
    if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
        echo "✅ Git is already configured with:"
        echo "   Username: $(git config --global user.name)"
        echo "   Email: $(git config --global user.email)"
    else
        echo "🔧 Configuring Git..."

        read -p "Enter your Git username: " GIT_USERNAME
        git config --global user.name "$GIT_USERNAME"

        read -p "Enter your Git email: " GIT_EMAIL
        git config --global user.email "$GIT_EMAIL"

        echo "✅ Git configured with username '$GIT_USERNAME' and email '$GIT_EMAIL'."
    fi
}

# Function to install VS Code extensions
install_vscode_extensions() {
    echo "🔌 Installing Visual Studio Code extensions..."

    EXTENSIONS=(
        # Python extensions
        ms-python.python
        ms-python.vscode-pylance
        ms-python.black-formatter
        ms-python.isort
        batisteo.vscode-django

        # JavaScript/React extensions
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        dsznajder.es7-react-js-snippets
        xabikos.javascriptsnippets

        # Docker extensions
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers

        # Git extensions
        eamodio.gitlens
        mhutchie.git-graph
        github.vscode-pull-request-github

        # General extensions
        ritwickdey.liveserver
        gruntfuggly.todo-tree
        streetsidesoftware.code-spell-checker
    )

    for EXT in "${EXTENSIONS[@]}"; do
        if ! code --list-extensions | grep -q "$EXT"; then
            echo "Installing $EXT..."
            code --install-extension "$EXT" || error_exit "Failed to install $EXT."
        else
            echo "✅ $EXT is already installed."
        fi
    done
}

# Function to create the Projects directory
create_projects_directory() {
    PROJECTS_DIR="$HOME/Projects"
    if [ ! -d "$PROJECTS_DIR" ]; then
        echo "📂 Creating Projects directory at $PROJECTS_DIR..."
        mkdir -p "$PROJECTS_DIR" || error_exit "Failed to create Projects directory."
    else
        echo "✅ Projects directory already exists."
    fi
}

# Function to install ASDF
install_asdf() {
    echo "🔧 Installing ASDF..."
    install_brew_package "asdf"

    # Add ASDF to shell configuration
    if ! grep -q 'source "$(brew --prefix asdf)/asdf.sh"' ~/.zshrc; then
        echo 'source "$(brew --prefix asdf)/asdf.sh"' >> ~/.zshrc
        echo 'source "$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash"' >> ~/.zshrc
        source ~/.zshrc || error_exit "Failed to source ASDF in ~/.zshrc."
    fi
}

# Function to install ASDF plugins for Python and Go
install_asdf_plugins() {
    echo "🔌 Adding ASDF plugins for Python and Go..."

    asdf plugin-add python || echo "Python plugin already added."
    asdf install python latest
    asdf global python latest

    asdf plugin-add golang || echo "Go plugin already added."
    asdf install golang latest
    asdf global golang latest

    echo "✅ ASDF plugins for Python and Go installed successfully."
}

# -------------------------
# Execution of the Setup
# -------------------------

echo "🚀 Starting your Mac setup..."

install_homebrew
update_path
install_brew_package "git"
configure_git
install_cask_app "visual-studio-code"
install_cask_app "google-chrome"
install_cask_app "firefox"
install_cask_app "bitwarden"
install_cask_app "iterm2"
install_cask_app "spotify"
install_cask_app "steam"
install_brew_package "docker"
install_asdf
install_asdf_plugins
install_vscode_extensions
create_projects_directory

# Call myfunctions.sh to add terminal functions
./myfunctions.sh || error_exit "Failed to execute myfunctions.sh."

echo "🎉 Setup completed successfully. Enjoy your Mac!"
