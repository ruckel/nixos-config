{ config, pkgs, lib, inputs, hostName, userName, vars, ... }: with lib;
{
  imports = [
    ../../modules/imports.nix
    ./hardware-configuration.nix
    ./packages.nix
  ];

  adb = {
    enable            = true;
    user              = userName;
    #ports             = vars.adbports;
  };
  scripts.enable      = true;
  customkbd.enable    = true;
  dwm.enable          = true;
  dwm.noBorder        = true;
  localization.enable = true;
  pcon = {
    enable = true;
    gscon = false;
    kde = true;
  };
  soundconf.enable    = true;
  ssh.enable          = true;
  syncthing.enable    = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  sops = {
    defaultSopsFile = /home/${userName}/nixos-cfg/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
    age.generateKey = true;
    secrets.pw.neededForUsers = true;
    secrets.nc-admin-pw = {};
    #secrets.data = {};
    #secrets.nc-admin-pw.owner = config.users.users.nextcloud.name;
  };
  environment.etc."test/test".source = config.sops.secrets."pw".path;
/* Constants */
  environment.localBinInPath = true;
  system.stateVersion = "24.05";
  services.devmon.enable = true; /* automatic device mounting daemon */
  services.gvfs.enable = true; /* Mount, trash, and other functionalities */
  services.tumbler.enable = true; /* Thumbnail support for images */
  services.udisks2 = {
    enable = true;
    #settings = {};
    mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
  users.users.${userName} = {
    isNormalUser = true;
    description = userName;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tilix bc ];
  };
  fonts.packages = with pkgs; [
    fira fira-code fira-code-nerdfont
    noto-fonts noto-fonts-cjk-sans
  ];
  xdg = {
    autostart.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      lxqt.enable = true;
    };
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = userName;
  };
  services.displayManager.defaultSession = "lxqt"; #"none+dwm"; # "gnome"
  services.xserver = {
    enable = true;
  };
  services.xserver.displayManager.lxqt.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = false;
  };
  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    firewall.enable = true;
  };
  boot.plymouth.enable = true;
  boot.loader.grub = {
    enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = false;
  };
  nix.gc = { /* garbage collection */
    automatic = true;
    dates = "06:00";
  };
}
