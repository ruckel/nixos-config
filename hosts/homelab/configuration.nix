{ config, pkgs, lib, inputs, ... }:
let vars = import "${inputs.vars}"; in
{ imports = [
  ../../modules/imports.nix
  ./hardware-configuration.nix
  ./packages.nix
  ];


scripts.enable      = true;
customkbd.enable    = true;
dwm = {
  enable            = true;
  user              = vars.user.lab;
};
localization.enable = true;
mysql.enable        = true;
nc.enable           = true;
soundconf.enable    = true;
soundconf.user      = vars.user.lab;
ssh = {
  enable            = true;
  user              = vars.user.lab;
  ports             = vars.ports;
  keys              = vars.keys;
  pwauth            = true;
  x11fw             = true;
  vncbg             = true;
};
syncthing.enable    = true;
syncthing.user      = vars.user.lab;
systemdconf.enable  = true;
#ollama.enable       = true;
xprofile.enable     = true;
xprofile.user       = vars.user.lab;

experimental = {
  enable                  = true;
  user                    = vars.user.lab;
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
  defaultSopsFile = ./secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
  age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  age.keyFile = "../.config/sops/age/keys.txt";
  age.generateKey = true;
  secrets.pw.neededForUsers = true;
  secrets.nc-admin-pw = {};
  secrets.nc-admin-pw.owner = config.users.users.nextcloud.name;
  #secrets.data = {};
};
environment.etc."test/test".source = config.sops.secrets."pw".path;

/* Constants */
environment.localBinInPath = true;
system.stateVersion = "24.05"; /*vars.burkStateVersion;*/
services.devmon.enable = true; /* automatic device mounting daemon */
services.gvfs.enable = true; /* Mount, trash, and other functionalities */
services.tumbler.enable = true; /* Thumbnail support for images */
services.udisks2 = { enable = true; #settings = {};
  mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
services.xserver.enable = true;
services.mullvad-vpn.enable = true;
users.users.${vars.user.lab} = { isNormalUser = true;
    description = vars.user.lab;
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
  };
services.displayManager.autoLogin = {
  enable = true;
  user = vars.user.lab;
};
services.xserver.displayManager.gdm = {
  enable = true;
  wayland = false;
};
networking = {
  hostName = vars.host;
  networkmanager.enable = true;
  firewall.enable = true;
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
   channel = "https://channels.nixos.org/nixos-24.05-small";
};
}
