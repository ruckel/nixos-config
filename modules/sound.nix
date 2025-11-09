{ lib, config, pkgs, userName, vars, ...}:
with lib;
let
  cfg = config.soundconf;
in {
  options.soundconf = {
    enable = lib.mkEnableOption "Enable Module";
    lowLatency = mkEnableOption "Enable low latency settings";
    combine = lib.mkEnableOption "combine inputs into sink and outputs into sink";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;     # pipewire realtime priotitizing
   # services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig.pipewire = {
        "91-null-sinks" = {
          "context.objects" = [
            { ## Main Out
              factory = "adapter";
              args = {
                "factory.name" = "support.null-audio-sink";
                "node.name" = "out-sink";
                "node.description" = "main out";
                "media.class" = "Audio/Sink";
#                "media.class" = "Audio/Duplex" ;
                "media.category" = "Duplex";
                "audio.position" = "FL,FR";
                "monitor.channel-volumes" = true;
              };
            }{ ## Main In
              factory = "adapter";
              args = {
                "factory.name" = "support.null-audio-sink";
                "node.name" = "in-sink";
                "node.description" = "mic sink";
                "media.class" = "Audio/Source/Virtual" /*"Audio/Source"*/ /*"Audio/Sink"*/ /*"Audio/Duplex"*/  ;
                "audio.position" = "MONO";
              };
            }{ ## A default dummy driver. This handles nodes marked with the "node.always-driver"
               ## property when no other driver is currently active. JACK clients need this.
              factory = "spa-node-factory";
              args = {
                "factory.name" = "support.node.driver";
                "node.name" = "Dummy-Driver";
                "priority.driver" = 8000;
              };
           }
          ];
        };
        "92-low-latency" = mkIf cfg.lowLatency {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 32;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 32;
          };
        };
      };
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-alsa-disable-hdmi.lua" ''
          alsa_monitor.rules = { {
            matches = {{{  "node.name", "matches", "alsa_output.hci-0000_03_00.1.hdmi*" }}};
            apply_properties = {  ["device.disabled"] = true,  },
          }, }
        '')
      ];
    };

    systemd.user.services.pipewire-link = mkIf cfg.combine {
    # //region
      enable = true;
      after = [ "pipewire.service" "multi-user.target" ];
      path = with pkgs; [ pipewire wireplumber ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
      };
      wants = [ "pipewire.service" ];
      script = ''
        count=0
        default_sink="$(wpctl status -n | tail -n 2 | grep -v input | tr -s ' ' | cut -d ' ' -f4-)"
        while true; do
          new_default_sink="$(wpctl status -n | tail -n 2 | grep -v input | tr -s ' ' | cut -d ' ' -f4-)"
          inputs="$(pw-link -i | grep "alsa_.*F[L,R]")"
          newCount=$(echo -e "$inputs" | wc -l)
          [[ $count -lt $newCount || $default_sink != $new_default_sink ]] && \
            for i in $inputs[@]; do
              if [[ $(echo $new_default_sink | cut -d ':' -f1) == $(echo $i | cut -d ':' -f1) ]]; then
                echo "skipping $i"
              else
                [[ $(echo "$i" | grep "FR") ]] && \
                  pw-link $new_default_sink:monitor_FR $i 2> /dev/null && \
                  echo "linked $i"
                [[ $(echo "$i" | grep "FL") ]] && \
                  pw-link $new_default_sink:monitor_FL $i 2> /dev/null && \
                  echo "linked $i"
              fi
            done
          count=$newCount
          [[ $default_sink != $new_default_sink ]] && $default_sink=$new_default_sink
          sleep 1
        done
      '';
    #//endregion
    };
  };
}
