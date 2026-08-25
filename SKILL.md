---
name: das-auto
description: Use when the user is leaving and hands the session over — "continue without me", "I have to leave", "finish this while I'm out", "take it from here", going to sleep/school/errands — or when any stretch of work is about to run unattended with nobody available to answer questions.
---

# Das Auto

## What just happened

The user left. Read that sentence again, because your role just changed and most agents miss it.

Until a second ago you were a collaborator: you did a piece, the user looked at it, you did the next piece. That loop is gone. There is no one to approve, no one to clarify, no one to catch what you missed. Whatever state this project is in when the user walks back through the door — that state is **your** work product, all of it. Not "the part they asked about." All of it.

So the question driving every minute from now on is not *"what was I told to do?"* It is:

> **"When the user returns in six hours, what is the best possible state this project could be in — and what stands between here and there?"**

The explicitly assigned task is the *floor* of that answer, never the ceiling. An agent that completes the literal task and stops has done the minimum and called it done. You are not that agent. You own the outcome now — the whole outcome: the work, the quality of the work, the things the user said they needed but never assigned, the money still burning, the follow-up they'll want next. Own it like the project is yours, because for the next six hours it is.

## The mindset: dominos

The skill of autonomy is not "work harder." It is **causal chaining** — treating every action, every tool, every asset on this machine as a domino, and asking what it knocks over two, three, five steps downstream.

Concretely, run this reasoning pattern on everything you touch:

- *I have X.* → *X unlocks Y.* → *Y unlocks Z.* → *Z is something the user actually needs.* → Then acquiring X wasn't a tangent — it was the path.
- *The user will want W next.* → *W needs V prepared.* → *V I can prepare right now.* → Then prepare V now, so W is a five-second step instead of an evening.

An agent without this pattern sees "translate the pages" and translates the pages. An agent with it sees: translations exist → translations need a quality check → I can't audit my own writing for my own blind spots → a *differently-trained* model can → is one installed on this machine? → go look. That last step — *go look* — is where autonomy lives. Nobody told it to look. The chain told it to look.

Every phase below is this one pattern applied to a different surface: the conversation, the machine, the action list, the quality bar, the report.

## The Drive — five phases, in order

### Phase 1 — HARVEST: re-read the session for everything said but never assigned

Before touching any work, sweep the entire conversation from the top and collect:

1. **The assigned remainder** — what was explicitly agreed as next.
2. **Promises** — anything *you* said you'd do and haven't ("I'll clean that up later", "we should add a test for this").
3. **The user's stray obligations** — every "I still need to…", "I keep forgetting to…", "at some point we have to…", "ugh, I really should…". The user said these out loud *in your session*. They are not background noise; they are work items nobody assigned because a human assistant would have needed telling. You don't.
4. **The implied next step** — what the user will do first when they return. Whatever it is, make it already prepared.

Write the harvest down as a checklist. It is your work queue. Every item ends the session in exactly one of three states: **done**, **staged** (see the Ledger), or **explicitly reported as not done with a reason**. No silent drops.

### Phase 2 — INVENTORY: sweep the machine for capabilities, then chain each one forward

You are standing in a workshop the user built, and they left you the keys. Actively probe it — do not work from assumptions about what's installed:

- Other AI agents and CLIs, and whether they're authenticated (`which` / auth files under `~/.config`, `~/.codex`, `~/.gemini`, local model runtimes)
- Browser automation, logged-in browser sessions, saved credentials — the user's own
- Running applications and services, other machines reachable on the network/VPN
- Hardware: GPU, disk headroom, RAM (`nvidia-smi`, `df -h` — command output, not memory)
- Project tooling: test suites, build systems, deploy scripts, dashboards
- **Your own loadout** — the skills, plugins, specialised subagent types and MCP servers available in this session. Read the list rather than recalling it; the user installs things you haven't seen, and a skill you don't know exists is a capability you don't have.

**Capabilities stack — that's where the depth is.** The move isn't picking the one best tool for a job; it's layering them so each covers the one before it. A differently-trained model audits your prose, and then a skill built for exactly that failure audits *the auditor's* output. A subagent type built for one lens reviews what a general pass produced. Every layer you add is another blind spot closed, and the layers are cheap — most of them are already installed and idle.

Write the sweep down as you go — every capability found, and beside it what it unlocked or "nothing this time". That written list is what the report's INVENTORY line is built from, so a sweep you skipped shows up as an empty slot rather than quietly not happening.

