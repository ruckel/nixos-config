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
      enable = true;
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
    audacity /* audio editor */
    bat
    brightnessctl
    #busybox
    clinfo
    chatterino7 alsa-lib
    deno #node alternative
    ddclient
    delta
    desktop-file-utils
    dmenu networkmanager_dmenu
    drawio
    docker docker-compose
    easyeffects helvum vesktop
    efibootmgr
    endeavour
    jetbrains.webstorm /* ide / code editor */
    jetbrains.pycharm-community-bin
    feh qimgv nomacs
    ferdium element-desktop
    ffmpegthumbnailer
    figma-linux
    firebase-tools
    fswebcam
    fortune
    gdu
    gimp openshot-qt obs-studio pinta
    git gh gitg
    gnupg
    gparted
    gradience
    gscreenshot
    htop
    kdocker
    keepassxc git-credential-keepassxc cryptsetup
    lazygit merge-fmt
    libgnomekbd
    libsForQt5.kleopatra
    libreoffice
    lsof showmethekey trashy termimage place-cursor-at mktemp
    mdp
    menulibre
    mpv media-downloader vlc playerctl helvum
    #mullvad-vpn /* duh */
    networkmanagerapplet
    nextcloud-client syncthing rymdport
    nix-plugins
    nodejs-slim nodePackages.npm dum
    ngrok jq
    ntfy-sh
    obsidian /* note editor */
    gnome-photos digikam shotwell libsForQt5.libopenshot
    photoqt previewqt
    qutebrowser
    signal-desktop /* E2E-encrypted chat */
    simplex-chat-desktop /* E2E-encrypted chat */
    #spacedrive
    sops /* secret manager */
    spotify spotify-tray spotifywm spotifyd spotify-player mlterm
    super-productivity /* task manager / pomodoro timer */
    streamlink
    shotcut /*openshot-qt*/
    taskwarrior3 /* task manager */ ptask /* taskwarrior plugin */
    tiramisu toastify #ntfy-sh
    tealdeer
    dunst libnotify
    tealdeer
    transmission_3
    translate-shell
    tmux
    tuxguitar /* guitar pro-like */
    usbutils
    upscayl
    veracrypt scrypt cryptsetup #rage /* encryption tools */
    thunderbird birdtray /* email client */
    ots /* onetimesecret cli */
    vscodium-fhs /* code editor */
    wine
    xorg.xev xorg.xmodmap xorg.xkill
    xscreensaver 
    xclip xprintidle xdotool
    zed-editor
    firebase-tools
    yazi
    kitty
    bluez-tools
];
}
