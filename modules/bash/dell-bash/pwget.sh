#!/bin/sh
ENTRY=bash
if [[ $1 != '' ]];then ENTRY=$1;fi
keepassxc-cli show \
-a password \
-k ~/keepAss.key \
#--no-password \
/home/${USER}/st/keepAss/pckeyfile.kdbx \
$ENTRY
