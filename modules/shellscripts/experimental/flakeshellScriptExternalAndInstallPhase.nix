{
  description = "flake that builds shell script properly, BROKEN";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.shell-script =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
      pkgs.stdenv.mkDerivation {
        pname = "cowsay-scriptus";
        version = "1.0";
        src = ./.;        
        buildInputs = [ pkgs.makeWrapper pkgs.ddate pkgs.cowsay ];

        installPhase = ''
          mkdir -p $out/bin
          cp ${./script.sh} $out/bin/cowsay-scriptus
          chmod +x $out/bin/cowsay-scriptus

          ${pkgs.makeWrapper}/bin/makeWrapper $out/bin/cowsay-scriptus $out/bin/cowsay-scriptus \
            --set PATH "${pkgs.ddate}/bin:${pkgs.cowsay}/bin:\$PATH"
        '';
      };

    nixosModules.default = { config, pkgs, lib, ... }: {
      config = {
        environment.systemPackages = [
          self.packages.${pkgs.system}.shell-script
        ];
      };
    };
  };
}
