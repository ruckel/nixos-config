{
  imports = [
    #./hardware-configuration.nix  # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    #./systemStateVersion.nix
    #/etc/nixos/systemStateVersion.nix
    #"${(import ./nix/sources.nix).sops-nix}/modules/sops"
    #<sops-nix/modules/sops>
    ../modules/ssh.nix
    ../modules/autorandr.nix
    ../modules/customscripts.nix
    ../modules/adb.nix
    ../modules/dwm.nix
    ../modules/experimental.nix
    ../modules/ffsyncserver.nix
    ../modules/gnomeWM.nix
    ../modules/customkbd.nix
    ../modules/localization.nix
    ../modules/mysql.nix
    ../modules/nextcloud.nix
    #../modules/packages.nix
    ../modules/phonecon.nix
    ../modules/python.nix
    ../modules/qemu.nix
    ../modules/sound.nix
#   ./modules/sops.nix
    ../modules/syncthing.nix
    ../modules/systemd.nix
    ../modules/ollama.nix
    ../modules/xprofile.nix
    #./nixscripts/helloWorld.nix
  ];
}