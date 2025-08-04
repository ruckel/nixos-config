#!/bin/sh
INPUT="$@"
echo -e "chromium --new-window \"https://regex-generator.olafneumann.org/?sampleText=$@\""
chromium --new-window "https://regex-generator.olafneumann.org/?sampleText=$INPUT"
