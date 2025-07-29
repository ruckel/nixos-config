{ config, lib, pkgs, specialArgs, ... }:{
  options = {};
  config = {
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [ spotify ];
    environment.etc."hello-user".text = "Hello ${specialArgs.user or "unknown"}!";
  };
}
