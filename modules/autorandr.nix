{ lib, config, ...}:
with lib;
let
fingerprint  = {
  DisplayPort-0 =
    "00ffffffffffff004c2d1a71484c4e3010210104b55022783a0a7da6564f9f27114e54bfef8081c0810081809500a9c0b300714f01014ed470a0d0a0465030203a001e4e3100001a000000fd0832a51e0358000a202020202020000000fc004c433334473535540a20202020000000ff00484e54573430323130330a2020026302031cf147901f04131203402309070783010000e305c000e3060501023a801871382d40582c45001e4e3100001e565e00a0a0a02950302035001e4e3100001ae77c70a0d0a0295030203a001e4e3100001a5aa000a0a0a04650302035001e4e3100001a489680a0703829403020b8041e4e3100001a000000000000   000000657012790000030128a25701886f0d9f002f801f009f0528001a000700a2030108ff099f002f801f009f0528001a000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e190"
   ;
  DisplayPort-1 =
    "00ffffffffffff0022f0653201010101021a010380351e782a2195a756529c26105054210800d1c081c0a9c0b3009500810081800101023a801871382d40582c45000f282100001e000000fd00323c1e5011000a202020202020000000fc00485020453234300a2020202020000000ff00434e4b363032305059440a2020012802031ab149901f0413031202110168030c001000002200e2002b023a801871382d40582c45000f262100001e023a80d072382d40102c45800f262100001e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003"
   ;
  DisplayPort-2 =
    "00ffffffffffff0022f0793200000000111b0104a5331d7822c075a756529b260f5054210800d1c0a9c081c0b3009500810081800101023a801871382d40582c4500fd1e1100001e000000fd00323c1e5011010a202020202020000000fc00485020453233320a2020202020000000ff00434e34373137303557500a202000bc"
   ;
  HDMI-A-0 =
    "00ffffffffffff004c2dc507010000002e140103806639780aee91a3544c99260f5054bdef80714f8100814081809500950fb300a940023a801871382d40582c4500a05a0000001e662150b051001b3040703600a05a0000001e000000fd00184b1a5117000a202020202020000000fc0053414d53554e470a20202020200144020332f14b901f0413051403122021222309070783010000e2000fe305030172030c001000b82d20d0080140073f405090a0023a80d072382d40102c4580a05a0000001e011d00bc52d01e20b8285540a05a0000001e011d80d0721c1620102c2580a05a0000009e0000000000000000000000000000000000000000   000000b8"
   ;
 };
DisplayPort-0 = { # widescreen
  enable      = true;
  mode        = "3440x1440";
  rate        = "165.00";
  crtc        = 0;
  position    = "1920x325";
  primary     = true;
 };
DisplayPort-1 = { # regular 16:9
  enable      = true;
  mode        = "1920x1080";
  rate        = "60.00";
  crtc        = 1;
  position    = "0x555";
 };
DisplayPort-2 = { # vertical 9:16
  enable      = true;
  mode        = "1920x1080";
  rate        = "60.00";
  rotate      = "left";
  crtc        =  2;
  position    = "5360x0";
 };
HDMI-A-0      = { # tv unit
  enable      = true;
  mode        = "1920x1080";
  rate        = "60.00";
  crtc        = 3;
  position    = "0x465";
 };
#

/* 3screen / def
# output DisplayPort-2 crtc 2 pos 5360x0
  mode 1920x1080
  rate 60.00
  rotate left
  x-prop-colorspace Default
  x-prop-max_bpc 16
  x-prop-non_desktop 0
  x-prop-scaling_mode None
  x-prop-tearfree auto
  x-prop-underscan off
  x-prop-underscan_hborder 0
  x-prop-underscan_vborder 0
# output DisplayPort-0 crtc 0 pos 1920x294
  mode 3440x1440
  primary
  rate 165.00
  x-prop-colorspace Default
  x-prop-max_bpc 16
  x-prop-non_desktop 0
  x-prop-scaling_mode None
  x-prop-tearfree auto
  x-prop-underscan off
  x-prop-underscan_hborder 0
  x-prop-underscan_vborder 0
# output DisplayPort-1 crtc 1 pos 0x465
  mode 1920x1080
  rate 60.00
  x-prop-colorspace Default
  x-prop-max_bpc 16
  x-prop-non_desktop 0
  x-prop-scaling_mode None
  x-prop-tearfree auto
  x-prop-underscan off
  x-prop-underscan_hborder 0
  x-prop-underscan_vborder 0
# output HDMI-A-0 crtc 3 pos 0x465
  mode 1920x1080
  rate 60.00
    x-prop-colorspace Default
    x-prop-max_bpc 16
    x-prop-non_desktop 0
    x-prop-scaling_mode None
    x-prop-tearfree auto
    x-prop-underscan off
    x-prop-underscan_hborder 0
    x-prop-underscan_vborder 0
   */

