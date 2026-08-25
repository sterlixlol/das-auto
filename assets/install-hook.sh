#!/usr/bin/env bash
# das-auto — register the ignition-sequence hook.
#
# Hand-editing settings.json is the step people get wrong: a stray comma
# breaks every hook, and a path that doesn't resolve fails silently — the
# hook simply never fires and there is nothing to see. This writes the entry
# for you, with the absolute path resolved from where this script actually
# lives, and backs the file up first.
#
#   ./install-hook.sh            register
#   ./install-hook.sh --remove   unregister
#   ./install-hook.sh --print    show the JSON without writing anything

set -euo pipefail

HOOK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/hook.sh"
SETTINGS="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json"
MODE="${1:-install}"

command -v python3 >/dev/null || { echo "python3 required"; exit 1; }
[ -f "$HOOK" ] || { echo "hook.sh not found next to this script"; exit 1; }
chmod +x "$HOOK" 2>/dev/null || true

python3 - "$HOOK" "$SETTINGS" "$MODE" <<'PY'
import json, os, shutil, sys, time

hook, settings, mode = sys.argv[1], sys.argv[2], sys.argv[3]
cmd = f'bash "{hook}"'

if mode == "--print":
    print(json.dumps({"hooks": {"UserPromptSubmit": [
        {"hooks": [{"type": "command", "command": cmd}]}]}}, indent=2))
    sys.exit(0)

data = {}
if os.path.exists(settings):
    try:
        with open(settings) as f:
            data = json.load(f)
    except json.JSONDecodeError as e:
        sys.exit(f"{settings} is not valid JSON ({e}); fix it before running this.")
    shutil.copy(settings, f"{settings}.bak-das-auto-{time.strftime('%Y%m%d-%H%M%S')}")
else:
    os.makedirs(os.path.dirname(settings), exist_ok=True)

entries = data.setdefault("hooks", {}).setdefault("UserPromptSubmit", [])
mine = [e for e in entries if "das-auto" in json.dumps(e)]

if mode == "--remove":
    if not mine:
        print("nothing to remove — no das-auto hook registered")
        sys.exit(0)
    data["hooks"]["UserPromptSubmit"] = [e for e in entries if e not in mine]
    if not data["hooks"]["UserPromptSubmit"]:
        del data["hooks"]["UserPromptSubmit"]
    if not data["hooks"]:
        del data["hooks"]
    verb = "removed"
else:
    if mine:
        # Re-point an existing entry rather than stacking duplicates, so
        # running this twice — or after moving the skill — is harmless.
        for e in mine:
            for h in e.get("hooks", []):
                if "das-auto" in h.get("command", ""):
                    h["command"] = cmd
        verb = "updated"
    else:
        entries.append({"hooks": [{"type": "command", "command": cmd}]})
        verb = "registered"

with open(settings, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")

print(f"{verb}: {cmd}")
print(f"wrote:  {settings}")
print("\nRestart Claude Code — hooks are loaded at session start.")
print("Undo:   ./install-hook.sh --remove")
PY
