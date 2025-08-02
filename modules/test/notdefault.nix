{
  outputTxtDrv = runCommand "output.txt" {
    nativeBuildInputs = [ coreutils jq ];
    # only strings can be passed to builder
    someString = "hello";
    someNumber = builtins.toString 42;
    someJson = builtins.toJSON { dst = "world"; };
  } (builtins.readFile ./builder.sh);
}
