{ lib, config, ... } :
with lib; let
  cfg = config.util;
#  p = config.print;
in {
  imports = [
      (mkAliasOptionModule  [ "util" "print" ] [ "util" "trace" ])
      (mkAliasOptionModule  [ "print" "this" ] [ "util" "trace" ])
  ];
  options = {
    util.enable = mkEnableOption "";
    util.trace = mkOption {
      default = [];
      type = with types; listOf anything;
      description = "List of trace sources";
    };
  };
  config = mkIf (cfg.trace != []) {
    environment.etc."nixos-eval-util".enable =
      trace "'${concatStringsSep "' '" (map toString cfg.trace)}')"
      false
    ;
  };
}