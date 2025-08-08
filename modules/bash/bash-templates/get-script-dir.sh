#!/usr/bin/env bash

symlink_path="$0"
symlink_abs_path="$(realpath "$0")"
symlink_name="$(basename "$0")"
symlink_dir="$(dirname "$symlink_abs_path")"
script_path="$(readlink -f "$0")"
script_name="$(basename "$script_path")"
script_dir="$(dirname "$script_path")"

echo "Symlink path:       $symlink_path"
echo "Symlink abs path:   $symlink_abs_path"
echo "Symlink name:       $symlink_name"
echo "Symlink directory:  $symlink_dir"
echo "Resolved real path: $script_path"
echo "Resolved real name: $script_name"
echo "Real directory:     $script_dir"
