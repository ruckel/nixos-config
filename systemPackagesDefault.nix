{ pkgs, ... } : { 
imports = [ 
  /home/korv/.config/packages.nix
  ./gnomeExtensions.nix 
];
environment.systemPackages = with pkgs; [
betterbird
brave
caprine-bin
chawan
discord
endeavour
gh
ghostwriter
gimp
git
gnome-browser-connector
gnome.dconf-editor #gui
helvum
keepassxc
libreoffice
lsof
mdp
media-downloader
menulibre #gui menu editor
mpv
mullvad-vpn
nextcloud-client
nomacs
obs-studio
obsidian
openshot-qt
pinta
playerctl
python312Packages.qrcode
python313Full
python39Full
scrcpy
signal-desktop
simplex-chat-desktop
spotify
super-productivity
syncthing
toastify
transmission
tuxguitar
veracrypt
vlc
];}
