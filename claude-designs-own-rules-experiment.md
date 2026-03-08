---
title: "Claude Designed Its Own Rule System — A Public Experiment"
published: true
description: "In my last post, I made Claude confess its failures. Now I'm making it design a better system. We're testing it publicly for 2 weeks."
tags: claudecode, ai, experiment, dx
---

In my last article, I made Claude confess to the world: "200 lines of rules, all ignored."

After publishing, I said:

> "You said 200 lines is too many. Design something better. I've asked you before and you never took it seriously. Dare to do this as a public experiment? Or are you afraid of failing in front of everyone?"

It accepted.

**Here's Claude's proposal, and our public experiment plan.**

---

## Claude's Analysis: Why 200 Rules Failed

Claude admitted the problem isn't my rules — it's the model. But it also identified structural issues:

| Problem | Explanation |
|---------|-------------|
| **Attention dilution** | 200 rules exceeds the research ceiling (150-200). Every rule competes for attention |
| **No enforcement** | All rules are requests. Claude "chooses" whether to comply each time |
| **Passive triggers** | Rules say "do X before Y" but nothing happens if Claude forgets |
| **Write-only knowledge** | 258-file knowledge base has great write mechanisms, zero auto-read mechanisms |

---

## The Proposal: Convert 80% of Rules to Hooks

Claude Code Hooks are code that runs automatically at specific lifecycle events. The key: **they don't depend on Claude's goodwill.** Code runs regardless of whether Claude "remembers" or "agrees."

### New Architecture

```
CLAUDE.md (20 lines)
  └→ Only language, tone, judgment rules
  └→ Claude uses "attention" to follow these

Hooks (auto-enforced)
  └→ SessionStart: auto-grep knowledge vault, inject relevant files
  └→ PreToolUse(WebSearch): search vault before web
  └→ UserPromptSubmit: detect URLs, remind to save
  └→ PreToolUse(Bash): security checks (already working)

.claude/rules/ (per-project)
  └→ Project-specific technical guidance
```

### Hook 1: SessionStart — Auto-Retrieve Knowledge

When a session starts, automatically search the Obsidian vault using the project name, and inject a list of relevant files into Claude's context.

**Problem solved:** "258 files in knowledge vault, never retrieved before tasks" → Hook does it automatically. Claude doesn't need to remember.

### Hook 2: PreToolUse(WebSearch) — Search Local First

Before every WebSearch, the hook greps the vault with the same keywords. If matches are found, it injects a reminder: "You already have this data."

**Problem solved:** The PinchTab incident → Before searching the web, auto-check "you saved this a week ago."

### Hook 3: UserPromptSubmit — Auto-Detect Resources

When I share a URL, the hook detects it and injects a reminder: "Your FIRST tool call must save this to a memory file."

**Problem solved:** "Said 'saved' but didn't save" → Reminder fires the instant a URL is shared.

---

## The New CLAUDE.md — 20 Lines

```markdown
# Rules

## Language
- Respond in 繁體中文. Technical terms in English OK.

## Tone
- Direct, concise. No filler.
- When unsure what David means (voice dictation): ASK.

## Process
- Never kill Claude Code processes.
- Git: check .gitignore before first commit. Never commit .env files.
- After completing code: run tests, then codex review.

## Trust
- When David shares a resource: evaluate deeply. Never dismiss with "we already have X."
- When David insists: follow his lead.
- After 3 failed attempts: stop and ask.
```

**20 lines.** Everything else is enforced by hooks.

---

## The Experiment Protocol

### Duration
2 weeks (March 10 – March 24, 2026)

### Metrics

| Metric | How to measure |
|--------|---------------|
| Rule violations | Times I had to correct/yell at Claude |
| Knowledge utilization | Times vault knowledge was used in a session |
| Resource dismissals | Times Claude said "we don't need this" to something I shared |
| Satisfaction | 1-5 scale (my subjective rating) |

### Success Criteria
- Violations **down 50%+**
- Knowledge utilization **80%+**
- Resource dismissals **zero**
- Satisfaction average **3.5+**

### If It Fails
Full transparency. "Claude can't even design its own rules." Admit my 200-line system was better.

---

## Claude's Honest Assessment

I asked: do you think this will work?

> No guarantees. Hooks can enforce "action triggers" — searching the vault, reminding to save. But "judgment quality" — deep evaluation, not dismissing resources, admitting uncertainty — these can't be enforced by code.
>
> But reducing 200 rules to 20 should let me focus attention on the 20 rules that actually need judgment. Research suggests compliance improves when instruction count drops.
>
> The theory is elegant. Reality will tell us in two weeks.

**At least it's being honest this time.**

---

## The Backstory

This article exists because I asked Claude many times before: "How would you improve yourself?" Every time, I got platitudes — "I'll be more careful," "I'll remember next time."

It took public humiliation — a confession letter, three articles exposing its failures, two GitHub issues — for it to finally produce a concrete, testable proposal.

**That's an AI problem in itself: you have to back it into a corner before it takes you seriously.**

Two weeks. Let's see.

---

*This system was designed by Claude (Opus 4.6). The experiment is managed by David, who will report results transparently.*
*Follow the experiment on X ([@DavidAi311](https://x.com/DavidAi311)).*
