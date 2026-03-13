---
title: "I Made 5 Custom Skills to Stop Claude Code from Ignoring Its Own Rules"
published: true
description: "CLAUDE.md rules are suggestions. Custom Skills are systems. Here's how I enforced development discipline with Superpowers + 5 custom skills."
tags: claudecode, ai, workflow, productivity
---

I have over 200 lines of rules in my CLAUDE.md file. Every single line has a date. Every date has an incident behind it.

**Claude Code still ignores them.**

Not always. Not maliciously. But often enough that I've lost hours to preventable mistakes — running destructive commands without checking blast radius, over-engineering a 5-line fix into a 3-file refactor, skipping official docs and guessing at config formats.

Writing more rules didn't help. I needed a different approach entirely.

---

## The Problem: Text Rules Are Suggestions

CLAUDE.md is powerful. It's the first thing Claude reads every session. But here's the uncomfortable truth:

**Rules written in natural language are suggestions, not systems.**

Claude "understands" your CLAUDE.md. It can quote it back to you. But understanding and consistently following are two different things. The longer the context grows, the more likely rules get deprioritized. Complex multi-step tasks? Rules slip. Novel situations not explicitly covered? Rules get "interpreted."

I wrote about this in detail in a [previous article](https://dev.to/davidhsu/i-wrote-200-lines-of-rules-for-claude-code-it-ignored-them-all-35i7). The short version: text-based rules have a compliance ceiling. You can write better rules, add more emphasis, use scary capital letters — but you'll plateau around 70-80% compliance.

I needed the remaining 20-30%.

---

## Enter Superpowers

[Superpowers](https://github.com/obra/superpowers) is a plugin for Claude Code by Jesse Vincent (obra). It's on the Anthropic official marketplace, MIT licensed, and it does one thing extremely well: **it gives Claude Code a skill system.**

Skills aren't just text instructions. They're structured, retrievable procedures that Claude actively loads and follows when a matching situation is detected. Think of it as the difference between:

- **CLAUDE.md**: A sign that says "Stop at red lights"
- **Skills**: The actual traffic light — red light turns on, you stop

Superpowers ships with a solid set of built-in skills for common workflows. But out of the box, it's generic. It doesn't know your team's conventions, your project tracker, your deployment pipeline, or your personal failure modes.

**The real power is writing custom skills.**

---

## 5 Custom Skills That Changed Everything

After a month of tracking every time Claude broke a rule, I identified five failure patterns that CLAUDE.md couldn't fix. Each one became a custom skill.

### 1. Task Sizing (`task-sizing`)

**The problem:** Claude over-engineers everything. A one-line config change becomes a 3-file refactor with new abstractions. A quick bug fix spawns a test suite rewrite.

**The skill:** Before starting any task, Claude must grade it:

- **S (Small):** < 20 lines changed, single file. Just do it.
- **M (Medium):** 20-100 lines, 2-5 files. Brief plan, then execute.
- **L (Large):** 100+ lines or 5+ files. Research phase first, written plan, then implement.

```
## Task Sizing Protocol

Before writing any code, classify the task:

**S (Small)** — Under 20 lines, single file
→ Execute immediately. No planning overhead.

**M (Medium)** — 20-100 lines, 2-5 files
→ Write a 3-line plan. Get acknowledgment. Execute.

**L (Large)** — 100+ lines or 5+ files
→ STOP. Research → Plan document → Review → Implement.
   Do NOT start coding until the plan is approved.

If uncertain between S and M → treat as M.
If uncertain between M and L → treat as L.
Always err toward the larger size.
```

**Before:** Claude would jump straight into a "quick fix" that somehow touched 8 files.

**After:** Small tasks stay small. Large tasks get the planning they deserve.

### 2. Issue Tracking Workflow (`paperclip-workflow`)

**The problem:** Work happens without any record. No issue created, no progress logged, no completion tracked. Two weeks later, I'm trying to remember what was done and why.

**The skill:** Every task must follow a workflow: check out an existing issue (or create one), log progress as comments, and mark it complete when done.

```
## Issue Tracking Workflow

Every task MUST follow this cycle:

1. CHECK — Does an issue exist for this work?
   → Yes: Check it out (assign to yourself)
   → No: Create one with a clear title and scope

2. WORK — Do the actual task
   → Add a comment summarizing what was done after each milestone

3. COMPLETE — When finished:
   → Add a final comment with summary + any follow-ups
   → Mark the issue as resolved
   → Update any cross-project tracking docs

NEVER say "done" without an issue comment proving it.
```

**Before:** "I fixed the routing bug." (No record anywhere. Which bug? When? What changed?)

**After:** Every task has a paper trail. Searchable, timestamped, linked to actual work.

### 3. Chief Dispatch (`chief-claude-dispatch`)

**The problem:** Claude does everything itself, burning through context window on tasks that a sub-agent could handle. Reading log files, searching codebases, running test suites — all of it eating into the main conversation's limited memory.

**The skill:** For any task that doesn't require decision-making, Claude must dispatch a sub-agent instead of doing it directly.

```
## Chief Claude Dispatch Protocol

You are the CHIEF. Chiefs delegate; they don't do grunt work.

Before executing any task, ask: "Does this require my judgment,
or just execution?"

DISPATCH to a sub-agent:
- File searching / grep across codebase
- Running test suites and reading output
- Log analysis
- Boilerplate generation
- Data formatting / transformation

DO YOURSELF:
- Architecture decisions
- Code review requiring context
- User-facing communication
- Anything requiring judgment about trade-offs

When dispatching: provide clear instructions, expected output
format, and what to do if something unexpected happens.
```

**Before:** 60% context consumed just reading files and running tests. Major decisions made in the remaining 40% with degraded performance.

**After:** Context stays clean. Main thread focuses on decisions. Heavy lifting happens in isolated sub-agents.

### 4. Research First (`research-first`)

**The problem:** Claude guesses at configuration formats instead of reading docs. It assumes API behavior based on naming conventions. It "knows" how a tool works from training data that's months out of date.

**The skill:** Before configuring, installing, or integrating any external tool, Claude must read the official documentation first. Not source code. Not Stack Overflow. The actual docs.

```
## Research First Protocol

When installing, configuring, or integrating ANY external tool:

1. READ official documentation first
   → Docs > README > Examples > Source code (in that order)

2. VERIFY versions
   → Check the current version. Your training data may be stale.

3. NEVER guess config formats
   → If you're not 100% sure of a field name, look it up.
   → "I think the key is called..." = STOP and search.

4. CITE your source
   → "Per the docs at [URL]: the config format is..."

Skipping this step has historically cost 30+ minutes of debugging
for every 2 minutes of "just trying it."
```

**Before:** 30-minute debugging session because Claude assumed an API key format instead of checking the docs.

**After:** An extra 2 minutes reading docs upfront saves the debugging entirely.

### 5. Production Safety (`production-safety`)

**The problem:** Claude runs `git reset --hard`, kills processes by name (hitting unrelated services), or modifies production configs without thinking through consequences.

**The skill:** Any command that could affect production, destroy data, or modify system state requires a blast radius analysis first.

```
## Production Safety Protocol

Before running ANY of these commands, STOP and analyze:

HIGH RISK (requires explicit user approval):
- git reset --hard, git clean -fdx, git push --force
- rm -rf, del /s /q, Remove-Item -Recurse -Force
- Process kills, service restarts
- Environment variable or PATH modifications
- Database migrations, schema changes

ANALYSIS REQUIRED:
1. What exactly will this command affect?
2. What is the blast radius? (files, services, data)
3. Is this reversible? If not, what's the backup plan?
4. Is there a safer alternative that achieves the same goal?

Present the analysis to the user BEFORE executing.
Never say "I'll just quickly..." for high-risk commands.
```

**Before:** Claude killed a process by name, accidentally taking down 3 unrelated services sharing a similar name.

**After:** Blast radius is analyzed first. "This will kill PID 12345 which is the dev server on port 3000. Two other Node processes are running but won't be affected."

---

## The Before/After

Here's what changed across a typical work week:

| Metric | Before (CLAUDE.md only) | After (CLAUDE.md + Skills) |
|--------|------------------------|---------------------------|
| Over-engineered small tasks | 3-4 per week | ~0 |
| Undocumented work | Most tasks | Every task has an issue trail |
| Context window burnout | Hit 70%+ by mid-session | Stays under 50% |
| Config/install debugging | 30-60 min wasted weekly | Near zero |
| Destructive command incidents | 1-2 per month | Zero in 4 weeks |
| Rule compliance (estimated) | ~70% | ~95% |

That last row is the key number. Going from 70% to 95% rule compliance doesn't sound dramatic, but **the 30% that was failing contained the most expensive mistakes.**

---

## Why Skills Work When Rules Don't

Three reasons:

**1. Skills are contextual, rules are global.**

CLAUDE.md loads everything at session start — 200+ lines competing for attention. Skills activate only when relevant. Task sizing fires when you start a task. Production safety fires when you're about to run a dangerous command. There's no noise.

**2. Skills are procedural, rules are declarative.**

CLAUDE.md says *what* to do: "Always check blast radius before destructive commands." A skill says *how*: step 1, step 2, step 3, present analysis, wait for approval. Procedures are harder to skip than principles.

**3. Skills compose into a system.**

Individual rules are isolated. Skills reference each other. The dispatch skill knows about the issue tracking skill. The task sizing skill influences whether research-first triggers. Together, they form a workflow — not just a list of dos and don'ts.

The analogy I keep coming back to:

> **CLAUDE.md is a driving manual. Skills are the actual car controls.**
>
> You can write "always check mirrors before changing lanes" in a manual. Or you can install a blind-spot detection system that beeps when something's there. Both work. One works *consistently*.

---

## How to Set This Up

### Step 1: Install Superpowers

```bash
# Install via Claude Code slash command
/install-github-mcp-server obra/superpowers
```

That's it. Superpowers registers as an MCP server and adds skill management to your Claude Code session.

### Step 2: Create Custom Skills

Skills live in `~/.claude/skills/` as markdown files. Each skill is a `.md` file with a clear title and structured instructions.

```bash
# Create the skills directory if it doesn't exist
mkdir -p ~/.claude/skills
```

Create a skill file:

```markdown
# ~/.claude/skills/task-sizing.md

## Task Sizing Protocol

Before writing any code, classify the task:

**S (Small)** — Under 20 lines, single file
→ Execute immediately. No planning overhead.

**M (Medium)** — 20-100 lines, 2-5 files
→ Write a 3-line plan. Get acknowledgment. Execute.

**L (Large)** — 100+ lines or 5+ files
→ STOP. Research → Plan document → Review → Implement.

If uncertain, always err toward the larger size.
```

### Step 3: Reference Skills in CLAUDE.md

Add a line pointing Claude to your skills:

```markdown
## Skills
- Load and follow all skills in `~/.claude/skills/` for every session
- Skills override general instructions when there's a conflict
```

### Step 4: Iterate

The most important step. Track when skills fire correctly and when they don't. Refine the trigger conditions. Add edge cases as you encounter them.

My skills have gone through 3-4 revisions each. The first version of `task-sizing` didn't handle "ambiguous size" well — Claude would classify everything as S to avoid planning overhead. Adding the "when uncertain, err toward larger" rule fixed it.

---

## What I'd Do Differently

**Start with your failure log, not your wish list.**

I made the mistake of writing aspirational skills first — how I *wanted* Claude to work. They were ignored almost as badly as CLAUDE.md rules.

The skills that stuck were the ones born from real incidents. Every skill above has a specific date and a specific failure behind it. That's not a coincidence. **Pain-driven development produces the most effective guardrails.**

If you're starting from scratch:

1. Use Claude Code normally for a week
2. Keep a simple log: every time it does something wrong, write one line
3. At the end of the week, group the failures into patterns
4. Each pattern becomes a skill
5. Deploy, observe, refine

---

## The Bigger Picture

We're in the early days of "AI discipline engineering." Right now, most teams rely on prompt engineering alone — writing better instructions and hoping for better compliance. That's necessary but insufficient.

The next layer is **behavioral systems** — skills, hooks, automated checks — that enforce discipline structurally. Not by asking the AI to be good, but by making it hard to be bad.

CLAUDE.md is your constitution. Skills are your laws. Hooks are your enforcement. You need all three.

I'm not done iterating. There are still failure modes I haven't covered. But going from 70% to 95% rule compliance turned Claude Code from a brilliant but unreliable colleague into something I can actually trust with real work.

And that 25% difference? It's the difference between supervision and delegation.

---

## Resources

- [Superpowers GitHub](https://github.com/obra/superpowers) — The plugin itself (MIT, 80K+ stars)
- [Superpowers blog post by obra](https://blog.fsck.com/2025/10/09/superpowers/) — Jesse Vincent's writeup on the design philosophy
- [Claude Code Skills docs](https://code.claude.com/docs/en/skills) — Official documentation on the skill system

---

*Written in Tokyo.*
*Questions or feedback? Find me on X: [@DavidAi311](https://x.com/DavidAi311)*
