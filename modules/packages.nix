{ lib, pkgs, config, ... } :
with lib;
let args = {
  cfg = config.mypkgs;
  textfile = import ../packages.txt;
};
in {
  options.mypkgs = {
    enable = mkEnableOption "DESCRIPTION";

    };

  config = {
    programs = {
      bash.vteIntegration = true;
      firefox.enable = true;
      steam.enable = true;
      appimage.binfmt = true;
      thunar = { enable = true; 
        plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin ];
      };
    };
    environment.systemPackages = with pkgs; [#args.textfile 
     appimage-run
brave floorp ungoogled-chromium surf
brightnessctl
dmenu networkmanager_dmenu
easyeffects helvum
endeavour
feh qimgv nomacs
ferdium element-desktop
foot
gimp openshot-qt obs-studio pinta
git gh
gradience
keepassxc
libgnomekbd
libreoffice

menulibre
mpv media-downloader vlc playerctl helvum
mullvad-vpn
networkmanagerapplet
nextcloud-client syncthing transmission rymdport
openshot-qt gnome-photos digikam shotwell
signal-desktop simplex-chat-desktop
spotify spotify-tray spotifywm spotifyd spotify-player mlterm
super-productivity
tiramisu toastify ntfy-sh dunst
tuxguitar
veracrypt scrypt #rage
tilix vim termimage feh mdp trashy ots xorg.xev lsof showmethekey
vscodium-fhs
x11vnc tigervnc scrcpy 

    ];
  };
}