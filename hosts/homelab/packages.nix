{pkgs, ...}:{ environment.systemPackages = with pkgs; [
  surf /* browser */
  cryptsetup
  deno
  efibootmgr
  netbird
  fastfetch
  ffmpegthumbnailer
  fswebcam
  git
  gh
  gitg
  git-credential-keepassxc
  keepassxc
  #mpv
  mullvad-vpn /* duh */
  networkmanagerapplet
  nodejs_20
  openssl
  sops
  sqlite
  xkbset
  spotify
  wget
];}
