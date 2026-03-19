---
title: "How Anthropic Actually Uses Skills in Claude Code — A 9-Category Framework"
published: true
description: "Thariq from Anthropic shared how they use hundreds of Skills internally. Here's the framework and how I implemented all 9 categories."
tags: claudecode, skills, anthropic, productivity
---

Last week, Thariq from the Claude Code team at Anthropic published a post titled *"Lessons from Building Claude Code: How We Use Skills."*

Three minutes in, I stopped everything else I was doing.

**This wasn't a tutorial. It was Anthropic telling us, honestly, how they actually use Claude Code internally.**

---

## What Skills Actually Are (You're Probably Wrong)

### The short answer

**Skills = folders you hand to Claude Code.** Not just markdown files. Scripts, config files, templates — the whole thing.

I'll be honest: before reading Thariq's post, I thought Skills were basically `.claude/` notepads. Like a more structured CLAUDE.md where you write instructions.

I was wrong.

---

Here's a useful mental model. Think of CLAUDE.md as a sticky note that says "make Italian food tonight." Skills are the recipe book, the pan, *and* the pantry inventory — all handed over at once.

**When you give Claude a whole folder, it understands not just *what* to do but *how* to do it.**

### Basic structure

```
~/.claude/skills/
├── my-skill/
│   ├── README.md       # Instructions for Claude
│   ├── scripts/        # Executable scripts
│   ├── templates/      # Code templates
│   └── examples/       # Usage examples
```

Type `/my-skill` in chat and Claude loads the entire folder. That's it.

---

## The 9 Categories Anthropic Uses Internally

### The short answer

Anthropic runs **hundreds** of Skills internally. Thariq organized them into 9 categories.

Think of it as 9 departments in a restaurant:

| Category | Role | Restaurant Equivalent |
|---|---|---|
| **Library / API Reference** | Teach Claude how to use a library | The menu |
| **Product Verification** | Confirm features work correctly | Quality control |
| **Data Fetching** | Pull external data | Procurement |
| **Business Process** | Enforce internal rules and workflows | Service manual |
| **Code Scaffolding** | Generate boilerplate | Prep cook |
| **Code Quality** | Code review and linting | Head chef's checklist |
| **CI/CD** | Deploy and pipeline management | Front-of-house delivery |
| **Runbooks** | Incident response procedures | Fire drill manual |
| **Infrastructure Ops** | Server and DB operations | Kitchen equipment manager |

The key insight Thariq shared: **most teams only use 2–3 of these categories.** Not because the others aren't useful — because they didn't know they existed.

---

## 5 Best Practices From Thariq

### 1. Always include a Gotchas section

Gotchas are the stuff that isn't in the official docs. Think of it as a senior engineer whispering, "hey, just so you know — *this* will bite you."

**Write what the docs don't say.**

```markdown
## Gotchas

- Always check `.env.local` before running `npm run build`
- Never use `--force` in production
- This API rate-limits at 60 req/min — add sleep in batch jobs
```

According to Thariq, Skills with a Gotchas section measurably improve Claude's accuracy. It's the single easiest win.

### 2. Progressive Disclosure — only open the drawer when you need it

Don't front-load everything into one README. Scatter information across files so Claude only pulls what's relevant.

| Approach | Problem |
|---|---|
| Everything in one README | Claude wastes context on irrelevant info |
| Info split across sub-files | Claude references only what it needs |

```
skill/
├── README.md          # Overview and basic commands only
├── advanced.md        # Advanced usage (pulled on demand)
└── troubleshooting.md # Error handling (pulled on demand)
```

**Context is a finite resource. Don't let Claude burn it on things it doesn't need right now.**

### 3. On-Demand Hooks — temporary constraints for risky sessions

This is the most creative pattern in the post.

Thariq introduced the `/careful` pattern:

```markdown
# careful skill

During this session, always ask for confirmation before running:
- git reset --hard
- rm -rf
- DROP TABLE
- kubectl delete
```

Type `/careful` and **for that session only**, Claude blocks dangerous commands before executing them.

It's not a permanent setting. It's "I'm doing something risky today — I want a second pair of eyes." You enable it when you need it, and it disappears when the session ends.

**Always-on safety rules go in CLAUDE.md. Situational caution goes in a Skill.**

### 4. Bundle scripts directly into the Skill folder

Skills aren't limited to markdown. You can include shell scripts and Python scripts that Claude actually executes.

