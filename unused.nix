  #printing.enable = true; #CUPS
  #keyd.enable = true;
  #keyd.keyboards = {
    #default = { # name does not really matter
      #ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
      #settings = { # Everything but the ID section
        #main = {  # The main layer, if you choose to declare it in Nix
          ##capslock = "layer(control)"; # you might need to also enclose the key in quotes if it contains non-alphabetical symbols
          #scrolllock = "`";
  #};};};};


# networking.wireless.enable = true;  #wireless via wpa_supplicant.
# networking.proxy.default = "http://user:password@proxy:port/";   #network proxy
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";#network proxy



  #libinput.enable = true;  #touchpad support

