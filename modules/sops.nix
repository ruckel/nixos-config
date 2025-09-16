{ lib, pkgs, config, userName, ... } :
with lib;
let cfg = config.secrets;

in {
  options.secrets = {
     keyFile = mkOption {
      default = null;
      type = with types; nullOr str;
      description = ''

      '';
     };
   };

  config = /*mkIf cfg.enable*/ (mkMerge [
    ({ #static config
      environment.systemPackages = with pkgs; [ ssh-to-age ];
      sops = {
        defaultSopsFile = ../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        secrets = {
          pw.neededForUsers = true;

          ports = {
            uid = 1000;
            path = "/etc/ssh/sshd_config.d/ports.conf";
            restartUnits = [ "sshd.service" ];
          };
          service = {
            sopsFile = ../secrets/service.sh;
            format = "binary";
            mode = "0500";
          };
          pubkey-burk = { reloadUnits = [ "sshd.service" ]; };
          pubkey-labb = { reloadUnits = [ "sshd.service" ]; };
          pubkey-tele = { reloadUnits = [ "sshd.service" ]; };
          pubkey-dell = { reloadUnits = [ "sshd.service" ]; };
#          ssh-pub-main =    { sopsFile = "../secrets/.sensitive.yaml"; reloadUnits = [ "sshd.service" ]; };
#          ssh-pub-secure =  { sopsFile = "../secrets/.sensitive.yaml"; reloadUnits = [ "sshd.service" ]; };

          hostkey-burk = { reloadUnits = [ "sshd.service" ]; };
          hostkey-labb = { reloadUnits = [ "sshd.service" ]; };
          hostkey-tele = { reloadUnits = [ "sshd.service" ]; };
          hostkey-dell = { reloadUnits = [ "sshd.service" ]; };

#          knownHosts = { sopsFile = ../secrets/public_keys.txt; };

          main-pub = {};
          secure-pub = {};

          main = lib.mkIf (config.networking.hostName == "burk") {
            uid = 1000;
            mode = "0400";
            sopsFile = ../secrets/main.txt;
            format = "binary";
            path = "~/.ssh/main_id_ed25519";
          };
          secure = lib.mkIf (config.networking.hostName == "burk") {
            uid = 1000;
            mode = "0400";
            sopsFile = ../secrets/secure.bin;
            format = "binary";
            path = "~/.ssh/id_ed25519";
          };

          sshkey-labb = lib.mkIf (config.networking.hostName == "labb")  {
            reloadUnits = [ "sshd.service" ];
            uid = 1000;
            path = "~/.ssh/sops.test";
          };
          sshkey-dell = lib.mkIf (config.networking.hostName == "tele")  {
            reloadUnits = [ "sshd.service" ];
            uid = 1000;
            path = "~/.ssh/sops.test";
          };

        };
      };
          print.this = [ "sops: " ];
    })
   ]);
}
