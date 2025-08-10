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
      services.netbird.server = {
        enable = true;
        #enableNginx = true;
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
          enable = true;
          /*enableNginx
          package
          domain
          finalDrv
          managementServer
          settings*/
        };
        #domain = "";
        management = {
          enable = true;
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
        signal = {
          enable
          enableNginx
          package
          domain
          extraOptions
          logLevel
          metricsPort
          port
        };
      };
    })
    (mkIf cfg.client.enable {
      services.netbird.clients = {
        "default" = {
          autoStart
          bin.suffix
          config
          dir.baseName
          dir.runtime
          dir.state
          dns-resolver.address
          dns-resolver.port
          environment
          hardened
          interface
          logLevel
          name
          openFirewall
          port
          service.name
          suffixedName
          ui.enable
          user.group
          user.name
        };
      };
    })
    ({
      # static config here
    })
   ]);
}
