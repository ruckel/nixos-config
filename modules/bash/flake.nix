{
  description = ''flake with multiple shell script packages, 
    just edit `let scripts<[]>` & `options.shellScripts`
  '';
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      scripts = import ./included-scripts.nix { inherit system; };

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
          description = "install all shell scripts in systemPackages";
        };
      };
    };
}
