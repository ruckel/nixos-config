{
  description = "Spotify system module, flake";

  outputs = { self, ... }: {
    nixosModules.default = import ./module.nix;
  };
}
