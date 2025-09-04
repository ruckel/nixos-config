{ config, pkgs, lib, inputs, ... }:
{ imports = [
  ../../modules/imports.nix
  ./hardware-configuration.nix
  ./packages.nix
];

fileSystems = {
  "/var/lib/nextcloud/5tb" = {
    device = "/dev/disk/by-uuid/cbbd80d8-68e0-4288-afcd-b040c8865dd8";
    # options = [ "uid=990" "gid=989" "dmask=007" "fmask=117" ];
  };
};

x = {
  dm = "startx";
  defaultSession = null;
  wm.kodi = true;
};

netbird.clients = {
  netbird = {
    port = 51820;
    hardened = false;
    interface = "nb0";
    name = "netbird";
  };
};

# remember to keep the cachix keys updated for nvidia: while using cachix for the nvidia latest packages
# do this by running `cachix use cuda-maintainers`
nix.settings = {
  substituters = [ "https://cuda-maintainers.cachix.org" ];
  trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
};
environment.systemPackages = [ pkgs.cachix ];
localization.enable = true;
ssh = {
  enable            = true;
  user              = "user";
  ports             = [ 6842 6843 6844 ]; # todo ports
  keys              = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJsd82H9yUf2hgBiXECvfPVgUxy84vHz5MbsBDbShvv korv@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPC8sV9tofPmdM1VmrsUK1AoymNkobPphDynC6nKd/E korv@nixos-dell"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa8dGCkZtulhJ7Peg2XvdryhAowWpL0hVMAS+i0I1t5 root@debian-homelab"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEpTIZfMSLWJBzkvSZyCthrU40R0CB8GjRi0WUMxi62z korv@pixel"
  ];
  pwauth            = true;
  x11fw             = false;
  vncbg             = false;
};
boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
};
nginx.enable = true;
    mysql.enable        = true;
    nc = {
      enable             = true;
      hostName = "moln.kevindybeck.com";
      directory = "/var/lib/nextcloud/5tb/nextcloud";
      version            = "30";
      jellyfin.enable    = true;
    };
    kodi.enable         = true;
nix.settings.experimental-features = [ "nix-command" "flakes" ];
sops = {
  defaultSopsFile = /home/user/nixos-cfg/secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
  age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  age.keyFile = "/home/user/.config/sops/age/keys.txt";
  age.generateKey = true;
  secrets.pw.neededForUsers = true;
  secrets.nc-admin-pw = {};
};

# services.mullvad-vpn.enable = true;
environment.localBinInPath = true;
system.stateVersion =  "23.11";
services = {
  devmon.enable = true;  # automatic device mounting daemon
  gvfs.enable = true;    # Mount, trash, and other functionalities
  tumbler.enable = true; # Thumbnail support for images
  udisks2 = { 
    enable = true; #settings = {};
    mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
};
users.users = {
  "kodi" = {
    isNormalUser = true;
    description = "graphical user";
    
  };
  ${"user"} = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tilix bc ];
    hashedPasswordFile = config.sops.secrets.pw.path;
  };
};
networking = {
  hostName = "nix-homelab";
  networkmanager.enable = true;
  firewall.enable = true;
};
nix.gc = { # nix-collect-garbage
  options = "--delete-older-than 30d"; # removes stale profile generations
  automatic = true;
  dates = "06:00";
   # persistent = false; # (def: t) time when the service unit was last triggered is stored on disk
};
}
