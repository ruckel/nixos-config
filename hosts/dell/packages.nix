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
    i3lock i3lock-blur i3lock-color i3lock-fancy i3lock-fancy-rapid xss-lock
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
    bat
    brightnessctl
    #busybox
    clinfo
    deno
    ddclient
    dmenu networkmanager_dmenu
    easyeffects helvum vesktop
    efibootmgr
    endeavour
    #jetbrains.idea-community /* ide / code editor */
    fastfetch
    feh qimgv nomacs
    ferdium element-desktop
    ffmpegthumbnailer
    fswebcam
    gdu
    gimp openshot-qt obs-studio pinta
    git gh gitg
    gnupg
    gparted
    gradience
    gscreenshot
    htop
    hydrapaper
    jetbrains.jdk
    keepassxc git-credential-keepassxc cryptsetup
    lazygit
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
    openshot-qt gnome-photos digikam shotwell
    qutebrowser
    rofi
    signal-desktop /* E2E-encrypted chat */
    simplex-chat-desktop /* E2E-encrypted chat */
    #spacedrive
    sops /* secret manager */
    spotify spotify-tray spotifywm spotifyd spotify-player mlterm
    super-productivity /* task manager / pomodoro timer */
    tealdeer
    tiramisu toastify #ntfy-sh
    dunst libnotify
    transmission_4
    tuxguitar /* guitar pro-like */
    veracrypt scrypt cryptsetup #rage /* encryption tools */
    thunderbird birdtray /* email client */
    ots /* onetimesecret cli */
    vscodium-fhs /* code editor */
    xorg.xev lsof showmethekey trashy termimage xprintidle xdotool place-cursor-at mktemp xclip
    jellyfin-media-player
    zed-editor
];
}
