#!/usr/bin/env bash

symlink_path="$0"
symlink_abs_path="$(realpath "$0")"
symlink_name="$(basename "$0")"
symlink_dir="$(dirname "$symlink_abs_path")"
real_script_path="$(readlink -f "$0")"
real_script_name="$(basename "$real_script_path")"
real_script_dir="$(dirname "$real_script_path")"

echo "Symlink path:       $symlink_path"
echo "Symlink abs path:   $symlink_abs_path"
echo "Symlink name:       $symlink_name"
echo "Symlink directory:  $symlink_dir"
echo "Resolved real path: $real_script_path"
echo "Resolved real name: $real_script_name"
echo "Real directory:     $real_script_dir"
