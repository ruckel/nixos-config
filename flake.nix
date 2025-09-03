{ description = "main flake";

inputs = {
  nixpkgs-unstable.url  = "github:NixOS/nixpkgs/nixos-unstable";
  nixpkgs-stable.url    = "github:NixOS/nixpkgs/nixos-25.05";
  nixpkgs-small.url     = "github:NixOS/nixpkgs/nixos-25.05-small";
  sops-nix.url          = "github:Mic92/sops-nix";
  #sxwm.url = "path:/home/korv/nixos-cfg/modules/sxwm"; #"path:./modules/sxwm";
  #spotify.url = "path:./modules/spotify"/*"path:/home/korv/nixos-cfg/modules/spotify"*/;
  bash.url = "path:./modules/bash";
  /* vars = {
    url = "/etc/vars.nix";
     flake = false;
  };*/
};

outputs = {
  self,
  nixpkgs-unstable,
  nixpkgs-stable,
  nixpkgs-small,
  sops-nix,
  #sxwm,
  #spotify,
  bash,
  ...
} @ inputs: 

let
  inherit (self) outputs;
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs outputs;
    vars = {
      username-admin = "korv";
      ssh = {
        ports = [ 6842 ];
        keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJsd82H9yUf2hgBiXECvfPVgUxy84vHz5MbsBDbShvv korv@nixos"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINVVXnVUOmIZT0SCScu/An4NgyOvZJA+ZcGAq/BlwmDi korv@dell"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa8dGCkZtulhJ7Peg2XvdryhAowWpL0hVMAS+i0I1t5 root@nix-homelab"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEpTIZfMSLWJBzkvSZyCthrU40R0CB8GjRi0WUMxi62z korv@pixel"
        ];
        knownHosts = {
          "nixburk" = {
            publicKey = null;
            admin-user-keyfile = null;
          };
          "dell" = {
            publicKey = null;
            };
          "nixvaio" = {
            publicKey = null;
            };
          "nix-homelab" = {
            publicKey = null;
            };
        };
      };
    };
  };
in {
  nixosConfigurations = {
    nixburk  = nixpkgs-unstable.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./hosts/burk/configuration.nix
        sops-nix.nixosModules.sops
        #sxwm.nixosModules.sxwm
        #spotify.nixosModules.default
        bash.nixosModules.default
      ];
    };
    dell = nixpkgs-stable.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs outputs; };
      modules = [
        ./hosts/dell/configuration.nix
        sops-nix.nixosModules.sops
        bash.nixosModules.default
      ];
    };
    /*nixvaio = nixpkgs-small.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs outputs; };
      modules = [
        ./hosts/vaio/configuration.nix
        sops-nix.nixosModules.sops
        bash.nixosModules.default
      ];
      };*/
    nix-homelab = nixpkgs-small.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs outputs; };
      modules = [
        ./hosts/homelab/configuration.nix
        sops-nix.nixosModules.sops
        bash.nixosModules.default
      ];
    };
  };
};
}