/* 4screen / tv
# output DisplayPort-2 crtc 2 pos 5360x0
  mode 1920x1080
  rate 60.00
  rotate left
  x-prop-colorspace Default
  x-prop-max_bpc 16
  x-prop-non_desktop 0
  x-prop-scaling_mode None
  x-prop-tearfree auto
  x-prop-underscan off
  x-prop-underscan_hborder 0
  x-prop-underscan_vborder 0
# output DisplayPort-0 crtc 0 pos 1920x294
    mode 3440x1440
    primary
    rate 165.00
    x-prop-colorspace Default
    x-prop-max_bpc 16
    x-prop-non_desktop 0
    x-prop-scaling_mode None
    x-prop-tearfree auto
    x-prop-underscan off
    x-prop-underscan_hborder 0
    x-prop-underscan_vborder 0
# output DisplayPort-1 crtc 1 pos 0x465
    mode 1920x1080
    rate 60.00
    x-prop-colorspace Default
    x-prop-max_bpc 16
    x-prop-non_desktop 0
    x-prop-scaling_mode None
    x-prop-tearfree auto
    x-prop-underscan off
    x-prop-underscan_hborder 0
    x-prop-underscan_vborder 0
# output HDMI-A-0 crtc 3 pos 0x465
    mode 1920x1080
    rate 60.00
    x-prop-colorspace Default
    x-prop-max_bpc 16
    x-prop-non_desktop 0
    x-prop-scaling_mode None
    x-prop-tearfree auto
    x-prop-underscan off
    x-prop-underscan_hborder 0
    x-prop-underscan_vborder 0
 */



/*mons = {
  wide = {
    description = "";
    res = "3440x1440";
    hz = "165.00";
    output = "";
    identifier = ""
   };
  reg = {
    description = "";
    res = "1920x1080";
    hz = "60.00";
   };
  vert = {
    description = "";
    res = "1920x1080";
    hz = "60.00";
   };
  tv = {
    description = "";
    res = "1920x1080""60.00";
    hz = "60.00";
   };
 };
 */
xconf = ''
  Section "Monitor"
  Identifier "DP0"
  VendorName "samsung"
  EndSection
  Section "Monitor"
  Identifier "DP1"
  VendorName "asus"
  EndSection
  Section "Monitor"
  Identifier "DP2"
  VendorName "hp"
  EndSection
  Section "Monitor"
  Identifier "HDMI"
  ModelName "tv"
  EndSection
 '';
cfg = config.autorandr;
in
{
options.autorandr = {
  enable = mkEnableOption "";
  xrandrHeads = mkOption { default = false;
       type = types.bool;
     };
  # extraconf = mkEnableOption "";
  defaultProfile = mkOption { default = "def";
        type = types.str;
   };
  enableProfile = {
    "two" = mkEnableOption "";
    "def" = mkEnableOption "";
    "tv"  = mkEnableOption "";
    #"" = mkEnableOption "";
   };
};
config = mkIf cfg.enable {
services.autorandr.enable = true;
environment.etc."xprofile1".text = ''
  xrandr
  if [ $HOSTNAME == 'nixburk' ]; then
    autorandr ${cfg.defaultProfile} &
    fi
 '';
# services.xserver = lib.mkIf cfg.extraconf {extraConfig = mkAfter xconf;};
/**
   * The monitors will be mapped from left to right in the order of the list.
   *
   * By default, the first monitor will be set as the primary monitor if none of the elements contain an option that has set primary to true.
   */
services.xserver.xrandrHeads = mkIf cfg.xrandrHeads [
    "HDMI-A-0"
    {
      output = "";
      primary = true;
      monitorConfig = ''

       '';  /* Example:
        DisplaySize 408 306
        Option "DPMS" "false"
        Option \"Rotate\" \"left\"
       */
    }

   ];
services.autorandr.profiles.def = mkIf cfg.enableProfile."def" {
  inherit fingerprint;
  config = {
    inherit DisplayPort-0;
    inherit DisplayPort-1;
    inherit DisplayPort-2;
    HDMI-A-0.enable = false;
  };
 };
services.autorandr.profiles.tv = mkIf cfg.enableProfile."tv" {
  inherit fingerprint;
  config = {
    inherit DisplayPort-0; # wide.res; rate = mons.wide.hz; crtc = 0; position = "1920x0"; primary = true; };
    inherit DisplayPort-1; # reg.res; rate = mons.reg.hz ; crtc = 1; position = "0x0"; };
    inherit DisplayPort-2; # vert.res; rate = mons.vert.hz; rotate = "left"; crtc =  2; position = "5360x0"; };
    inherit HDMI-A-0;      # tv.res; rate = mons.tv.hz; crtc = 3; position = "0x0"; };
   };
 };
services.autorandr.profiles.two = mkIf cfg.enableProfile."two" { /*
  # output DisplayPort-1 off
  # output HDMI-A-0 off
  # output DisplayPort-2
  crtc 2
  pos 3440x0
  rotate left
    mode 1920x1080
    rate 60.00
    x-prop-colorspace Default
    x-prop-max_bpc 16
    x-prop-non_desktop 0
    x-prop-scaling_mode None
    x-prop-tearfree auto
    x-prop-underscan off
    x-prop-underscan_hborder 0
    x-prop-underscan_vborder 0
    # output DisplayPort-0
    crtc 0
    pos 0x240
    mode 3440x1440
    primary
    rate 165.00
    x-prop-colorspace Default
    x-prop-max_bpc 16
    x-prop-non_desktop 0
    x-prop-scaling_mode None
    x-prop-tearfree auto
    x-prop-underscan off
    x-prop-underscan_hborder 0
    x-prop-underscan_vborder 0
    */
    #
  inherit  fingerprint;
  config = {
    inherit DisplayPort-0;# = { enable = true;mode = mons.wide.res;rate = mons.wide.hz;crtc = 0;position = "0x240";primary = true;};
   #DisplayPort-0.position = "3440x0";
    inherit DisplayPort-2;# = { enable = true;mode = mons.vert.res;rate = mons.vert.hz;rotate = "left";crtc = 2;position = "3440x0";};
   #DisplayPort-2.position = "0x240";
    DisplayPort-1.enable = false;
    HDMI-A-0.enable = false;
   };
 };
# services.autorandr.profiles."korv" =      mkIf cfg.enableProfile.korv {};
};}
