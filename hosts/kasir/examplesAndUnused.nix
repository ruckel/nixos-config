{


services.mullvad-vpn.enable = true;

nixpkgs.config = {
  allowUnfree = true;
  permittedInsecurePackages = [
    #"python3.11-youtube-dl-2021.12.17"
  ];
};
}
