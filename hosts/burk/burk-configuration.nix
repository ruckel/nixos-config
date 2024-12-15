{ config, pkgs, lib, inputs, ... }:
let vars = import "${inputs.vars}"; in
{ imports = [
  ../../modules/imports.nix
  ./hardware-configuration.nix
  ./packages.nix
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

adb = {
  enable            = true;
  user              = "korv";
  #ports             = vars.adbports;
};
autorandr.enable    = true;
#autorandr.extraconf = true;
scripts.enable      = true;
customkbd.enable    = true;
#docker.enable       = true;
#docker.user         = "korv";
dwm = {
  enable            = true;
  user              = "korv";
};
#ffsyncserver.enable = true;
hyprland.enable     = true;
gnomeWM.enable      = true;
kanata.enable       = true;
kanata.user         = "korv";
localization.enable = true;
#mysql.enable        = true;
#nc.enable           = true;
qemu.enable         = true;
pcon = {
  enable = true;
  gscon = false;
  kde = true;
};
pythonconf.enable   = true;
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
  pwauth            = true;
  x11fw             = true;
  vncbg             = true;
};
syncthing.enable    = true;
syncthing.user      = "korv";
systemdconf.enable  = true;
 # ollama.enable       = true;
xprofile.enable     = true;
xprofile.user       = "korv";

experimental = {
  enable                  = true;
  user                    = "korv";
  enableSystembus-notify  = true;
  enableAvahi             = true;
  enableRustdeskServer    = true;
  enableVirtualScreen     = true;
  enableVncFirewall       = true;
};

programs.java.enable      = true;

services.displayManager.defaultSession = /*"none+dwm"*/ /**/"gnome"/**/  ;

systemd.services = { # fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  "getty@tty1".enable = false;
  "autovt@tty1".enable = false;
};
nixpkgs.config = {
  allowUnfree = true;
  permittedInsecurePackages = [
    #"python3.11-youtube-dl-2021.12.17"
  ];
};
nix.settings.experimental-features = [ "nix-command" "flakes" ];
sops = {
  defaultSopsFile = /home/korv/nixos-cfg/secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
  age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  age.keyFile = "/home/korv/.config/sops/age/keys.txt";
  age.generateKey = true;
  secrets.pw.neededForUsers = true;
  secrets.nc-admin-pw = {};
 #secrets.nc-admin-pw.owner = config.users.users.nextcloud.name;
 #secrets.data = {};
};
environment.etc."test/test".source = config.sops.secrets."pw".path;

/* Constants */
environment.localBinInPath = true;
system.stateVersion = "24.05";
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
services.mullvad-vpn.enable = true;
users.users."korv" = { isNormalUser = true;
    description = "korv";
    extraGroups = [ "networkmanager" "wheel" "transmission" ];
    packages = with pkgs; [ tilix bc ];
    hashedPasswordFile = config.sops.secrets.pw.path;
};
fonts.packages = with pkgs; [
    aileron /* helvetica in 9 weights */
    fira fira-code fira-code-nerdfont
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
services.displayManager.autoLogin = {
  enable = true;
  user = "korv";
};
services.xserver.displayManager.gdm = {
  enable = true;
  wayland = false;
};
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
 #themePackages = [ ];
 #theme         = "";
 #logo          = "";
 #font          = "";
 #extraConfig   = "";
};
boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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
}
