{pkgs, ...}:{
  programs = {
    bash.vteIntegration = true;
    firefox.enable = true;
    thunar = { enable = true;
      plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin ];
    };
    xfconf.enable = true;
  };
  environment.systemPackages = with pkgs; [
    surf /* browser */
    brightnessctl
    efibootmgr
    feh
    qimgv
    nomacs
    ffmpegthumbnailer
    fswebcam
    git
    gh
    gitg
    gscreenshot
    keepassxc
    lazygit
    git-credential-keepassxc
    cryptsetup
    mpv
    mullvad-vpn /* duh */
    networkmanagerapplet
    nextcloud-client
    spotify-player mlterm
    xorg.xev lsof showmethekey trashy termimage xprintidle xdotool place-cursor-at mktemp xclip
    x11vnc tigervnc
    vim
    tilix
];
}
