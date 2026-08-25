#!/bin/bash
# das-auto — UserPromptSubmit hook.
#
# Runs on EVERY prompt, so the common path must be near-free: one grep that
# rejects anything without the string at all, and only then a real JSON parse.
#
# Two things this gets right the hard way:
#
# 1. The match is ANCHORED to the start of the prompt. Claude Code only
#    recognizes a slash command at the start of a message anyway, so matching
#    anywhere buys nothing — and it costs a great deal: invoking the command
#    submits both the raw text and the expanded skill body, and the skill body
#    quotes "/das-auto" in six worked examples. An unanchored match fires on
#    both and plays the jingle twice.
#
# 2. A debounce lock, because #1 is a fix for the duplicate path I could see.
#    Any second trigger within DEBOUNCE seconds is dropped, so a duplicate
#    event from somewhere else can't double up either.

DEBOUNCE=5

PAYLOAD=$(cat)

# Fast reject: no occurrence at all, nothing to do.
printf '%s' "$PAYLOAD" | grep -q 'das-auto' || exit 0

# Precise check on the prompt field only — the payload also carries cwd and
# session paths, which contain "das-auto" for anyone who installed it there.
printf '%s' "$PAYLOAD" | python3 -c '
import json, re, sys
try:
    prompt = json.load(sys.stdin).get("prompt", "")
except Exception:
    sys.exit(1)
sys.exit(0 if re.match(r"\s*/das-auto\b", prompt) else 1)
' || exit 0

LOCK="${TMPDIR:-/tmp}/.das-auto-fired-$(id -u)"
NOW=$(date +%s)
if [ -f "$LOCK" ]; then
  LAST=$(cat "$LOCK" 2>/dev/null || echo 0)
  case "$LAST" in ''|*[!0-9]*) LAST=0 ;; esac
  [ $(( NOW - LAST )) -lt "$DEBOUNCE" ] && exit 0
fi
printf '%s' "$NOW" > "$LOCK"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve the terminal HERE, while this process still has the agent as an
# ancestor. setsid detaches the animation into its own session, so by the
# time it runs the parent chain no longer leads anywhere.
eval "$(python3 "$DIR/probe.py" $$ 2>/dev/null | grep -E '^(TTY|PID)=')"
DAS_AUTO_TTY="${TTY:-}" DAS_AUTO_PID="${PID:-}" \
  setsid bash "$DIR/intro-band.sh" >/dev/null 2>&1 < /dev/null &

exit 0
