---
title: "I Built an 'Autopilot Mode' for Claude Code. Now AI Works While I Sleep"
published: true
description: "A custom Claude Code skill that lets the AI work autonomously — planning tasks, monitoring progress, handling failures, and notifying you when done."
tags: [ai, claudecode, automation, productivity]
---

I use Claude Code 12+ hours a day.

One night I was setting up a LoRA training run. Three hours for training. Two hours for batch generation afterward. Then deployment. Over six hours of work ahead of me.

I was exhausted.

I wanted to tell Claude "handle the rest" and go to bed. **But Claude Code doesn't work that way.** You give it a task. It finishes. It waits for the next instruction. You have to be there the whole time.

So I built `/automode` — a custom skill that turns Claude Code into an autonomous worker.

---

## What Is Automode?

**In one sentence: Claude keeps working after you walk away.**

Think of it like hiring a junior developer for the night shift. You leave clear instructions on their desk. "Do this first, then this, if something breaks try once more, and text me when everything's done." You come in the next morning. There's a completion report waiting.

`/automode` is that workflow inside Claude Code.

| Standard Claude Code | /automode |
|---------------------|-----------|
| One task at a time | Batch multiple tasks |
| Waits for next instruction after each task | Automatically chains to the next |
| Failure = stuck until you notice | Auto-retry once, skip if still failing |
| You check completion manually | Telegram notification |
| Must be present | Walk away, sleep, go outside |

---

## How It Works

When you invoke `/automode`, Claude asks:

> "What do you want done? Describe all tasks in plain language."

You say: "Train the LoRA, then run batch generation with the trained model, then deploy the results."

### Step 1: Build the Work Plan

Claude generates a **numbered work plan**.

```
═══════════ AUTOMODE WORK PLAN ═══════════

1. [GPU 3h] LoRA Training — verify config → start training
2. [GPU 2h] Batch Generation — generate 50 images with trained model
3. [CPU 5m] Deploy — upload results to production

Estimated total: 5h 5m
Context usage: currently 15% → estimated 45% at completion
═══════════════════════════════════════════
```

Each task gets a time estimate. And there's a **context window usage forecast**. This matters. More on that later.

### Step 2: Execute with Monitoring

Once running, Claude **monitors progress in the background** at intervals tuned to the task type:

| Task type | Check interval | Why |
|-----------|---------------|-----|
| GPU (training, generation) | 15 min | Long-running. Checking more often is noise |
| CPU (builds, tests) | 5 min | Medium duration |
| Queue waiting | 30 sec | Could finish any moment |

Is the process stuck? Any errors? VRAM overflowing? Claude watches for you.

### Step 3: Auto-Chain Tasks

**Task 1 finishes → Task 2 starts automatically.** This is the core of automode.

Without it, Claude finishes training and reports "Training complete." Then it waits. For three hours. Until you wake up and say "now run the batch generation."

With automode: **detect completion → prepare next task → execute.** No human in the loop.

### Step 4: Handle Failures

Like training that junior dev — "don't panic if something breaks."

- **Failure detected** → retry once
- **Second failure** → skip the task, move to the next one
- **Skipped tasks get flagged** in the final report

If a 3-hour training run crashes at 2.5 hours, automode won't freeze. It skips batch generation, runs deployment, and flags both failed tasks in the report.

### Step 5: Send Completion Notification

When everything's done, **Telegram delivers the report**.

> AUTOMODE Complete
> - Task 1: LoRA Training (2h 47m)
> - Task 2: Batch Generation (1h 52m)
> - Task 3: Deploy (3m)
> - Total: 4h 42m
> - Skipped: none

You check your phone in the morning. It's already there.

---

## The Context Window Problem

Here's what actually made automode hard to build. **Not the task execution. The context window management.**

Claude Code has a "battery" — the context window. Longer conversations drain it. At 100%, the session ends.

Normally you just start a new session. But automode runs **when nobody's watching.** If the battery dies, work disappears mid-task.

### Solution: The 70% Safety Line

Automode continuously monitors context usage. **At 70%, it saves state.**

The save file is `AUTOMODE-STATUS.md`:

```markdown
# Automode Session — 2026-03-06 03:42

## Completed
1. LoRA Training (2h 47m)
2. Batch Generation (1h 52m)

## Remaining
3. Deploy — not started

## Current State
- Output: /output/batch-001/ (50 images)
- Model: ./models/lora-v3.safetensors
- Next action: run deploy script
```

