{
  description = "flake shell script";
  
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.shell-script =
      let
        name = "cowsay-scriptus";
        scriptFile = ./script.sh;
        deps = with pkgs; [ ddate cowsay ];

        pkgs = import nixpkgs { system = "x86_64-linux"; };
        envSetup = "export PATH=${pkgs.lib.makeBinPath deps}";
      in
      pkgs.writeShellScriptBin name ''
          ${envSetup}
          ${builtins.readFile scriptFile}
        '';          
      nixosModules.default = { config, pkgs, lib, ... }: {
        config.environment.systemPackages = [ self.packages.${pkgs.system}.shell-script ];
      };
  };
}
