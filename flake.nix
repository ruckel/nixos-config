{ description = "main flake";

inputs = {
  nixpkgs-unstable.url  = "github:NixOS/nixpkgs/nixos-unstable";
  nixpkgs-stable.url    = "github:NixOS/nixpkgs/nixos-25.11";
  nixpkgs-small.url     = "github:NixOS/nixpkgs/nixos-25.05-small";
  sops-nix.url          = "github:Mic92/sops-nix";
};

outputs = {
  self,
  nixpkgs-unstable,
  nixpkgs-stable,
  nixpkgs-small,
  sops-nix,
  ...
} @ inputs: 

let
  inherit (self) outputs;
  system = "x86_64-linux";
in {
  nixosConfigurations = {
    burk  = nixpkgs-unstable.lib.nixosSystem {
      specialArgs = {
      inherit system inputs outputs;
        hostName = "burk";
        userName = "korv";
      };
      modules = [
        ./hosts/burk/configuration.nix
        sops-nix.nixosModules.sops
      ];
    };
#    dell = nixpkgs-stable.lib.nixosSystem {
#      specialArgs = {
#      inherit system inputs outputs;
#        hostName = "dell";
#        userName = "korv";
#      };
#      modules = [
#        ./hosts/dell/configuration.nix
#        sops-nix.nixosModules.sops
#      ];
#    };
    vaio = nixpkgs-small.lib.nixosSystem {
      specialArgs = {
      inherit system inputs outputs;
        hostName = "vaio";
        userName = "korv";
      };
      modules = [
        ./hosts/vaio/configuration.nix
        sops-nix.nixosModules.sops
      ];
     };
    labb = nixpkgs-small.lib.nixosSystem {
      specialArgs = {
      inherit system inputs outputs;
        hostName = "labb";
        userName = "user";

      };
      modules = [
        ./hosts/homelab/configuration.nix
        sops-nix.nixosModules.sops
      ];
    };
    pad = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {
      inherit system inputs outputs;
        hostName = "pad";
        userName = "korv";
      };
      modules = [
        ./hosts/pad/configuration.nix
        sops-nix.nixosModules.sops
      ];
    };
  };
};
}
