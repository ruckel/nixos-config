{
  description = "flake shell script";
  
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.shell-script =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
      pkgs.writeShellScriptBin "cowsay-scriptus" ''
        export PATH=${pkgs.lib.makeBinPath [ pkgs.ddate pkgs.cowsay ]}
        ${builtins.readFile ./script.sh}
      '';
    
      nixosModules.default = { config, pkgs, lib, ... }: {
        config = {
          environment.systemPackages = [
            self.packages.${pkgs.system}.shell-script
          ];
        };
      };
  };
}
