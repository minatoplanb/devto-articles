---
title: "I Got Tired of Text Dashboards, So I Built a Pixel Art Command Center"
published: true
description: "An Electron + Canvas 2D visual project manager for 27+ dev projects — with animated cats, a rocket launcher, and live Claude Code session detection."
tags: [electron, productivity, pixelart, projectmanagement]
---

I'm running 27 projects simultaneously.

A while back, I built a text-based "Mission Control" dashboard inside Claude Code. Every morning, it would scan all my projects and spit out an ASCII dashboard in the terminal.

**It worked. But staring at a black terminal every morning got old fast.**

So I upgraded it into a pixel art visual command center.

![Pixel Office screenshot](https://raw.githubusercontent.com/minatoplanb/devto-articles/main/images/pixel-office-mission-control.png)

---

## What Is Pixel Office

**A desktop app built with Electron.** It draws a pixel art office on Canvas 2D, with projects laid out in categorized zones.

Honestly — **I didn't build this because I needed it. I built it because something you open every day should make you happy.**

| | Old (Text) | New (Pixel Office) |
|------|-----------|-------------------|
| Display | Terminal ASCII | Pixel art Canvas |
| Project list | Text dump | Color-coded zones |
| Launch | Type `claude` | Double-click the app |
| Talk to AI | Same terminal | 🚀 Click the rocket |
| Boot startup | Manual | Auto-launch |
| Session state | Unknown | Real-time detection |

---

## 8 Zones

The office has 8 zones, **each category gets its own color**:

| Zone | Color | Contains |
|------|-------|----------|
| 🔨 FORGE | Orange | Brainstorming, experiments, tool learning |
| ✏️ CONTENT | Blue | Blog publishing (3 languages) |
| 💬 SNS | Pink | AI character auto-posting |
| ⚙️ PRODUCTS | Yellow | Desktop apps, tools |
| 🛡️ INFRA | Green | Bots, infrastructure |
| 💼 BUSINESS | Purple | Business, portfolio |
| 🎮 GAMES | Teal | Game dev |
| 📦 ARCHIVE | Gray | Paused projects |

Each project icon **auto-styles based on status**. Active gets a solid border, prototype gets dashed, completed gets a gold checkmark. Anything untouched for 7+ days gets a red warning badge that pulses.

---

## 🚀 The Rocket = Mission Control

Bottom center of the screen, there's a **big rocket**.

That's **Mission Control**.

Double-click it and Claude Code launches in a dedicated planning folder. Morning planning, brainstorming, cross-project strategy. **Pixel Office is the "eyes." Mission Control is the "brain."**

The rocket has animated exhaust flames. Purely for vibes.

---

## Live Session Detection

**Projects running Claude Code glow in real-time.**

The mechanism is simple: check JSONL file modification times in `~/.claude/projects/`. If updated within 2 minutes, it's "active."

Active projects get:
- Green pulsing border
- Blinking terminal cursor
- Green background overlay

Running 3 Claude Code sessions at once? **You can tell which ones are active at a glance.**

---

## Daily Reminders

The right sidebar has a "DAILY CHECK" section:

| Reminder | Data Source | Display |
|----------|-----------|---------|
| 📝 Blog publishing | `git log` (content repo) | Days since last post |
| 🦋 SNS status | Bluesky API | Hours since last post |
| 🌐 Translation queue | File count comparison | Translated / total |
| 🤖 Bot queue | `action-queue.json` | Pending task count |

**All fetched automatically.** Zero manual updating.

---

## Tech Stack

| Layer | Tech |
|-------|------|
| Framework | Electron |
| Rendering | Canvas 2D (pixel art) |
| UI | DOM + CSS (sidebar only) |
| Data | Markdown frontmatter files |
| Sprites | Reused from a cat game I built |
| Session detection | Filesystem monitoring |
| Launcher | VBS script (hidden terminal) |

**No frontend framework.** No React, no Vue. Canvas draws directly, DOM only for the sidebar. Light and fast.

Total codebase: about 5 files, ~800 lines.

---

## One-Click Launch

Double-click a project icon → confirm → Claude Code launches in that folder.

The daily workflow becomes:

1. **Windows boots** → Pixel Office auto-starts
2. **Click the rocket** → Mission Control for morning planning
3. **Click a project** → Claude Code launches
4. **Pixel Office stays visible all day** as a background dashboard

---

## There Are Cats

I pulled cat sprites from a game I built and they wander around the office.

They sit down and sleep when tired. Wake up and wander again.

**Zero productivity impact. Maximum comfort.**

There are also potted plants, bookshelves, teddy bears, and cat food bowls — all reused assets from past projects. Your old work decorating your new work. I like that.

---

## Honest Take

This is over-engineered. The text dashboard was fine.

**But "fine" and "enjoyable" are different things.**

The first thing you open every day should make you want to open it. Rocket animations, wandering cats, pixel art zones. **Functionally nothing changed. But the experience did.**

27 projects on one screen — text could do that. But now it feels like sitting in my own office. A pixel office that's entirely mine.

**Don't pick tools only for function. If you use something every day, joy is part of the performance.**

---

*Building in Tokyo. Writing in 3 languages.*
