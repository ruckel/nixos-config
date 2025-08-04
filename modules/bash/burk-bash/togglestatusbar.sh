#!/usr/bin/env bash
DCONF_PATH=/org/gnome/shell/extensions/just-perfection/panel
CURRENT_SETTING=$(dconf read $DCONF_PATH)
#echo -e "CURRENT_SETTING:$CURRENT_SETTING¦"
if [[ $CURRENT_SETTING == 'false'  ]]; then
  dconf write $DCONF_PATH true && echo "status bar on"
else
  dconf write $DCONF_PATH false && echo "status bar off"
fi
