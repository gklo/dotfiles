# source antidote
if [[ -f /opt/homebrew/opt/antidote/share/antidote/antidote.zsh ]]; then
  source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
  # initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
  antidote load
fi

# load prompt
autoload -Uz promptinit && promptinit && prompt pure

# initialize Homebrew paths  
eval "$(/opt/homebrew/bin/brew shellenv)"

if (( $+commands[mcfly] )); then
  eval "$(mcfly init zsh)"
fi
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

alias cat=bat
alias vim=nvim
alias ls="eza"
alias ll="eza -l --icons --group-directories-first"
alias man="batman"
alias grep="rg"

alias nvm="fnm"
if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd)"
fi

alias gco="git checkout"
alias gcm="git commit -m"
alias gst="git status"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/gklo/.lmstudio/bin"

# pnpm
export PNPM_HOME="/Users/gklo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
