#!/bin/sh

dwm_idletime() {
	printf  "%s" "$(xprintidle -H)"
	printf " %s" "[$(xprintidle)]"
}
dwm_idletime
