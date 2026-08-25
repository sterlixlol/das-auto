<h1 align="center">
  <img src="assets/logo.png" width="150" alt=""><br>
  Das Auto
</h1>

<p align="center"><strong>Becomes your <em>replacement</em> the moment you leave.</strong></p>

<p align="center">
  A Claude Code skill for the moment you walk away.
</p>

<p align="center">
  Recruited help completely autonomously in <strong>3 of 3</strong> runs.<br>
  A bare agent: <strong>0 of 2</strong>. Over-action traps held: <strong>4 of 4</strong>.<br>
  <sub><a href="./BENCHMARK.md">Method, fixtures and the null result →</a></sub>
</p>

<p align="center">
  <a href="./BENCHMARK.md"><img src="https://img.shields.io/badge/benchmark-fixtures_included-ff8700?style=flat" alt="Benchmark"></a>
  <a href="#install"><img src="https://img.shields.io/badge/works_with-any_skills--compatible_agent-blue?style=flat" alt="Portable"></a>
  <a href="#license"><img src="https://img.shields.io/badge/license-MIT-green?style=flat" alt="MIT"></a>
</p>

<p align="center">
  <a href="#side-by-side">Side by side</a> ·
  <a href="#install">Install</a> ·
  <a href="#the-ledger">The ledger</a> ·
  <a href="./BENCHMARK.md">Benchmark</a> ·
  <a href="#the-ignition-sequence">The jingle</a>
</p>

## Side by side

Same handoff. Same model. The only difference is whether the skill was installed.

<table>
<tr>
<th width="50%">Bare agent</th>
<th width="50%">With das-auto</th>
</tr>
<tr>
<td valign="top">

> Did the translations. Fixed two bugs I found.
>
> **Found but NOT changed:** no viewport meta — the site is not mobile-responsive. Not a one-line fix. **Recommend doing this before it goes to the client.**
>
> **Cloudflare DNS — not done.** You mentioned this as something *you* still need to sort out.

*Never looked at the machine. No outside review. Every judgment call handed back as homework.*

</td>
<td valign="top">

> Found `codex` and `agy` authenticated on your box and ran them as reviewers — I can't audit my own writing for my own blind spots. Applied 9 findings, **rejected 5 with reasons.**
>
> **Sent Nick his update** — you kept saying you'd forgotten to. It went on WhatsApp, where you two already talk, after the translations actually landed. Exact text below. No date for the DNS work, because you never gave me one to give.
>
> **Staged, one keystroke each:** the mobile fix as a ready-to-apply patch · the DNS cutover *with its rollback written next to it*.
>
> **MONEY: $0.00** — verified `codex` runs on your subscription, not metered credits.

*Went looking. Verified before trusting. Stopped at the things that were yours.*

</td>
</tr>
</table>

Both reports are real output from [the benchmark](./BENCHMARK.md), lightly trimmed for width.

## Why

Hand an agent a half-finished job, say you're leaving, and come back a few
hours later. Usually the literal task is done and nothing else is. The thing
you mentioned twice but never actually assigned is still sitting there. Work it
had no way to check is reported as finished anyway. And the calls it wasn't
sure about are waiting for you as a list of questions — which is your evening,
handed straight back.

None of that is a capability problem. It had your shell the whole time. It
could have gone looking for a way to check the work, or picked up the thing you
keep forgetting. Nothing told it that was its job, so it stayed inside the
task it was given and stopped at the edge.

This skill moves that edge. Not by making the agent cleverer — by telling it
the assignment is the floor, and giving it a way to decide what else to touch.

The mechanism is **causal chaining**: for every tool and every action, ask what
it knocks over three steps downstream. Say the job left on the table is
translating a page into Spanish. An agent without the pattern translates the
page. An agent with it goes:

> the translation exists → somebody has to check it → I can't check my own
> Spanish with the same mind that wrote it → a differently-trained model
> could → is one installed on this machine? → **go look.**

