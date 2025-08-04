#!/usr/bin/env bash

: <<'END_COMMENT'
--image $HOME/files/pictures/locked.png --tiling \
--no-unlock-indicator \
--ignore-empty-password \
--show-failed-attempts \
END_COMMENT

i3lock \
--ignore-empty-password \
--show-failed-attempts \
--color=000000
