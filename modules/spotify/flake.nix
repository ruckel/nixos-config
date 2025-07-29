#{ system, user, ... }:
{
description = "Spotify system module, flake";
inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
outputs = { self, nixpkgs, system, user }: 
let
  pkgs = nixpkgs.legacyPackages.${system};
in {
  nixosModules = {
    default = {
      config = {
        #environment.systemPackages = [ pkgs.spotify ];
      };
    };
  };
};
}
