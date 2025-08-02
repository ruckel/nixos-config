{
  description = "flake with multiple shell script packages";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      scriptDefs = [
        {
          name = "cowsay-script";
          file = ./script.sh;
          deps = with pkgs; [ cowsay ddate ];
        }
        {
          name = "cowsay-scriptus";
          file = ./script2.sh;
          deps = with pkgs; [ cowsay ];
        }
        /*{
          name = "hello-dater";
          file = ./scripts/hello-dater.sh;
          deps = with pkgs; [ coreutils ];
        }*/
      ];

      # Function to build each script into a shell binary
      makeScript = { name, file, deps }: pkgs.writeShellScriptBin name ''
        export PATH=${pkgs.lib.makeBinPath deps}
        ${builtins.readFile file}
      '';

      # Build all packages
      packageList = builtins.listToAttrs (
        map (def: {
          name = def.name;
          value = makeScript def;
        }) scriptDefs
      );
    in
    {
      packages.${system} = packageList;

      # Optional: install all in systemPackages when used as a NixOS module
      nixosModules.default = { config, pkgs, lib, ... }: {
        config.environment.systemPackages =
          lib.mkIf (config.programs.cowsayScripts.enable or true) (
            builtins.attrValues self.packages.${pkgs.system}
          );
        options.programs.cowsayScripts.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install all cowsayScripts tools.";
        };
      };
    };
}
