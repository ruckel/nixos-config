alias sudoa='sudo -A'

alias ekit=exit
alias ex="exit;alert"

alias ls='ls --color=auto  --almost-all --human-readable -1 --group-directories-first --classify=auto --hyperlink=auto'
alias l='ls -C'
alias ll='ls -l'
#alias lsl='ls -l'

alias cl='clear'
alias mv='mv -v'
alias rm='trash'
alias cat=bat

alias printtime='echo $(date +%H:%M)'

alias trademark='echo ™'
alias dunno='echo ¯\_(ツ)_/¯'
alias invisiblecharacter='printf "​" | xclip -sel clip && echo "copied invisible char to clipboard: [​]"'

alias noti='sleep 5; echo'
alias alert=/home/korv/scripts/alert

alias ..bashrc='. ~/.bashrc'
alias grepinverted="grep -v"

alias hist=history
alias histgrep="history | grep -v grep | grep"
alias historyrmlastentry='history -d -1; history'
alias histlastentryrm='history -d -1; history'

alias wraplines-temporary-disabling='tput rmam'
alias wraplines-restore='tput smam'

alias nixfindpackage=~/scripts/nix/find.sh
alias nixfastfind=~/scripts/nix/find.sh
alias nfind=~/scripts/nix/find.sh
alias nixupdatesearch=~/scripts/nix/updateStore.sh
alias nfindgnomeext=~/scripts/nix/gnomefindext.sh

alias nixshellp="nix-shell -p"

alias nixswitch-burk='sudo -A nixos-rebuild switch --fast --impure --flake ~/nixos-cfg/# -p korvus; alert'
alias nixtestburk='sudo -A nixos-rebuild test --fast --impure --flake ~/nixos-cfg/# -p korvus; alert'
alias nixswitch-homelab='sudo printf; LASTPWD=$PWD && cd ~/nixos-cfg && git pull && sudo nixos-rebuild switch --fast --impure --flake ~/nixos-cfg/# ; cd $LASTPWD'

alias tilixwidth='dconf write /com/gexperts/Tilix/quake-width-percent'
alias tilixheight='dconf write /com/gexperts/Tilix/quake-height-percent'
alias tilixautohide='/home/korv/scripts/tilixautohide'
alias tilixmonitor='dconf write /com/gexperts/Tilix/quake-specific-monitor 0'
alias tilixmonitor1='dconf write /com/gexperts/Tilix/quake-specific-monitor 1'
alias tilixmonitor2='dconf write /com/gexperts/Tilix/quake-specific-monitor 2'

alias lock='xdg-screensaver lock'
alias poweroffgnome='gnome-session-quit --no-prompt --power-off'
alias shutdowngnome='gnome-session-quit --no-prompt --power-off'
alias rebootgnome='gnome-session-quit --no-prompt --reboot'
alias logoutgnome='gnome-session-quit --logout'
alias gnome-console=kgx

alias sshmoln='ssh moln'
alias sshburk='ssh burk'
alias sshdell='ssh dell'
alias sshvaio='ssh vaio'

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
alias chawan=cha
alias blurtoggle=~/scripts/blurwindows
alias torrent='transmission-remote --add'

alias tmux="tmux a"
alias mux="tmux"
