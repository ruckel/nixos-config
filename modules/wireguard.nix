#types = {attrs, bool, path, int, port, str, lines, commas}
{ lib, pkgs, config, ... } :
with lib;
let 
  cfg = config.wg;
  serverCmds = {
    /* 
      This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
    */
    postSetup = ''
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    ''; 
    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
    ''; # This undoes the above command
  };
  peers = {
    clients = [{ 
      name = "korv-burk"; # optional
      publicKey = "4GKEXr4HkDMTrIB04YB/iJtfjhzVii3e4QkdHxnBzHw="; # string
      # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
      allowedIPs = [ "10.100.0.2/32" ];
    }];
    servers = [{
      endpoint = "192.168.1.12:51666"; # Server IP and port
      publicKey = "P8PQu5AVJzN9tge3zwT1LZphU1JGRo1q0YeLcDokCi8="; #cfg.server.publicKey; # key of server (str)
      persistentKeepalive = 25; # Important to keep NAT tables alive
      allowedIPs = [ "0.0.0.0/0" ]; # Forward all the traffic via VPN
      #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ]; # Or forward only particular subnets 
    }];
  };
  serverPeers = [
    /*{ 
      name = "Jane Doe"; # optional
      publicKey = "yyy"; # string
      # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
      allowedIPs = [ "10.100.0.2/32" ];
    }*/
    /*{ 
      publicKey = "yyy"; # string
      allowedIPs = [ "10.100.0.3/32" ];
    }*/
  ];
  clientPeers = [
    /* Todo: Route to endpoint not automatically configured 
      https://wiki.archlinux.org/index.php/WireGuard#Loop_routing 
      https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577 
    */
    /*{
      endpoint = "{server ip}:${cfg.port}"; # Server IP and port
      publicKey = cfg.server.publicKey; # of server (str)
      persistentKeepalive = 25; # Important to keep NAT tables alive
      allowedIPs = [ "0.0.0.0/0" ]; # Forward all the traffic via VPN
      #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ]; # Or forward only particular subnets 
    }*/
  ];
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
    server = {
      ips = mkOption {
        default = [ "10.100.0.1/24" ];
        description = "Addresses/subnets of server tunnel interface";
        type = with types; listOf str;
      };
      externalInterface = mkOption {
        default = "eno1";
        description = "Ethernet connection name";
        type = types.str;
      };
      privateKeyFile = mkOption {
        default = "/etc/wireguard-keys/server/private";
        description = "Path (as string) of private server key file";
        type = types.str;
      };
      generatePrivateKeyFile = {
        default = true;
        description = "Generate server key file at privateKeyFile";
        type = types.bool;
      };
      publicKey = mkOption {
        default = "P8PQu5AVJzN9tge3zwT1LZphU1JGRo1q0YeLcDokCi8=";
        description = "Value (not path) of public server key ";
        type = types.str;
      };
      systemd = {
        default = false;
        type = types.bool; 
      };
      dns = mkEnableOption "Enable DNS setup";
      wg-quick = mkEnableOption "";
      dnsmasq = mkEnableOption "";
      enable = mkEnableOption "";
    };
    client = {
      privateKeyFile = mkOption {
        default = "/etc/wireguard-keys/client/private";
        description = "Path (as string) of private client key file";
        type = types.str;
      };
      generatePrivateKeyFile = {
        default = true;
        description = "Generate client key file at privateKeyFile";
        type = types.bool;
      };
      publicKey = mkOption {
        default = "4GKEXr4HkDMTrIB04YB/iJtfjhzVii3e4QkdHxnBzHw=";
        description = "Value (not path) of public client key ";
        type = types.str;
      }; 
      ips = mkOption {
        default = [ "10.100.0.2/24" ];
        description = "Addresses/subnets of client tunnel interface";
        type = with types; listOf str;
      };
      wg-quick = mkEnableOption "Enable DNS setup";
      enable = mkEnableOption "";
    };
  };

  config = (mkMerge [
    (mkIf cfg.client.enable {
      environment.systemPackages = with pkgs; [ wireguard-tools wireguard-ui iptables ];
      networking = {
        wireguard = {
          interfaces."${cfg.interfaceName}" = {
            privateKeyFile = cfg.client.privateKeyFile; 
            generatePrivateKeyFile = true; #cfg.client.generatePrivateKeyFile;
            listenPort = cfg.port;
            ips = cfg.client.ips;
            peers = peers.servers;
          };
          enable = true;
        };
        firewall.allowedUDPPorts = [cfg.port];
      };
    })

    (mkIf cfg.client.wg-quick {
      networking.wg-quick.interfaces = {
        "${cfg.interfaceName}" = {
          address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
          dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
          privateKeyFile = "/root/wireguard-keys/privatekey";
          
          peers = [
            {
              publicKey = "{server public key}";
              presharedKeyFile = "/root/wireguard-keys/preshared_from_peer0_key";
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              endpoint = "{server ip}:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    })
    
    (mkIf cfg.server.enable {
      environment.systemPackages = with pkgs; [ wireguard-tools wireguard-ui iptables ];
      networking = {
        wireguard = {
          interfaces = {
            "${cfg.interfaceName}" = {
              listenPort = cfg.port; # Must be accessible by the client
              privateKeyFile = cfg.server.privateKeyFile;
              generatePrivateKeyFile = true; #cfg.server.generatePrivateKeyFile;
              peers = peers.clients;
              ips = cfg.server.ips;
              postSetup = serverCmds.postSetup; 
              postShutdown = serverCmds.postShutdown;
            };
          };
          enable = true;
        };
        nat = {
          enable = true;
          internalInterfaces = [cfg.interfaceName];
          externalInterface = cfg.server.externalInterface;
        };
        firewall.allowedUDPPorts = [cfg.port];
      };
    })

    (mkIf cfg.server.dns {
      networking ={
        nat = {
          enable = true;
          enableIPv6 = true;
          externalInterface = cfg.server.externalInterface;
          internalInterfaces = [ cfg.interfaceName ];
        };
        firewall = {
          allowedTCPPorts = [ 53 ];
          allowedUDPPorts = [ 53 cfg.port ];
        };
      };
    })

    (mkIf cfg.server.wg-quick {
      networking.wg-quick.interfaces = {
        "${cfg.interfaceName}" = { 
          address = [ "10.0.0.1/24" "fdc9:281f:04d7:9ee9::1/64" ]; # IP/IPv6 address/subnet of client tunnel interface
          listenPort = cfg.port;
          privateKeyFile = cfg.server.privateKeyFile;
 
          postUp = ''
            ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
          ''; # This allows the wireguard server to route your traffic to the internet and hence be like a VPN

          preDown = ''
            ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
            ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
          ''; # Undo the above

          peers = [
            { 
              publicKey = cfg.client.publicKey;
              presharedKeyFile = "/etc/wireguard-keys/client/private";
              allowedIPs = [ "10.0.0.2/32" "fdc9:281f:04d7:9ee9::2/128" ];
            }
          ];
        };
      };
    })

    (mkIf cfg.server.dnsmasq {
      services.dnsmasq = {
        enable = true;
        settings.interface = cfg.interfaceName;
      };
    })

    /*(mkIf cfg.server.systemd {
      environment.systemPackages = with pkgs; [ wireguard-tools wireguard-ui iptables ];
      networking = {
        firewall.allowedUDPPorts = [cfg.port];
        useNetworkd = true;  
      };
      systemd.network = {
        netdevs = {
          "50-${cfg.interfaceName}" = {
            netdevConfig = {
              Kind = "wireguard";
              Name = cfg.interfaceName;
              MTUBytes = "1300";
            };
            wireguardConfig = {
              PrivateKeyFile = cfg.server.privateKeyFile;
              ListenPort = cfg.port;
              RouteTable = "main";
            };
            wireguardPeers = serverPeers;
          };
        };
        networks."${cfg.interfaceName}" = {
          matchConfig.Name = cfg.interfaceName;
          address = cfg.server.ips;
          networkConfig = {
            IPMasquerade = "ipv4";
            IPForward = true;
          };
        };
        enable = true;
      };
    })*/
  ]);
}
