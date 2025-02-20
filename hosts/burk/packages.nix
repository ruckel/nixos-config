{pkgs, ...}:{
  services.transmission.enable = true;
  programs = {
    appimage.binfmt = true;
    bash.vteIntegration = true;
    firefox.enable = true;
    nix-ld = { enable = true;
      libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
       ];
     };
    steam.enable = true;
    # thunderbird.enable = true;
    gnupg.agent = { enable = true;
      # enableSSHSupport = true;
      # enableBrowserSocket = true;
      # enableExtraSocket = true;
      # pinentryPackage = null;
     };
    thunar = { enable = true;
      plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin ];
     };
    xfconf.enable = true;
   };
  environment.systemPackages = with pkgs; [
    # args.textfile
    android-studio /* android ide */
    appimage-run /* appimage compability wrapper */
    arandr /* gui randr editor */
    brave /* browser */
    floorp /* browser */
    ungoogled-chromium /* browser */
    surf /* browser */
    # bitwig-studio /* audio editor */
    audacity /* audio editor */
    brightnessctl
    busybox /* lsusb */
    # birdtray /* thunderbird tray */
    clinfo
    chatterino2
    deno #node alternative
    ddclient
    delta
    dmenu networkmanager_dmenu
    drawio
    easyeffects helvum vesktop
    efibootmgr
    endeavour
    inkscape /* svg editor  */
    jdk23
    # jetbrains.jdk
    # jetbrains.idea-community /* ide / code editor */
    jetbrains.webstorm
    feh qimgv nomacs
    ferdium element-desktop
    ffmpegthumbnailer
    firebase-tools
    fswebcam
    fortune
    gdu
    gimp openshot-qt pinta
    git gh gitg
    glibc
    gnupg
    gparted
    gradience
    gscreenshot
    keepassxc git-credential-keepassxc cryptsetup
    lazygit merge-fmt
    libgnomekbd
    libsForQt5.kleopatra
    libreoffice
    mdp
    menulibre
    mpv media-downloader vlc playerctl helvum
    # mullvad-vpn /* duh */
    networkmanagerapplet
    nextcloud-client syncthing rymdport
    nix-plugins
    nodejs-slim nodePackages.npm dum
    obsidian /* note editor */
    openshot-qt gnome-photos digikam shotwell libsForQt5.libopenshot
    signal-desktop /* E2E-encrypted chat */
    simplex-chat-desktop /* E2E-encrypted chat */
    # spacedrive
    sops /* secret manager */
    spotify spotify-tray spotifywm spotifyd
    spotify-player mlterm
    streamlink
    super-productivity /* task manager / pomodoro timer */
    taskwarrior3 /* task manager */ ptask /* taskwarrior plugin */
    tiramisu toastify #ntfy-sh
    dunst libnotify
    transmission_4
   #tmux
    tuxguitar /* guitar pro-like */
    tealdeer
    veracrypt scrypt cryptsetup #rage /* encryption tools */
    ots /* onetimesecret cli */
    vscodium-fhs /* code editor */
    wine wine64 wine64Packages.stable winetricks
    xorg.xev lsof showmethekey trashy termimage xprintidle xdotool place-cursor-at mktemp xclip
    xscreensaver
    zed-editor
    firebase-tools
    yazi
    # kitty
    bluez-tools
   ];
}
