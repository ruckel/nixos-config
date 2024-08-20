{ config, pkgs, ... }:
{ imports =
  [ ./hardware-configuration.nix  # Include the results of the hardware scan.
    ./systemPackagesDefault.nix
  ]; 

  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
    #localNetworkGameTransfers.openFirewall = true;
  };


  # remote desktop START
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "gnome-remote-desktop";
  services.xrdp.openFirewall = true;
  
  # remote desktop END

  environment.systemPackages = with pkgs; [ 
    vim wget dconf trash-cli fastfetch 
    librewolf-wayland 
   gnome.gnome-remote-desktop
  ]; #see imports
  
  users.users.korv = { isNormalUser = true;
    description = "korv";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [  tilix vte ];
  };
  programs.bash.vteIntegration = true;
  programs.adb.enable = true;
  programs.firefox.enable = true;

# pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
#   jack.enable = true;
#   media-session.enable = true; # use the example session manager 
    # (no others are packaged yet so this is enabled by default, no need to redefine it in your config for now)
  };

# fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

# services.xserver.libinput.enable = true;  #touchpad support
# networking.wireless.enable = true;  #wireless via wpa_supplicant.
# networking.proxy.default = "http://user:password@proxy:port/";   #network proxy
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";#network proxy

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  fonts.packages = with pkgs; [
    fira fira-code fira-code-nerdfont
    noto-fonts noto-fonts-cjk-sans 
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
#trace: warning: The option `services.xserver.displayManager.autoLogin' defined in `/etc/nixos/configuration.nix' has been renamed to `services.displayManager.autoLogin'.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "korv";
  services.xserver = { 
# 'services.xserver.xkbVariant'  has been renamed to:   services.xserver.xkb.variant
    layout = "se"; 
# 'services.xserver.layout' has been renamed to:    services.xserver.xkb.layout
    xkbVariant = ""; 
  };
  services.printing.enable = true; #CUPS
  services.mullvad-vpn.enable = true;
  services.openssh.enable = true; 
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 5555 ];# [adb]
  networking.firewall.allowedUDPPorts = [ 5555 ];
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];#gsconnect
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];#gsconnect
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };
  console.keyMap = "sv-latin1";  #console keymap conf
  system.stateVersion = "24.05"; #dont change, see org nix conf file
}
