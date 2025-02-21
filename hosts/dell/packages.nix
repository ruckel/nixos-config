{pkgs, ...}:{
  services.transmission.enable = true;
  programs = {
    appimage.binfmt = true;
    bash.vteIntegration = true;
    firefox.enable = true;
    steam.enable = true;
    gnupg.agent = {
      enable = true;
    # enableSSHSupport = true;
    # enableBrowserSocket = true;
    # enableExtraSocket = true;
    # pinentryPackage = null;
    };
    thunar = { enable = true;
      plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin ];
    };
    vim = {
      #enable = true;
      defaultEditor = true;
    };
    xfconf.enable = true;
  };
  environment.systemPackages = with pkgs; [
#args.textfile
#android-studio /* android ide */
appimage-run /* appimage compability wrapper */
arandr /* gui randr editor */
brave /* browser */
floorp /* browser */
ungoogled-chromium /* browser */
surf /* browser */
#bitwig-studio /* audio editor */
#audacity /* audio editor */
brightnessctl
#busybox
clinfo
ddclient
dmenu networkmanager_dmenu
easyeffects helvum vesktop
efibootmgr
endeavour
jetbrains.webstorm /* ide / code editor */
feh qimgv nomacs
ferdium element-desktop
ffmpegthumbnailer
fswebcam
gimp openshot-qt obs-studio pinta
git gh gitg
gnupg
gparted
gradience
gscreenshot
keepassxc git-credential-keepassxc cryptsetup
libgnomekbd
libsForQt5.kleopatra
libreoffice
mdp
menulibre
mpv media-downloader vlc playerctl helvum
mullvad-vpn /* duh */
networkmanagerapplet
nextcloud-client syncthing rymdport
nix-plugins
nodejs-slim nodePackages.npm dum
obsidian /* note editor */
openshot-qt gnome-photos digikam shotwell
signal-desktop /* E2E-encrypted chat */
simplex-chat-desktop /* E2E-encrypted chat */
#spacedrive
sops /* secret manager */
spotify spotify-tray spotifywm spotifyd spotify-player mlterm
super-productivity /* task manager / pomodoro timer */
taskwarrior3 /* task manager */ ptask /* taskwarrior plugin */
tiramisu toastify #ntfy-sh
dunst libnotify
transmission #_3
tuxguitar /* guitar pro-like */
veracrypt scrypt cryptsetup #rage /* encryption tools */
thunderbird birdtray /* email client */
ots /* onetimesecret cli */
vscodium-fhs /* code editor */
xorg.xev lsof showmethekey trashy termimage xprintidle xdotool place-cursor-at mktemp xclip
];
}
