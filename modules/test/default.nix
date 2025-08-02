{
  outputTxtDrv = stdenv.mkDerivation rec {
    name = "output.txt";
    # disable unpackPhase etc
    phases = "buildPhase";
    builder = ./builder.sh;
    nativeBuildInputs = [ coreutils jq ];
    PATH = lib.makeBinPath nativeBuildInputs;
    # only strings can be passed to builder
    someString = "some string";
    someNumber = builtins.toString 42;
    someJson = builtins.toJSON { key = "value"; };
  };
}
