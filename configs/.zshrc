eval "$(starship init zsh)"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^k' history-search-backward
bindkey '^j' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -G $realpath'

# Aliases
alias ls='ls -G'
alias vim='nvim'
alias c='clear'
alias s="source ~/.zshrc"
alias f=fzf
alias i="sudo pacman -Syu "
alias m="mkdir"
alias t="touch"
alias r="rm -rf"
alias g="nvim ~/.zshrc"
alias x=nvim
alias sd="cd ~ && cd \$(find * -type d | fzf)"
alias l="ls -a"
alias ff="spf"

bindkey -v
bindkey '\ek' history-beginning-search-backward
bindkey '\ej' history-beginning-search-forward

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"






export PATH=$HOME/.local/bin:$PATH
export PATH="$HOME/go/bin:$PATH"


bp() {
    # Default settings
    local exclude_dirs=(".git" "docs" "node_modules" "vendor" "dist" "build")
    local copy_clipboard=true

    while [ "$1" != "" ]; do
        case $1 in
            -n|--no-copy)
                copy_clipboard=false
                shift
                ;;
            *)
                exclude_dirs=("$@")
                break
                ;;
        esac
    done
    
    local exclude_pattern=""
    for dir in "${exclude_dirs[@]}"; do
        exclude_pattern="${exclude_pattern} -not -path \"*/${dir}/*\""
    done
    
    local result
    result=$(eval "find \"$(pwd)\" -type f ${exclude_pattern} -exec echo \"\\\"{}\\\"\" \;")
    
    # Print result to terminal
    echo "$result"
    
    # Copy to clipboard (default behavior)
    if [ "$copy_clipboard" = true ]; then
        echo "$result" | wl-copy
        echo "//NOTE: Results copied to clipboard"
    fi
}




[ -s "/home/toor/.bun/_bun" ] && source "/home/toor/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"



export PATH="$PATH:/home/toor/.local/share/bin"
alias scaffold="bash /home/toor/.local/share/bin/scaffold.sh"
alias ai="bash /home/toor/.local/share/bin/ai.sh"
alias ccp="bash /home/toor/.local/share/bin/ccp.sh"

# opencode
export PATH=/home/toor/.opencode/bin:$PATH
