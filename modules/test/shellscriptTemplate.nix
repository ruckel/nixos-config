{ system, user, nixpkgs }:

let
  pkgs = import nixpkgs { inherit system; };
  #nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
in
{
  package = pkgs.writeShellScriptBin "korv-hello" ''
    echo "Hello, ${user}! System: ${system}"
  '';
}
