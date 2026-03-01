# -----------------------------
# Prompt
# -----------------------------
eval "$(starship init zsh)"

# -----------------------------
# Zinit
# -----------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

autoload -Uz compinit
compinit
zinit cdreplay -q

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# -----------------------------
# Keybindings
# -----------------------------
bindkey -e
bindkey -v
bindkey '^k' history-search-backward
bindkey '^j' history-search-forward

# -----------------------------
# History
# -----------------------------
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# -----------------------------
# Completion styling
# -----------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G $realpath'

# -----------------------------
# FZF + Zoxide
# -----------------------------
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export FZF_DEFAULT_OPTS="
--layout=reverse
--border=rounded
--padding=1
--margin=1
--info=inline
--prompt='> '
--pointer='▶'
--marker='✓'
--cycle
"

# -----------------------------
# Aliases
# -----------------------------
alias ls='ls -G'
alias l='ls -a'
alias vim='nvim'
alias x='nvim'
alias g='nvim ~/.zshrc'
alias s='source ~/.zshrc'
alias c='clear'
alias r='rm -rf'
alias m='mkdir'
alias t='touch'
alias i='sudo pacman -Syu'
alias f='fzf'

# -----------------------------
# PATH
# -----------------------------
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="/home/toor/.local/share/bin:$PATH"
export PATH="/home/toor/.opencode/bin:$PATH"

# -----------------------------
# NVM
# -----------------------------
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# -----------------------------
# bun
# -----------------------------
[[ -s "/home/toor/.bun/_bun" ]] && source "/home/toor/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# -----------------------------
# Your scripts
# -----------------------------
alias scaffold="bash /home/toor/.local/share/bin/scaffold.sh"
alias ai="bash /home/toor/.local/share/bin/ai.sh"
alias ccp="bash /home/toor/.local/share/bin/ccp.sh"

# -----------------------------
# bp function
# -----------------------------
bp() {
  local -a exclude_dirs
  exclude_dirs=(".git" "docs" "node_modules" "vendor" "dist" "build")

  local copy_clipboard=true

  while [[ "${1:-}" != "" ]]; do
    case "$1" in
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
  local d
  for d in "${exclude_dirs[@]}"; do
    exclude_pattern+=" -not -path \"*/$d/*\""
  done

  local result
  result="$(eval "find \"$(pwd)\" -type f $exclude_pattern -exec echo \"\\\"{}\\\"\" \;")"

  echo "$result"

  if [[ "$copy_clipboard" == true ]] && command -v wl-copy >/dev/null; then
    echo "$result" | wl-copy
    echo "//NOTE: Results copied to clipboard"
  fi
}

# -----------------------------
# tmux (simple, stable picker)
# -----------------------------
ta() {
  command -v tmux >/dev/null 2>&1 || return 0
  command -v fzf  >/dev/null 2>&1 || { echo "tmux: fzf not found"; return 1; }
  [[ -t 0 && -t 1 ]] || { echo "tmux: not a terminal (no TTY)"; return 1; }

  local sessions
  sessions="$(tmux list-sessions -F '#{session_name} :: #{session_windows} :: #{?session_attached,yes,no}' 2>/dev/null || true)"

  if [[ -z "$sessions" ]]; then
    local name
    read -r "name?No tmux sessions. Create one [main]: "
    tmux new-session -A -s "${name:-main}"
    return 0
  fi

  local picked
  picked="$(
    printf '%s\n' "$sessions" | fzf \
      --height=55% \
      --layout=reverse \
      --border=rounded \
      --padding=1 \
      --margin=1 \
      --info=inline \
      --cycle \
      --prompt='tmux> ' \
      --delimiter=' :: ' \
      --with-nth=1,2,3 \
      --header='Enter: attach/switch | Tab: select | /: search | Esc: cancel' \
      --preview='tmux list-windows -t {1} -F "#{window_index}: #{window_name} (#{window_panes})" 2>/dev/null | sed -n "1,140p"' \
      --preview-window='down:60%:wrap' \
      --no-separator
  )" || return 0

  [[ -z "$picked" ]] && return 0

  local name="${picked%% :: *}"
  [[ -z "$name" ]] && return 0

  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$name"
  else
    tmux new-session -A -s "$name"
  fi
}

# -----------------------------
# tmux kill helper (optional)
# -----------------------------
tk() {
  tmux list-sessions -F '#{session_name}' |
    fzf --multi --prompt='kill> ' |
    xargs -r tmux kill-session -t
}



alias cc='cd ~/Code/cc && tmux new -A -s cc'
