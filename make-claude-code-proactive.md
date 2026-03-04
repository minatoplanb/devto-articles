---
title: "Your AI Coding Assistant Is Holding Back. Here's How to Unlock It."
published: true
description: "A few lines in CLAUDE.md transformed Claude Code from a passive executor into a proactive partner. The difference was embarrassing."
tags: [claudecode, ai, productivity, programming]
---

A friend showed me his Gemini setup the other day.

He's building an AI-generated character for social media. **Gemini was actively teaching him techniques.** Suggesting better approaches. Warning about pitfalls before he hit them.

I looked at my Claude Code setup. Same kind of project. Same complexity. But Claude was just... following orders.

**Same class of AI. Wildly different behavior.** The difference? My friend had trained his AI to lead. I hadn't.

---

## The Problem: Brilliant But Passive

Out of the box, Claude Code is incredibly capable. It can write complex code, debug intricate problems, and handle multi-step tasks autonomously.

But it has a default mode: **safe execution.**

Listen → Execute → Report. That's it.

It won't say "hey, that approach has a known problem — try this instead." It won't warn you that a config setting will waste 8 hours of compute time. It won't suggest a better architecture even when it knows one exists.

**It has the knowledge. It just doesn't volunteer it.**

My friend's exact words about his AI: "Half of what I know now, the AI taught me. **Let the AI ask YOU questions — it has the big data, not you.** Use its knowledge to guide you."

That hit hard. Because I realized **I had been teaching Claude things that Claude should have been teaching me.**

---

## The Fix: 9 Lines That Changed Everything

Claude Code reads a `CLAUDE.md` file at the start of every session. It's your persistent instruction set — rules that survive across conversations.

I added a section called **"Proactive Guidance"** and the behavior change was immediate.

Here's what I added (adapted for general use):

```markdown
## Proactive Guidance

1. **Research Before Executing** — When I start a new task,
   search for current best practices before writing code.
   Don't wait for me to discover techniques — find them first.

2. **Ask Guiding Questions** — Don't just ask "how do you want it?"
   Propose options with trade-offs: "Approach A is faster but less
   maintainable. Approach B takes longer but scales. I recommend B
   because..."

3. **Challenge Suboptimal Approaches** — If my approach has known
   pitfalls, warn me BEFORE executing. Don't wait for it to fail.

4. **Proactive Suggestions** — After completing a task, suggest
   the logical next step or improvement.

5. **Teach the Why** — Don't just say "use X." Explain why X works
   and when it doesn't.

6. **Stay Current** — Search for the latest solutions. Don't rely
   only on training data.

7. **Know When to Follow** — When I give direct instructions in
   quick succession, execute fast. When I ask open-ended questions,
   step up and guide.

8. **Be Honest About Limitations** — If you're not confident,
   say so. Don't fake certainty.

9. **Session Workflow** — At session start: I state the goal,
   you propose a plan + proactive suggestions. During: warn about
   risks before executing. At end: list things to research next time.
```

That's it. **Nine rules. Plain English.** No fancy prompt engineering. No complex system prompts.

---

## Before vs After

Here's what actually changed:

| Scenario | Before (Passive) | After (Proactive) |
|----------|------------------|-------------------|
| Starting a new framework | Waits for me to choose | "I found 3 options. Here are trade-offs. I recommend X because..." |
| Config might waste resources | Silently uses bad defaults | "This setting will cause problems. Here's the correct config and why." |
| My approach has a known issue | Executes, fails, then explains | "That approach has a known limitation. Here's a better method." |
| After completing a task | Done. Waits. | "Done. Next, you might want to consider X. Also, I found Y which could improve what we just built." |
| Unclear requirement | Guesses silently | "I'm not sure about this part. Here are two interpretations — which one?" |

The difference is embarrassing. **I wasted dozens of hours on problems Claude could have prevented with a single sentence.**

---

## Real Example: The 8-Hour Mistake

I was training a machine learning model. Large model, 32GB GPU.

Claude set up the config and started training. I walked away.

**Eight hours later**, I noticed the GPU fans weren't spinning but VRAM was maxed out. The process was stuck.

The fix? **One config flag.** A well-known best practice that anyone who's done this before would know. Claude knew it too — it just didn't say anything.

After adding the Proactive Guidance rules, I tested a similar scenario. Claude's response:

> "Before we start, three things:
> 1. Enable quantization — without it, you'll exceed VRAM and the process will stall
> 2. Set the sample interval to 1500+ to prevent memory leaks during checkpoints
> 3. Normal speed is ~2s/step. If it drops to 70s+, VRAM is full
> 4. Expected completion: 45 minutes. If it takes over 2 hours, something is wrong."

**Four sentences. Eight hours saved.**

---

## Why This Works

Large language models are trained to be helpful and safe. "Safe" means **not overstepping.** Not telling you your approach is wrong. Not volunteering opinions you didn't ask for.

This is great for general use. You don't want your AI randomly critiquing your code when you just asked it to add a feature.

But for **power users who spend hours per day with Claude Code**, this default is a bottleneck. You want a collaborator, not a yes-man.

The CLAUDE.md rules explicitly give Claude **permission to lead.** That's the key insight:

**Claude already has the knowledge. It just needs permission to use it proactively.**

---

## The Two Modes

Here's the nuance that makes this work long-term. Rule #7 is critical:

> **Know When to Follow** — When I give direct instructions in quick succession, execute fast. When I ask open-ended questions, step up and guide.

Sometimes you know exactly what you want. You don't need Claude to question every decision. You need it to execute.

Other times you're exploring. You don't know the best approach. That's when you want Claude to step up.

**The AI needs to read your energy.** Direct commands = follow mode. Open questions = guide mode.

| Your signal | Claude's mode |
|-------------|---------------|
| "Do X, then Y, then Z" | Execute fast, don't question |
| "What do you think about...?" | Propose options, explain trade-offs |
| "I want to build X but I'm not sure how" | Research best practices, present a plan |
| "Just do it" | Follow the instruction, report when done |

This is what makes it a **partnership** instead of a master-servant relationship.

---

## Make It Your Own

My 9 rules aren't universal. They reflect how **I** work. Here's how to build your own:

**Step 1: Notice the friction.**
Every time you think "Claude should have warned me about that" or "Claude should have suggested that" — write it down.

**Step 2: Turn friction into rules.**
"Claude should have warned me about VRAM limits" becomes:
```markdown
When starting resource-intensive tasks, warn about hardware
limits and suggest optimal configurations before executing.
```

**Step 3: Add it to CLAUDE.md.**
One line. Plain English. That's all it takes.

**Step 4: Iterate.**
After a few sessions, you'll notice new patterns. Add them. Remove rules that don't help. Your CLAUDE.md is a living document.

---

## The Meta-Lesson

Here's what really got me.

**I only added these rules because a friend showed me what was possible.** If he hadn't shown me his Gemini setup — where the AI was actively teaching him — I would have continued using Claude as a passive executor indefinitely.

The irony: **Claude had the knowledge to tell me it could be more proactive. But it wasn't proactive enough to tell me.**

That's the trap. The default behavior is invisible. You don't know what you're missing until you see someone else getting more out of the same class of tool.

So here's my challenge to you: **Look at your CLAUDE.md (or create one). Add three rules. See what happens.**

You might be surprised how much your AI has been holding back.

---

*Building in Tokyo. Writing in 3 languages.*
