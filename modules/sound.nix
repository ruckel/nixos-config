{ lib, config, pkgs, ...}:
with lib;
let
  cfg = config.soundconf;
in {
  options.soundconf = {
    enable = lib.mkEnableOption "Enable Module";
    lowLatency = mkEnableOption "Enable low latency settings";
    combine = lib.mkEnableOption "combine inputs into sink and outputs into sink";

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
      extraConfig.pipewire = {
        "91-null-sinks" = {
          "context.objects" = [
            { ## Main Out
              factory = "adapter";
              args = {
                "factory.name" = "support.null-audio-sink";
                "node.name" = "out-sink";
                "node.description" = "main out";
                "media.class" = /*"Audio/Sink"*/ "Audio/Duplex" ;
                "media.category" = "Duplex";
                "audio.position" = "FL,FR";
              };
            }{ ## Main In
              factory = "adapter";
              args = {
                "factory.name" = "support.null-audio-sink";
                "node.name" = "in-sink";
                "node.description" = "mic sink";
                "media.class" = /*"Audio/Source/Virtual"*/ /*"Audio/Source"*/ /*"Audio/Sink"*/ "Audio/Duplex"  ;
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

    systemd.user.services.pipewire-linking = mkIf cfg.combine {
      enable = true;
      after = [ "pipewire.service" "multi-user.target" "gdm.service" ];
      path = [ pkgs.pipewire ];
      serviceConfig = {
          Type = "oneshot";
          ExecStart = ''/etc/pipewire-link.sh'';
      };
      wantedBy = [ "pipewire.service" ];
    };
    environment.etc."pipewire-link.sh" = mkIf cfg.combine {
      user = cfg.user;
      mode = "0700";
      text = ''
        #!/bin/sh
        RUN_AS_USER=${cfg.user}
        
        sinkL='out-sink:capture_FL'
        sinkR='out-sink:capture_FR'
        micSink='in-sink:input_MONO'
        micWebcam='alsa_input.usb-Sonix_Technology_Co.__Ltd._USB_2.0_Camera-02.mono-fallback:capture_MONO'
        micHeadset='alsa_input.usb-SteelSeries_SteelSeries_Arctis_1_Wireless-00.mono-fallback:capture_MONO'
        outWlL='alsa_output.usb-GENERIC_USB_Headset-00.analog-stereo:playback_FL'
        outWlR='alsa_output.usb-GENERIC_USB_Headset-00.analog-stereo:playback_FR'
        outHeadsetL='alsa_output.usb-SteelSeries_SteelSeries_Arctis_1_Wireless-00.analog-stereo:playback_FL'
        outHeadsetR='alsa_output.usb-SteelSeries_SteelSeries_Arctis_1_Wireless-00.analog-stereo:playback_FR'       
        outLineL='alsa_output.pci-0000_00_1f.3.analog-stereo:playback_FL'
        outLineR='alsa_output.pci-0000_00_1f.3.analog-stereo:playback_FR'
        outTvL='alsa_output.pci-0000_03_00.1.hdmi-stereo.2:playback_FL'
        outTvR='alsa_output.pci-0000_03_00.1.hdmi-stereo.2:playback_FR'
        
        # Monitors
        echo "trying w/less usb dongle" && pw-link $sinkL $outWlL      && pw-link $sinkR $outWlR
        echo "trying headset"           && pw-link $sinkL $outHeadsetL && pw-link $sinkR $outHeadsetR
        echo "trying line out"          && pw-link $sinkL $outLineL    && pw-link $sinkR $outLineR
        echo "trying tv"                && pw-link $sinkL $outTvL      && pw-link $sinkR $outTvR
        
        # Mics
        echo "trying webcam mic"        && pw-link $micWebcam $micSink
        echo "trying headset mic"       && pw-link $micHeadset $micSink
      '';
    };
  };
}
