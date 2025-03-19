{ lib, pkgs, config, ... } :
with lib;
let cfg = config.immich;
in {
  options.immich = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "immich";

    user = mkOption { default = "user";
      type = types.str;
     };
    port = mkOption { default = 2283;
      type = types.port;
     };
    hwVideo = mkEnableOption "Hardware Accelerated Video Transcoding";
    ml = mkEnableOption "functionality to detect faces and search for objects";
    domain = mkOption {
      type = with types; nullOr str;
     };
    };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.hwVideo {
      # `null` will give access to all devices.
      # You may want to restrict this by using something like `[ "/dev/dri/renderD128" ]`
      # services.immich.accelerationDevices = null;

      hardware.graphics = {
       # ...
       # See: https://wiki.nixos.org/wiki/Accelerated_Video_Playback
      };

      users.users.immich.extraGroups = [ "video" "render" ];
    })
    (mkIf cfg.domain {
      services.nginx.virtualHosts."${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://[::1]:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
    })
    /*(mkIf cfg.ml {
      machine-learning = {
        enable = true;
        environment = { }; #https://immich.app/docs/install/environment-variables
       };
    })*/
    ## https://search.nixos.org/options?show=services.immich.
    ({
    services.immich = {
      enable = true;
      port = cfg.port;
      #mediaLocation = "/var/lib/immich";
      #secretsFile = "";
     };
      users.users.immich.extraGroups = [ "nextcloud" ];
     })
  ]);
}
