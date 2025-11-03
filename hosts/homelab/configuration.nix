{ config, pkgs, lib, inputs, hostName, userName, ... }:
{ imports = [
  ../../modules/imports.nix
  ./hardware-configuration.nix
  ./packages.nix
];
services.avahi.enable = false;
fileSystems = {
  "/var/lib/nextcloud/5tb" = {
    device = "/dev/disk/by-uuid/cbbd80d8-68e0-4288-afcd-b040c8865dd8";
    # options = [ "uid=990" "gid=989" "dmask=007" "fmask=117" ];
  };
};
x = {
  dm = "lightdm";
  defaultSession = "none+dwm";
  wm.kodi = true;
  wm.dwm = true;
  autologin = "user";
};
boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
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
  auth.root         = true;
#  vncbg             = false;
};
tmux.enable         = true;
netbird.clients = {
  netbird = {
    port = 51820;
    hardened = false;
    interface = "nb0";
    name = "netbird";
  };
};
nginx.enable = true;
# services.mullvad-vpn.enable = true;
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
  ${userName} = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tilix bc ];
    hashedPasswordFile = config.sops.secrets.pw.path;
  };
};
networking = {
  hostName = hostName;
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
