#!/bin/bash

function generate_linux_icon() {
  outer_dim=$1
  inner_dim=$(($outer_dim * 3 / 4))

  foreground_temp="linux/icon_foreground_temp.png"
  output_folder="linux/${outer_dim}x${outer_dim}/apps"

  mkdir -p $output_folder

  # Export foreground image at a given size
  inkscape icon_foreground_noborder.svg --export-height=$inner_dim --export-filename=$foreground_temp

  # Extend output to padded square image
  convert $foreground_temp -background none -gravity center -extent ${outer_dim}x${outer_dim} "$output_folder/finamp.png"

  # Clean up
  rm $foreground_temp
}

# Generate Linux icons for various sizes
for dim in 16 32 48 64 128 256 384 512 1024; do
  generate_linux_icon $dim
done