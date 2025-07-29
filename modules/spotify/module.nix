{ config, lib, pkgs, specialArgs, ... }:{
  options = {};
  config = {
    environment.systemPackages = with pkgs; [ spotify ];
    environment.etc."hello-user".text = "Hello ${specialArgs.user or "unknown"}!";
  };
}
