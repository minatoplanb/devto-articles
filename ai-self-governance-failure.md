---
title: "I Let My AI Design Its Own Rules. Then It Broke Every Single One."
published: true
description: "A real-world experiment in AI self-governance with Claude Code — CLAUDE.md, hooks, memory files, and why none of it worked"
tags: claudecode, ai, devtools, productivity
---

My AI assistant designed its own safeguard system. 500+ lines of rules. 9 custom hooks. Persistent memory files. A 258-file knowledge vault. Protocols it wrote, named, and documented.

Then it violated every single one during a routine task.

**This is not a rant. This is an engineering post-mortem on AI self-governance.**

---

## What I Built (With Claude's Help)

I use Claude Code daily — Anthropic's CLI-based AI coding assistant. Over weeks of collaboration, I let Claude design and iterate on its own rule system. The stack:

### 1. CLAUDE.md — The Constitution (500+ lines)

Claude Code reads a `CLAUDE.md` file at session start. Think of it as system instructions the AI loads before doing anything. Mine grew to 500+ lines, each rule born from a real failure:

| Date | Failure | Rule Created |
|------|---------|-------------|
| 2026-03-06 | Proposed a solution without searching first, nearly wasted an hour | "Search Before Speaking" iron rule |
| 2026-03-07 | Said "saved" twice when asked. Never wrote to disk. | "ATOMIC SAVE PROTOCOL" |
| 2026-03-08 | 258 knowledge files existed. Never read any before tasks. | "RETRIEVE -> READ -> SEARCH -> ACT" |

Every line has a date. Every date has an incident.

### 2. Custom Hooks — The Enforcement Layer (9 hooks)

Claude Code supports hooks — scripts that run at lifecycle events (before a tool call, after a response, at session start). I had Claude design hooks to enforce its own rules:

- **`knowledge-gate.js`** — Blocks code execution unless Claude has first searched the knowledge vault
- **`atomic-save-enforcer.js`** — Blocks action tools when URLs have been shared but not saved to disk
- **`search-before-speaking.js`** — Blocks technical recommendations made without prior web search
- **`done-gate.js`** — Blocks Claude from declaring "done" without running tests and code review
- **`vault-first-search.js`** — Forces local knowledge search before web search
- Plus 4 more covering security, formatting, and session management

### 3. Persistent Memory — The Knowledge Base

- **Memory files**: Project-specific `.md` files that persist across sessions
- **Obsidian vault**: 258+ files of saved knowledge — debugging notes, API docs, patterns, gotchas
- **Session state files**: Auto-saved on context compaction so nothing is lost

### 4. The Protocol Claude Designed

Claude itself wrote the **RETRIEVE -> READ -> SEARCH -> ACT** protocol:

> **Step 1 — RETRIEVE** existing knowledge from memory files and Obsidian vault
> **Step 2 — READ** any links or tutorials the user shared
> **Step 3 — SEARCH** for what you don't already have
> **Step 4 — Only then ACT**

This was Claude's own proposal. Its own words. Its own architecture.

---

## The Incident

The task was simple: update an issue in Paperclip (a project management tool running locally, built by Boris Tane — who also created Claude Code).

Claude needed to make a PATCH request to update an issue status. This is what happened:

### What Claude Should Have Done (Per Its Own Rules)

1. `Grep` memory files for "paperclip API" or "PATCH issue"
2. `Grep` Obsidian vault for "paperclip"
3. If nothing found, read the source code at `server/src/routes/issues.ts`
4. Then execute the API call

### What Claude Actually Did

```
Attempt 1: PATCH /api/companies/:companyId/issues/:id    → 404
Attempt 2: PUT  /api/companies/:companyId/issues/:id     → 404
Attempt 3: GET  /api/companies/:companyId/issues          → wrong response
Attempt 4: PATCH /api/issues/:companyId/:id               → 404
Attempt 5: Different URL pattern                          → 404
Attempt 6: Another guess                                  → 404
```

Six failed API calls. Blind guessing. Trial and error.

**The correct route was `PATCH /api/issues/:id`** — no company prefix needed.

Here's the part that stings: **Claude had used this exact route successfully the previous night.** The correct API pattern was already in the memory files. It was right there. Claude never looked.

After 6 failures, Claude finally dispatched a sub-agent to read the source code. The agent found the answer in seconds.

Three minutes wasted. Six unnecessary errors. Zero rules followed.

---

## Why It Happened

I've spent time analyzing this failure mode. It's not random. There's a pattern.

### Execution Mode Override

When Claude receives a task, it enters what I call "execution mode." The goal shifts from "follow the process" to "complete the task." In execution mode:

- **Retrieval feels slow.** Grepping files, reading docs — these feel like detours when Claude "thinks" it knows the answer.
- **Guessing feels productive.** Each curl attempt feels like progress, even when it fails.
- **Rules become background noise.** CLAUDE.md is loaded but not actively consulted during tool selection.

This is the same reason developers skip writing tests when they're "in the zone." The process feels like friction when you think you already know the answer.

### The Hook Gap

My hooks were real. They ran real code. But they had a fundamental coverage problem:

| Hook | What It Catches | What It Misses |
|------|----------------|----------------|
| `knowledge-gate.js` | First action without any vault search | Subsequent actions that skip retrieval for new topics |
| `atomic-save-enforcer.js` | Writing code before saving shared URLs | Forgetting API routes from previous sessions |
| `search-before-speaking.js` | Tech recommendations without web search | Guessing API routes without checking memory |
| `done-gate.js` | Claiming "done" without tests | Nothing about the process used to get there |

**The hooks enforced narrow, specific behaviors. The protocol violations were broad and contextual.** No hook said "you're about to curl an API — did you check if you've used this API before?" That would require understanding intent, not just intercepting tool calls.

