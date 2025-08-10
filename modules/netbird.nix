{ lib, pkgs, config, ... } :
with lib;
let cfg = config.netbird;
in {
  options.netbird = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}

    user = mkOption { default = "user";
      description = "";
      type = types.str;
     };
    strings = mkOption {
      description = "";
      type = with types; nullOr listOf str;
     };
    server = {
      enable = mkEnableOption "DESCRIPTION";
      
    };
    client = {
      enable = mkEnableOption "DESCRIPTION";
      
    };
   };

  config = (mkMerge [
    (mkIf cfg.server.enable {
      services.netbird.enable = true;
      services.netbird.server = {
        enable = true;
        #enableNginx = true;
        domain = "127.0.0.1";
        coturn = {
          enable = false;
          /*domain
          openPorts
          password
          passwordFile
          useAcmeCertificates
          user*/
        };
        dashboard = {
          enable = false;
          /*enableNginx
          package
          domain
          finalDrv
          managementServer
          settings*/
        };
        management = {
          #enable = true;
          /*enableNginx
          package
          disableAnonymousMetrics
          disableSingleAccountMode
          dnsDomain
          domain
          extraOptions
          logLevel
          metricsPort
          oidcConfigEndpoint
          port
          settings
          singleAccountModeDomain
          turnDomain
          turnPort*/
        };
        /*signal = {
          enable
          enableNginx
          package
          domain
          extraOptions
          logLevel
          metricsPort
          port
        };*/
      };
    })
    (mkIf cfg.client.enable {
      #services.netbird.enable = true;
      environment.systemPackages = with pkgs; [
        netbird netbird-dashboard netbird-ui
      ];
      services.netbird.ui.enable = true;
      #services.netbird.useRoutingFeatures = ; #["none"], "client", "server", "both"
      services.netbird.clients = {
        netbird = {
          port = 51820;
          hardened = false;
          interface = "nb0";
          name = "netbird";
          #systemd.name = "netbird";
          #autoStart = true;
          #bin.suffix = "netbird-default";
          /*config = {
            DisableAutoConnect = !client.autoStart;
            WgIface = client.interface;
            WgPort = client.port;
          } // optionalAttrs (client.dns-resolver.address != null) {
            CustomDNSAddress = "${client.dns-resolver.address}:${builtins.toString client.dns-resolver.port}";
          }*/
          #dir.baseName = "netbird-default";
          #dir.runtime ="/var/run/netbird-default";
          #dir.state = "/var/lib/netbird-default";
          #dns-resolver.address
          #dns-resolver.port
          /*environment = {
             NB_STATE_DIR = client.dir.state;
             NB_CONFIG = "${client.dir.state}/config.json";
             NB_DAEMON_ADDR = "unix://${client.dir.runtime}/sock";
             NB_INTERFACE_NAME = client.interface;
             NB_LOG_FILE = mkOptionDefault "console";
             NB_LOG_LEVEL = client.logLevel;
             NB_SERVICE = client.service.name;
             NB_WIREGUARD_PORT = toString client.port;
           } // optionalAttrs (client.dns-resolver.address != null) {
             NB_DNS_RESOLVER_ADDRESS = "${client.dns-resolver.address}:${builtins.toString client.dns-resolver.port}";
           }
          */
          #logLevel = "info"; /* "panic", "fatal", "error", "warn", "warning", ["info"], "debug", "trace" */
          #openFirewall = true;
          #service.name = "netbird-default";
          #suffixedName = "netbird-default";
          #ui.enable
          #user.group
          #user.name*/
        };
      };
    })
    ({
    })
   ]);
}
