alias sudoa='sudo -A'
alias suda='sudo -A'

alias ekit=exit
alias ex="exit;alert"
alias :q=exit

alias ls='ls --color=auto  --almost-all --human-readable -1 --group-directories-first --classify=auto --hyperlink=auto'
alias l='ls -C'
alias ll='ls -l'
#alias lsl='ls -l'

alias cl='clear'
alias mv='mv -v'
alias rm='trash'

alias printtime='echo $(date +%H:%M)'

alias invisiblecharacter='printf "​" | xclip -sel clip && echo "copied invisible char to clipboard: [​]"'

alias noti='sleep 5; echo'
alias alert=/home/korv/scripts/alert
alias test-term-bell='echo -en "\007"'
alias bell-term-test='echo -en "\007"'

alias ..bashrc='. ~/.bashrc'
alias grepinverted="grep -v"

alias diff="diff --color=always"
alias diffwithoutbloat='diff --suppress-common-lines -sU 0'

alias hist=history
alias histgrep="history | grep -v grep | grep"
alias historyrmlastentry='history -d -1; history'
alias histlastentryrm='history -d -1; history'

alias wraplines-not='tput rmam'
alias wraplines='tput smam'

alias nshellp="nix-shell -p"

alias gitstashpull="git stash push -q -m \"${HOSTNAME}_$(date +%y%m%d_%H-%M)\" && git pull ; git stash pop -q"

alias lock='xdg-screensaver lock'
alias poweroffgnome='gnome-session-quit --no-prompt --power-off'
alias shutdowngnome='gnome-session-quit --no-prompt --power-off'
alias rebootgnome='gnome-session-quit --no-prompt --reboot'
alias logoutgnome='gnome-session-quit --logout'
alias gnome-console=kgx
alias blurtoggle=~/scripts/blurwindows
alias files=thunar

alias wpctlstatus='wpctl status'
alias wpctldefault='wpctl set-default'
alias wpctlvol='wpctl set-volume @DEFAULT_SINK@'
alias wpctlvolup='wpctl set-volume @DEFAULT_SINK@ .05+'
alias wpctlvoldn='wpctl set-volume @DEFAULT_SINK@ .05-'
alias wpctlgrep='wpctl status | grep'

alias spotifyplayer='spotify_player'
alias potsify='spotify_player'

alias ff=fastfetch
alias ffget='nix-shell -p fastfetch --command fastfetch'
alias neofetch='nix-shell -p fastfetch --command fastfetch'
alias torrent='transmission-remote --add'

alias tmux="tmux a"
alias mux="tmux"
alias vimrc="vim ~/.config/vim/.vimrc"

alias drp='deno run preview'
alias drd='deno run start'

alias nextcloud-occ="sudo nextcloud-occ"
alias occ="sudo nextcloud-occ"
alias nixdir="cd ~/nixos-cfg"
