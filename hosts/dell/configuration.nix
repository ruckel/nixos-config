{ config, pkgs, ... }:
{ imports =
  [ ./hardware-configuration.nix  # Include the results of the hardware scan.
    ./systemPackagesDefault.nix
    ./systemStateVersion.nix
  ]; 

  # remote desktop START
  services.xrdp = {
      enable = true;
      defaultWindowManager = "gnome-remote-desktop";
      openFirewall = true;
  };
  programs.ssh.setXAuthLocation = true;
  # remote desktop END  
  
  users.users.korv = { isNormalUser = true;
    description = "korv";
    extraGroups = [ "korv" "networkmanager" "wheel" "adbusers" "docker" ];
    packages = with pkgs; [  tilix vte ddclient fastfetch ];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJsd82H9yUf2hgBiXECvfPVgUxy84vHz5MbsBDbShvv korv@nixos"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPC8sV9tofPmdM1VmrsUK1AoymNkobPphDynC6nKd/E korv@nixos-dell"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa8dGCkZtulhJ7Peg2XvdryhAowWpL0hVMAS+i0I1t5 root@debian-homelab"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEpTIZfMSLWJBzkvSZyCthrU40R0CB8GjRi0WUMxi62z korv@pixel"
    ];
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "python3.11-youtube-dl-2021.12.17"
  ];
  programs = {
    bash.vteIntegration = true;
    adb.enable = true;
    firefox.enable = true;
    steam.enable = true;
    appimage.binfmt = true;
    virt-manager.enable = true;
    thunar = { enable = true; 
      plugins = with pkgs.xfce; [ thunar-volman thunar-archive-plugin thunar-media-tags-plugin ];
    };
  };
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
    docker.enable = true;
  };
  systemd = {
    services = { # fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
    };
    user.services = {
        pipewire-linking = {
            enable = true;
            after = [ "pipewire.service" "multi-user.target" "gdm.service" ];
            path = [ pkgs.pipewire ];
            serviceConfig = {
                Type = "oneshot";
                ExecStart = ''/home/korv/scripts/pipewire.sh'';
                #User = "korv";
                #Group = "users";
            };
            wantedBy = [ "pipewire.service" ];
        };
        lock-on-boot = {
            enable = true;
            after = [ "multi-user.target" "gdm.service" "pipewire-linking.service" ];
            path = [ pkgs.xdg-utils ];
            serviceConfig = {
                Type = "oneshot";
                ExecStart = ''/home/korv/scripts/lock.sh'';
                #User = "korv";
                #Group = "users";
            };
            wantedBy = [ "pipewire-linking.service" ];
        }; 
    };
  };

 

# services.xserver.libinput.enable = true;  #touchpad support
# networking.wireless.enable = true;  #wireless via wpa_supplicant.
# networking.proxy.default = "http://user:password@proxy:port/";   #network proxy
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";#network proxy

  fonts.packages = with pkgs; [
    fira fira-code fira-code-nerdfont
    noto-fonts noto-fonts-cjk-sans 
  ];


services = {
    printing.enable = true; #CUPS
    mullvad-vpn.enable = true;
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        X11Forwarding = true;
      };
    };
    pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.configPackages = [
            (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-alsa-disable-hdmi.lua" ''
                alsa_monitor.rules = { {
                    matches = {{{ "node.name", "matches", "alsa_output.hci-0000_03_00.1.hdmi*" }}};
                    apply_properties = { ["device.disabled"] = true, },
                }, }
            '')
        ];
    };
    #keyd.enable = true;
    #keyd.keyboards = {
        #default = { # name does not really matter
          #ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
          #settings = { # Everything but the ID section
            #main = {  # The main layer, if you choose to declare it in Nix
              ##capslock = "layer(control)"; # you might need to also enclose the key in quotes if it contains non-alphabetical symbols
              #scrolllock = "`";
    #};};};};
    displayManager.autoLogin = {
        enable = true;
        user = "korv";
    };
    displayManager.defaultSession = "none+dwm";
    xserver = {
        enable = true;
        xkb.layout = "se";
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = false;
        windowManager.dwm = {
          enable = true;
          package = pkgs.dwm.overrideAttrs rec {
            src = ./dwm;
            patches = [
              #./path/to/local.patch
              (pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20210714-138b405.diff";
                hash = "sha256-7AHooplO1c/W4/Npyl8G3drG0bA34q4DjATjD+JcSzI=";
              })
	     #	 (pkgs.fetchpatch {
             #	   url = "https://dwm.suckless.org/patches/systray/dwm-systray-20230922-9f88553.diff";
             #	   hash = "sha256-Kh1aP1xgZAREjTy7Xz48YBo3rhrJngspUYwBU2Gyw7k=";
	     #	 }) 
              (pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
                hash = "sha256-CrKItgReKz3G0mEPYiqCHW3xHl6A3oZ0YiQ4oI9KXSw=";
              })
#              (pkgs.fetchpatch {
#                url = "https://tools.suckless.org/dmenu/patches/navhistory/dmenu-navhistory-5.0.diff";
#                hash = "sha256-zBADNWotwgt2ur0kf0Dk/Jiw/JcD+nxOQuzZsWJd5Jo=";
#              }) 
              (pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/centretitle/dwm-centretitle-20200907-61bb8b2.diff";
                hash = "sha256-1SSsJaIq1WjAfrz5fiWg+kHs7kHNj3Ie9ls6E834n9c=";
              }) 
              (pkgs.fetchpatch {
                url = "https://dwm.suckless.org/patches/preserveonrestart/dwm-preserveonrestart-6.3.diff";
                hash = "sha256-zgwTCgD3YE+2K4BF6Em+qkM1Gax5vOZfeuWa6zXx8cE=";
              })
#              (pkgs.fetchpatch {
#                url = "https://dwm.suckless.org/patches/centeredwindowname/dwm-centeredwindowname-20200723-f035e1e.diff";
#                hash = "sha256-oL8VrdqVpJ9yw+yDFpKdr17mvIJjQEYiLYv5DEaLUug=";
#              }) 
#              (pkgs.fetchpatch {
#                url = "https://dwm.suckless.org/patches/clientopacity/dwm-clientopacity-6.4.diff";
#                hash = "sha256-Q7mUN+jJMVKHL3Nd1zTpTUmEcv3H1DBSNezaeXCJpaM=";
#              }) 
#              (pkgs.fetchpatch {
#                url = "";
#                hash = "";
#              }) 
            ];
          };
        };
        desktopManager.gnome.enable = true;
    };
  };
  environment.localBinInPath = true;
  security.rtkit.enable = true;     # pipewire realtime priotitizing
  hardware.pulseaudio.enable = false;
  nix.gc = {        # nix store garbage collection
        automatic = true;
        dates = "06:00";
  };
  networking = {
      hostName = "nixdell";
      networkmanager.enable = true;
      firewall = {
          enable = false;#true;
          allowedTCPPorts = [ 5555 8191 ];# [adb, macro deck]
          allowedUDPPorts = [ 5555 8191 ];
          allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];#gsconnect
          allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
      };
  };
  time.timeZone = "Europe/Stockholm";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };
  console.keyMap = "sv-latin1";  #console keymap conf

  boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
  };
  system.autoUpgrade = {
        enable = false;
        allowReboot = false;
        channel = "https://channels.nixos.org/nixos-24.05";
  }; 
}
