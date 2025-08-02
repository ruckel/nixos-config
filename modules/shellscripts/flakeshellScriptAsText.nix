{
  description = "flake with shell script in flake file";

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.cowsay-scriptus;
    packages.x86_64-linux.cowsay-scriptus =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
      pkgs.writeShellScriptBin "cowsay-scriptus" ''
        DATE="$(${pkgs.ddate}/bin/ddate +'the %e of %B%, %Y')"
        ${pkgs.cowsay}/bin/cowsay Hello, world! Today is $DATE.
      '';

      nixosModules.default = { config, pkgs, lib, ... }: {
        config = {
          environment.systemPackages = [
            self.packages.${pkgs.system}.cowsay-scriptus
          ];
        };
      };
  };
}
