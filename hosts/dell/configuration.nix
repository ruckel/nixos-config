{ config, pkgs, inputs, ... }:
let vars = import "${inputs.vars}"; in
{ imports = [
  ../../modules/imports.nix
  ./hardware-configuration.nix
  ./packages.nix
  ];

services.displayManager.defaultSession = "none+dwm"; # "gnome"
adb = {
  enable            = true;
  user              = vars.user.dell;
  #ports             = vars.adbports;
};
autorandr.enable    = false;
scripts.enable      = true;
customkbd.enable    = true;
dwm.enable          = true;
ffsyncserver.enable = false;
gnomeWM.enable      = true;
localization.enable = true;
mysql.enable        = false;
nc.enable           = true;
qemu.enable         = true;
pcon = {
  enable = true;
  gscon = false;
  kde = true;
};
#pythonconf.enable   = true;
soundconf.enable    = true;
soundconf.user      = vars.user.dell;
ssh = {
  enable            = true;
  user              = vars.user.dell;
  ports             = vars.ports;
  keys              = vars.keys;
  pwauth            = true;
  x11fw             = true;
  vncbg             = true;
};
syncthing.enable    = true;
syncthing.user      = vars.user.dell;
systemdconf.enable  = true;
#ollama.enable       = true;
xprofile.enable     = true;
xprofile.user       = vars.user.dell;

experimental = {
  enable                  = true;
  user                    = vars.user.dell;
  enableSystembus-notify  = false;
  enableAvahi             = true;
  enableRustdeskServer    = false;
  enableVirtualScreen     = false;
  enableVncFirewall       = true;
};
/* Constants */
environment.localBinInPath = true;
system.stateVersion = vars.stateVersion.dell;
services.devmon.enable = true; /* automatic device mounting daemon */
services.gvfs.enable = true; /* Mount, trash, and other functionalities */
services.tumbler.enable = true; /* Thumbnail support for images */
services.udisks2 = { enable = true; #settings = {};
  mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
services.xserver.enable = true;
services.mullvad-vpn.enable = true;
users.users.${vars.user.dell} = { isNormalUser = true;
    description = vars.user.dell;
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
  user = vars.user.dell;
};
services.xserver.displayManager.gdm = {
  enable = true;
  wayland = false;
};
nix.gc = {        # nix store garbage collection
  automatic = true;
  dates = "06:00";
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
boot.plymouth.enable = true;
system.autoUpgrade = {
  enable = true;
  allowReboot = true;
  channel = "https://channels.nixos.org/nixos-24.05";
};
}
