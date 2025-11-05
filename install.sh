#!/bin/bash

set -e

RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

YAY_DIR="${HOME}/yay"
PKG_LIST="./pkg.list"
LOG_FILE="install.log"
MAX_WIDTH=80

TERMINAL_WIDTH=$(tput cols)
if [ $TERMINAL_WIDTH -gt $MAX_WIDTH ]; then
    TERMINAL_WIDTH=$MAX_WIDTH
fi
BAR_WIDTH=$((TERMINAL_WIDTH - 30))

print_status() { echo -e "${BLUE}[*]${RESET} $1"; }
print_success() { echo -e "${GREEN}[✓]${RESET} $1"; }
print_error() { echo -e "${RED}[✗]${RESET} $1"; }

show_loading_bar() {
    local completed=$1
    local total=$2
    local package=$3
    local percentage=$((completed * 100 / total))
    local filled=$((percentage * BAR_WIDTH / 100))
    local empty=$((BAR_WIDTH - filled))

    local max_pkg_length=20
    local pkg_display="$package"
    if [ ${#package} -gt $max_pkg_length ]; then
        pkg_display="${package:0:$((max_pkg_length-3))}..."
    fi

    echo -ne "\r\033[K"
    printf "[%-${filled}s%-${empty}s] %3d%% %-${max_pkg_length}s" \
           "$(printf '%0.s█' $(seq 1 $filled))" \
           "$(printf '%0.s░' $(seq 1 $empty))" \
           "$percentage" \
           "$pkg_display"
}

check_arch() {
    if ! grep -qi "Arch" /etc/os-release; then
        print_error "This script requires an Arch-based distribution"
        exit 1
    fi
}

install_yay() {
    if command -v yay &> /dev/null; then
        print_success "yay already installed"
        return 0
    fi

    print_status "Installing yay..."
    
    if ! command -v git &> /dev/null; then
        print_status "Installing git dependency"
        sudo pacman -S --noconfirm git &>> "$LOG_FILE" || {
            print_error "Failed to install git"
            exit 1
        }
    fi

    if [ ! -d "$YAY_DIR" ]; then
        git clone https://aur.archlinux.org/yay.git "$YAY_DIR" &>> "$LOG_FILE" || {
            print_error "Failed to clone yay repository"
            exit 1
        }
    fi

    cd "$YAY_DIR" || { print_error "Failed to navigate to $YAY_DIR"; exit 1; }
    
    print_status "Building yay..."
    makepkg -si --noconfirm &>> "$LOG_FILE" || { print_error "Failed to build yay"; exit 1; }
    cd - &> /dev/null || exit 1

    if command -v yay &> /dev/null; then
        print_success "yay installed successfully"
        print_status "Updating system packages..."
        yay -Syu --noconfirm &>> "$LOG_FILE"
        print_success "System updated"
    else
        print_error "yay installation failed"
        exit 1
    fi
}

count_packages() {
    grep -v '^#' "$PKG_LIST" | grep -v '^$' | wc -l
}

install_packages() {
    if [ ! -f "$PKG_LIST" ]; then
        print_error "Package list not found: $PKG_LIST"
        exit 1
    fi

    print_status "Installing packages from $PKG_LIST"

    local total_pkgs=$(count_packages)
    local current=0
    local installed=0
    local skipped=0
    local failed=0
    
    while IFS= read -r line || [ -n "$line" ]; do
        [[ -z "$line" || "$line" =~ ^#.*$ ]] && continue
        
        current=$((current + 1))
        
        if yay -Q "$line" &> /dev/null; then
            show_loading_bar "$current" "$total_pkgs" "$line"
            skipped=$((skipped + 1))
            sleep 0.05
            continue
        fi
        
        show_loading_bar "$current" "$total_pkgs" "$line"
        
        if yay -S --noconfirm "$line" &>> "$LOG_FILE"; then
            installed=$((installed + 1))
        else
            failed=$((failed + 1))
            echo -e "\r\033[K${RED}[✗]${RESET} Failed to install $line"
        fi
    done < "$PKG_LIST"
    
    echo -e "\n"
    print_success "Installation complete"
    echo -e "  ${GREEN}✓ Installed:${RESET} $installed  ${YELLOW}↷ Skipped:${RESET} $skipped  ${RED}✗ Failed:${RESET} $failed"
}

install_nvm_node() {
    print_status "Installing nvm..."
    
    if [ -d "$HOME/.nvm" ]; then
        print_success "nvm already installed"
    else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash &>> "$LOG_FILE" || {
            print_error "Failed to install nvm"
            return 1
        }
    fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    if ! command -v nvm &> /dev/null; then
        print_error "nvm installation failed"
        return 1
    fi

    print_status "Installing Node.js v22..."
    nvm install 22 &>> "$LOG_FILE" || {
        print_error "Failed to install Node.js"
        return 1
    }

    NODE_VERSION=$(node -v)
    print_success "Node.js installed: $NODE_VERSION"
}

run_installation() {
    > "$LOG_FILE"
    check_arch
    install_yay
    install_packages
    install_nvm_node
    echo -e "${BLUE}[*]${RESET} Log saved to: ${BOLD}$LOG_FILE${RESET}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_installation
fi