Open a new session, read this file, and **resume from where it stopped.** Battery dies, data survives.

---

## Real Example: Work Done While Sleeping

Last Friday, I queued this workflow in `/automode`:

1. **LoRA training** (new style, estimated 3 hours)
2. **Quality check** (auto-generate 10 samples, automated pass/fail)
3. **Batch generation** (production run, 50 images, estimated 2 hours)
4. **Deploy** (upload results to server)

Started at 11 PM. Went to bed.

**At 6 AM, Telegram notification was waiting on my phone.**

```
AUTOMODE Complete — 4/4 tasks succeeded
Total time: 5h 12m
Skipped: none
```

Five hours of work, finished while I slept.

Previously, I would have either stayed up all night — watching training finish, manually starting batch generation, watching that finish, manually deploying — or pushed everything to the next day and lost a full workday.

**Those hours are mine now.**

---

## What Is a Claude Code Skill?

If you haven't used the skill system, here's the short version.

**A skill is a custom command for Claude Code.** You type `/automode` and a pre-written Markdown file gets loaded into Claude's context. Claude follows the instructions in that file.

The mechanism is simple:

1. Put a Markdown file in `~/.claude/skills/`
2. Write step-by-step instructions in plain English
3. Type `/skill-name` in Claude Code to activate

```
~/.claude/skills/
├── automode.md      ← autonomous work mode
├── write.md         ← blog writing
├── update.md        ← mission control dashboard
└── review.md        ← action item review
```

The skill file is **plain English instructions.** No programming required. "Build a task list, execute them in order, retry on failure, send a Telegram notification when done." That's literally what you write.

This isn't an official Anthropic feature. It's more of a hack using Claude Code's prompt system. But it works.

---

## Building Your Own Automode

Here's the design philosophy. Use it directly or adapt it.

### Five Core Components

| Component | Purpose | Why it's needed |
|-----------|---------|-----------------|
| **Work plan** | Numbered task list + time estimates | Without clarity, it goes off the rails |
| **Monitor loop** | Periodic progress checks | Detect stalls and failures |
| **Auto-chain** | Task N done → start Task N+1 | Without this, it's just manual with extra steps |
| **Failure handling** | Retry → skip → flag | One failure shouldn't kill the whole batch |
| **State save** | Persist at 70% context | Prevent data loss |

### Minimal Skill File

```markdown
# /automode

## Steps
1. Ask user for task list
2. Create numbered work plan (time estimate per task)
3. Check context usage (warn if above 70%)
4. Execute tasks in order
5. Auto-start next task after each completion
6. On failure: retry once → skip + flag if still failing
7. Save state when all done OR context hits 70%
8. Send Telegram notification (requires API setup)
```

That's a working foundation. Adjust monitoring intervals and retry counts for your workflow.

---

## What Changed

Numbers.

| Before | After |
|--------|-------|
| Idle during GPU training (3h wasted) | Sleep or work on something else |
| Manual handoff between tasks | Automatic. Zero seconds |
| Failure → sits there until I notice | Auto-retry or skip |
| Occasional all-nighters waiting for jobs | **Gone** |
| Productive hours per day ≈ waking hours | **24 hours** |

Sounds dramatic. But just being able to **push time-consuming tasks to overnight** doubles the next day's output. Wait time goes to zero.

For me, automode isn't a convenience feature. **It changed how I work.**

---

## Caveats

Not a silver bullet.

- **Judgment-heavy tasks don't fit.** "Which design looks better?" requires human eyes. Automode works best for tasks with clear steps and verifiable outcomes.
- **Context window is finite.** Too many tasks and you hit the 70% save point. Five to six tasks is the realistic ceiling per session.
- **This isn't an official feature.** It's a custom solution built on Claude Code's skill system. Anthropic doesn't guarantee anything about it.
- **Monitoring isn't perfect.** Claude can't read GPU state directly. Unusual error patterns might slip through.

---

## Conclusion

Claude Code is powerful. But by default, it assumes **a human is watching.**

Automode removes that assumption. Give it clear instructions and Claude works independently. It handles failures, chains tasks, and reports when done.

Like the night-shift junior developer. At first you'll check on them nervously at 2 AM. Then you stop. Because the work is done when you arrive in the morning.

**AI isn't just a tool that waits for instructions. You can make it a colleague you delegate to.** All you need to design is the delegation.

---

*Building in Tokyo. Writing in 3 languages.*
