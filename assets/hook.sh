#!/bin/bash
# das-auto — UserPromptSubmit hook.
#
# Runs on EVERY prompt, so the common path must be near-free: one grep that
# rejects anything without the string at all, and only then a real JSON parse.
#
# Matching is deliberately loose about POSITION. The command is normally typed
# at the END of a sentence — "I have to leave now! Continue without me.
# /das-auto" — which is how every example in the skill reads. An earlier
# version anchored to the start of the prompt to avoid firing when someone
# merely mentioned the command; that silenced the primary use case entirely.
# An extra jingle when discussing it is a far cheaper mistake than the command
# not working when invoked.

PAYLOAD=$(cat)

# Fast reject: no occurrence anywhere, nothing to do. Keeps the cost of the
# 99.9% case down to a single grep.
printf '%s' "$PAYLOAD" | grep -q 'das-auto' || exit 0

# Precise check on the prompt field only — the payload also carries cwd and
# session paths, which contain "das-auto" for anyone who installed it there.
printf '%s' "$PAYLOAD" | python3 -c '
import json, re, sys
try:
    prompt = json.load(sys.stdin).get("prompt", "")
except Exception:
    sys.exit(1)
sys.exit(0 if re.search(r"(?:^|\s)/das-auto\b", prompt) else 1)
' || exit 0

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
setsid bash "$DIR/intro-band.sh" >/dev/null 2>&1 < /dev/null &

exit 0
