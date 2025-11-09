{ description = "main flake";

inputs = { #//region
  nixpkgs-unstable.url  = "github:NixOS/nixpkgs/nixos-unstable";
#  nixpkgs-stable.url    = "github:NixOS/nixpkgs/nixos-25.05";
#  nixpkgs-small.url     = "github:NixOS/nixpkgs/nixos-25.05-small";
  sops-nix.url          = "github:Mic92/sops-nix";
#  bash.url              = "path:./modules/bash";
}; #//endregion

outputs = {
  self,
  nixpkgs-unstable,
#  nixpkgs-stable,
#  nixpkgs-small,
  sops-nix,
#  bash,
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
#        bash.nixosModules.default
        #sxwm.nixosModules.sxwm
        #spotify.nixosModules.default
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
#        bash.nixosModules.default
#      ];
#    };
    /* vaio = nixpkgs-small.lib.nixosSystem {
      specialArgs = {
      inherit system inputs outputs;
        hostName = "vaio";
        userName = "korv";
      };
      modules = [
        ./hosts/vaio/configuration.nix
        sops-nix.nixosModules.sops
        bash.nixosModules.default
      ];
      }; */
#    labb = nixpkgs-small.lib.nixosSystem {
#      specialArgs = {
#      inherit system inputs outputs;
#        hostName = "labb";
#        userName = "user";
#
#      };
#      modules = [
#        ./hosts/homelab/configuration.nix
#        sops-nix.nixosModules.sops
#        bash.nixosModules.default
#      ];
#    };
  };
};
}
