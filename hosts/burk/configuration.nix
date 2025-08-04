{ config, pkgs, lib, inputs, ... }:
let vars = import "${inputs.vars}"; in
{
  imports = [
    ../../modules/imports.nix
    ./hardware-configuration.nix
    ./packages.nix
   ];
  services.zoneminder = { enable = true;
    database = {
      createLocally =   true;
      username =        "zoneminder";
    }; 
   };
/*
environment.etc = {
  "xdg/user-dirs.defaults".text = ''
    # Format: XDG_xxx_DIR="$HOME/$USERDIR"
    # USERDIR = [ homedir-relative path | absolute path ]
    #
    # Doesn't change already created user-dirs.
    # For that; see:
    #   ~/.config/user-dirs.dirs
    #   man xdg-user-dirs-update
    DESKTOP="$HOME/files/desktop"
    DOWNLOAD="$HOME/files/downloads"
    DOCUMENTS="$HOME/files/Documents"
    MUSIC="$HOME/files/music"
    PICTURES="$HOME/files/pictures"
    VIDEOS="$HOME/files/videos"
    PUBLICSHARE="$HOME/files/public"
    TEMPLATES="/media/some/other/dir"
  '';
};
*/
/* custom services */
  adb = { enable        = true;
    user                = "korv";
    # ports               = vars.adbports;
   };
  autorandr.enable      = true;
 #autorandr.enableProfile = {
 #  "tv" = true;
 #  "def" = true;
 #};
  scripts.enable        = true;
  customkbd.enable      = true;
  # docker = { enable     = true;
    # user                = "korv";
   # };
  dwm = { enable        = true;
    user                  = "korv";
   };
  dunst-service = { enable = true;
    user                   = "korv";
   };
  # ffsyncserver.enable   = true;
  hyprland.enable       = true;
  gnomeWM.enable        = true;
  # kanata.enable         = true;
  # kanata.user           = "korv";
  localization.enable   = true;
  mysql.enable        = true;
  # nc.enable           = true;
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
    user              = "korv";
    lowLatency        = true;
    combine           = true;
   };
  ssh = {
    enable            = true;
    user              = "korv";
    ports             = [ 6842 6843 6844 ];
    keys              = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJsd82H9yUf2hgBiXECvfPVgUxy84vHz5MbsBDbShvv korv@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPC8sV9tofPmdM1VmrsUK1AoymNkobPphDynC6nKd/E korv@nixos-dell"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa8dGCkZtulhJ7Peg2XvdryhAowWpL0hVMAS+i0I1t5 root@debian-homelab"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEpTIZfMSLWJBzkvSZyCthrU40R0CB8GjRi0WUMxi62z korv@pixel"
     ];
     pwauth            = false;
     x11fw             = true;
     vncbg             = true;
   };
  syncthing = { enable  = true;
    user                = "korv";
   };
  lockScreenOnBoot.enable= true;
  #sxwm.enable           = true;
  # ollama.enable       = true;
  tmux.enable           = true;
  vim.enable            = true;
  xprofile = { enable   = true;
    user                = "korv";
   };

  experimental = {
    enable                  = true;
    user                    = "korv";
    enableSystembus-notify  = true;
    enableAvahi             = true;
    enableRustdeskServer    = true;
    enableVirtualScreen     = true;
    enableVncFirewall       = true;
   };
/* end custom services */

  programs.java.enable      = true;

  services.displayManager.defaultSession = "gnome-xorg"
    # "none+dwm"
    # "gnome"
    # "none+sxwm"
    # "gnome-xorg"
   ;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  systemd.services = { # fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
   };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "libsoup-2.74.3" "spotify" ];
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
   };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  sops = {
    defaultSopsFile = /*/home/korv/nixos-cfg*/../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.keyFile =
      "/home/korv" +
      # ".." +
      "/.config/sops/age/keys.txt";
    age.generateKey = true;
    secrets.pw.neededForUsers = true;
    secrets.nc-admin-pw = {};
    # secrets.nc-admin-pw.owner = config.users.users.nextcloud.name;
    # secrets.data = {};
   };
  environment.etc."test/test".source = config.sops.secrets."pw".path;

/* Constants */
  environment.localBinInPath = true;
  system.stateVersion = "24.05"; /* DONT toush */
  services.printing.enable = true;
  services.devmon.enable = true; /* automatic device mounting daemon */
  services.gvfs.enable = true; /* Mount, trash, and other functionalities */
  services.tumbler.enable = true; /* Thumbnail support for images */
  services.udisks2 = { enable = true; #settings = {};
    mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
   };
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
   };
  # services.mullvad-vpn.enable = true;
  users.users."korv" = { isNormalUser = true;
    description = "korv";
    extraGroups = [ "networkmanager" "wheel" "transmission" ];
    packages = with pkgs; [ tilix bc ];
    hashedPasswordFile = config.sops.secrets.pw.path;
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
  services.displayManager = {
    gdm = {
      enable = true;
      wayland = false;
    };
    autoLogin = { enable = true;
      user = "korv";
   };
  };
  qt.style = "adwaita-dark";
  networking = {
    hostName = "nixburk";#vars.host.burk;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 443 3000 ]; #TODO ports
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
  nix.gc = { /* garbage collection */
    automatic = true;
    dates = "06:00";
   };
  system.autoUpgrade = {
    enable = true;
    allowReboot = false; #true;
    channel = "https://channels.nixos.org/nixos-unstable";
   };
/* end constants */
}
