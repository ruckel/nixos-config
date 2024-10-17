{
  description = "A template that shows all standard flake outputs";
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      #nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
      sops-nix.url = "github:Mic92/sops-nix";
      vars = {
        url = "/etc/vars.nix";
        flake = false;
      };
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    ...
  } @ inputs: let
  inherit (self) outputs;
  system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      nixburk = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = [
          /home/korv/nixos-cfg/hosts/burk/burk-configuration.nix
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
