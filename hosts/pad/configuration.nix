{ config, pkgs, lib, inputs, hostName, userName, vars, ... }: with lib;
{
  imports = [
    ../../modules/imports.nix
    ./hardware-configuration.nix
    ./packages.nix
  ];

  users.users.korv = {
    isNormalUser = true;
    description = "korv";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ gimp2 ];
  };

  nixpkgs.config.allowUnfree = true;
  programs.firefox.enable = true;
  programs.tmux.enable = true;
  programs.nm-applet.enable = true;
  services.openssh.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    gh
    git

  ];

  networking = {
    hostName = "pad";
    networkmanager.enable = true;
    firewall.enable = false;
  };
  nix.settings.trusted-users = [ "root" "korv" ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPatches = [{
      name = "samsung-hid-multitouch-fix";
      #patch = ./hid-multitouch.patch;
      patch = ./hid-multitouch-samsung-a00a-6.12.patch;
    }];
  };

  console.keyMap = "sv-latin1";
  services.displayManager.autoLogin = {
    enable = true;
    user = "korv";
  };
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.lxqt.enable = true;
    xkb = {
      layout = "se";
      variant = "";
    };
  };
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
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
  system.stateVersion = "24.05";
}
