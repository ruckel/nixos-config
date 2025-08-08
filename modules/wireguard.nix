#types = {attrs, bool, path, int, port, str, lines, commas}
{ lib, pkgs, config, ... } :
with lib;
let 
  cfg = config.wg;
in {
  options.wg = {
    port = mkOption {
      default = 51666;
      description = "For both client/peers, which can use same";
      type = types.int;
    };
    interfaceName = mkOption {
      default = "wg0";
      description = "For both client/server. Any arbitrary name";
      type = types.str;
    };
    presharedKeyFile = mkOption {
      default = "/etc/wireguard-keys/prekey.psk";
      description = "Path (as string) of private key file";
      type = types.str;
    };
    ipv6 = mkEnableOption "Use IPv4 & IPv6";
    mtu = mkOption {
      default = null;
      description = "maximum transmission unit, 1240 is usually default";
      type = with types; nullOr int;
    };
    server = {
      ips = mkOption {
        default = [ "10.0.0.1/24" "fdc9:281f:04d7:9ee9::1/64" ];
        description = "Addresses/subnets of server tunnel interface";
        type = with types; listOf str;
      };
      externalInterface = mkOption {
        default = "eno1";
        description = "Ethernet connection name";
        type = types.str;
      };
      externalAddress = mkOption {
        default = "127.0.0.1";
        description = "Local or public ip address";
        type = types.str;
      };
      /*privateKeyFile = mkOption {
        default = "/etc/wireguard-keys/server/private";
        description = "Path (as string) of private server key file";
        type = types.str;
      };
      generatePrivateKeyFile = mkOption {
        default = true;
        description = "Generate server key file at privateKeyFile";
        type = types.bool;
      };
      publicKey = mkOption {
        default = "P8PQu5AVJzN9tge3zwT1LZphU1JGRo1q0YeLcDokCi8=";
        description = "Value (not path) of public server key ";
        type = types.str;
      };*/
      autostart = mkOption {
        default = true;
        description = "Start with system";
        type = types.bool;
      };
      rerouteAllTraffic = mkOption {
        default = false;
        description = "";
        type = types.bool;
      };
      dns =  mkOption {
        default = false;
        description = "";
        type = types.bool;
      };
      dnsmasq = mkOption {
        default = false;
        description = "";
        type = types.bool;
      };
      wg-quick =  mkOption {
        default = false;
        description = "";
        type = types.bool;
      };
      enable =  mkOption {
        default = false;
        description = "";
        type = types.bool;
      };
    };
    client = {
      /*privateKeyFile = mkOption {
        default = "/etc/wireguard-keys/client/private";
        description = "Path (as string) of private client key file";
        type = types.str;
      };
      generatePrivateKeyFile = mkOption {
        default = false;
        description = "Generate client key file at privateKeyFile";
        type = types.bool;
      };
      publicKey = mkOption {
        default = "lO286k/nBLBasod2FzKmO8RQwxOALvY3FHvFyuV9BUA=";
        description = "Value (not path) of public client key ";
        type = types.str;
      };*/ 
      ips = mkOption {
        default = [ "10.0.0.1/24" "fdc9:281f:04d7:9ee9::1/64" ];
        description = "Addresses/subnets of client tunnel interface";
        type = with types; listOf str;
      };
      wg-quick = mkOption {
        default = false;
        description = "";
        type = types.bool;
      };
      enable = mkOption {
        default = false;
        description = "";
        type = types.bool;
      };
    };
  };

  config = (mkMerge [
    
    (mkIf cfg.client.enable {
      environment.systemPackages = with pkgs; [ wireguard-tools ];
      networking.firewall.allowedUDPPorts = [cfg.port];
      networking.wireguard.enable = true;
      networking.wireguard.interfaces = mkIf (!cfg.client.wg-quick) {
        "${cfg.interfaceName}-c" = {
          #privateKeyFile = cfg.client.privateKeyFile; 
          #generatePrivateKeyFile = cfg.client.generatePrivateKeyFile;
          listenPort = cfg.port;
          ips = cfg.client.ips;
          peers = [
            {
              endpoint = "${cfg.server.externalAddress}:${toString cfg.port}";
              #publicKey = cfg.server.publicKey;
              allowedIPs = cfg.client.ips;
              persistentKeepalive = 25;
            }
          ];
        };
      };
      networking.wg-quick = mkIf cfg.client.wg-quick {
        interfaces."${cfg.interfaceName}-qc" = {
          address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
          dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
          #privateKeyFile = cfg.client.privateKeyFile;
          #generatePrivateKeyFile = cfg.client.generatePrivateKeyFile; 
          peers = [{
              endpoint = "${cfg.server.externalAddress}:${toString cfg.port}";
              #publicKey = cfg.server.publicKey;
              allowedIPs = cfg.client.ips;
              persistentKeepalive = 25;
              #presharedKeyFile = cfg.presharedKeyFile;
          }];
        };
      };
    })

    (mkIf cfg.server.rerouteAllTraffic {
      networking.wireguard = mkIf (!cfg.client.wg-quick) {
        interfaces."${cfg.interfaceName}-cr".peers = [{
          endpoint = "${cfg.server.externalAddress}:${toString cfg.port}";
          #publicKey = cfg.server.publicKey;
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          persistentKeepalive = 25;
        }];
      };
      networking.wg-quick = mkIf cfg.client.wg-quick {
        interfaces."${cfg.interfaceName}-crc".peers = [{
          endpoint = "${cfg.server.externalAddress}:${toString cfg.port}";
          #publicKey = cfg.server.publicKey;
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          persistentKeepalive = 25;
          #presharedKeyFile = cfg.presharedKeyFile;
        }];
      };
    })

    (mkIf cfg.server.enable {
      networking.firewall.allowedUDPPorts = [cfg.port];
      environment.systemPackages = with pkgs; [ wireguard-tools ];
      networking.nat = {
        enable = true;
        enableIPv6 = cfg.ipv6;
        internalInterfaces = [cfg.interfaceName];
        externalInterface = cfg.server.externalInterface;
      }; 
      networking.wireguard.enable = true;
      networking.wireguard.interfaces = mkIf (!cfg.server.wg-quick) {
        "${cfg.interfaceName}-s" = {
          ips = cfg.server.ips; 
          listenPort = cfg.port;
          mtu = cfg.mtu;
          #privateKeyFile = cfg.server.privateKeyFile;
          #generatePrivateKeyFile = cfg.server.generatePrivateKeyFile;
          peers = [{ 
            #publicKey = cfg.client.publicKey;
            #presharedKeyFile = cfg.presharedKeyFile;
            allowedIPs = [ "10.0.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
          }];
        };
      };
      networking.wg-quick = mkIf cfg.server.wg-quick {
        interfaces."${cfg.interfaceName}-sq" = {
          address = cfg.server.ips;
          listenPort = cfg.port;
          mtu = cfg.mtu;
          #privateKeyFile = cfg.server.privateKeyFile;
          #generatePrivateKeyFile = cfg.server.generatePrivateKeyFile;
          autostart = cfg.server.autostart;
          peers = [{ 
            #publicKey = cfg.client.publicKey;
            #presharedKeyFile = cfg.presharedKeyFile;
            allowedIPs = [ "10.0.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
          }];
        };
      }; 
    })

    (mkIf cfg.server.rerouteAllTraffic {
      environment.systemPackages = with pkgs; [ iptables ];
      networking.wireguard.interfaces."${cfg.interfaceName}" = {
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${cfg.server.externalInterface} -j MASQUERADE
        '';  # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${cfg.server.externalInterface} -j MASQUERADE
        ''; # This undoes the above command
      };
      networking.wg-quick.interfaces."${cfg.interfaceName}" = {
        postUp = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i ${cfg.server.externalInterface} -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o ${cfg.server.externalInterface} -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o ${cfg.server.externalInterface} -j MASQUERADE
        ''; # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        preDown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o ${cfg.server.externalInterface} -j MASQUERADE
          ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o ${cfg.server.externalInterface} -j MASQUERADE
        ''; # Undo the above
      };
    })

    (mkIf cfg.server.dns {
      networking.nat.enableIPv6 = mkOverride 50 true;
      networking.firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };
      networking.wg-quick.interfaces."${cfg.interfaceName}".dns = cfg.server.ips;
      services.dnsmasq = mkIf cfg.server.dnsmasq {
        enable = true;
        settings.interface = cfg.interfaceName;
      };
    })

  ]);
}
