{ pkgs }:[{
  name = "nix-shell-run";
  file = scripts/nix-shell-run.sh;
}{
   name = "tilix-config";
   file = scripts/tilix-config.bash;
   aliases = [ "dconf-set-tilix" ];
 }
]
/* template
{
  name = "";
  file = scripts/x.sh;
}
*/
