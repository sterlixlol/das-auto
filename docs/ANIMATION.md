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
  `/dev/tty` is unreachable; kitty's remote control is asked which device backs
  the window.
- **One `printf` per frame, inside synchronized output (DEC 2026).** Per-cell
  writes race Claude's own repaint and tear badly.
- **Everything is eased.** Cubic ease-out on entry, ease-in on exit, ease-in-out
  on the glimmer. Linear motion reads as mechanical.
- **It never takes the whole screen.** An early version used the alternate
  screen buffer and blanked everything — much too much for a 1.2-second joke.

**Requirements.**

| | |
|---|---|
| **Linux** | The animation resolves your terminal through `/proc` and `/dev/pts`. macOS and Windows have neither, so nothing fires there. |
| **Binaries** | `bash` · `python3` · `awk` · `setsid` · `seq` — plus `pw-play`, `paplay` or `aplay` for sound |
| **Jingle swapping** | `ffmpeg` and `ffprobe`, for `install-sound.sh` only |
| **[kitty](https://sw.kovidgoyal.net/kitty/)** | with remote control on — and **fully quit and reopened** afterwards, since the socket opens at startup and a config reload won't do it |

```
allow_remote_control socket-only
listen_on unix:/tmp/kitty-{kitty_pid}
```

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

