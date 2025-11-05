#!/bin/bash

set -e

CYAN="\033[0;36m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BOLD="\033[1m"
RESET="\033[0m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="${SCRIPT_DIR}/configs"
CONFIG_DEST="${HOME}/.config"
SCRIPTS_SRC="${SCRIPT_DIR}/scripts"
SCRIPTS_DEST="${HOME}/.local/share/bin"
THEME_REPO="https://github.com/vinceliuice/Graphite-gtk-theme.git"

print_logo() {
    echo -e "${CYAN}"
    echo '  ███╗   ███╗ ██████╗ ███╗   ██╗ ██████╗ '
    echo '  ████╗ ████║██╔═══██╗████╗  ██║██╔═══██╗'
    echo '  ██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║'
    echo '  ██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║'
    echo '  ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║╚██████╔╝'
    echo '  ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ '
    echo -e "${RESET}"
}

print_header() { echo -e "${BOLD}${BLUE}$1${RESET}\n"; }
print_status() { echo -e "${BLUE}[*]${RESET} $1"; }
print_success() { echo -e "${GREEN}[✓]${RESET} $1"; }
print_error() { echo -e "${RED}[✗]${RESET} $1"; }
print_warning() { echo -e "${YELLOW}[!]${RESET} $1"; }

ask_yes_no() {
    while true; do
        read -p "$1 [y/n]: " yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
}

run_installation() {
    print_header "PACKAGE INSTALLATION"
    source "$SCRIPT_DIR/install.sh"
    run_installation
}

deploy_configs() {
    print_header "CONFIGURATION DEPLOYMENT"
    
    if [ ! -d "$CONFIG_SRC" ]; then
        print_error "Config directory not found: $CONFIG_SRC"
        return 1
    fi
    
    mkdir -p "$CONFIG_DEST"
    
    find "$CONFIG_SRC" -mindepth 1 -maxdepth 1 -type d | while read -r src_dir; do
        config_name=$(basename "$src_dir")
        dest_dir="$CONFIG_DEST/$config_name"
        
        if [ -d "$dest_dir" ]; then
            print_warning "Config exists: $config_name - replacing"
            rm -rf "$dest_dir"
        fi
        
        print_status "Deploying config: $config_name"
        cp -r "$src_dir" "$dest_dir"
        print_success "Config deployed: $config_name"
    done
    
    print_success "Configuration deployment complete"
}

deploy_scripts() {
    print_header "SCRIPTS DEPLOYMENT"
    
    if [ ! -d "$SCRIPTS_SRC" ]; then
        print_error "Scripts directory not found: $SCRIPTS_SRC"
        return 1
    fi
    
    mkdir -p "$SCRIPTS_DEST"
    
    find "$SCRIPTS_SRC" -type f -name "*.sh" | while read -r script; do
        script_name=$(basename "$script")
        dest_script="$SCRIPTS_DEST/$script_name"
        
        print_status "Deploying script: $script_name"
        cp "$script" "$dest_script"
        chmod +x "$dest_script"
        print_success "Script deployed: $script_name"
    done
    
    print_success "Scripts deployment complete"
}

install_theme() {
    print_header "THEME INSTALLATION"
    
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" RETURN
    
    print_status "Cloning Graphite GTK theme..."
    cd "$TEMP_DIR"
    git clone "$THEME_REPO" &> /dev/null || {
        print_error "Failed to clone theme repository"
        return 1
    }
    
    cd Graphite-gtk-theme
    print_status "Installing theme..."
    ./install.sh -d ~/.themes/ -t -c dark -s compact -l --tweaks darker rimless normal colorful &> /dev/null || {
        print_error "Theme installation failed"
        return 1
    }
    
    print_success "Theme installed successfully"
}

run_postinstall() {
    print_header "POST-INSTALLATION SETUP"
    
    print_status "Enabling Bluetooth service..."
    sudo systemctl enable bluetooth &> /dev/null
    sudo systemctl start bluetooth &> /dev/null
    print_success "Bluetooth enabled"
    
    print_status "Enabling ly display manager..."
    sudo systemctl enable ly.service &> /dev/null
    print_success "ly display manager enabled"
    
    if ask_yes_no "Change default shell to zsh?"; then
        chsh -s /usr/bin/zsh
        print_success "Shell changed to zsh (restart required)"
    else
        print_warning "Skipping shell change"
    fi
    
    print_success "Post-installation complete"
}

main() {
    clear
    print_logo
    
    echo -e "${BOLD}Mono Arch Setup${RESET}"
    echo -e "This script will set up your Arch Linux environment\n"
    
    if ask_yes_no "Run package installation?"; then
        run_installation
        echo
    fi
    
    deploy_configs
    echo
    
    deploy_scripts
    echo
    
    if ask_yes_no "Install Graphite GTK theme?"; then
        install_theme
        echo
    fi
    
    if ask_yes_no "Run post-installation setup?"; then
        run_postinstall
        echo
    fi
    
    echo -e "${GREEN}${BOLD}Setup complete!${RESET}"
    echo -e "Please restart your system for all changes to take effect."
}

main
