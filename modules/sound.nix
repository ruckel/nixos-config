{ lib, config, pkgs, ...}:
with lib;
let
  cfg = config.soundconf;
in {
  options.soundconf = {
    enable = lib.mkEnableOption "Enable Module";

    linkouts.enable = lib.mkEnableOption "";

    user = mkOption { default = "user";
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
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

    systemd.user.services.pipewire-linking = lib.mkIf cfg.linkouts.enable {
      enable = true;
      after = [ "pipewire.service" "multi-user.target" "gdm.service" ];
      path = [ pkgs.pipewire ];
      serviceConfig = {
          Type = "oneshot";
          ExecStart = ''/home/${cfg.user}/scripts/pipewire.sh'';
          #User = vars.user;
          #Group = "users";
      };
      wantedBy = [ "pipewire.service" ];
    };

    environment.etc."xprofile2".text = lib.mkIf cfg.linkouts.enable ''
    if [ ! -f ~/scripts/pipewire.sh ];then
      printf "#" > ~/scripts/pipewire.sh
      printf "!" >> ~/scripts/pipewire.sh
      printf "/bin/sh" >> ~/scripts/pipewire.sh
      echo "" >> ~/scripts/pipewire.sh
      echo "RUN_AS_USER=${cfg.user}" >> ~/scripts/pipewire.sh
      echo "sourceL='alsa_output.pci-0000_00_1f.3.analog-stereo:monitor_FL'" >> ~/scripts/pipewire.sh
      echo "sourceR='alsa_output.pci-0000_00_1f.3.analog-stereo:monitor_FR'" >> ~/scripts/pipewire.sh

      echo "phonesL='alsa_output.usb-SteelSeries_SteelSeries_Arctis_1_Wireless-00.analog-stereo:playback_FL'" >> ~/scripts/pipewire.sh
      echo "phonesR='alsa_output.usb-SteelSeries_SteelSeries_Arctis_1_Wireless-00.analog-stereo:playback_FR'" >> ~/scripts/pipewire.sh

      echo "pw-link $sourceL $phonesL" >> ~/scripts/pipewire.sh
      echo "pw-link $sourceR $phonesR" >> ~/scripts/pipewire.sh
      chmod +x ~/scripts/pipewire.sh
    fi
    ~/scripts/pipewire.sh
    '';
  };
}