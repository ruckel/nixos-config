{ config, pkgs, ... }:
let vars = import "${inputs.vars}"; in
{ imports = [
  ../../modules/imports.nix
  ./hardware-configuration.nix
  ./packages.nix
  ];


adb = {
  enable            = true;
  user              = "user";
  #ports             = vars.adbports;
};
scripts.enable      = true;
customkbd.enable    = true;
dwm.enable          = true;
localization.enable = true;
pcon = {
  enable = true;
  gscon = false;
  kde = true;
};
#pythonconf.enable   = true;
soundconf.enable    = true;
soundconf.user      = "user";
ssh = {
  enable            = true;
  user              = "user";
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
syncthing.user      = "user";
systemdconf.enable  = true;
#ollama.enable       = true;
xprofile.enable     = true;
xprofile.user       = "user";

experimental = {
  enable                  = true;
  user                    = "user";
#  enableSystembus-notify  = true;
#  enableAvahi             = true;
#  enableRustdeskServer    = true;
#  enableVirtualScreen     = true;
  enableVncFirewall       = true;
};


services.displayManager.defaultSession = "none+dwm"; # "gnome"

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
services.udisks2 = { enable = true; #settings = {};
  mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
services.xserver = {
  enable = true;
};
services.mullvad-vpn.enable = true;
users.users.${"user"} = { isNormalUser = true;
    description = "user";
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
  };
  };
services.displayManager.autoLogin = {
  enable = true;
  user = "user";
};
services.xserver.displayManager.gdm = {
  enable = true;
  wayland = false;
};
networking = {
  hostName = "vaio";
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
system.autoUpgrade = {
   enable = true;
   allowReboot = false; #true;
   channel = "https://channels.nixos.org/nixos-24.05-small";
};
}
