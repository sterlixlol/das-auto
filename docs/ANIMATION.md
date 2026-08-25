# The ignition sequence

Because a skill this dramatic deserved a jingle.

Typing `/das-auto` plays the voice line and animates the two `─` rules that
sandwich your prompt box: **DAS** rides in along the top rule from the left,
**AUTO** along the bottom from the right, a glimmer travels down both, then the
orange cools back to the rules' normal grey as the words carry on out the far
sides.

Details that turned out to matter:

- **The rules move.** Your prompt box grows as you type, so their rows shift.
  Every run locates them from the screen contents rather than assuming a row.
- **It writes to the pts directly.** A hook has no controlling terminal, so
  `/dev/tty` is unreachable. `probe.py` walks `/proc/<pid>/fd` up the parent
  chain to find one, which also yields the pid to `SIGWINCH` for the repaint.
  The hook does that resolution *before* `setsid` detaches the animation —
  afterwards the parent chain leads nowhere.
- **One `printf` per frame, inside synchronized output (DEC 2026).** Per-cell
  writes race Claude's own repaint and tear badly.
- **Everything is eased.** Cubic ease-out on entry, ease-in on exit, ease-in-out
  on the glimmer. Linear motion reads as mechanical.
- **It never takes the whole screen.** An early version used the alternate
  screen buffer and blanked everything — much too much for a 1.2-second joke.

**Requirements.** Linux — it finds your terminal through `/proc` and
`/dev/pts`, which macOS and Windows don't have. Plus `bash`, `python3`, `awk`,
`setsid`, `seq`, and one of `pw-play` / `paplay` / `aplay` for sound.
`install-sound.sh` also wants `ffmpeg` and `ffprobe`.

## Terminal support

Four things are needed, and only one is terminal-specific:

| Need | How |
|---|---|
| Find the pts | walk `/proc/<pid>/fd/{0,1,2}` up the parent chain |
| Geometry | `TIOCGWINSZ` ioctl on the pts |
| Force a repaint | `SIGWINCH` to the process that owns it |
| **Read the screen** | **kitty `get-text`, Konsole `getAllDisplayedText` over D-Bus, or tmux `capture-pane` — nothing portable** |

| Terminal | What you get |
|---|---|
| **kitty** | Full animation. Remote control on, and kitty **fully restarted** afterwards — the socket opens at startup, so a config reload won't do it. |
| **Konsole** | Full animation, via its D-Bus `getAllDisplayedText`. Nothing to configure; needs `qdbus`. |
| **tmux** | Full animation via `capture-pane`, in any terminal. Nothing to configure. |
| **Alacritty, others** | Jingle only — Alacritty's IPC does `create-window` and config, with no way to read the screen. Run tmux inside it for the full thing, or set `DAS_AUTO_BLIND=1` to animate the bottom rows on a guess. |

The rules that sandwich your prompt box move as the box grows, so they're
located per run by reading the screen. With no way to read it the choice is
guess or stop — and guessing means painting over rows nobody looked at, so it
stops and plays the jingle instead.

`probe.py` reports what it picked:

```bash
python3 assets/probe.py
# MODE=kitty TTY=/dev/pts/2 PID=230779 COLS=211 ROWS=51 RULE_TOP=46 RULE_BOT=48
```

kitty setup, if that's your terminal:

Miss any of it and the visual is impossible — no pts, no rule detection — so
it falls back to playing the sound alone. Half the joke beats none. On macOS,
where neither the pts lookup nor those audio players exist, nothing fires.

### Swapping the jingle

```bash
~/.claude/skills/das-auto/assets/install-sound.sh <any-audio-or-video-file>
```

Trims silence, normalizes loudness, caches the duration so the animation
re-times itself to whatever you install.

`assets/preview.sh` replays the sequence without a real invocation, useful
while tuning. Every knob (colors, glimmer profile, frame counts, easing) sits
in clearly marked constants at the top of `assets/intro-band.sh`.

### Why the dump gets checked against the geometry

Terminal variables are inherited. Launch Konsole from kitty and the Konsole
still carries `KITTY_LISTEN_ON`, so asking "are we in kitty?" answers yes and
returns *kitty's* screen — which is how an early version put the rules at row
46 of a 28-row window. Every dump is now checked against the size measured off
our own pts, and rules landing outside the window are rejected.
