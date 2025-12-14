{ config, pkgs, lib, inputs, hostName, userName, vars, ... }: with lib;
{
  imports = [
    ../../modules/imports.nix
    ./hardware-configuration.nix
    ./packages.nix
   ];

#  print.this = [ "${vars.username-admin}" "${toString vars.ssh-ports}" ];
programs.fuse.userAllowOther = true;

ollama = {
    enable = true;
    webui = true;
    amd = true;
  };
services.ollama.openFirewall = true;

services.nginx.enable = true;
services.nginx.virtualHosts."192.168.1.12".locations."/".proxyPass = "http://localhost:11434/";
#security.sudo.defaultOptions = [ "Defaults   insults" ];
nix.settings.trusted-users = [ "root" "korv" ];
environment.systemPackages = with pkgs; [
  smartmontools
  ddrescueview
  ddrescue
  sleuthkit
  autopsy
];
xscreensaver = {
  enable = true;
  pam = true;
};

#netbird.enable = true;
services.flatpak.enable = true;
services.zoneminder = { enable = false;
  database = {
    createLocally =   true;
    username =        "zoneminder";
  };
};
services.home-assistant = {
  enable = false;
  config.homeassistant.name = "home";
};
services.rustdesk-server.enable = true;
services.rustdesk-server.openFirewall = true;
services.rustdesk-server.signal.enable = false;
/* custom services */
  adb.enable            = true;
  adb.scrcpy            = true;
  #autorandr.enable      = true;
  scripts.enable        = true;
  shell.scripts         = true;
  dunst-service.enable  = true;
  ffsyncserver.enable   = false;

  localization.enable   = true;
  mpv.enable            = true;
  mysql.enable          = true;
  nginx = {
    #enable = true;
    #deno = true;
  };
  obsStudio.enable      = true;
  pcon = {
    enable = true;
    gscon = false;
    kde = true;
   };
  pythonconf.enable     = true;
  qemu.enable           = true;
  soundconf = {
    enable            = true;
    lowLatency        = true;
    combine           = true;
   };
  ssh.enable            = true;
  ssh.auth.root = "yes";
  ssh.auth.pw = true;
  syncthing.enable      = true;
  userServices = {
    enable              = true;
    lockScreenOnBoot    = true;
  };
  tmux.enable           = true;
  transmission = {
    enable              = true;
  };
  vim.enable            = true;
  virtualisation.vmware.host.enable = true;

  experimental = {
    enable                  = true;
#    enableSystembus-notify  = true;
#    enableAvahi             = true;
#    enableRustdeskServer    = true;
#    enableVirtualScreen     = true;
#    enableVncFirewall       = true;
   };
/* end custom services */

  programs.flutter.enable = false;

  programs.java.enable      = false;

services.xserver.desktopManager.gnome.debug = true;
  /*  */x.autologin = userName;
  x = {
    defaultSession = "xfce";
    dm = "lightdm";
    wm = {
      dwm = true;
      xfce = true;
      gnome = false;
     };
  };
services.xserver.windowManager.awesome.enable = true;
#services.xserver.displayManager.lightdm.background = /home/korv/pictures/wps/bliss.jpg;
services.xserver.displayManager.lightdm.background = "#000000";
services.xserver.displayManager.lightdm.greeters.gtk.extraConfig = ''
  active-monitor=0
  indicators = ~session;~layout;~spacer;~power
''; # indicators = ~host;~spacer;~session;~language;~layout;~a11y;~clock;~power
services.xserver.windowManager.i3 = {
  enable = true;
};
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "libsoup-2.74.3" "spotify" ];
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
   };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.localBinInPath = true;
  system.stateVersion = "24.05"; /* DONT toush */
  services.printing.enable = true;
  services.devmon.enable = true; /* automatic device mounting daemon */
  #services.gvfs.enable = true; /* Mount, trash, and other functionalities */
  services.tumbler.enable = true; /* Thumbnail support for images */
  services.udisks2 = { enable = true; #settings = {};
    mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.mullvad-vpn.enable = false;
  users.users."${userName}" = {
    isNormalUser = true;
    description = userName;
    extraGroups = [ "networkmanager" "wheel" "transmission" ];
    packages = with pkgs; [ tilix bc ];
    hashedPasswordFile = mkAfter config.sops.secrets.pw.path;
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
    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
     };
  };
  qt.style = "adwaita-dark";
  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    #networkmanager.unmanaged = [ "tap0" "br0" ];
    firewall = {
      enable = true;
#      trustedInterfaces = [ "br0" "tap0" ];
      allowedTCPPorts = [ 80 3000 3001 ];
      allowedTCPPortRanges = [{ from = 40000; to = 65535; }];
    };
  };
  security.pki.certificateFiles = [
    /etc/nixos/configfiles/korv_org-250921T192042-RootCA.crt
    ];

#  networking.useDHCP = false;
#  networking.bridges = {
#    "br0" = {
#      interfaces = [ "eno1" ];
#    };
#  };
#  networking.interfaces.br0.ipv4.addresses = [ {
#    address = "192.168.1.10";
#    prefixLength = 24;
#  } ];
#  networking.defaultGateway = "192.168.1.1";
#  networking.nameservers = ["192.168.1.1" "8.8.8.8"];

# systemd.network = {
#    enable = true;
#    wait-online.enable = false;
#    netdevs = {
#      # Create the tap interface
#      "20-tap2" = {
#       enable = true;
#        netdevConfig = {
#          Kind = "tap";
#          Name = "tap2";
#        };
#      };
#      "20-tap3" = {
#       enable = true;
#        netdevConfig = {
#          Kind = "tap";
#          Name = "tap3";
#        };
#      };
#      "20-bridge0" = {
#        enable = true;
#        netdevConfig = {
#          Kind = "bridge";
#          Name = "br0";
#        };
#      };
#    };
#    networks = {
#      "30-eno1" = {
#        matchConfig.Name ="eno1";
#        linkConfig = {
#          Unmanaged = "yes";
#        };
#      };
#      "40-tap2" = {
#        matchConfig.Name ="tap2";
#        bridgeConfig = {   };
#        linkConfig = {
#          ActivationPolicy = "always-up";
#          RequiredForOnline = "no";
#        };
#        networkConfig = {
#          Bridge = "br0";
#        };
#      };
#      "40-tap3" = {
#        matchConfig.Name ="tap3";
#        bridgeConfig = {   };
#        linkConfig = {
#          ActivationPolicy = "always-up";
#          RequiredForOnline = "no";
#        };
#        networkConfig = {
#          Bridge = "br0";
#        };
#      };
#      "40-bridge0" = {
#        matchConfig.Name = "br0";
#        linkConfig = {
#          ActivationPolicy = "always-up";
#          RequiredForOnline = "no";
#        };
#        networkConfig = {
#          Address = ["192.168.1.10/24"];
#          # Bridge = "br0";
#        };
#      };
#    };
#  };




  boot.plymouth = { enable = true;
    # themePackages = [ ];
    # theme         = "";
    # logo          = "";
    # font          = "";
    # extraConfig   = "";
   };
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
   };
  boot.tmp = {
    cleanOnBoot = false;
    useTmpfs = false;
    tmpfsSize = "50%";
   };

  nix.gc = { # nix-collect-garbage
    options = "--delete-older-than 30d"; # removes stale profile generations
    automatic = true;
    dates = "06:00";
     # persistent = false; # (def: t) time when the service unit was last triggered is stored on disk
  };
}
