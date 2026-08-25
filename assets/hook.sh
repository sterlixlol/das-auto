#!/bin/bash
# das-auto — UserPromptSubmit hook.
#
# Runs on EVERY prompt, so the non-matching path must be as close to free as
# possible: read stdin, one grep, exit. Only a literal /das-auto invocation
# fires the ignition sequence, and it fires detached so nothing waits on it.

PAYLOAD=$(cat)

printf '%s' "$PAYLOAD" | grep -qE '"prompt"[[:space:]]*:[[:space:]]*"[[:space:]]*/das-auto' || exit 0

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
setsid bash "$DIR/intro-band.sh" >/dev/null 2>&1 < /dev/null &

exit 0
