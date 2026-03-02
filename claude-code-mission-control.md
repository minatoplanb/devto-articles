---
title: "I Built a Mission Control Dashboard with Claude Code to Manage 20+ Projects"
published: true
description: "How a single CLAUDE.md file turns Claude Code into an auto-generating project dashboard with daily reminders, status tracking, and priority suggestions."
tags: [claudecode, productivity, projectmanagement, ai]
---

Every morning, the first thing I do is double-click a rocket icon on my desktop.

Claude Code launches, **automatically scans all my projects, and displays today's dashboard.**

It looks something like this:

```
═══════════════════════════════════════════════
  MISSION CONTROL — 2026-03-02
═══════════════════════════════════════════════

📡 Active: 19 | 📋 Tasks: 12 | 🚫 Blocked: 0

─── DAILY REMINDERS ──────────────────────────
  📝 Blog: Last post 1 day ago ✅
  🤖 Bot: Auto-posting normal ✅
  💼 Business: Action items pending

─── PRODUCTS ─────────────────────────────────
  ▸ desktop-app — active | VAD model in progress
  ▸ ai-companion — active | 6 characters
  ...
═══════════════════════════════════════════════
```

I'm running 20+ projects simultaneously. Game dev, blogging, bots, products, business prep. **Normally, you'd lose track of everything.**

I don't anymore.

---

## Why Not Trello/Notion/Jira?

Let me be honest. **I hate project management tools.**

I've tried them all. None stuck. The reason is simple: **I'm too lazy to open a separate app just to update task statuses.**

Mission Control is different.

| Traditional Tools | Mission Control |
|-------------------|-----------------|
| Manual status updates | Auto-reads from project files |
| Separate app to open | Just open Claude Code |
| You decide priorities | Suggests based on deadlines & publish frequency |
| Static task lists | Dynamic dashboard regenerated daily |

**The Claude Code session itself becomes your project management tool.**

---

## How It Works: CLAUDE.md Drives Everything

The core of Mission Control is **one CLAUDE.md file.**

Claude Code reads `CLAUDE.md` on startup. Write "do these things when you start" in that file, and **it executes automatically every time.**

```markdown
# Mission Control

## Session Start Protocol
1. Scan all project notes
2. Read each project's status
3. Display dashboard
4. Ask: "What do you want to work on today?"
```

That's it. Claude Code will:

1. Read all `.md` files in your project notes folder
2. Check each project's status and last updated date
3. Verify blog posting frequency
4. Check bot health
5. Generate and display the dashboard

**You don't lift a finger.**

---

## Project Notes: A Business Card for Each Project

Each project has a `.md` file in my Obsidian vault:

```yaml
---
project: desktop-app
path: /home/user/dev/desktop-app
updated: 2026-03-01
status: active
category: product
---

## Active Tasks
- Implement VAD model
- Add tests

## Done This Session
- UI refactoring complete
```

**The key: these notes auto-update when you end each project's Claude Code session.**

Run `/update` when you're done working on a project, and its note gets refreshed. Next time you open Mission Control, **the latest state is already there.**

Zero manual maintenance.

---

## Organize by Category

Dumping 20+ projects into a flat list? Exhausting just to look at.

**Categories matter.**

| Category | Check Frequency | Examples |
|----------|----------------|----------|
| **Infrastructure** | Daily | Bots, automation tools |
| **Content** | Daily | Blogs, social posts |
| **Business** | Daily | Business prep, portfolio |
| **Products** | As needed | App development |
| **Games** | Weekly | Game development |

The CLAUDE.md defines check frequency per category.

I don't want to be nagged about game projects every day. A weekly "You have {N} active game projects. Want to work on any?" is enough.

But blog posts? Check every day. No post in 2+ days? ⚠️ alert.

**Matching reminder frequency to project type.** Simple idea, massive impact.

---

## Daily Workflow: Your Automatic Morning Checklist

The top of the dashboard shows "Daily Reminders":

```
─── DAILY REMINDERS ──────────────────────────
  📝 Blog: Last post 2026-03-01 (1 day ago) ✅
  🤖 Bot: Auto-posting normal ✅
  💼 Business: Certification incomplete
  🎨 Content: Tasks for today
```

These are defined in the `Daily Workflow` section of CLAUDE.md.

**Claude Code actually reads your project files to determine status.**

For blogs, it runs `git log` to get the last commit date. For bots, it reads log files. It can even hit APIs to check the latest post.

Write it in CLAUDE.md, **it runs every morning automatically.**

---

## Rules: What It Can and Cannot Do

Mission Control has clear boundaries.

### ✅ What it does
- Display all project statuses
- Suggest today's work order
- Track publishing frequency
- Alert on forgotten projects

### ❌ What it doesn't do
- **Never modifies project code**
- **Never deploys anything**
- **Never makes decisions for you** (suggests, doesn't decide)

**Read-only. Never write.**

This is intentional. If Mission Control started modifying your projects, that's chaos. It's a **command center**, not the **ground crew**.

---

## Build Your Own: 5 Steps

### Step 1: Create a directory

```bash
mkdir mission-control
cd mission-control
```

Doesn't need to be a git repo. **Just needs a CLAUDE.md.**

### Step 2: Write your CLAUDE.md

Minimal version:

```markdown
# Mission Control

## Session Start Protocol
1. Scan project-notes/ folder
2. Read each project's status
3. Display dashboard
4. Ask what to work on today
```

### Step 3: Create a note for each project

```yaml
---
project: my-app
path: /path/to/my-app
updated: 2026-03-01
status: active
category: product
---
```

### Step 4: Define categories and reminder frequencies

Write them in your CLAUDE.md.

### Step 5: Create a desktop shortcut

```
claude --dangerously-skip-permissions
```

Double-click every morning. Done.

---

## After 3 Weeks of Use

Here's the honest truth. **I can't go back.**

### Before
- Morning starts with "What was I doing yesterday?"
- Abandoned projects go unnoticed
- Blog posting becomes irregular
- 20+ project statuses stored only in my head

### After
- Morning starts with a full status overview
- Stale projects auto-flagged with ⚠️
- Publishing frequency auto-tracked
- **One glance tells me what to focus on today**

The biggest change: **zero time spent deciding what to do.**

Look at dashboard. Pick a project. Start working. That's it.

---

## Summary

| Component | Purpose |
|-----------|---------|
| **CLAUDE.md** | The blueprint. Defines what happens on startup |
| **Project Notes** | One `.md` per project. Auto-updated on session end |
| **Categories** | Group by type. Different check frequencies |
| **Daily Workflow** | Automatic morning checklist |
| **Rules** | Read-only. Suggest, don't decide |

**Managing 20+ projects doesn't require another tool.** Spend 30 minutes writing rules in a CLAUDE.md, and you get a dashboard that auto-generates every morning.

If you're paying monthly for a project management tool, maybe reconsider.

---

*Building in Tokyo. Writing in 3 languages.*