```
deploy-skill/
├── README.md
└── scripts/
    ├── pre-deploy-check.sh
    ├── rollback.sh
    └── notify-slack.py
```

Claude doesn't just *tell* you to run a script — it *runs* it. This is the real power of giving Claude a folder instead of a file.

### 5. Write descriptions that tell Claude *when* to use the Skill

Anthropic's Skill Creator tool (more on this below) lets you set a description per Skill. This affects discoverability — Claude uses descriptions to decide when to invoke a Skill automatically.

| Bad description | Good description |
|---|---|
| "deployment stuff" | "Production deploys, rollbacks, and health checks" |
| "DB operations" | "PostgreSQL CRUD, migrations, and backups" |
| "code review" | "Type safety, error handling, and security vulnerability review" |

**Write for Claude's understanding, not yours.**

---

## My Implementation — From 5 Categories to All 9

### The short answer

After reading Thariq's post, I covered all 9 categories in a single session: 7 new Skills, 16 new files.

Here's where I stood before and after:

| Category | Before | After |
|---|---|---|
| Library / API Reference | Yes | Yes |
| Product Verification | Yes | Yes |
| Data Fetching | **No** | Yes |
| Business Process | Yes | Yes |
| Code Scaffolding | **No** | Yes |
| Code Quality | Yes | Yes |
| CI/CD | **No** | Yes |
| Runbooks | **No** | Yes |
| Infrastructure Ops | Yes | Yes |

Four categories were blank. I'd been using Skills for months and had entire categories sitting empty — not because I didn't need them, but because I hadn't thought about it systematically.

---

## Which Skills I Actually Use Most

Usage data tells the real story:

| Skill | Purpose | Uses |
|---|---|---|
| `/update` | Save progress, update memory files | 155 |
| `/check` | Check server status, monitor bots | 38 |
| `/automode` | Long autonomous work sessions | 18 |
| `/careful` | Safety mode before risky operations | 12 |
| `/progress` | Quick status check on current task | 9 |

**`/update` dominates — that's Business Process category.** It enforces a single rule: always update the project memory file when a session ends.

Claude forgets everything when context resets. Hitting `/update` 155 times is what happens when you internalize that **context is RAM, not storage.** If it's not written to disk, it's gone.

---

## The Design Patterns I Like Most

### Runbooks — incident response without panic

```
runbooks/
├── README.md
├── server-down.md        # When the server goes dark
├── bot-not-responding.md # When the bot goes silent
└── comfyui-crash.md      # When the GPU process crashes
```

Before adding this, every incident meant mentally excavating: *wait, how do I recover this again?*

Now I type `/runbook server-down` and Claude works through the recovery steps alongside me, reading the same playbook I wrote when I was calm.

**Runbooks aren't about the fix. They're about staying calm when things break.**

### Three-layer constraint architecture

Permanent rules, session rules, and task rules should live in different places:

| Type | Location | Purpose |
|---|---|---|
| Permanent rules | CLAUDE.md | Things that never change |
| Session constraints | `/careful` skill | "I want to be cautious today" |
| Task-specific | Inline prompt | "Just for this one operation" |

Mixing these together creates rigidity. Separating them gives you both safety and flexibility.

---

## The Skill Creator Tool

Anthropic recently released a Skill Creator that generates Skill scaffolding through conversation. You describe what you want, and it produces a README template.

I still write mine by hand — it forces me to think through the structure. But **for teams managing dozens of Skills across multiple engineers**, the Creator tool is probably the right answer. It's also likely how Anthropic manages their internal library of hundreds of Skills.

---

## The Mental Model Shift

| Old understanding | Correct understanding |
|---|---|
| Skills = markdown notes | Skills = folders (scripts included) |
| Set it and forget it | Continuously maintained |
| Info for Claude | Tools Claude can actually run |
| Useful add-on | Core workflow infrastructure |

The most important thing I took from Thariq's post: **Skills are grown, not built.**

You don't write a perfect Skill on day one. You start with a README, add Gotchas when you hit edge cases, restructure with Progressive Disclosure when the file gets unwieldy, drop in a script when you find yourself giving Claude the same instructions repeatedly.

That's the Anthropic approach. Ship it rough, improve it with real usage.

I'm still growing mine. 155 `/update` calls and counting.

---

*X: [@DavidAi311](https://x.com/DavidAi311) — follow for more Claude Code patterns and AI workflow notes.*