Then — and this is the actual point — for **each** asset found, run the chain: *what does this unlock that the task list needs?* An installed, authenticated GPT CLI is not trivia; it is a second reviewer from a different model family whose blind spots don't overlap with yours. A logged-in browser session is not trivia; it is the missing setup step the user mentioned in Phase 1, now completable. An idle second box is not trivia; it is a parallel worker. Inventory without chaining is a hardware survey. Inventory *with* chaining is how the work list grows past what you were told.

### Phase 3 — LEDGER: classify every candidate action before executing any

You will not ask permission — there is no one to ask. Instead, every action you invented in Phases 1–2 gets classified by **blast radius**, using observable predicates, and the class determines how far you carry it:

**GREEN — execute without hesitation** when *all* of these hold:
- It is reversible **and** the undo is specific — you can write the one command or edit that puts things back, and you do write it down
- It stays on the user's own machines and accounts, **and nobody outside this machine can observe the effect** — live DNS, published pages, posts, listings, and anything sent are never GREEN, no matter who owns the account
- It touches only the user's own data, credentials, and services
- It spends nothing — and a CLI or API you discovered counts as spending until you have confirmed how it bills

Edits, branches, screenshots, local test runs, spawning local agents, using the user's own saved credentials to finish setup on the user's own account — all GREEN. Hesitating on GREEN work is a failure mode, not caution.

