{ 
pkgs, 
lib, 
config, 
#fetchFromGitHub, 
#stdenv, 
#glib, 
#gettext, 
...
}:
#with import <nixpkgs> {};
#let order-icons = with pkgs; in 
{
 #options = {order-icons.enable = mkEnableOption "Enable Module"};
  config = /*lib.mkIf cfg.enable*/ {
    environment.systemPackages = with pkgs; [ 
    # order-icons
      (stdenv.mkDerivation rec {
        pname = "gnome-shell-extension-order-icons";
        uuid = "order-extensions@wa4557.github.com";
        version = "1";
        owner = "ruckel";
        repoName = "order-icons";
        rev = "8bcdd8824ae0dac4339f02e41fade23e333295ca";
        hash = "sha256-IxSDkWQEB9IyV5rFw9gPi9/T3ecx975jiGWmqFbb/bA=";

        src = fetchFromGitHub {
          owner = owner;
          repo = repoName;
          rev = rev;
          hash = hash;
        };
        nativeBuildInputs = with pkgs; [ buildPackages.glib ];
        buildPhase = ''
          runHook preBuild
          if [ -d schemas ]; then
            glib-compile-schemas --strict schemas
          fi
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/gnome-shell/extensions/
          cp -r -T . $out/share/gnome-shell/extensions/${uuid}
          runHook postInstall
        '';
        passthru = {
          extensionUuid = uuid;
          extensionPortalSlug = pname;
        };
        meta = with lib; {
          description = "a description";
          license = licenses.gpl2Plus;
          maintainers = with maintainers; [ ];
          homepage = "https://github.com/${owner}/${repoName}";
        };
      })
     ];
  };
}
