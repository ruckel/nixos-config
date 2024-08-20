#!/bin/sh
nix-env -qaP --description > ~/scripts/nix/storeresult.txt && alert