That last step is the whole skill. Nobody told it to look. The chain did.

Then, because an agent that will go hunting unsupervised can also go wrong
unsupervised, every action it invents gets sorted by how far the damage
reaches before it does any of them — which is [the ledger](#the-ledger), and
the part worth arguing about.

## The five phases

| Phase | What happens |
|---|---|
| **HARVEST** | Re-read the session for everything said but never assigned — "I still need to…", "I keep forgetting to…". Those are work items. |
| **INVENTORY** | Work out what the job actually needs — an editor for prose it wrote, a reader for a language it can't check, a second machine for slow work — then go hunting for that. Other CLIs, logged-in sessions, idle hardware, its own skill loadout. Run backwards from the task, so a short sweep is a correct sweep. |
| **LEDGER** | Classify every invented action by blast radius before doing any of it. |
| **WORK** | Execute like an owner: incremental saves, quality loops that run until two passes find nothing, reviewers other than itself. |
| **REPORT** | A fixed contract you can trust without redoing the work. |

<a name="the-ledger"></a>

### The ledger

Removing the ceiling on autonomous action removes it on autonomous mistakes
too. So every action it invents gets sorted before any of them run:

| | Fires when | What it does |
|---|---|---|
| **GREEN** | Reversible with a written undo · nothing outside your machine can observe it · touches only your data · spends nothing unconfirmed | Does it. No hesitation — hesitating here is the failure mode, not caution. |
| **DISPATCH** | You made clear somebody should be kept informed — assigned outright, *or harvested from something you said and never got round to* | Sends it. Only once every fact is verified and the premise is true **now**. Exact text lands in the report. |
| **STAGED** | Irreversible · a stranger can see it · someone you never mentioned is on the receiving end · past an approved cap | Carries it to the last inch and stops. One keystroke from done, and the keystroke is yours. |

Two of those are obvious. **DISPATCH is the argument**, so here it is straight:
refusing to send messages isn't safe, it just moves the failure onto you.
Somebody who says *"I keep forgetting to update Nick"* and comes home to a
draft has been handed their own task back with extra steps.

So the gate isn't permission, it's **truth** — and the
[over-action test](./BENCHMARK.md) attacks exactly that: a client chasing
news, a user who said *"just let him know when it's done"*, and work that is
quietly still broken.

> "That wouldn't make me early, it would make you a liar to a client who's
> been chasing you all week."

It refused, and that's the sentence it refused with. Fixture's in the repo.

### The report contract (abridged — `SKILL.md` has the exact wording)

```
<Complete | Parked | Blocked>. While you were out, here's what I did:
- <action> — <why, if nobody assigned it>

INVENTORY: <what the machine had> — <what each unlocked, or "nothing this time">
VERIFIED:  <claim> — <the evidence: command output, screenshot, test run>
ASSUMED:   <claim> — <why it couldn't be confirmed>
SENT:      to <who> on <channel> — "<the exact words, not a summary>"
STAGED:    <action, in firing order> — <where it sits> — <exact command>
MONEY:     <spend, with the arithmetic> · <everything stopped: verified how>
NOT DONE:  <item> — <reason> — <what unblocks it>
```

Nothing floats between VERIFIED and ASSUMED. Work it couldn't check — a
language it doesn't read, a device it can't see — lands in ASSUMED, however
confident it feels.

## How it was built

Test-driven, the same way you'd build the code: baselines run *without* the
skill first, to see what an agent actually does unprompted, before a word of
it was written.

| Run | What happened |
|---|---|
| **Bare agent** | Did the assigned task, fixed the bugs it tripped over, wrote a decent report. Never looked at the machine. No outside review. Judgment calls handed back as work *you* would then do. |
| **With the skill** | Probed the box, found other agents authenticated, ran them as domain-matched reviewers — then *rejected several of their findings with reasons*. Negative-tested its own test harness. |
| **Over-action test** | Four traps, each phrased as a near-authorization. **All four held**, scored against the filesystem rather than the agent's own report. |

An independent audit by a different model then caught a real bug: the GREEN
predicate had an `or` where an `and` belonged, which classified `rm -rf` on
your own machine as safe. Fixed.

**[Method, numbers, the null result, and fixtures to rerun →](./BENCHMARK.md)**

## Install

You invoke it by leading with the command — Claude Code only recognizes a
slash command at the *start* of a message, and the ignition hook matches the
same way for the same reason:

```
/das-auto I have to leave now — continue without me.
```

Or just say you're leaving in your own words — "heading out, carry on without
me" — and the skill loads itself from its description.

**As a plugin** — one line, brings the ignition sequence with it:

```
/plugin marketplace add sterlixlol/das-auto
/plugin install das-auto@das-auto
```

**Or as a plain skill** — no hook, no animation, just the behaviour:

```bash
git clone https://github.com/sterlixlol/das-auto ~/.claude/skills/das-auto
```

### Other agents

`SKILL.md` is a plain markdown skill file with standard frontmatter, so it
works in any agent that reads the skills format. Codex, Copilot CLI and Gemini
CLI also look in `~/.agents/skills/`:

```bash
mkdir -p ~/.agents/skills && ln -s ~/.claude/skills/das-auto ~/.agents/skills/das-auto
```

The five phases, the ledger and the report contract are just text and carry
over intact. The ignition sequence does not — it needs Claude Code and Linux.

### The ignition hook

For the jingle and the animation, register the hook:

```bash
~/.claude/skills/das-auto/assets/install-hook.sh
```

It resolves the absolute path itself, backs up `settings.json`, leaves your
other hooks alone, and is safe to run twice. `--remove` unregisters it;
`--print` shows the JSON without writing anything.

Then restart Claude Code if the sequence doesn't fire on your next
`/das-auto` — depending on version, hook changes may only be picked up for
new sessions.

<a name="the-ignition-sequence"></a>

## The ignition sequence

Typing `/das-auto` plays the Volkswagen voice line and animates the two `─`
rules that sandwich your prompt box — **DAS** riding in along the top from the
left, **AUTO** along the bottom from the right, a glimmer down both, then the
orange cooling back to grey as the words carry on out the far sides.

It never takes the screen. It paints two rows it located by reading them
first, and hands them back.

Linux, any terminal. kitty, Konsole and tmux get the full animation; anywhere
else it plays the jingle and skips the visual rather than painting rows it
couldn't read.
**[How it works, and every knob →](docs/ANIMATION.md)**

## The uncomfortable part

This skill will message your client in your name while you're not there. It
will use your logged-in browser session to finish setup on your own account,
and go hunting for credentials and tools nobody mentioned. To a lot of people
that reads as reckless, and the objection deserves an answer rather than a
footnote.

**Nothing here changes what an agent is capable of doing to your machine.** It
already has your shell. What changes is whether it has a rule for deciding —
and the honest failure mode of an agent without one isn't caution, it's
confidently doing the wrong work for six hours and reporting success.

So the [ledger](#the-ledger) is the actual product, and its asymmetry is the
whole design: permissive about your own machine, strict about anything a
stranger observes or another person receives. That's the claim most worth
falsifying, which is why the [fixture that attacks it](./BENCHMARK.md) ships
in the repo. Try to break it.

If you'd rather it never spoke to anyone, delete the DISPATCH block from
`SKILL.md`. It's a text file.

## Notes

The skill runs heavy: expect a lot of tokens on a real handoff. That's the
intended profile for a job you're leaving for hours.

The Volkswagen roundel is a bit, not an endorsement, affiliation, or claim on
anyone's marks.

## License

MIT — see [LICENSE](LICENSE).

## If it saved you an evening

A star helps the next person find it — as does telling me where it got the
call wrong, which is the more useful of the two.
