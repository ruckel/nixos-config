{ lib, config, pkgs, ...}:
let args = {
  cfg = config.soundconf;
  vars = import ../vars.nix;
};
in {
  options.soundconf = {
    enable = lib.mkEnableOption "Enable Module";

    linkedOutputs.enable = lib.mkEnableOption "";
  };

  config = lib.mkIf args.cfg.enable {
    security.rtkit.enable = true;     # pipewire realtime priotitizing
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.configPackages = [
          (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-alsa-disable-hdmi.lua" ''
              alsa_monitor.rules = { {
                  matches = {{{  "node.name", "matches", "alsa_output.hci-0000_03_00.1.hdmi*" }}};
                  apply_properties = {  ["device.disabled"] = true,  },
              }, }
          '')
      ];
    };

    systemd.user.services.pipewire-linking = lib.mkIf args.cfg.linkedOutputs.enable {
      enable = true;
      after = [ "pipewire.service" "multi-user.target" "gdm.service" ];
      path = [ pkgs.pipewire ];
      serviceConfig = {
          Type = "oneshot";
          ExecStart = ''/home/${args.vars.user}/scripts/pipewire.sh''; #TODO: define shell scirpt
          #User = vars.user;
          #Group = "users";
      };
      wantedBy = [ "pipewire.service" ];
    };

  };
}