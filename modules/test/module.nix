{ config, lib, pkgs, ... }:

let
  outputTxtDrv = pkgs.stdenv.mkDerivation {
    name = "output.txt";
    phases = "buildPhase";
    builder = ./builder.sh;
    nativeBuildInputs = [ pkgs.coreutils pkgs.jq ];
    PATH = lib.makeBinPath [ pkgs.coreutils pkgs.jq ];
    someString = "some string";
    someNumber = builtins.toString 42;
    someJson = builtins.toJSON { key = "value"; };
  };
in {
  options.test.outputTxtDrv = lib.mkOption {
    type = lib.types.package;
    description = "Custom output text derivation.";
  };

  config.test.outputTxtDrv = outputTxtDrv;
}
