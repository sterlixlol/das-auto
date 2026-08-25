#!/bin/bash
# das-auto — install a jingle. Takes any audio file (mp3, m4a, ogg, webm, wav,
# or a video container) and produces the trimmed, level-matched wav the intro
# plays. Keeps the previous jingle as dasauto.prev.wav so a bad take is one
# move from undone.
#
#   ./install-sound.sh ~/Downloads/das-auto.mp3

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${1:-}"
OUT="$DIR/dasauto.wav"

[ -n "$SRC" ] || { echo "usage: install-sound.sh <audio-file>"; exit 1; }
[ -f "$SRC" ] || { echo "no such file: $SRC"; exit 1; }

command -v ffmpeg >/dev/null || { echo "ffmpeg not found"; exit 1; }

[ -f "$OUT" ] && cp "$OUT" "$DIR/dasauto.prev.wav"

# Trim leading/trailing silence, normalise loudness so it doesn't blow the
# user's ears off relative to system volume, resample to a safe rate.
ffmpeg -hide_banner -loglevel error -y -i "$SRC" \
  -af "silenceremove=start_periods=1:start_silence=0.05:start_threshold=-45dB,areverse,silenceremove=start_periods=1:start_silence=0.05:start_threshold=-45dB,areverse,loudnorm=I=-16:TP=-1.5:LRA=11" \
  -ac 2 -ar 48000 "$OUT"

DUR=$(ffprobe -hide_banner -loglevel quiet -show_entries format=duration -of csv=p=0 "$OUT")
printf '%s' "$DUR" > "$DIR/dasauto.dur"
printf 'installed: %s\nduration:  %.2fs\n' "$OUT" "$DUR"

if command -v pw-play >/dev/null 2>&1; then
  echo "playing back…"
  pw-play "$OUT" 2>/dev/null || true
fi

echo "revert: mv \"$DIR/dasauto.prev.wav\" \"$OUT\""
