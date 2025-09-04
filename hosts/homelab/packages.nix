  {pkgs, ...}:{
 # services.dnsmasq = { enable = true;
  #alwaysKeepRunning = false;
 #};
programs = {
  #firefox.enable = true;
  #steam.enable = true;
  #thunar = { enable = true;
   # plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin ];
   #};
  xfconf.enable = true;
 };

environment.systemPackages = with pkgs; [
  surf /* browser */
  cryptsetup
  deno
  efibootmgr
  netbird
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
  #spotify spotify-player 
  wget
];
}
