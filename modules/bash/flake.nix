{
#  description = ''flake with multiple shell script packages,
#    just edit `let scripts<[]>` & `options.shellScripts`
#  '';
#  inputs.nixpkgs.url = "github:nixos/nixpkgs";
#  outputs = { self, nixpkgs }:
#    let
#      system = "x86_64-linux";
#      pkgs = import nixpkgs { inherit system; };
#
#      wrappedScripts = import ./included-scripts.nix { inherit pkgs; };
#      unwrappedScripts = import ./included-scripts-not-wrapped.nix { inherit pkgs; };
#
#      makeWrappedScript = { name, file, deps }: pkgs.writeShellScriptBin name ''
#        export PATH=${pkgs.lib.makeBinPath deps}
#        ${builtins.readFile file}
#      '';
#      makeUnwrappedScript = { name, file, aliases }: pkgs.writeScriptBin name ''
#        ${builtins.readFile file}
#      '';
#
#      packageListWrapped = builtins.listToAttrs (
#        map (def: {
#          name = def.name;
#          value = makeWrappedScript def;
#        }) wrappedScripts
#      );
#      packageListUnwrapped = builtins.listToAttrs (
#        map (def: {
#          name = def.name;
#          value = makeUnwrappedScript def;
#        }) unwrappedScripts
#      );
#    in
#    {
#      packages.${system} = packageListWrapped // packageListUnwrapped;
#      nixosModules.default = { config, pkgs, lib, ... }: {
#        config.environment.systemPackages =
#          lib.mkIf (config.programs.shellScripts.enable /* or true*/) (
#            builtins.attrValues self.packages.${pkgs.system}
#          );
#        options.programs.shellScripts.enable = lib.mkOption {
#          type = lib.types.bool;
#          default = true;
#          description = "install all shell scripts in systemPackages";
#        };
#      };
#    };
}
