{
  description = ''flake with multiple shell script packages, 
    just edit `let scripts<[]>` & `options.shellScripts`
  '';
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  outputs = { self, nixpkgs }: 
    let
      scripts = [
        { name = "cowsay-script";
          file = ./script.sh;
          deps = with pkgs; [ cowsay ddate ];
        }
        { name = "cowsay-scriptus";
          file = ./script2.sh;
          deps = with pkgs; [ cowsay ];
        }
        { name = "exec-with-watch";
          file = ./exec-with-watch.sh;
          deps = with pkgs; [ inotify-tools ];
        }
        #{ name = "";
        #  file = ./x.sh;
        #  deps = with pkgs; [  ];
        #}
      ];

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      makeScript = { name, file, deps }: pkgs.writeShellScriptBin name ''
        export PATH=${pkgs.lib.makeBinPath deps}
        ${builtins.readFile file}
      '';
      packageList = builtins.listToAttrs (
        map (def: {
          name = def.name;
          value = makeScript def;
        }) scripts
      );
    in
    { 
      packages.${system} = packageList;
      nixosModules.default = { config, pkgs, lib, ... }: {
        config.environment.systemPackages =
          lib.mkIf (config.programs.shellScripts.enable/* or true*/) (
            builtins.attrValues self.packages.${pkgs.system}
          );
          /*options.shellScripts = {
            enable = lib.mkEnableOption "install all shell scripts in systemPackages";
          };*/
        options.programs.shellScripts.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install all cowsayScripts tools.";
        };
      };
    };
}
