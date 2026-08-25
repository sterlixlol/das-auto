#!/usr/bin/env python3
"""Work out where to draw, without assuming a particular terminal.

Emits shell-eval'able KEY=VALUE lines:

    MODE=kitty|tmux|blind|sound
    TTY=/dev/pts/N        PID=<owner>       COLS=<n>  ROWS=<n>
    RULE_TOP=<row>        RULE_BOT=<row>    (absent in sound mode)

The animation needs four things, and only one of them is terminal-specific:

  pts          walk /proc/<pid>/fd up the parent chain — a hook has no
               controlling terminal, so /dev/tty is unreachable
  geometry     TIOCGWINSZ on that pts
  repaint      SIGWINCH to the process that owns it
  screen text  the hard one. kitty has `get-text`, tmux has `capture-pane`,
               and nothing else offers a portable way to read the screen

Without screen text the prompt-box rules can't be located, and painting rows
blind risks scribbling over a terminal we never read. That degrades to sound
unless DAS_AUTO_BLIND=1 says otherwise.
"""

import fcntl
import os
import re
import struct
import subprocess
import sys
import termios


def ppid_of(pid):
    try:
        with open(f"/proc/{pid}/stat") as f:
            return int(f.read().rsplit(") ", 1)[1].split()[1])
    except Exception:
        return 0


def find_tty(start):
    """Nearest ancestor holding a pts, and the pid that holds it."""
    pid, hops = start, 0
    while pid > 1 and hops < 16:
        for fd in (0, 1, 2):
            try:
                link = os.readlink(f"/proc/{pid}/fd/{fd}")
            except OSError:
                continue
            if link.startswith("/dev/pts/"):
                return link, pid
        pid = ppid_of(pid)
        hops += 1
    return None, None


def geometry(tty):
    try:
        fd = os.open(tty, os.O_RDONLY | os.O_NOCTTY)
    except OSError:
        return None, None
    try:
        cols, rows = 0, 0
        ws = fcntl.ioctl(fd, termios.TIOCGWINSZ, struct.pack("HHHH", 0, 0, 0, 0))
        rows, cols, _, _ = struct.unpack("HHHH", ws)
        return (cols or None), (rows or None)
    except OSError:
        return None, None
    finally:
        os.close(fd)


def screen_text():
    """(text, mode) — however this terminal will let us read itself."""
    sock, win = os.environ.get("KITTY_LISTEN_ON"), os.environ.get("KITTY_WINDOW_ID")
    if sock and win:
        try:
            out = subprocess.run(
                ["kitten", "@", "--to", sock, "get-text", "--extent=screen"],
                capture_output=True, text=True, timeout=4)
            if out.returncode == 0 and out.stdout:
                return out.stdout, "kitty"
        except Exception:
            pass

    if os.environ.get("TMUX"):
        try:
            out = subprocess.run(["tmux", "capture-pane", "-p"],
                                 capture_output=True, text=True, timeout=4)
            if out.returncode == 0 and out.stdout:
                return out.stdout, "tmux"
        except Exception:
            pass

    return None, None


def find_rules(text, cols):
    """Last two rows that are essentially a solid run of ─."""
    threshold = max(20, cols // 3)
    hits = [i + 1 for i, line in enumerate(text.split("\n"))
            if line.count("─") > threshold]
    return (hits[-2], hits[-1]) if len(hits) >= 2 else (None, None)


def emit(**kw):
    for k, v in kw.items():
        if v is not None:
            print(f"{k}={v}")


def main():
    start = int(sys.argv[1]) if len(sys.argv) > 1 else os.getppid()

    tty = os.environ.get("DAS_AUTO_TTY")
    pid = os.environ.get("DAS_AUTO_PID")
    if not tty:
        tty, pid = find_tty(start)
    if not tty or not os.access(tty, os.W_OK):
        emit(MODE="sound")
        return

    cols, rows = geometry(tty)
    if not cols or not rows:
        emit(MODE="sound")
        return

    text, mode = screen_text()
    if text:
        top, bot = find_rules(text, cols)
        if top and bot:
            emit(MODE=mode, TTY=tty, PID=pid or "", COLS=cols, ROWS=rows,
                 RULE_TOP=top, RULE_BOT=bot)
            return

    # No readable screen. Guessing which rows hold the prompt box means
    # painting over content we never looked at, so it stays opt-in.
    if os.environ.get("DAS_AUTO_BLIND") == "1" and rows > 6:
        emit(MODE="blind", TTY=tty, PID=pid or "", COLS=cols, ROWS=rows,
             RULE_TOP=rows - 3, RULE_BOT=rows - 1)
        return

    emit(MODE="sound")


if __name__ == "__main__":
    main()
