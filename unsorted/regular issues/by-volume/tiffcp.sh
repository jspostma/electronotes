#!/usr/bin/env bash

voldir="$1"
for f in "$voldir"/*; do
  if [[ -d "$f" ]]; then
    fname="$(basename "$f").tiff"
    if [[ -d "$f/pages" ]]; then
      tiffcp "$f"/pages/*.tif "$f/$fname"
    fi
  fi
done
