{ config, pkgs, lib, inputs, hostName, userName, vars, ... }: with lib;
#let vars = import "${inputs.vars}";
#in
{
  imports = [
    ../../modules/imports.nix
    ./hardware-configuration.nix
    ./packages.nix
   ];

#  print.this = [ "${vars.username-admin}" "${toString vars.ssh-ports}" ];

netbird.enable = true;
services.zoneminder = { enable = false;
  database = {
    createLocally =   true;
    username =        "zoneminder";
  }; 
};
services.home-assistant = {
  enable = false;
  config.homeassistant.name = "home";
};
/* custom services */
  adb.enable            = true;
  autorandr.enable      = true;
 #autorandr.enableProfile = {
 #  "tv" = true;
 #  "def" = true;
 #};
  scripts.enable        = true;
  customkbd.enable      = true;
  dunst-service.enable  = true;
  ffsyncserver.enable   = true;

  localization.enable   = true;
  mpv.enable            = true;
  mysql.enable          = true;
  obsStudio.enable      = true;
  pcon = {
    enable = true;
    gscon = false;
    kde = true;
   };
  pythonconf.enable     = true;
  qemu.enable           = true;
  soundconf = {
    enable            = true;
    lowLatency        = true;
    combine           = true;
   };
  ssh.enable            = true;
  syncthing.enable      = true;
  userServices = {
    enable              = true;
    lockScreenOnBoot    = true;
  };
  tmux.enable           = true;
  transmission = {
    enable              = true;
  };
  vim.enable            = true;

  experimental = {
    enable                  = true;
    enableSystembus-notify  = true;
    enableAvahi             = true;
    enableRustdeskServer    = true;
    enableVirtualScreen     = true;
    enableVncFirewall       = true;
   };
/* end custom services */

  programs.java.enable      = false;

  x = {
#    defaultSession = "gnome-xorg";
     wm.dwm = true;
  };


  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "libsoup-2.74.3" "spotify" ];
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
   };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.localBinInPath = true;
  system.stateVersion = "24.05"; /* DONT toush */
  services.printing.enable = true;
  services.devmon.enable = true; /* automatic device mounting daemon */
  services.gvfs.enable = true; /* Mount, trash, and other functionalities */
  services.tumbler.enable = true; /* Thumbnail support for images */
  services.udisks2 = { enable = true; #settings = {};
    mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.mullvad-vpn.enable = true;
  x.autologin = userName;
  users.users."${userName}" = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "transmission" ];
    packages = with pkgs; [ tilix bc ];
    hashedPasswordFile = mkAfter config.sops.secrets.pw.path;
  };
  fonts.packages = with pkgs; [
    # nerdfonts /* All nerdfonts */
    aileron /* helvetica in 9 weights */
    fira fira-code nerd-fonts.fira-code
    noto-fonts noto-fonts-cjk-sans
    comic-mono comic-relief
  ];
  xdg = {
    autostart.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
     };
  };
  qt.style = "adwaita-dark";
  networking = {
    hostName = "nixburk";#hostName;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 3000 3001 ];
      allowedTCPPortRanges = [{ from = 40000; to = 65535; }];
    };
  };
  boot.plymouth = { enable = true;
    # themePackages = [ ];
    # theme         = "";
    # logo          = "";
    # font          = "";
    # extraConfig   = "";
   };
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
   };
  boot.tmp = {
    cleanOnBoot = false;
    useTmpfs = false;
    tmpfsSize = "50%";
   };
  
  nix.gc = { # nix-collect-garbage
    options = "--delete-older-than 30d"; # removes stale profile generations
    automatic = true;
    dates = "06:00";
     # persistent = false; # (def: t) time when the service unit was last triggered is stored on disk
  };
}
