# vi: wrap
fish_config theme choose "Dracula Official"
if status is-interactive
    set PATH /usr/local/bin $PATH
    set PATH /usr/local/opt/mysql-client/bin $PATH
    set PATH /opt/homebrew/bin $PATH
    set PATH /opt/homebrew/sbin $PATH
    set PATH /opt/homebrew/opt/node@20/bin $PATH
    set -x LF_ICONS "tw=:st=:ow=:dt=:di=:fi=:ln=:or=:ex=:*.c=:*.cc=:*.clj=:*.coffee=:*.cpp=:*.css=:*.d=:*.dart=:*.erl=:*.exs=:*.fs=:*.go=:*.h=:*.hh=:*.hpp=:*.hs=:*.html=:*.java=:*.jl=:*.js=:*.json=:*.lua=:*.md=:*.php=:*.pl=:*.pro=:*.py=:*.rb=:*.rs=:*.scala=:*.ts=:*.vim=:*.cmd=:*.ps1=:*.sh=:*.bash=:*.zsh=:*.fish=:*.tar=:*.tgz=:*.arc=:*.arj=:*.taz=:*.lha=:*.lz4=:*.lzh=:*.lzma=:*.tlz=:*.txz=:*.tzo=:*.t7z=:*.zip=:*.z=:*.dz=:*.gz=:*.lrz=:*.lz=:*.lzo=:*.xz=:*.zst=:*.tzst=:*.bz2=:*.bz=:*.tbz=:*.tbz2=:*.tz=:*.deb=:*.rpm=:*.jar=:*.war=:*.ear=:*.sar=:*.rar=:*.alz=:*.ace=:*.zoo=:*.cpio=:*.7z=:*.rz=:*.cab=:*.wim=:*.swm=:*.dwm=:*.esd=:*.jpg=:*.jpeg=:*.mjpg=:*.mjpeg=:*.gif=:*.bmp=:*.pbm=:*.pgm=:*.ppm=:*.tga=:*.xbm=:*.xpm=:*.tif=:*.tiff=:*.png=:*.svg=:*.svgz=:*.mng=:*.pcx=:*.mov=:*.mpg=:*.mpeg=:*.m2v=:*.mkv=:*.webm=:*.ogm=:*.mp4=:*.m4v=:*.mp4v=:*.vob=:*.qt=:*.nuv=:*.wmv=:*.asf=:*.rm=:*.rmvb=:*.flc=:*.avi=:*.fli=:*.flv=:*.gl=:*.dl=:*.xcf=:*.xwd=:*.yuv=:*.cgm=:*.emf=:*.ogv=:*.ogx=:*.aac=:*.au=:*.flac=:*.m4a=:*.mid=:*.midi=:*.mka=:*.mp3=:*.mpc=:*.ogg=:*.ra=:*.wav=:*.oga=:*.opus=:*.spx=:*.xspf=:*.pdf=:*.nix=:"

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
