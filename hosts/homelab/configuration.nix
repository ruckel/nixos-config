{ config, pkgs, lib, inputs, ... }:
#let vars = import "${inputs.vars}"; in
{ imports = [
  ../../modules/imports.nix
  /etc/nixos/hardware-configuration.nix
  ./packages.nix
 #/etc/nixos/cachix.nix
  ];

#networking.firewall = {
#    allowedTCPPorts = [ 80 ]; #TODO ports
#    allowedUDPPorts = [ 80 ];
#    };
fileSystems = {
# "/" = {
#   device = "/dev/sda2";
# };
  "/var/lib/nextcloud/5tb" = {
    label = "5tb";
    device = "/dev/disk/by-uuid/cbbd80d8-68e0-4288-afcd-b040c8865dd8";
#    options = [ "uid=990" "gid=989" "dmask=007" "fmask=117" ];
  };
};

  # remember to keep the cachix keys updated for nvidia: while using cachix for the nvidia latest packages
  # do this by running `cachix use cuda-maintainers`
  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
  };
  environment.systemPackages = [ pkgs.cachix ];

scripts.enable      = true;
customkbd.enable    = true;
dwm = {
  enable            = true;
  user              = "user";
};
 docker.enable       = true;
 gnomeWM.enable      = true;
 kodi.enable         = true;
 localization.enable = true;
 mysql.enable        = true;
 nc.enable           = true;
nc.pwfile	    = "/pw/pw"; #config.sops.secrets.nc-admin-pw.path;
  soundconf = { enable      = true;
    user                    = "user";
    disablehdmi             = true;
    linkout                 = false;
    headless                = true;
  };
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
 ollama.enable       = true;
 xprofile.enable     = true;
 xprofile.user       = "user";

experimental = {
  enable                  = true;
  user                    = "user";
  enableAvahi             = true;
  enableVirtualScreen     = true;
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
  defaultSopsFile = /home/user/nixos-cfg/secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
  age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  age.keyFile = "/home/user/.config/sops/age/keys.txt";
  age.generateKey = true;
  secrets.pw.neededForUsers = true;
  secrets.nc-admin-pw = {};
  secrets.nc-admin-pw.owner = config.users.users.nextcloud.name;
 #secrets.nc-admin-pw.neededForUsers = true;
  #secrets.data = {};
};

/* Constants */
environment.localBinInPath = true;
system.stateVersion =  "23.11";
services.devmon.enable = true; /* automatic device mounting daemon */
services.gvfs.enable = true; /* Mount, trash, and other functionalities */
services.tumbler.enable = true; /* Thumbnail support for images */
services.udisks2 = { enable = true; #settings = {};
  mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
services.xserver.enable = true;
#services.mullvad-vpn.enable = true;
users.users.${"user"} = { isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tilix bc ];
    hashedPasswordFile = config.sops.secrets.pw.path;
};
#users.users."nextcloud" = { isSystemUser = true; group = "nextcloud";};
#users.groups.nextcloud = {};
fonts.packages = with pkgs; [
    fira fira-code fira-code-nerdfont
    noto-fonts noto-fonts-cjk-sans
];
xdg = {
  autostart.enable = true;
  icons.enable = true;
#  portal = {
#    enable = true;
#    extraPortals = [pkgs.xdg-desktop-portal-gtk];
#  };
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
  hostName = "nix-homelab";
  networkmanager.enable = true;
  firewall.enable = true;
  firewall.allowedTCPPorts = [ 80 ]; #TODO ports
  firewall.allowedUDPPorts = [ 80 ];


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
   allowReboot = true;
   channel = "https://channels.nixos.org/nixos-unstable";
};
}
