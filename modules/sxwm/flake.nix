{
  description = "SXWM module flake";

  outputs = { self, ... }: {
    nixosModules.sxwm = import ./module.nix;
  };
}
