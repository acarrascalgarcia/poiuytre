#!/bin/bash

# -------------------------------------------------------
# Terminal Functions Setup Script
# -------------------------------------------------------
# This script adds useful terminal functions to ~/.zshrc
# and allows listing them at any time.
# -------------------------------------------------------

# Function to display error messages and exit
error_exit() {
    echo "❌ Error: $1"
    exit 1
}

# Function to add useful terminal functions to ~/.zshrc
add_terminal_functions() {
    echo "🔧 Adding useful terminal functions to ~/.zshrc..."

    FUNCTIONS='
# --- Useful Terminal Functions ---

function take() {
    mkdir -p "$1" && cd "$1"
}

function up() {
    local count=${1:-1}
    local path=""
    for ((i=0; i<count; i++)); do
        path+="../"
    done
    cd "$path" || echo "❌ Failed to go up $count directories."
}

function cdb() {
    cd - || echo "❌ Failed to return to previous directory."
}

function findd() {
    find . -type d -name "*$1*"
}

function findf() {
    find . -type f -name "*$1*"
}

function cls() {
    clear
}

function list_terminal_functions() {
    echo -e "\\n📜 \\033[1mList of Configured Terminal Functions:\\033[0m"
    echo "\\033[1m1. take\\033[0m   - Create a directory and move into it: take my_directory"
    echo "\\033[1m2. up\\033[0m     - Go up multiple directory levels: up 2"
    echo "\\033[1m3. cdb\\033[0m    - Return to the previous directory: cdb"
    echo "\\033[1m4. findd\\033[0m  - Find directories by name: findd project"
    echo "\\033[1m5. findf\\033[0m  - Find files by name: findf main.py"
    echo "\\033[1m6. cls\\033[0m    - Clear the terminal screen: cls"
}
'

    if ! grep -q "# --- Useful Terminal Functions ---" ~/.zshrc; then
        echo "$FUNCTIONS" >> ~/.zshrc
        echo "✅ Terminal functions added to ~/.zshrc."
        source ~/.zshrc || error_exit "Failed to source ~/.zshrc."
    else
        echo "✅ Terminal functions are already present in ~/.zshrc."
    fi
}

# -------------------------
# Execution
# -------------------------

add_terminal_functions

echo "🎉 Terminal functions setup completed successfully!"
