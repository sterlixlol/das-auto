#!/usr/bin/env bash
# das-auto — self test.
#
# Exists because of a real bug: probe.py learned to detect Konsole, the
# animation's allow-list was never updated to accept it, and the result was a
# jingle with no animation on every Konsole in the world. Nothing caught it
# because the two files agree in every other respect.
#
#   ./selftest.sh          run the checks
#
# Exits non-zero if anything fails.

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fail=0
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$1"; fail=1; }

echo "modes"
# Every mode probe.py can emit must be one intro-band.sh will act on.
probe_modes=$(grep -oE 'return [a-z_.]+, "[a-z]+"' "$DIR/probe.py" \
              | grep -oE '"[a-z]+"' | tr -d '"' | sort -u)
probe_modes="$probe_modes blind"
accepted=$(grep -oE '^\s+[a-z|]+\) : ;;' "$DIR/intro-band.sh" | tr -d ' );:' )
for m in $probe_modes; do
  if printf '%s' "$accepted" | tr '|' '\n' | grep -qx "$m"; then
    ok "probe emits '$m' and the animation accepts it"
  else
    bad "probe emits '$m' but the animation IGNORES it — jingle, no visual"
  fi
done

echo "syntax"
for f in "$DIR"/*.sh; do
  bash -n "$f" 2>/dev/null && ok "$(basename "$f")" || bad "$(basename "$f") has a syntax error"
done
python3 -c "import ast,sys; ast.parse(open('$DIR/probe.py').read())" 2>/dev/null \
  && ok "probe.py" || bad "probe.py does not parse"

echo "hook gating"
fire() {
  printf '{"prompt":%s}' "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1]))' "$1")" \
  | grep -qE 'das-auto' && \
  printf '{"prompt":%s}' "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1]))' "$1")" \
  | python3 -c 'import json,re,sys
try: p=json.load(sys.stdin).get("prompt","")
except Exception: sys.exit(1)
sys.exit(0 if re.match(r"\s*/das-auto\b", p) else 1)'
}
fire "/das-auto"                         && ok "bare command fires"       || bad "bare command does NOT fire"
fire "/das-auto finish the site"         && ok "command with args fires"  || bad "command with args does not fire"
fire "please explain /das-auto to me"    && bad "a mention fires — it should not" || ok "a mention stays quiet"
fire "$(cat "$DIR/../SKILL.md" 2>/dev/null | head -200)" \
    && bad "the skill body fires — that is the double-jingle bug" \
    || ok "the skill body stays quiet"

echo "assets"
for f in dasauto.wav logo.png intro-band.sh hook.sh probe.py; do
  [ -e "$DIR/$f" ] && ok "$f present" || bad "$f MISSING"
done
[ -s "$DIR/dasauto.dur" ] && ok "jingle duration cached" || bad "dasauto.dur missing — animation cannot re-time"

echo
[ "$fail" -eq 0 ] && echo "all good" || echo "FAILURES above"
exit "$fail"
