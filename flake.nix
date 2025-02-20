{
description = "a description";
inputs = {
  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
  nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-24.11-small";
  sops-nix.url = "github:Mic92/sops-nix";
  # dcowsay = "./nixscripts/dcowsay";
  vars = {
      url = "/etc/vars.nix";
      flake = false;
     };
 };

outputs = {
  self,
  nixpkgs-unstable,
  nixpkgs-stable,
  nixpkgs-small,
  sops-nix,
  # dcowsay,
  ...
 } @ inputs: let
inherit (self) outputs;
system = "x86_64-linux";
in
{
  nixosConfigurations = {
    nixburk = nixpkgs-stable.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs outputs; };
      modules = [
        ./hosts/burk/configuration.nix
        sops-nix.nixosModules.sops
       ];
     };
    nixdell = nixpkgs-stable.lib.nixosSystem {
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
     };
   };
 };
}
