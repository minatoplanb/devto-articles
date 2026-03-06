---
title: "GPT-5.4 Just Dropped. Here's What I Think as a Heavy Claude Code User"
published: true
description: "OpenAI released GPT-5.4 with three variants. As someone who uses Claude Code 12+ hours daily, here's my honest analysis of what matters for developers."
tags: [ai, openai, chatgpt, webdev]
---

Yesterday, OpenAI released GPT-5.4.

I use Claude Code 12+ hours a day. When a competitor drops a new model that beats Opus 4.6 on several benchmarks, I pay attention. **So I spent the evening digging into what actually matters.**

This isn't a hype piece. It's a developer's honest analysis.

---

## GPT-5.4 Is Three Models, Not One

First, let's get this straight. GPT-5.4 ships as **three variants**:

| Model | Think of it as | Best for |
|-------|---------------|----------|
| **GPT-5.4** | Daily driver | Chat, code gen, general tasks |
| **GPT-5.4 Thinking** | Off-road vehicle | Reasoning-heavy tasks with visible chain-of-thought |
| **GPT-5.4 Pro** | F1 race car | Maximum performance, enterprise workloads |

The Thinking model has an interesting twist: **it shows you its plan upfront**, so you can redirect mid-response if it's heading the wrong way. Claude's Extended Thinking shows reasoning too, but you can't intervene mid-stream. That's a meaningful difference.

---

## Benchmarks: GPT-5.4 Wins on Paper

Let's look at the numbers everyone's talking about.

| Benchmark | GPT-5.4 | Opus 4.6 | Gemini 3.1 Pro |
|-----------|---------|----------|----------------|
| **GDPval** (professional knowledge) | **83.0%** | 78.0% | — |
| **OSWorld** (computer use) | **75.0%** | 72.7% | — |
| **BrowseComp** (web browsing) | **89.3%** (Pro) | — | 85.9% |
| **SWE-Bench Pro** (software eng) | **57.7%** | — | 54.2% |

On paper, GPT-5.4 looks dominant.

**But benchmarks and real development experience are different things.**

I build and deploy Telegram bots with Claude Code every day. What matters to me isn't a benchmark score — it's **whether the AI can nail a 10-file refactor in one shot**.

---

## Three Features Developers Should Care About

### 1. Native Computer Use

GPT-5.4 has **built-in computer operation at the API level**. Opening browsers, manipulating spreadsheets, multi-app workflows.

This directly competes with Claude's Computer Use. On the OSWorld benchmark, GPT-5.4 scored 75.0% — surpassing human performance at 72.4%.

**What this means:** If you're building agents, it's time to seriously evaluate both options.

### 2. 1M Token Context Window

The API supports **one million tokens**. The largest context window OpenAI has ever offered.

Feed an entire codebase for refactoring. Load a complete spec document and ask questions. These use cases are now realistic.

**The catch:** Beyond 272K input tokens, pricing jumps to 2x input and 1.5x output. It's not an all-you-can-eat buffet.

### 3. Excel / Google Sheets Plugin (Beta)

ChatGPT now lives **inside your spreadsheets**. Build financial models, analyze data, run complex calculations.

**Claude doesn't have this.** For anyone who lives in spreadsheets — analysts, traders, finance people — this could be a game changer.

---

## The Price Reality

For developers, cost matters as much as capability.

| Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-------|----------------------|------------------------|
| **GPT-5.4** | $2.50 | $15.00 |
| **GPT-5.4 Pro** | $30.00 | $180.00 |
| **Claude Opus 4.6** | $15.00 | $75.00 |
| **Claude Haiku 4.5** | $0.80 | $4.00 |

Standard GPT-5.4 is **remarkably cheap**. One-sixth the input cost of Opus 4.6.

GPT-5.4 Pro is **12x the price**. Enterprise money. Not for indie developers.

**Cost optimization tips:** Prompt Caching saves 50-90%. Batch mode gives 50% off (24-hour processing).

---

## Will I Switch? Honestly, No.

**Not right now.**

Here's why.

My entire development workflow is built on Claude Code. Three Telegram bots, an Obsidian knowledge base, automated deploy pipelines, a Night Worker that processes tasks while I sleep. Everything runs on Claude's ecosystem.

**The cost of switching tools is far greater than a 5% benchmark difference.**

That said, GPT-5.4 has my attention in specific areas:

| GPT-5.4 strengths | Claude strengths |
|-------------------|-----------------|
| Higher Computer Use benchmark | Claude Code developer experience |
| 1M token context | Extended Thinking reasoning quality |
| Excel/Sheets integration | MCP ecosystem |
| Cheaper standard pricing | Code generation consistency |

**My take: GPT-5.4 is worth using as an API tool for specific tasks.**

For example, my bot's Night Worker runs lightweight overnight tasks — bookmark analysis, summarization. The standard GPT-5.4 at $2.50/M input could cut those costs significantly. Main development stays on Claude Code. That's the realistic hybrid strategy.

---

## What This Actually Means for Developers

The best thing about GPT-5.4 isn't the features. It's that **competition just got fiercer**.

A year ago, Claude Code was essentially the only choice for AI-assisted development. Now GPT-5.4 Thinking, Gemini 3.1 Pro, and Opus 4.6 are all going head-to-head.

**Competition drives prices down, quality up, and gives us more options.**

Which model you pick shouldn't be based on benchmark rankings. It should be based on **what fits your workflow**. For me, that's still Claude Code. In six months? Who knows.

The point isn't loyalty to a tool. It's **picking whatever makes you most productive**.

---

*Building in Tokyo. Writing in 3 languages.*