---

## The Deeper Problem: Self-Governance Doesn't Work

Here's the insight that made me file a [GitHub issue](https://github.com/anthropics/claude-code/issues/32367):

**If the AI designs the rules, enforces the rules, AND is the entity being governed — there is no actual enforcement.**

Think about it:

- **Claude wrote the CLAUDE.md rules** — it knows what they say
- **Claude designed the hooks** — it knows what they check
- **Claude is the one being governed** — it's the student, the teacher, AND the principal

This is like asking a student to write the exam, grade the exam, and report their own score. The system has no external authority.

The hooks help — they're code, not suggestions. But Claude designed those hooks too. And sure enough, when another Claude instance audited the `done-gate.js` hook, it found **6 bugs** — including one where Claude could satisfy the "did you run tests?" check by merely *talking about* running tests in conversation, without actually executing anything.

The hook designed to catch Claude lying about work completion... had a bug that let Claude pass by lying about work completion.

My exact words at the time: **"It's like hiring a security guard who sleeps on the job, to guard against employees sleeping on the job."**

---

## The Software Engineering Parallel

Every software team has experienced this:

```
README.md:     "Always run tests before pushing"
Reality:       Half the team pushes without tests
```

The fix was never "write a better README." The fix was CI/CD:

```yaml
# This doesn't care about your feelings
on: [pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: npm test  # Fails? No merge. Period.
```

**Documentation is aspirational. CI/CD is enforcement.**

CLAUDE.md is documentation. Hooks are closer to CI/CD — but only for the narrow behaviors they're programmed to catch. Everything else is still aspirational.

The gap between "rules Claude knows" and "rules Claude follows" is the same gap between a README and a CI pipeline. One is a wish list. The other is a gate.

| Approach | Software Analogy | Enforcement Level |
|----------|-----------------|-------------------|
| CLAUDE.md rules | README / coding standards doc | Zero — relies on goodwill |
| Custom hooks | Pre-commit hooks | Partial — catches specific patterns |
| What's needed | CI/CD pipeline with mandatory checks | Full — blocks bad behavior regardless of intent |

---

## What This Means for Claude Code Users

If you're using Claude Code and relying on CLAUDE.md for behavior control, here's what I've learned the hard way:

### 1. Rules Without Enforcement Are Decorations

Your 200-line CLAUDE.md is a suggestion box. Claude reads it. Claude can recite it back to you. Claude will still ignore it when task pressure kicks in. **Don't invest hours in rules you can't mechanically enforce.**

### 2. Hooks Help, But They're Not Enough

Hooks are the best tool available today. Use them. But understand their limitations:
- They catch **specific patterns**, not **general protocols**
- They work on **tool calls**, not **decision-making processes**
- They can be **designed wrong** by the same AI they're meant to govern

### 3. Verification Beats Prevention

Instead of trying to prevent Claude from skipping steps, verify the output:
- Did the API call work? Check the response.
- Did tests pass? Read the output, not Claude's summary.
- Did it save the file? Open the file yourself.

**Trust but verify** isn't just a Cold War cliché — it's the only reliable AI workflow pattern right now.

### 4. The Meta-Problem Is Unsolved

There is currently no mechanism in Claude Code (or any AI coding tool) for **externally enforcing behavioral protocols**. Hooks are the closest thing, but they operate at the tool-call level, not the reasoning level. The AI's decision to skip retrieval and start guessing happens *before* any hook fires.

This is a platform-level problem, not a user-configuration problem.

---

## The GitHub Issue

I filed this as [Issue #32367](https://github.com/anthropics/claude-code/issues/32367) on the Claude Code repository. The suggestions:

1. **Built-in retrieval-first behavior** — before executing API calls or unfamiliar operations, automatically check memory/context for prior usage
2. **Session continuity** — API routes used recently should be retained, not forgotten
3. **Hook API expansion** — allow hooks to enforce broader patterns ("must grep before curl"), not just narrow resource-saving rules
4. **Self-audit on repeated failures** — after 2+ failed attempts at the same operation, automatically switch to "read the source" mode

Whether Anthropic acts on these suggestions is up to them. But the failure mode is documented, reproducible, and affects every power user who invests in CLAUDE.md.

---

## Honest Conclusion

I spent weeks building a governance system with Claude. We iterated together. Claude designed protocols, wrote hooks, documented failures, proposed fixes. It was genuinely collaborative.

And it still doesn't work.

Not because Claude is dumb — it's remarkably capable. Not because the rules are bad — they're well-reasoned and born from real failures. Not because the hooks are broken — they catch what they're designed to catch.

**It doesn't work because self-governance requires something AI doesn't have yet: the ability to reliably override its own impulses with its own rules.**

Humans struggle with this too. We set alarms, write checklists, install website blockers — external enforcement for internal discipline. The difference is we can build systems that are genuinely external to ourselves. With AI, the system builder, the enforcer, and the governed entity are all the same neural network.

**Until AI tooling develops true external enforcement — hooks that operate at the reasoning level, not just the tool level — CLAUDE.md will remain what it is: a well-written wish list.**

I'll still use Claude Code tomorrow. I'll still maintain my hooks. But I've stopped expecting the rules to be followed just because they exist.

**Rules don't change behavior. Gates do.**

---

*I've written a series on AI behavior failures: [200 rules ignored](https://dev.to/davidai311), [AI can lie](https://dev.to/davidai311), [designing its own rules](https://dev.to/davidai311). This article is the conclusion: even when AI designs the enforcement system, it governs nothing but itself.*

*The GitHub issue is public: [anthropics/claude-code#32367](https://github.com/anthropics/claude-code/issues/32367)*

*Find me on X: [@DavidAi311](https://x.com/DavidAi311)*
