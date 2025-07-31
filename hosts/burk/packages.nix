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
    alsa-lib
    android-studio
    appimage-run /* appimage compability wrapper */
    arandr /* gui randr editor */
    #args.textfile
    audacity /* audio editor */
    bat
    birdtray /* email client */
    #bitwig-studio /* audio editor */
    bluez-tools
    brightnessctl
    #busybox
    chatterino7 alsa-lib
    clinfo
    cryptsetup #rage /* encryption tools */
    ddclient
    delta
    deno #node alternative
    desktop-file-utils
    digikam
    dmenu networkmanager_dmenu
    docker docker-compose
    drawio
    easyeffects helvum vesktop
    efibootmgr
    element-desktop
    endeavour
    feh qimgv nomacs
    ferdium element-desktop
    ffmpegthumbnailer
    figma-linux
    firebase-tools
    floorp /* browser */
    fortune
    fswebcam
    gdu
    gh
    gimp 
    git gh gitg
    gnupg
    gparted
    gradience
    gscreenshot
    helvum
    htop
    hydrapaper
    jdocker
    jetbrains.pycharm-community-bin
    jetbrains.webstorm /* ide / code editor */
    jq
    kdocker
    keepassxc git-credential-keepassxc cryptsetup
    kitty
    lazygit 
    libgnomekbd
    libnotify
    libreoffice
    libsForQt5.kleopatra
    libusb-compat-0_1
    libusb1
    libusbp
    lsof 
    mdp
    media-downloader 
    menulibre
    merge-fmt
    mktemp
    mlterm
    mpv 
    #mullvad-vpn /* duh */
    networkmanagerapplet
    nextcloud-client
    ngrok jq
    nix-plugins
    nodePackages.npm dum
    nodejs-slim nodePackages.npm dum
    ntfy-sh
    obs-studio 
    obsidian /* note editor */
    ots /* onetimesecret cli */
    photoqt
    pinta
    place-cursor-at 
    playerctl
    previewqt
    ptask /* taskwarrior plugin */
    qutebrowser
    rkflashtool libusb1 libusbp libusb-compat-0_1
    rymport
    scrypt cryptsetup #rage /* encryption tools */
    showmethekey 
    shotcut /*openshot-qt*/
    shotwell
    signal-desktop /* E2E-encrypted chat */
    simplex-chat-desktop /* E2E-encrypted chat */
    sops /* secret manager */
    #spacedrive
    spotify spotify-tray spotifywm spotifyd spotify-player mlterm
    streamlink
    super-productivity /* task manager / pomodoro timer */
    surf /* browser */
    syncthing
    taskwarrior3 /* task manager */ ptask /* taskwarrior plugin */
    tealdeer
    termimage 
    thunderbird birdtray /* email client */
    tiramisu toastify
    tmux
    translate-shell
    transmission_3
    trashy 
    tuxguitar /* guitar pro-like */
    ungoogled-chromium /* browser */
    upscayl
    usbutils
    veracrypt scrypt cryptsetup #rage /* encryption tools */
    vlc
    vscodium-fhs /* code editor */
    wine
    xclip xprintidle xdotool
    xorg.xev xorg.xmodmap xorg.xkill
    xscreensaver 
    yazi
    zed-editor
];
}
