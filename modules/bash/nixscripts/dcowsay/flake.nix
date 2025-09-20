{
#  description = "helloWorld script";
#
#  inputs.flake-utils.url = "github:numtide/flake-utils";
#
#  outputs = { self, nixpkgs, flake-utils }:
#    flake-utils.lib.eachDefaultSystem (system:
#      let
#        pkgs = import nixpkgs { inherit system; };
#        script-name = "dcowsay";
#        /*                                dependencies  */
#        script-buildInputs = with pkgs; [ cowsay ddate ];
#        /*                                                            Script path here                      */
#        script = (pkgs.writeScriptBin script-name (builtins.readFile ./dcowsay.sh)).overrideAttrs(old: {
#          buildCommand = "${old.buildCommand}\n patchShebangs $out";
#        });
#      in rec {
#        defaultPackage = packages.script;
#        packages.script = pkgs.symlinkJoin {
#          name = script-name;
#          paths = [ script ] ++ script-buildInputs;
#          buildInputs = [ pkgs.makeWrapper ];
#          postBuild = "wrapProgram $out/bin/${script-name} --prefix PATH : $out/bin";
#        };
#      }
#    );
}