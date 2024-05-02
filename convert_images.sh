#!/bin/bash
SVG_INPUT=$1
OUTPUT=$2

if [[ -z $OUTPUT ]]; then
  OUTPUT="output.png"
fi

echo "This script converts a svg to png, removes background and inverts it."

if [[ -z $(command -v inkscape) && -z $(command -v convert) ]]; then
  echo "Inkscape and ImageMagick required, exiting..."
  exit 1
fi

inkscape $SVG_INPUT -o $OUTPUT -d 600
convert $OUTPUT -fuzz 100 -transparent white $OUTPUT
convert $OUTPUT -channel RGBA -negate $OUTPUT

echo "Image generated: $OUTPUT"