{
  description = "main flake";
  
  inputs = {
    #nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url  = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-small.url     = "github:NixOS/nixpkgs/nixos-24.11-small";
    sops-nix.url          = "github:Mic92/sops-nix";
    /* vars = {
      url = "/etc/vars.nix";
       flake = false;
    };*/
    #sxwm.url = "path:/home/korv/nixos-cfg/modules/sxwm"; #"path:./modules/sxwm";
    #spotify.url = "path:./modules/spotify"/*"path:/home/korv/nixos-cfg/modules/spotify"*/;
  };

  outputs = {
    self,
    nixpkgs-unstable,
    #nixpkgs-stable,
    #nixpkgs-small,
    sops-nix,
    #sxwm,
    #spotify,
    ...
  } @ inputs: let
  inherit (self) outputs;
  system = "x86_64-linux";
  user = "korv";
  specialArgs = {
    inherit inputs system;
    user = "korv"; 
  };
  in
  {
    nixosConfigurations = {
      nixburk  = nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        specialArgs = { 
          inherit inputs outputs;
          user = "korv";
        };
        modules = [
          ./hosts/burk/configuration.nix
          sops-nix.nixosModules.sops
          #sxwm.nixosModules.sxwm
          #spotify.nixosModules.default
        ];
      };
      /*nixdell = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/dell/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };
      nixvaio = nixpkgs-small.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/vaio/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };
      nix-homelab = nixpkgs-small.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/homelab/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };*/
    };
  };
}
