{ config, pkgs, lib, inputs, ... }:
let
vars = import "${inputs.vars}";
in
{ imports = [
  #../modules/imports.nix /* TODO: why no work? :( */
  /home/korv/nixos-cfg/modules/imports.nix
  ./hardware-configuration.nix
  ];

adb.enable          = true;
autorandr.enable    = true;
scripts.enable      = true;
customkbd.enable    = true;
dwm.enable          = true;
ffsyncserver.enable = true;
gnomeWM.enable      = true;
localization.enable = true;
qemu.enable         = true;
pcon = {
  enable = true;
  gscon = false;
  kde = true;
};
pythonconf.enable   = true;
soundconf.enable    = true;
soundconf.user      = vars.user;
ssh = {
  enable            = true;
  user              = vars.user;
  ports             = vars.ports;
  keys              = vars.keys;
  pwauth            = true;
  x11fw             = true;
  vncbg             = true;
};
syncthing.enable    = true;
syncthing.user      = vars.user;
systemdconf.enable  = true;
ollama.enable       = true;
xprofile.enable     = true;
xprofile.user       = vars.user;

experimental = {
  enable                  = true;
  user                    = vars.user;
  enableSystembus-notify  = true;
  enableAvahi             = true;
  enableRustdeskServer    = true;
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
    "python3.11-youtube-dl-2021.12.17"
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
users.users.${vars.user} = { isNormalUser = true;
    description = "basic user";
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
  user = vars.user;
};
services.xserver.displayManager.gdm = {
  enable = true;
  wayland = false;
};
networking = {
  hostName = vars.user;
  networkmanager.enable = true;
  firewall.enable = true;
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
