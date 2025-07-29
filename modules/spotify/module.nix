{ config, lib, pkgs, specialArgs, ... }:{
  options = {};
  config = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
    environment.systemPackages = with pkgs; [ spotify ];
    environment.etc."hello-user".text = "Hello ${specialArgs.user or "unknown"}!";
  };
}
