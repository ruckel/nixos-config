{ lib, pkgs, config, ... } :
with lib;
let cfg = config.tailscale;
in {
  options.tailscale = {
    ## types = {attrs, bool, path, int, port, str, lines, commas}
    enable = mkEnableOption "";
    derper = mkEnableOption "enable tailscale derper https://tailscale.com/kb/1118/custom-derp-servers";
    auth = mkEnableOption "enable tailscale.nginx-auth, to authenticate users via tailscale";
    authKey = mkEnableOption "enable key file configs";
   };

  config = mkIf cfg.enable (mkMerge [
    ({ #static
      services.tailscale = {
        enable = true;
        interfaceName = "tailscale0";
        port = 41641; # 0 = autoselect
        openFirewall = false;
        disableTaildrop = false;
        useRoutingFeatures = "none"; # ["none"], "client", "server", "both"
         # extraDaemonFlags = [ "" ]; # Extra flags to pass to tailscaled
         # extraSetFlags = [ "" ]; # Extra flags to pass to tailscale set
         # extraUpFlags = [ "" ]; # Only applied if authKeyFile is specified
        permitCertUid = null; # Username or ID of user allowed fetching Tailscale TLS certificates for node
      };
    })
    (mkIf cfg.authKey {
      services.tailscale = {
        # authKeyFile = null;  
        # authKeyParameters = { };
        # authKeyParameters.baseURL = null;
        # authKeyParameters.ephemeral = null;
        # authKeyParameters.preauthorized = null;
      };
    })
    (mkIf cfg.auth {
      services.tailscaleAuth = {
        enable = true;
         # group = "tailscale-nginx-auth";
         # socketPath = "/run/tailscale-nginx-auth/tailscale-nginx-auth.sock";
         # user = "tailscale-nginx-auth";
         # group = "tailscale-nginx-auth";
         # socketPath = "/run/tailscale-nginx-auth/tailscale-nginx-auth.sock";
      };
    })
    (mkIf cfg.derper {
      services.tailscale.derper = {
        enable = true;
         #domain = "";
         #openFirewall = true;
         #port = 8010
         #stunPort = 3478;
         #verifyClients = false;
      };
    })
   ]);
}
