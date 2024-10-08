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
    services.transmission.enable = true;
    programs = {
      appimage.binfmt = true;
      bash.vteIntegration = true;
      firefox.enable = true;
      kdeconnect.enable = true;
      steam.enable = true;
      thunar = { enable = true;
        plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin ];
      };
      vim.defaultEditor = true;
      xfconf.enable = true;
    };
    environment.systemPackages = with pkgs; [#args.textfile
     #android-studio
     appimage-run
     arandr
brave floorp ungoogled-chromium surf
#bitwig-studio audacity
brightnessctl
#busybox
ddclient
dmenu networkmanager_dmenu
easyeffects helvum vesktop
efibootmgr
endeavour
feh qimgv nomacs
ferdium element-desktop
ffmpegthumbnailer
foot
fswebcam
gimp openshot-qt obs-studio pinta
git gh gitg
gparted
gradience
keepassxc git-credential-keepassxc cryptsetup
libgnomekbd
libreoffice
mdp
menulibre
mpv media-downloader vlc playerctl helvum
mullvad-vpn
networkmanagerapplet
nextcloud-client syncthing transmission rymdport
obsidian
openshot-qt gnome-photos digikam shotwell
signal-desktop simplex-chat-desktop
#spacedrive
spotify spotify-tray spotifywm spotifyd spotify-player mlterm
super-productivity
taskwarrior3 ptask
tiramisu toastify ntfy-sh dunst libnotify
tuxguitar
veracrypt scrypt cryptsetup #rage
thunderbird birdtray
ots
vscodium-fhs
x11vnc tigervnc scrcpy vncdo
xorg.xev lsof showmethekey trashy termimage xprintidle xdotool place-cursor-at mktemp xclip
    ];
  };
}
