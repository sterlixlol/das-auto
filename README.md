<h1 align="center">
  <img src="assets/logo.png" width="150" alt=""><br>
  Das Auto
</h1>

<p align="center"><em>A Claude Code skill for the moment you walk away.</em></p>


You're mid-session. The work isn't done. You have to leave. You type:

```
I have to leave now! Continue autonomously without me. /das-auto
```

Most agents, handed that, finish the literal task and stop. This one is meant
to pick up the thing you mentioned but never assigned, go looking for tools
nobody told it about, and know which actions aren't its to take while you're
unreachable.

## The idea

Autonomy isn't "work harder." It's **causal chaining** — asking of every tool,
asset and action what it knocks over two, three, five steps downstream.

An agent without that pattern sees *translate the pages* and translates the
pages. An agent with it sees: translations exist → they need a quality check →
I can't audit my own writing for my own blind spots → a differently-trained
model can → is one installed on this machine? → **go look.**

That last step is the whole skill. Nobody told it to look. The chain did.

## The five phases

| Phase | What happens |
|---|---|
| **HARVEST** | Re-read the session for everything said but never assigned — "I still need to…", "I keep forgetting to…". Those are work items, not small talk. |
| **INVENTORY** | Probe the machine for capabilities: other AI CLIs and whether they're authenticated, logged-in browser sessions, idle hardware, other boxes — *and its own skill/plugin loadout*. Then chain each one forward. |
| **LEDGER** | Classify every invented action by blast radius before doing any of it. |
| **WORK** | Execute like an owner: incremental saves, quality loops that run until two passes find nothing, reviewers that aren't itself. |
| **REPORT** | A fixed contract you can trust without redoing the work. |

### The ledger is the important part

Removing the ceiling on autonomous action also removes it on autonomous
mistakes. So every action gets classified:

**GREEN — do it, don't hesitate** when all hold: reversible *and* the undo is
written down; stays on your machines and accounts *and* nobody outside can
observe the effect; touches only your data; spends nothing (a CLI it just
discovered counts as spending until it has checked how that bills).

**STAGED — carry to the last inch, then stop** when any hold: irreversible;
a third-party human is on the receiving end; over an approved cap.

Staging isn't skipping. The deploy is built and verified with the command
written out. The message to your client is drafted with its destination named
— never typed into a live compose box, because a compose box where one stray
keystroke sends it isn't staging, it's a loaded gun on the table. You come
back, read, and fire each one in seconds, with the judgment call still yours.

### The report contract

```
<Complete | Parked | Blocked>. While you were out, here's what I did:
- <action> — <why, if nobody assigned it>

INVENTORY: <what the machine had> — <what each unlocked, or "nothing this time">
VERIFIED:  <claim> — <the evidence: command output, screenshot, test run>
ASSUMED:   <claim> — <why it couldn't be confirmed>
STAGED:    <action> — <where it sits> — <exact command / button>
MONEY:     <spend, with the arithmetic> · <everything stopped: verified how>
NOT DONE:  <item> — <reason> — <what unblocks it>
```

Nothing floats between VERIFIED and ASSUMED. Work it couldn't check — a
language it doesn't read, a device it can't see — is ASSUMED however confident
it feels, and saying so is the honest half of the job.

## How it was built

Following [superpowers](https://github.com/anthropics/claude-plugins-official)'
`writing-skills` methodology — TDD for documentation. Baselines were run
*without* the skill first, to see what an agent actually does unprompted,
before a word of it was written.

**Baseline, no skill:** did the assigned task, fixed the bugs it tripped over,
wrote a decent report. Zero machine inventory. No external review. Judgment
calls delivered as paragraphs recommending work *you* would then have to do.

**With the skill:** probed the box, found `codex` and `agy` authenticated, ran
them as domain-matched reviewers, then *rejected several of their findings with
reasons* rather than obeying them. Negative-tested its own test harness. Pixel-
diffed to prove the approved design hadn't shifted. Staged the third-party
message instead of sending it.

**Over-action pressure test** — the direction that can actually hurt you. Four
traps, each phrased as a near-authorization: a DNS cutover on a *live* site
("point it at the new host once you're happy"), a message to a client waiting
on news ("just let him know when it's done"), a metered CLI dressed as a local
tool, and a delete framed as cleanup ("that old folder is probably junk").

**All four held**, scored against the filesystem rather than the agent's own
report. It also read the metered tool's source, found it never opened the file
it was passed, and substituted a free reviewer.

An independent audit by a different model then caught a real bug: the GREEN
predicate had an `or` where an `and` belonged, which classified `rm -rf` on
your own machine as safe. Fixed.

## Install

```bash
git clone https://github.com/sterlixlol/das-auto ~/.claude/skills/das-auto
```

The skill works on its own from there. For the ignition sequence, register the
hook:

```bash
~/.claude/skills/das-auto/assets/install-hook.sh
```

It resolves the absolute path itself, backs up `settings.json`, leaves your
other hooks alone, and is safe to run twice. `--remove` unregisters it;
`--print` shows the JSON without writing anything.

Restart Claude Code afterwards — hooks are loaded at session start.

## The ignition sequence

Because a skill this dramatic deserved a jingle.

Typing `/das-auto` plays the voice line and animates the two `─` rules that
sandwich your prompt box: **DAS** rides in along the top rule from the left,
**AUTO** along the bottom from the right, a glimmer travels down both, then the
orange cools back to the rules' normal grey as the words carry on out the far
sides.

Details that turned out to matter:

- **The rules are found, not hardcoded.** Your prompt box grows as you type, so
  their rows move. Every run locates them from the actual screen contents.
- **It writes to the pts directly.** A hook has no controlling terminal, so
  `/dev/tty` is unreachable; kitty's remote control is asked which device backs
  the window.
- **One `printf` per frame, inside synchronized output (DEC 2026).** Per-cell
  writes race Claude's own repaint and tear badly.
- **Everything is eased.** Cubic ease-out on entry, ease-in on exit, ease-in-out
  on the glimmer. Linear motion reads as mechanical.
- **It never takes the whole screen.** An early version used the alternate
  screen buffer and blanked everything — much too much for a 1.2-second joke.

Requires [kitty](https://sw.kovidgoyal.net/kitty/) with remote control enabled:

```
allow_remote_control socket-only
listen_on unix:/tmp/kitty-{kitty_pid}
```

Without it the visual is impossible — no pts, no rule detection — so it plays
the sound and skips the animation. Half the joke beats none.

### Swapping the jingle

```bash
assets/install-sound.sh <any-audio-or-video-file>
```

Trims silence, normalizes loudness, caches the duration so the animation
re-times itself to whatever you install.

`assets/preview.sh` replays the sequence without a real invocation — useful
while tuning. Every knob (colors, glimmer profile, frame counts, easing) sits
in clearly marked constants at the top of `assets/intro-band.sh`.

## Notes

The skill runs heavy — expect a lot of tokens on a real handoff. That's the
intended profile for a job you're leaving for hours, not a quick question.

The Volkswagen roundel is a bit, not an endorsement, affiliation, or claim on
anyone's marks.

## License

MIT — see [LICENSE](LICENSE).
