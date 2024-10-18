# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "vaio"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
services.xserver.windowManager.dwm.enable = true;
services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs rec {
src = ./dwm;
 patches = [
 #./path/to/local.patch
 (pkgs.fetchpatch {
    url = "https://dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20210714-138b405.diff";
    hash = "sha256-7AHooplO1c/W4/Npyl8G3drG0bA34q4DjATjD+JcSzI=";
  })
# (pkgs.fetchpatch {
#   url = "https://dwm.suckless.org/patches/systray/dwm-systray-20230922-9f88553.diff";
#   hash = "sha256-Kh1aP1xgZAREjTy7Xz48YBo3rhrJngspUYwBU2Gyw7k=";
# })
 (pkgs.fetchpatch {
   url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
   hash = "sha256-CrKItgReKz3G0mEPYiqCHW3xHl6A3oZ0YiQ4oI9KXSw=";
 })
   (pkgs.fetchpatch {
   url = "https://dwm.suckless.org/patches/tilewide/dwm-tilewide-6.4.diff";
   hash = "sha256-l8QDEb8X32LlnGpidaE4xKyd0JmT8+Oodi5qVXg1ol4=";
  })
 ];
};
services.dwm-status.enable = true;
services.dwm-status.order = [ "audio" "backlight" "battery" "cpu_load" "network" "time" ];

# Configure keymap in X11
services.xserver.xkb = {
layout = "se";
variant = "";
};

# Configure console keymap
console.keyMap = "sv-latin1";

# Enable CUPS to print documents.
services.printing.enable = true;

# Enable sound with pipewire.
hardware.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
};

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.user = {
isNormalUser = true;
description = "user";
extraGroups = [ "networkmanager" "wheel" ];
packages = with pkgs; [
mpv
feh
];
};

# Enable automatic login for the user.
services.displayManager.autoLogin.enable = true;
services.displayManager.autoLogin.user = "user";

# Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
systemd.services."getty@tty1".enable = false;
systemd.services."autovt@tty1".enable = false;

# Install firefox.
programs.firefox.enable = true;
programs.vim.defaultEditor = true; 
programs.kdeconnect.enable = true;
programs.thunar.enable = true;
programs.xfconf.enable = true;
programs.thunar.plugins = with pkgs.xfce; [
  thunar-archive-plugin
  thunar-volman
];
services.gvfs.enable = true; # Mount, trash, and other functionalities
services.tumbler.enable = true; # Thumbnail support for images

# Allow unfree packages
nixpkgs.config.allowUnfree = true;
programs.adb.enable = true;
# List packages installed in system profile. To search, run:
# $ nix search wget
environment.systemPackages = with pkgs; [
xprintidle
vim
wget
tilix
gh
git
dwm-status
dmenu
qimgv
xfce.thunar-volman ffmpegthumbnailer
brightnessctl
x11vnc tigervnc
nextcloud-client
keepassxc
surf
scrcpy
python3
  ];
environment.localBinInPath = true;
boot.plymouth.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
services.openssh.enable = true;

  # Open ports in the firewall.
networking.firewall.allowedTCPPorts = [ 5900 ];
networking.firewall.allowedUDPPorts = [ 5900 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
