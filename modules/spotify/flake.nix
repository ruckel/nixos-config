{
  /*inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };*/

  description = "spotify flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs, ... }: {
    nixosModules.default = { config, lib, ... } @ args:
      let
        system = args.specialArgs.system or "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
      in
        import ./module.nix {
          inherit pkgs;
          inherit (args) config lib specialArgs;
        };
  };
}
