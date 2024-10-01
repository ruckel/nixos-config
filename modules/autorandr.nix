let   monitors = {
    wide = {
      fingerprint = "00ffffffffffff004c2d1a71484c4e3010210104b55022783a0a7da6564f9f27114e54bfef8081c0810081809500a9c0b300714f01014ed470a0d0a0465030203a001e4e3100001a000000fd0832a51e0358000a202020202020000000fc004c433334473535540a20202020000000ff00484e54573430323130330a2020026302031cf147901f04131203402309070783010000e305c000e3060501023a801871382d40582c45001e4e3100001e565e00a0a0a02950302035001e4e3100001ae77c70a0d0a0295030203a001e4e3100001a5aa000a0a0a04650302035001e4e3100001a489680a0703829403020b8041e4e3100001a000000000000000000657012790000030128a25701886f0d9f002f801f009f0528001a000700a2030108ff099f002f801f009f0528001a000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e190";
      res = "3440x1440";
      hz = "165.00";
    };
    reg = {
      fingerprint = "00ffffffffffff0006b3da24aae70100181e010380341d782a4995a556529f270d5054bfef00d1c0b30095008180814081c0714f0101023a801871382d40582c450009252100001e000000ff004c364c4d54463132343834320a000000fd00324b185311000a202020202020000000fc00415355532056503234370a2020016902031a314f0102031112130414050e0f1d1e1f9065030c0010008c0ad08a20e02d10103e9600092521000018011d007251d01e206e28550009252100001e011d00bc52d01e20b828554009252100001e8c0ad090204031200c4055000925210000180000000000000000000000000000000000000000000000000000000000f3";
      res = "1920x1080";
      hz = "60.00";
    };
    vertical = {
      fingerprint = "00ffffffffffff0022f0793200000000111b0104a5331d7822c075a756529b260f5054210800d1c0a9c081c0b3009500810081800101023a801871382d40582c4500fd1e1100001e000000fd00323c1e5011010a202020202020000000fc00485020453233320a2020202020000000ff00434e34373137303557500a202000bc";
      res = "1920x1080";
      hz = "60.00";
    };
    tv = {
      fingerprint = "";
      res = "";
      hz = "";
    };
  };
  in
  {
  imports = [];

  services.autorandr = {
    enable = true;
    profiles = { 
      "3screen" = { 
        fingerprint = {
          DisplayPort-0 = monitors.wide.fingerprint;
          DisplayPort-1 = monitors.reg.fingerprint;
          DisplayPort-2 = monitors.vertical.fingerprint;
        };
        config = {  
          HDMI-A-0.enable = false;
          DisplayPort-0 = { 
            enable = true; 
            mode = monitors.wide.res; 
            rate = monitors.wide.hz;  
            crtc = 0; 
            position = "1920x294"; 
            primary = true; 
          };
          DisplayPort-1 = { 
            enable = true;
            mode = monitors.reg.hz;
            rate = monitors.reg.hz;  
            crtc = 1;
            position = "0x465";
          };
          DisplayPort-2 = { 
            enable = true;
            mode = monitors.vertical.res;
            rate = monitors.vertical.hz; 
            rotate = "left";
            crtc =  2;
            position = "5360x0";
          }; 
        }; 
        };
      "2screen" = { 
        fingerprint = { 
          DisplayPort-0 = monitors.wide.fingerprint;
          DisplayPort-1 = monitors.reg.fingerprint;
          DisplayPort-2 = monitors.vertical.fingerprint;
        };
        config = {  
          HDMI-A-0.enable = false; 
          DisplayPort-1.enable = false;
          DisplayPort-0 = { 
            enable = true; 
            mode = monitors.wide.res; 
            rate = monitors.wide.hz;  
            crtc = 0;
            position = "0x240";
            primary = true;
          };
          DisplayPort-2 = { 
            enable = true;
            mode = monitors.vertical.res;
            rate = monitors.vertical.hz; 
            rotate = "left";
            crtc = 2;
            position = "3440x0";
          }; 
        }; 
      };
    };
  };
}