{ system, user, nixpkgs }:

let
  pkgs = import nixpkgs { inherit system; };
in
{
  package = pkgs.writeShellScriptBin "spotify-hello" ''
    echo "Hello, ${user}! System: ${system}"
  '';
}
