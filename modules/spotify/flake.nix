{
  description = "Spotify system module, flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosModules = {
      default = {
        config = {
          environment.systemPackages = [ pkgs.spotify ];
        };
      };
    };
  };
}
