# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install Vim-Plug for Neovim if missing
if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

# <<< conda initialize <<<
if [ -f "/opt/anaconda/etc/profile.d/conda.sh" ]; then
    . "/opt/anaconda/etc/profile.d/conda.sh"
else
    export PATH="/opt/anaconda/bin:$PATH"
fi
# >>> conda initialize >>>


player="ytmdesktop"
# ------------------------------
# Zinit (plugin manager)
# ------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# ------------------------------
# Plugins
# ------------------------------
zinit ice depth=1
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# ------------------------------
# Load completions
# ------------------------------
autoload -U compinit && compinit

# ------------------------------
# Powerlevel10k config
# ------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ------------------------------
# Keybindings
# ------------------------------
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward


# ------------------------------
# History
# ------------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# ------------------------------
# Completion styling
# ------------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# ------------------------------
# Aliases
# ------------------------------
alias nv='nvim'
alias ls='ls --color=never'
alias obsidian="/usr/bin/obsidian"
alias ytm="firefox music.youtube.com"
alias github="firefox github.com"
alias gpt="firefox chatgpt.com"
alias yt="firefox youtube.com"
alias calendar="firefox calendar.notion.so"
# ------------------------------
# fzf integration
# ------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_CTRL_Z_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$' {}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "preview 'bat -n --color=always --line-range :500 {}'" "$@" ;;
  esac
}

# ------------------------------
# PATH additions
# ------------------------------
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/snap/bin

# ------------------------------
# End of zshrc
# -----------------------------

export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/go/bin

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
cowsay -f actually "I use Arch btw" | lolcat

export PATH=$PATH:/home/Woeter/.spicetify
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cat="bat"
eval "$(zoxide init zsh)"
alias cd="z"
export OPENSSL_MODULES=/opt/anaconda/lib/ossl-modules
alias wake-server='wol -i 192.168.1.255 CC:47:40:2D:0D:49'

# NPM Global Packages
export PATH=~/.npm-global/bin:$PATH

# bun completions
[ -s "/home/Woeter/.bun/_bun" ] && source "/home/Woeter/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Antigravity CLI installer
export PATH="/home/Woeter/.local/bin:$PATH"
source /usr/share/nvm/init-nvm.sh
