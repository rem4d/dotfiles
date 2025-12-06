# Default path
export PATH="/opt/homebrew:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# Allow any custom binaries
export PATH="$HOME/bin:$PATH"

# curl
export PATH="/opt/homebrew/curl/bin:/usr/local/Casroom:$PATH"

export ZSH=$HOME/.oh-my-zsh

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# zplug

source ~/.zplug/init.zsh

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/history", from:oh-my-zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions", defer:2
zplug "agkozak/zsh-z"
# zplug "jeffreytse/zsh-vi-mode"


# zplug install
zplug load

source $ZSH/oh-my-zsh.sh

# Example aliases
alias cl="clear"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias git='LC_ALL=en_GB git'
alias nvi='~/Documents/nvim-new/nvim-macos-x86_64/bin/nvim'
# alias nvim='~/Documents/nvim-10.0.2/bin/nvim'
alias nvim='~/Documents/NVIM/nvim-macos-x86_64/bin/nvim'
alias postgrestools='~/Documents/postgrestools/postgrestools_x86_64-apple-darwin'
alias python='python3'
alias pip='pip3'


#fzf
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# pnpm
export PNPM_HOME="/Users/jane/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="/Users/jane/.local/bin:$PATH"

# increase the memory limit for the node process.
export NODE_OPTIONS=“--max-old-space-size=16384”
