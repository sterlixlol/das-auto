#!/bin/bash
# Replay the ignition sequence without waiting for a real /das-auto.
#   ./preview.sh        play once
#   ./preview.sh 3      play three times, 2s apart
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
N="${1:-1}"
for (( i=0; i<N; i++ )); do
  sleep 2
  setsid bash ./intro-band.sh >/dev/null 2>&1 < /dev/null &
  sleep 4
done
