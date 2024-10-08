{ lib, config, ... }:
let args = {
  vars = import ../vars.nix;
  bashfile = import ../xprofile;
};
in
{ environment.etc."xprofile".text = ''
    #!/bin/sh
    if [ -z _XPROFILE_SOURCED ]; then
      export _XPROFILE_SOURCED=True
      . /etc/xprofile2 &
      dunst &
      toastify send -a 'xserver' -t 1000 -u normal 'loaded' '.xprofile'
    fi
  '';
}