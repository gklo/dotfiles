# vi: wrap
fish_config theme choose "Dracula Official"
if status is-interactive
    set PATH /usr/local/bin $PATH
    set PATH /usr/local/opt/mysql-client/bin $PATH
    set PATH /opt/homebrew/bin $PATH
    set PATH /opt/homebrew/sbin $PATH

    mcfly init fish | source
    zoxide init fish | source
    alias icat="kitty +kitten icat"
    alias cat=bat
    alias vim=nvim    
    alias ls=eza
    alias ll="eza -l"    
    alias man="batman"
    alias grep="rg"
    alias nvm="fnm"
    alias gco="git checkout"
    alias gcm="git commit -m"
    alias gst="git status"
    alias gcf="git config -l"
    alias gll="git log --oneline"
    alias ghrl="gh run list"
    alias ghrv="gh run view"
    fnm env --use-on-cd | source

    function vim-win
      ssh my-boot-camp -f "nvim --listen 0.0.0.0:8899 --headless" && nvim-qt --server my-boot-camp:8899    
    end

    function sync-vim
      scp -r ~/.config/nvim/* my-boot-camp:AppData\\Local\\nvim    
    end
end
