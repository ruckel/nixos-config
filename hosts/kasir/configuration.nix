{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./packages.nix
    ];
    /* USERNAME setup consolidated */
#   services.syncthing.dataDir = "/home/USERNAME/syncthing"; # FIXME: Set username
#   services.syncthing.configDir = "/home/USERNAME/.config/syncthing"; # FIXME: Set username
#   users.users."USERNAME".openssh.authorizedKeys.keys = [];
#   services.syncthing.user = "USERNAME";

    users.users."USERNAME" = { isNormalUser = true;
        description = "user";
        extraGroups = [
            "networkmanager"
            "wheel"
            "adbusers"
            "syncthing"
        ];
        packages = with pkgs; [ tilix bc ];
    };
    networking.hostName = "hoops";

    boot.loader.grub = {
        enable = true;
        boot.loader.grub.device = "/dev/sda";
        boot.loader.grub.useOSProber = false;
    };
    services.displayManager.autoLogin = {
        enable = true;
        user = "USERNAME";
    };

    networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          # 5900  #vnc
            5555  #adb
            21027 #syncthing
        ];
        allowedUDPPorts = [
          # 5900 #vnc
        ];
        allowedTCPPortRanges = [
            { from = 1714; to = 1764; } #adb
        ];
        allowedUDPPortRanges = [
            { from = 1714; to = 1764; } #adb
        ];

    environment.systemPackages = with pkgs; [
      # x11vnc                  /* vnc host */
      # tigervnc                /* vnc app*/
      # scrcpy                  /* SCReenCoPY, visual remote client for android */
      # vncdo                   /* vnc app */
        dmenu                   /* DWM status bar menu */
        networkmanager_dmenu
        gsconnect               /* CANNOT be installed at same time as `programs.kdeconnect.enable = true;` *//* gnome implementaion of KDE connect to connect an android */
    ];

    services.xserver.desktopManager.gnome.enable = true; # gnome desktop environment setup

    /* dwm setup */
    services.dwm-status.enable = true;
    services.dwm-status.order = [ "audio" "backlight" "battery" "cpu_load" "network" "time" ];
    services.xserver.windowManager.dwm = {
        #enable = true;
        package = pkgs.dwm.overrideAttrs rec {
            /* In order to run and config dwm you will need to download the source code and import it below*/
            /* get source code by running `git clone https://git.suckless.org/dwm` while in directory `~` */
            #src = /home/USERNAME/dwm;

            /* Alternatively, get ruckels conf and use it instead */
            /* by running `git clone https://github.com/ruckel/dwm-conf.git` while in directory `~` */
            #src = /home/USERNAME/dwm-conf; #github.com/ruckel/dwm-conf

            patches = [
            # (pkgs.fetchpatch {
            #   url = "https://dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20210714-138b405.diff";
            #   hash = "sha256-7AHooplO1c/W4/Npyl8G3drG0bA34q4DjATjD+JcSzI=";})a

            # (pkgs.fetchpatch {
            #   url = "https://dwm.suckless.org/patches/statusallmons/dwm-statusallmons-6.2.diff";
            #   hash = "sha256-AdngAZTKzICfwAx66sOdWD3IdsoJN8UW8eXa/o+X5/4=";})

            # (pkgs.fetchpatch {
            #   url = "https://dwm.suckless.org/patches/activemonitor/dwm-activemonitor-20230825-e81f17d.diff";
            #   hash = "sha256-MEF/vSN3saZlvL4b26mp/7XyKG3Lp0FD0vTYPULuQXA=";})

            # (pkgs.fetchpatch {
            #   url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
            #   hash = "sha256-CrKItgReKz3G0mEPYiqCHW3xHl6A3oZ0YiQ4oI9KXSw=";})

            # (pkgs.fetchpatch {
            #   url = "https://dwm.suckless.org/patches/tilewide/dwm-tilewide-6.4.diff";
            #   hash = "sha256-l8QDEb8X32LlnGpidaE4xKyd0JmT8+Oodi5qVXg1ol4=";})
            ];
        };
    };

    /* Specify background services to execute when dwm */

    /*
    environment.etc."xprofile2".text = ''
    if [ $DESKTOP_SESSION == "none+dwm" ]; then
    ~/.fswebbg
    syncthing &
    fi
    '';
    };
    */

    /* dwm setup end */

    /* syncthing setup */ /* Before uncommenting and trying a rebuild, set username in fields */

    # systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
    # services.syncthing = {
    #enable = true;
    # };

    /* These settings need to be set elsewhere in this config:
    services.syncthing.user = "USERNAME";
    users.users."USERNAME".extraGroups = [ "syncthing" ];
    networking.firewall.allowedTCPPorts = [ 21027 ];
    #   services.syncthing.dataDir = "/home/USERNAME/syncthing"; # FIXME: Set username
    #   services.syncthing.configDir = "/home/USERNAME/.config/syncthing"; # FIXME: Set username
    */

    /* syncthing setup end */

    /* ssh / vnc */

    services.openssh = {
          enable = true;
          ports = [ 22 ];
          openFirewall = true;
          settings = {
            PasswordAuthentication = true;
            X11Forwarding = true;
          };
    };
    #programs.ssh.setXAuthLocation = true;
    };
    services.fail2ban.enable = true;

    /* ssh / vnc END */

    /* Android connect */
    programs.kdeconnect.enable = true; /* CANNOT be enabled at same time as gsconnect is installed */
    programs.adb.enable = true;
    /* These settings needs to set elsewhere in this conf file
    networking.firewall.allowedTCPPorts
    networking.firewall.allowedUDPPorts
    networking.firewall.allowedTCPPortRanges
    networking.firewall.allowedUDPPortRanges
    users.users."USERNAME".extraGroups
    */
    /* Android connect END */

    /* xprofile setup  */
    #FIXME: username /* otherwise `xautostart` will never get to run :( */
    environment.etc."xprofile".text = ''
    #!/bin/sh
    if [ -z _XPROFILE_SOURCED ]; then
    export _XPROFILE_SOURCED=True
    . /etc/xprofile2 &
    dunst &
    . /home/USERNAME/xautostart &
    toastify send -a 'xserver' -t 1000 -u normal 'loaded' '.xprofile'
    else
    echo already sourced
    fi
    '';

    /* xprofile setup END */

    /* bash aliases setup */ /* add new lines with aliases, after `neofetch`, like you would in .bashrc */
    environment.etc."bashaliases".text = ''
    alias neofetch='nix-shell -p fastfetch --command fastfetch'
    '';
    environment.etc."bashrc".text = ". /etc/bashaliases ";
    /* bash aliases setup END */

    /* Set what window manager starts at boot */
  # services.displayManager.defaultSession = "none+dwm";
    services.displayManager.defaultSession = "gnome";
    /* Only uncomment one of the above */

    /* A workaround to get auto login working */
    systemd.services = { # fix: github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
    };


    /** Constants */ # These should never need to be changed, ideally

    /* Audio configuration */
    security.rtkit.enable = true;         # pipewire realtime priotitizing
    hardware.pulseaudio.enable = false;   # explicitly disable older sound server
    services.pipewire = {                 # In favor of pipewire. (Almost instant/no delay sound processing is possible)
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
    # End of audio config

    /* executables like .sh and such will be globally available when put in ~/.local/bin/ */
    environment.localBinInPath = true;

    services.devmon.enable = true; /* automatic device mounting daemon */
    services.gvfs.enable = true; /* Mount, trash, and other functionalities */
    services.tumbler.enable = true; /* Thumbnail support for images */
    services.udisks2 = {
    enable = true;
    #settings = {};
    mountOnMedia = true; /* mount in /media/ instead of /run/media/$USER/ */
    };
    fonts.packages = with pkgs; [
          fira fira-code fira-code-nerdfont
          noto-fonts noto-fonts-cjk-sans
          comic-mono comic-relief
    ];
    xdg = {
    autostart.enable = true;
    icons.enable = true;
    portal = {
          enable = true;
          extraPortals = [pkgs.xdg-desktop-portal-gtk]; # helps enabling global dark mode
    };
    };

    /* This config uses X11 as the display server, wayland can still be buggy/incompatible */
    services.xserver = {
    enable = true;
    };
    /* Display manager, which handles and starts a window manager like gnome/dwm */
    services.xserver.displayManager.gdm = {
    enable = true;
    wayland = false;
    };

    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
    boot.plymouth.enable = true; /* enables boot splash, I.E no wall of text. Press `esc` to show verbose output during boot */
    nix.gc = { /* garbage collection of junk files once a week */ /* Remove "Mo" for daily */
    automatic = true;
    dates = "Mo 04:00";
    };
    system.autoUpgrade = {
         enable = true;
         allowReboot = false; #true;
         channel = "https://channels.nixos.org/nixos-24.05-small";
    };
    /* rör du, dör du. fast os:et */
    system.stateVersion = "24.05"; /* läs på innan ändring av denna. om det måstes göras */
    console.keyMap = "sv-latin1";
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
}
