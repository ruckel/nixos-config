{ config, pkgs, lib, inputs, ... }:
let vars = import "${inputs.vars}"; in
{ imports = [
  ../../modules/imports.nix
  ./hardware-configuration.nix
  ./packages.nix
  ];

x.defaultSession = null ; #"none-dwm";
adb = {
  enable            = true;
  #ports             = vars.adbports;
};
autorandr.enable    = false;
scripts.enable      = true;
customkbd.enable    = true;
ffsyncserver.enable = false;
localization.enable = true;
mysql.enable        = false;
#nc.enable           = true;
qemu.enable         = true;
pcon = {
  enable = true;
  gscon = false;
  kde = true;
};
#pythonconf.enable   = true;
soundconf.enable    = true;
ssh = {
  enable            = true;
#  pwauth            = true;
#  vncbg             = true;
};
syncthing.enable    = true;
#ollama.enable       = true;

/*experimental = {
  enable                  = true;
  enableSystembus-notify  = false;
  enableAvahi             = true;
  enableRustdeskServer    = false;
  enableVirtualScreen     = false;
  enableVncFirewall       = true;
};*/
/* Constants */
nixpkgs.config = {
  allowUnfree = true;
  permittedInsecurePackages = [ "libsoup-2.74.3" "spotify" ];
  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
 };
nix.settings.experimental-features = [ "nix-command" "flakes" ];
environment.localBinInPath = true;
system.stateVersion = "23.11";
services.devmon.enable = true; /* automatic device mounting daemon */
services.gvfs.enable = true; /* Mount, trash, and other functionalities */
services.tumbler.enable = true; /* Thumbnail support for images */
services.udisks2 = { enable = true; #settings = {};
  mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
services.mullvad-vpn.enable = true;
users.users."korv" = { isNormalUser = true;
    description = "korv";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tilix bc ];
};
fonts.packages = with pkgs; [
    # nerdfonts /* All nerdfonts */
    fira fira-code nerd-fonts.fira-code
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
nix.gc = {        # nix store garbage collection
  automatic = true;
  dates = "06:00";
};
networking = {
  hostName = "dell";
  networkmanager.enable = true;
 #firewall.enable = true;
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
