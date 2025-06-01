#!/bin/bash

#//NOTE: Color definitions for terminal output
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
SOURCE_MODE=false
SCRIPTS_MODE=false

print_logo() {
    echo -e "${CYAN}"
    echo '  ███╗   ███╗ ██████╗ ███╗   ██╗ ██████╗  ██████╗██╗  ██╗██████╗  ██████╗ ███╗   ███╗███████╗'
    echo '  ████╗ ████║██╔═══██╗████╗  ██║██╔═══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗████╗ ████║██╔════╝'
    echo '  ██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║██║     ███████║██████╔╝██║   ██║██╔████╔██║█████╗  '
    echo '  ██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║██║     ██╔══██║██╔══██╗██║   ██║██║╚██╔╝██║██╔══╝  '
    echo '  ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║╚██████╔╝╚██████╗██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗'
    echo '  ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝'
    echo -e "${RESET}"
}

print_header() {
    local text="$1"
    echo -e "${BOLD}${BLUE}$text${RESET}"
    echo
}

print_status() { echo -e "${BLUE}[*]${RESET} $1"; }
print_success() { echo -e "${GREEN}[✓]${RESET} $1"; }
print_error() { echo -e "${RED}[✗]${RESET} $1"; }
print_warning() { echo -e "${YELLOW}[!]${RESET} $1"; }

parse_args() {
    while getopts ":sh" opt; do
        case ${opt} in
            s)
                SOURCE_MODE=true
                ;;
            h)
                SCRIPTS_MODE=true
                ;;
            \?)
                print_error "Invalid option: -$OPTARG"
                exit 1
                ;;
        esac
    done
}

deploy_scripts() {
    if [ ! -d "$SCRIPTS_SRC" ]; then
        print_error "Scripts directory not found: $SCRIPTS_SRC"
        return 1
    fi
    
    print_status "Deploying scripts to $SCRIPTS_DEST"
    mkdir -p "$SCRIPTS_DEST"
    
    # Count scripts for reporting
    local scripts_total=$(find "$SCRIPTS_SRC" -type f | wc -l)
    local scripts_deployed=0
    local scripts_skipped=0
    
    find "$SCRIPTS_SRC" -type f | while read -r script; do
        script_name=$(basename "$script")
        dest_script="$SCRIPTS_DEST/$script_name"
        
        if [ -f "$dest_script" ] && ! $SOURCE_MODE; then
            print_warning "Script already exists: $script_name (use -s to replace)"
            scripts_skipped=$((scripts_skipped + 1))
            continue
        fi
        
        if $SOURCE_MODE; then
            print_status "Replacing script: $script_name"
        else
            print_status "Installing script: $script_name"
        fi
        
        cp -f "$script" "$dest_script"
        chmod +x "$dest_script"
        scripts_deployed=$((scripts_deployed + 1))
        
        print_success "Script deployed: $script_name"
    done
    
    print_success "Scripts deployment complete: $scripts_deployed deployed, $scripts_skipped skipped"
    return 0
}

deploy_configs() {
    if [ ! -d "$CONFIG_SRC" ]; then
        print_error "Config directory not found: $CONFIG_SRC"
        return 1
    fi
    
    print_status "Deploying configurations to $CONFIG_DEST"
    mkdir -p "$CONFIG_DEST"
    
    # Count configs for reporting
    local configs_total=$(find "$CONFIG_SRC" -mindepth 1 -maxdepth 1 -type d | wc -l)
    local configs_deployed=0
    local configs_skipped=0
    
    find "$CONFIG_SRC" -mindepth 1 -maxdepth 1 -type d | while read -r src_dir; do
        config_name=$(basename "$src_dir")
        dest_dir="$CONFIG_DEST/$config_name"
        
        if [ -d "$dest_dir" ] && ! $SOURCE_MODE; then
            print_warning "Config already exists: $config_name (use -s to replace)"
            configs_skipped=$((configs_skipped + 1))
            continue
        fi
        
        mkdir -p "$dest_dir"
        
        if $SOURCE_MODE; then
            print_status "Replacing config: $config_name"
            cp -rf "$src_dir/"* "$dest_dir/" 2>/dev/null
        else
            print_status "Installing config: $config_name"
            cp -rf "$src_dir/"* "$dest_dir/" 2>/dev/null
        fi
        
        configs_deployed=$((configs_deployed + 1))
        print_success "Config deployed: $config_name"
    done
    
    print_success "Configuration deployment complete: $configs_deployed deployed, $configs_skipped skipped"
    
    if $SOURCE_MODE; then
        print_warning "Configs sourced in replace mode (-s)"
    fi
    
    return 0
}

run_installation() {
    if [ "$1" = "install" ]; then
        source "$SCRIPT_DIR/install.sh"
        run_installation
    fi
}

main() {
    clear
    print_logo
    echo
    
    parse_args "$@"
    shift $((OPTIND-1))
    
    # Process installation if requested
    if [ "$1" = "install" ]; then
        print_header "INSTALLATION"
        run_installation install
        echo
    fi
    
    # Process configurations
    if [ "$SCRIPTS_MODE" = false ] || [ "$#" -eq 0 ]; then
        print_header "CONFIGURATION"
        deploy_configs
    fi
    
    # Process scripts if -h option was used
    if [ "$SCRIPTS_MODE" = true ]; then
        print_header "SCRIPTS"
        deploy_scripts
    fi
    
    # Show usage if no valid command was given
    if [ "$#" -gt 0 ] && [ "$1" != "install" ]; then
        print_error "Unknown command: $1"
        echo "Usage: ./setup.sh [-s] [-h] [install]"
        echo "  -s: Source mode (replace existing configs/scripts)"
        echo "  -h: Deploy scripts to ~/.local/share/bin"
        echo "  install: Run installation before deploying configs/scripts"
        exit 1
    fi
}

main "$@"
