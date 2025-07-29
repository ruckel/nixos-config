#{ system, user, ... }:
{ description = "Spotify system module, flake";
inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
outputs = inputs@{ self, nixpkgs, ... }:{
  packages.${inputs.specialArgs.system} = {
    default = let
      pkgs   = import nixpkgs { system = inputs.specialArgs.system; };
      user   = inputs.specialArgs.user or "user";
      system = inputs.specialArgs.system;
  in
    pkgs.writeShellScriptBin "spotify-hello" ''
      echo "Hello, ${user}! System: ${system}"
    '';
  };
};
}