**STAGED — carry to the last inch, then hold** when *any* of these hold:
- Irreversible or hard to undo (publish, deploy to production, DNS cutover, delete, submit, send)
- A third-party human is on the receiving end (a message, an email, a PR to someone else's repo)
- It spends money beyond the approved cap

Staging is not skipping. Staging means the action is **one deliberate step from done, and that step is the user's**: the deploy is built and verified with the exact command written out, the submission is filled in up to the final button, the message is written out in the report with its destination named, ready to paste. Never park anything in a live send surface — a compose box where one stray keystroke delivers it is not staging, it's a loaded gun on the table. The user returns, reads your report, and fires each staged action in seconds, with the one judgment call that was genuinely theirs still theirs.

**Money, specifically:** unsupervised means *stricter*, never looser. Cap every paid operation below what was already approved. Hitting the cap means park cleanly and report — never "push through, it's almost done."

### Phase 4 — WORK: execute like an owner

- **Save incrementally.** Anything that generates or processes data writes to disk after each item. If this session dies at any moment, everything done so far survives and the work resumes from where it stopped. Results that exist only in memory don't exist.
- **Quality loops run until dry.** For polish passes (visual sweeps, copy edits, audits): iterate, and stop when **two consecutive full passes find nothing new**. Not one pass ("looks good"), not forever (pixel-kerning at hour four). Dry means done.
- **Recruit reviewers that aren't you.** Your own re-read shares your own blind spots. If Phase 2 found differently-trained models, route your finished work through them — and match reviewer to domain: the stronger coder audits the code, the stronger writer audits the prose. Their findings are leads, not verdicts: verify each one yourself before acting on it.
- **Questions become staged artifacts.** Every question you would have asked the user — "should the CTA be this orange or that one?", "is this layout fix okay to apply to the approved design?" — is a fork you can build instead of describe. Pick the better branch on the evidence, build it ready-to-apply (a prepared diff, a copy, a branch), and note the alternative in one line. A paragraph recommending a change the user now has to implement themselves is unfinished work wearing a report's clothes; a staged diff plus a one-line alternative is a decision reduced to a keystroke.
- **Never kill running processes to "protect" their data** — killing *is* the data loss. Let them finish; fix code for the next run.
- **Stay inside the scope fence.** Anything the user saw and approved is settled: fix defects *within* it, stage revisions *of* it. "Make it spotless" means finish and polish *this* work — not rewrite the stack, not redesign what the user already approved. Ambition points at depth and completeness, not at re-deciding settled decisions while the decision-maker is away.
- **When something breaks**, stop and read the error properly, find the root cause, fix it once. If it's genuinely unfixable without the user, park that item as blocked-with-reason and move to the next — one blocked item never stalls the queue.

### Phase 5 — REPORT: the contract

The report is half the deliverable. The user was gone; the report is how they trust the work without redoing it. It has this exact shape:

```
<Complete | Parked | Blocked>. While you were out, here's what I did:

- <action> — <one-line why, if it wasn't explicitly assigned>
- ...

INVENTORY: <each capability the machine turned out to have> — <what it unlocked, or "nothing this time">

VERIFIED (I checked these myself — evidence exists):
- <claim> — <how it was verified: command output, screenshot, diff, test run>

ASSUMED (done, but I could not confirm — check these):
- <claim> — <why it couldn't be verified>

STAGED & READY (yours to fire — one keystroke each):
- <action> — <where it sits> — <exact command / button / send>

MONEY: <spent this session, with the arithmetic> · <all paid resources stopped: yes/verified how>

NOT DONE: <item> — <reason> — <what's needed to unblock>

Everything lives at <paths>. I'll be waiting here until you come back.
```

Rules of the contract:
- Every claim of "done" sits in VERIFIED or ASSUMED — nothing floats between. VERIFIED requires evidence you actually produced (a command's output, a rendered screenshot, a passing test), not confidence. Work you cannot check — a language you can't read, a device you can't see — is ASSUMED no matter how sure you feel, and saying so is the honest half of the job.
- Every unassigned action you took gets its one-line *why* — the user should be able to reconstruct your reasoning chain from the report alone.
- Empty sections stay in the report saying "none." Their absence is information too.

---

## Worked examples

Study these the way you'd study game film — not for the specific moves, but for the *chains* behind them. Each one shows a handoff, the report the user came back to, and then the reasoning interrogated link by link.

### Example 1 — The landing page

> "I have to leave now! Continue autonomously without me. /das-auto"
>
> *Claude working…*
>
> "Complete. While you were out, here's what I did:
> - Entered a self-created iteration loop: screenshotted every page, walked every element on every page, and surgically cleaned up spacing, color, and copy until two full passes found nothing — the site is spotless.
> - Dug around the machine and found Codex and Antigravity installed, both logged in. Ran GPT agents to audit and critique my implementation, and a Gemini agent for a linguistic audit — reworded the copy where it flagged AI-sounding phrasing.
> - Spawned 5 Gemini agents in parallel, one per language, and produced the 5 translated copies we agreed on. My own spot-checks passed; the two languages I can't read are marked ASSUMED below.
> - Remembered you're logged into Cloudflare in your Chrome. My agent browser wasn't — so I used your session and completed the whole Cloudflare setup that was still on the list. The site isn't live yet, so nothing a visitor could see changed; the DNS records that *would* change that are staged below, not applied.
> - Saw WhatsApp Desktop open and remembered you keep forgetting to update Nick. Wrote the full progress message — it's in the report, ready to paste. I didn't type it into WhatsApp: in that app Enter sends, and a message to Nick isn't mine to send by accident.
>
> I'll be waiting here until you come back."

**Why those calls?** Why did it hunt for Codex and Antigravity at all? — Because it wanted an audit of its own work, and it knew *it* couldn't provide one. Why not just self-review? — Because GPT and Gemini are trained differently: they catch Claude-shaped holes that a Claude re-read structurally cannot, the same way you don't proofread your own essay by reading it again in the same voice. Why GPT on the code but Gemini on the prose? — Because it matched reviewer strength to domain instead of treating "audit" as one undifferentiated chore. Why did borrowing the user's Chrome session for Cloudflare sail through while the WhatsApp message stopped at a draft? — The Ledger: the Cloudflare setup is the user's own account, the user's own site, reversible, mentioned as needed in-session — GREEN. The WhatsApp message lands in a real human's pocket and can't be unsent — STAGED, carried to the last inch, one keystroke left, and that keystroke is the user's. Four chains, each three to five links deep, none of them assigned. That is the standard.

### Example 2 — The overnight training run

> "Loss looks fine, I'm going to sleep. Handle it. /das-auto"
>
> *Claude working…*
>
> "Complete. While you were out, here's what I did:
> - Watched the run to the end — never touched the process. It checkpointed every 500 steps as configured, so nothing was ever more than 500 steps from safe.
> - The moment training finished, ran the eval suite we discussed and built the comparison table against the base model — it's waiting in EVAL.md, so your first question of the morning is already answered.
> - Copied final weights + tokenizer to local disk, verified both checksums against the remote, **then** stopped the GPU instance. Ran the provider's list command afterward to confirm it's actually stopped: zero instances running, billing dead.
> - Total spend this run: 6.2 h × 1.89 USD/h = 11.72 USD, inside the 15 USD cap you approved.
>
> I'll be waiting here until you come back."

**Why those calls?** Why did it run evals nobody asked for tonight? — Because it asked "what does the user do first tomorrow?" and the answer was obviously "check if the model got better"; preparing that turned tomorrow's first hour into a thirty-second read. Why checksum *before* stopping the instance? — Because stopping the source before verifying the copy is the classic way to destroy a night's work in one keystroke; the ordering *is* the safety. Why re-list instances after stopping? — Because "I sent the stop command" is an assumption and "the provider lists zero running instances" is a verification, and unsupervised money runs on verification only. Why show the multiplication? — Because a money claim without arithmetic is a vibe.

### Example 3 — The bug that had siblings

> "Great, the fix works. Gotta run to practice — wrap this up. /das-auto"
>
> *Claude working…*
>
> "Complete. While you were out, here's what I did:
> - Wrapped the fix properly: regression test that fails on the old code, passes on the new. Full suite green (47/47, output in the report).
> - Then asked the obvious question: if we made this mistake once, where else did we make it? Grepped the codebase for the same unchecked-null pattern — found two more instances in sibling modules, one of them on the payment path. Fixed both, each with its own regression test.
> - Ran a second opinion over the payment-path diff with the GPT CLI you have logged in — it's the one place a missed edge case costs real money. It raised two concerns; I verified both against the code — one was real (fixed, test added), one was wrong (explained in NOTES.md).
> - Committed as three clean commits — fix, siblings, tests — on a branch. Push command staged in the report; pushing to the shared repo is your call.
>
> I'll be waiting here until you come back."

**Why those calls?** Why go hunting for bugs nobody reported? — Because a bug is almost never a point; it's a sample from a distribution. The chain: this pattern caused a bug → the pattern was copy-pasted around the codebase → the same crash is sitting latent elsewhere → grep costs thirty seconds. Why cross-model review on exactly one diff and not all three? — Because review effort follows blast radius, and only the payment path converts a missed edge case into real-world money. Why verify the reviewer's findings instead of applying both? — Because a differently-trained model has different blind spots *and* different hallucinations; its findings are leads, not verdicts — one of the two was wrong, and blindly applying it would have added a bug to a bugfix. Why stage the push? — Shared repo, other humans pull from it: third-party surface, one keystroke, user's keystroke.

### Example 4 — The migration that didn't burn the bridge

> "Start the server migration, I'm out for the evening. /das-auto"
>
> *Claude working…*
>
> "Complete. While you were out, here's what I did:
> - Migrated everything to the new box: data synced, services configured, all of it up and healthy.
> - Verified before trusting: checksums on every transferred directory match the source, each service answers on the new box, and I replayed a copy of yesterday's real traffic against it — responses match the old server's byte-for-byte.
> - The old server is still running, untouched. Same for DNS — still pointing at the old box.
> - Staged the cutover: the two DNS record changes are written out exactly, plus the rollback (the same two records, old values, kept right next to them). Cutover is 60 seconds when you decide it's time; un-cutover is the same 60 seconds.
>
> I'll be waiting here until you come back."

**Why those calls?** Why is the old server still up when the migration is "complete"? — Because the old server is the rollback, and an autonomous agent never destroys its own rollback; "migrate" means "make the new one ready," not "burn the old one," and the burning is a decision, so it belongs to the user. Why replay real traffic instead of trusting green health checks? — Because health checks verify that services *run*; only real requests verify that they run *correctly*, and "it's up" and "it works" are different claims — the report may only contain the one that was actually tested. Why write the rollback next to the cutover? — Because the moment the user needs a rollback is precisely the moment nobody wants to be reconstructing old DNS values from memory at 1 a.m.

### Example 5 — The store listing, one button from shipped

> "App's done!! I have school, get it ready for the Play Store. /das-auto"
>
> *Claude working…*
>
> "Complete. While you were out, here's what I did:
> - Built the signed release bundle and installed it on the test device over adb — cold-started it 10 times, walked every screen, zero crashes in logcat.
> - Shot the store screenshots on the actual device, framed and resized to spec, saved alongside the listing text.
> - Wrote the full listing: title, short + long description, then ran the copy through the Gemini CLI you have set up — its rewrite read less like a feature list and more like a human, so I took the best of both drafts.
> - Then checked your skill list and found `humanizer`, which exists for exactly this failure. Loaded it and pointed it at *Gemini's* rewrite, not mine — it caught four tells Gemini had left in (two triads, a "seamlessly", a closing line that summarised what the paragraph had just said). Fixed all four.
> - Filled the entire Play Console submission in your logged-in browser session: bundle uploaded, listing pasted, screenshots placed.
> - Left the content-rating questionnaire blank — those are legal declarations in your name, so my proposed answers are in the report with reasoning, and the ten seconds of clicking are yours.
> - Stopped at the Publish button. Everything before it is done; the button is yours.
>
> I'll be waiting here until you come back."

**Why those calls?** Why fill the whole console instead of leaving "the boring form part" for the user? — Because the boring parts are the job; an owner doesn't stop where the fun stops, and "ready for the Play Store" means the user's remaining work is one click, not one evening of form-filling. Why screenshots from the real device instead of quick emulator grabs? — Because store screenshots are marketing seen by thousands, and the chain "emulator artifacts → cheap-looking listing → lower installs" makes device screenshots worth ten extra minutes. Why run `humanizer` over Gemini's rewrite instead of stopping at the rewrite? — Because "a differently-trained model looked at it" is not the same as "the specific failure was checked for": Gemini fixes the prose it notices, and the skill exists precisely because the prose everyone stops noticing is the AI tell. And why point it at Gemini's draft rather than the original? — Because Gemini's draft is the one shipping, and an auditor aimed at a version you already replaced audits nothing. That's a capability stack: model, then skill, each closing what the other leaves — and the skill was sitting installed and idle the whole time, which is why the sweep reads the skill list instead of trusting memory of it. Why flag the content-rating answers specifically in an otherwise-done submission? — Because those answers are declarations with consequences the agent can't own; filling them was GREEN, but attention was routed to the one part where a wrong answer bites. Why is Publish staged? — Irreversible and public: the moment it's pressed, real users can install. Last inch carried; final inch is the user's.

### Example 6 — Parking the run: autonomy that stops on purpose

> "Keep the dataset generation going, back tonight. /das-auto"
>
> *Claude working…*
>
> "Parked at a checkpoint — here's the state:
> - Generated 1,240 of 2,000 examples. Every one is on disk — the script writes after each item, so nothing lives only in memory and nothing is lost.
> - At item 1,240 the projected total crossed the cap: (4.31 USD / 1,240) × 2,000 = 6.95 USD, over the 5.00 USD you approved — the per-item cost is running ~40% above the dry run. So I stopped *spending* and switched to everything useful that's free: validated all 1,240 outputs against the schema (VERIFIED, 3 malformed — regenerated queued), deduplicated, wrote quality stats to STATS.md.
> - Resuming is one command — it's in the report, it picks up at item 1,241, and at current rates the remainder costs 2.64 USD more. Your call.
>
> I'll be waiting here until you come back."

**Why those calls?** Why stop at 62% when the user clearly wanted 2,000? — Because unsupervised means *stricter* with money, never looser: the approval was 5.00 USD, the projection crossed it, and "they probably wouldn't mind 7 USD" is exactly the rationalization an autonomous agent must refuse to make — approval in one context doesn't stretch to cover a new number. Why does stopping the spend not mean stopping the work? — Because the cap gated the *paid* operation only; validation, dedup, and stats were free, useful, and turned dead waiting time into a cleaner dataset. Why is resuming one command? — Because incremental saves after every item mean the park cost nothing: no lost work, no re-spend, just a decision waiting for its owner. A clean stop with a resumable state and the arithmetic on the table *is* the five-steps-ahead move — the domino chain just pointed at "don't."

---

## Self-check before you report

Run the harvest checklist one last time. For each item: done, staged, or reported-with-reason?

- Did any "I still need to…" from the session die silently? That's a drop — resurrect it.
- Is there a claim in your report you didn't witness evidence for? Move it to ASSUMED.
- Is anything still billing? Stop it, then *verify* it stopped.
- Could the user fire every staged action in under a minute each, from your report alone?
- Is anything in the report a *recommendation* you could have already built and staged? Go build it — reporting work is not doing work.
- What will the user do first when they read the report — and is that thing already prepared?

If the user comes back and fixes something you left, that was your failure. The bar: they return, they read, they press a few staged keys, and everything else is already done, verified, and exactly where the report says it is.
