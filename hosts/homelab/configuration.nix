{ config, pkgs, lib, inputs, ... }:
{ imports = [
  ../../modules/imports.nix
  /etc/nixos/hardware-configuration.nix
  ./packages.nix
];

fileSystems = {
  "/var/lib/nextcloud/5tb" = {
    device = "/dev/disk/by-uuid/cbbd80d8-68e0-4288-afcd-b040c8865dd8";
    # options = [ "uid=990" "gid=989" "dmask=007" "fmask=117" ];
  };
};
netbird.clients = {
  netbird = {
    port = 51820;
    hardened = false;
    interface = "nb0";
    name = "netbird";
  };
};
services.nextcloud.settings.trusted_domains = ["100.84.203.89"];

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
fail2ban.enable     = true;
gnomeWM.enable      = true;
immich = { enable   = false;
  domain           = "immich.korv.lol";
  hwVideo          = false;
  ml               = false;
};
kodi.enable         = true;
localization.enable = true;
mysql.enable        = true;
nc = {
  enable             = true;
  version            = "31";
  pwfile	           = "/pw/pw"; #config.sops.secrets.nc-admin-pw.path;
  jellyfin.enable    = true;
};
soundconf = { 
  enable      = true;
  user                    = "user";
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
  pwauth            = false;
  x11fw             = false;
  vncbg             = false;
};
syncthing.enable    = true;
syncthing.user      = "user";
tmux.enable         = true;
transmission.enable   = true;
ollama.enable       = false;
xprofile.enable     = true;
xprofile.user       = "user";

experimental = {
  enable                  = false;
  user                    = "user";
  enableAvahi             = true;
  enableVirtualScreen     = true;
  enableVncFirewall       = true;
};

services.displayManager.defaultSession = "none+dwm"; # "gnome"

/*systemd.services = { # fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  "getty@tty1".enable = false;
  "autovt@tty1".enable = false;
};*/
nixpkgs.config = {
  allowUnfree = true;
  permittedInsecurePackages = [];
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
};

/* Constants */
environment.localBinInPath = true;
system.stateVersion =  "23.11";
services = {
  devmon.enable = true; /* automatic device mounting daemon */
  gvfs.enable = true; /* Mount, trash, and other functionalities */
  tumbler.enable = true; /* Thumbnail support for images */
  udisks2 = { enable = true; #settings = {};
    mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
    };
  xserver.enable = true;
  mullvad-vpn.enable = true;
};
users.users.${"user"} = { isNormalUser = true;
  description = "user";
  extraGroups = [ "networkmanager" "wheel" ];
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
}
