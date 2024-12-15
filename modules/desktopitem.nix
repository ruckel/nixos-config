{ pkgs, ... }:
# let cfg = {
    # name = "disco-cowsay";
    # desktopname = "discordian-cowsay";
    # terminal = true /*false*/ ;
    # deps = [ cowsay ddate ];
# };
# in
pkgs.stdenv.mkDerivation rec {
  name = "disco-cowsay";
  buildCommand = let
    script = pkgs.writeShellApplication {
      name = "disco-cowsay";
      runtimeInputs = with pkgs; [ cowsay ddate ] /*cfg.deps*/ ;
      text = /*builtins.readFile "./my-script.sh";*/''
      DATE=$(ddate +'the %e of %B%, %Y')
      cowsay Hello, world! Today is $DATE.
      '';
    };
    desktopEntry = pkgs.makeDesktopItem {
      name = "disco-cowsay";
      desktopName = "discordian-cowsay";
      exec = "${script}/bin/${name} %f";
      terminal = true;
    };
  in ''
    mkdir -p $out/bin
    cp ${script}/bin/${name} $out/bin
    mkdir -p $out/share/applications
    cp ${desktopEntry}/share/applications/${name}.desktop $out/share/applications/${name}.desktop
  '';
  dontBuild = true;
}
