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
  vim = { #enable = true;
    defaultEditor = true;
   };
  xfconf.enable = true;
 };
#
environment.systemPackages = with pkgs; [
  surf /* browser */
  brave
  brightnessctl
  cryptsetup
  certbot
  # dnsmasq
  deno 
  efibootmgr
  feh
  qimgv
  nomacs
  ffmpegthumbnailer
  fswebcam
  git
  gh
  gitg
  git-credential-keepassxc
  gscreenshot
  htop
  keepassxc
  lazygit
  mpv
  mullvad-vpn /* duh */
  networkmanagerapplet
  nextcloud-client
  nodejs_20
  openssl
  spotify spotify-player mlterm
  #taskwarrior3 /* task manager */ ptask /* taskwarrior plugin */
  xorg.xev lsof showmethekey trashy termimage xprintidle xdotool place-cursor-at mktemp xclip
  x11vnc tigervnc
  tilix
  tmux
  zed
  yazi
];
}
