#!/bin/sh
RUN_AS_USER=korv

sinkL='Main-Output-Proxy:monitor_FL'
sinkR='Main-Output-Proxy:monitor_FR'
micSink='main-in-sink:input_MONO'

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

echo poopoo
# Monitors
pw-link $sinkL $outWlL      && pw-link $sinkR $outWlR
pw-link $sinkL $outHeadsetL && pw-link $sinkR $outHeadsetR
pw-link $sinkL $outLineL    && pw-link $sinkR $outLineR
pw-link $sinkL $outTvL    && pw-link $sinkR $outTvR

# Mics
pw-link $micWebcam $micSink
pw-link $micHeadset $micSink
