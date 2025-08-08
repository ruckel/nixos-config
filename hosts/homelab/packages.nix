{pkgs, ...}:{
services.dnsmasq = { enable = true;
  alwaysKeepRunning = false;
 };
programs = {
  bash.vteIntegration = true;
  firefox.enable = true;
  steam.enable = true;
  thunar = { enable = true;
    plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin ];
   };
  xfconf.enable = true;
 };
#
environment.systemPackages = with pkgs; [
  surf /* browser */
  bat
  brave
  brightnessctl
  cryptsetup
  certbot
  # dnsmasq
  deno 
  efibootmgr
  feh
  fzf
  qimgv
  nomacs
  ffmpegthumbnailer
  fswebcam
  gdu
  git
  gh
  gitg
  git-credential-keepassxc
  gscreenshot
  htop
  jless
  jq
  keepassxc
  lazygit
  mpv
  mullvad-vpn /* duh */
  networkmanagerapplet
  nextcloud-client
  nodejs_20
  openssl
  spotify spotify-player mlterm
  xorg.xev lsof showmethekey trashy termimage xprintidle xdotool place-cursor-at mktemp xclip
  x11vnc tigervnc
  tealdeer
  tilix
  tmux
  zed
  yazi
];
}
