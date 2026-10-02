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

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

alias cat="bat --pager=never"
alias vim=nvim
alias ls="eza"
alias ll="eza -l --icons --group-directories-first"
alias tree="eza --tree --icons"
alias man="batman"
alias grep="rg"

alias nvm="fnm"
if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd)"
fi

alias gco="git checkout"
alias gcm="git commit -m"
alias gst="git status"

export PURE_PROMPT_SYMBOL='»'
export PURE_PROMPT_VICMD_SYMBOL='«'
export PURE_GIT_UP_ARROW='↑'
export PURE_GIT_DOWN_ARROW='↓'
export PURE_GIT_STASH_SYMBOL='★'
export PURE_SUSPENDED_JOBS_SYMBOL='∗'

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/gklo/.lmstudio/bin"

# pnpm
export PNPM_HOME="/Users/gklo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

# >>> otty shell integration >>>
# Added by Otty — toggle in Settings > Shell > Shell Integration.
# Inert unless launched by Otty (it sets $OTTY_SHELL_INTEGRATION).
if [ -n "$OTTY_SHELL_INTEGRATION" ] && [ -r "$OTTY_SHELL_INTEGRATION/otty-integration.zsh" ]; then
  . "$OTTY_SHELL_INTEGRATION/otty-integration.zsh"
fi
# <<< otty shell integration <<<
