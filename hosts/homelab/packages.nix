{pkgs, ...}:{
services.dnsmasq = { enable = true;
  alwaysKeepRunning = false;
 };
programs = {
  firefox.enable = true;
  steam.enable = true;
  thunar = { enable = true;
    plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin ];
   };
  xfconf.enable = true;
 };

environment.systemPackages = with pkgs; [
  surf /* browser */
  brave
  brightnessctl
  cryptsetup
  # dnsmasq
  deno 
  efibootmgr
  feh
  qimgv
  netbird
  nomacs
  ffmpegthumbnailer
  fswebcam
  git
  gh
  gitg
  git-credential-keepassxc
  gscreenshot
  keepassxc
  mpv
  mullvad-vpn /* duh */
  networkmanagerapplet
  nextcloud-client
  nodejs_20
  openssl
  sops
  spotify spotify-player 
  x11vnc tigervnc
  wget
];
}
