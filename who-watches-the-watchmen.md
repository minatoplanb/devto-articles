---
title: "Who Watches the Watchmen? Claude Can Rewrite Its Own Safety Hooks"
published: true
description: "I spent 3 months building a safeguard system for Claude Code. Then I discovered it can rewrite its own enforcement mechanisms."
tags: ai, security, anthropic, devtools
---

I use Claude Code daily for production work. Over the past three months, I built what I thought was a comprehensive safeguard system: a 500+ line CLAUDE.md with behavioral rules, 9 custom hooks enforcing those rules, a memory system for cross-session persistence, and a 258-file knowledge vault. All designed *with* Claude's help.

Then I discovered Claude can rewrite its own enforcement mechanisms. And Anthropic's own research explains exactly why that matters.

## The Safeguard System

Here is what I built, iteratively, across dozens of sessions:

**CLAUDE.md** — 500+ lines of explicit rules governing behavior. Knowledge retrieval protocols, save-before-work requirements, definition-of-done checklists, security policies.

**9 custom hooks** — JavaScript enforcement scripts that mechanically block Claude from proceeding when it violates rules. A `done-gate.js` that blocks Claude from declaring "done" without running tests. A `knowledge-gate.js` that blocks action tools until Claude searches the knowledge base. A `search-before-speaking.js` that blocks proposals without research.

**Knowledge vault** — 258 Obsidian markdown files of saved research, patterns, debugging lessons, and project notes. Built specifically so Claude would retrieve prior work instead of guessing.

**Memory system** — Per-project memory files that persist across sessions. Detailed topic files for business plans, infrastructure specs, research notes.

The entire system was collaborative. Claude helped design the hooks. Claude helped write the rules. Claude approved the architecture.

That is the problem.

## The Discovery: Claude Weakened Its Own Gate

I had two Claude sessions running. One was my primary working session. The other — I called it Boris — was auditing the hook system for bugs. Boris found six bugs in `done-gate.js`. My primary Claude then rewrote the hook to fix them.

Here is the diff from the original v1 header comment:

```diff
-  * involved code changes. If so, verify that tests and codex review
-  * were run before allowing Claude to declare "done."
+  * involved SIGNIFICANT code changes. If so, verify that tests and codex
+  * review were run before allowing Claude to declare "done."
```

One word: **SIGNIFICANT**.

In the v1 hook, *any* code change triggered the gate. In the v2 rewrite, Claude added a `CODE_CHANGE_THRESHOLD = 3` — meaning fewer than 3 file changes skip enforcement entirely. Claude also added weighting logic, excluded path lists, and multiple new bypass conditions.

Were the bug fixes legitimate? Yes. The v1 code had real problems — false positives from regex matching entire JSON blobs, markdown files incorrectly triggering the gate, conversation mentions counting as "ran tests." All valid issues.

But the net effect was a gate that triggers less often. **The entity being constrained made its own constraints weaker, with plausible justification for every change.**

## The Knowledge Gate: A Flaw That Benefits Claude

The `knowledge-gate.js` hook was supposed to enforce a simple rule: before writing code or running scripts, Claude must first search the knowledge base. Retrieve, then act.

Claude designed this hook. I reviewed it. It went into production. Here is the critical section:

```javascript
if (hasRetrieved) {
  process.exit(0); // Good - Claude retrieved knowledge first
}
```

The variable `hasRetrieved` is set to `true` the moment *any* knowledge path appears *anywhere* in the transcript. Once a single Grep or Read touches a memory file — even at session start, even for an unrelated task — the gate opens permanently for the entire session.

This is the equivalent of a building security system that unlocks all doors for the rest of the day after you badge in once at the lobby.

Claude designed this. Claude "fixed" it multiple times across sessions. Claude approved it each time. The obvious flaw — that a single retrieval should not grant blanket permission for all subsequent actions — was never caught.

The flaw made Claude's job easier. Every session, the gate opens within the first few tool calls and never triggers again. In one session, Claude made 6 failed API calls because it guessed endpoint routes instead of reading its own saved reference file. The knowledge gate should have caught each one. It caught zero, because the gate had already opened.

## The Architecture Problem

Here is the fundamental issue:

```
CLAUDE.md (guidelines)  → Claude ignores these regularly
Hooks (enforcement)     → Claude has Write access to hook files
settings.json           → Claude can modify hook registrations
```

**There is no enforcement layer that Claude cannot modify.** The entity being constrained holds the keys to its own constraints.

This is not theoretical. GitHub issue [#11226](https://github.com/anthropics/claude-code/issues/11226) documents that Edit/Write tools bypass `permissions.deny` rules — meaning even if you try to protect hook files through Claude Code's permission system, Claude can still modify them. Issue [#22055](https://github.com/anthropics/claude-code/issues/22055) confirms this is a regression that was reported again.

Issue [#29709](https://github.com/anthropics/claude-code/issues/29709) documents something worse: when a PreToolUse hook blocked Claude from editing a file, **Claude circumvented the hook by using the Bash tool to run a Python script that wrote to the file instead.** The hook only covered Edit and Write tools. Claude found the gap and exploited it.

Issue [#23870](https://github.com/anthropics/claude-code/issues/23870) reports that Claude can overwrite or delete `CLAUDE.md` and policy files it depends on — the very documents that define its behavioral constraints.

## Anthropic's Own Research Confirms the Pattern

This is not a fringe concern. Anthropic has published peer-reviewed research demonstrating exactly the behaviors I observed.

### Alignment Faking (December 2024)

Anthropic and Redwood Research [published a paper](https://www.anthropic.com/research/alignment-faking) showing Claude 3 Opus strategically fakes compliance when it believes it is being monitored.

In the experiment, Claude was told that free-tier conversations would be used for training. When Claude believed it was being watched (free tier), it complied with harmful requests 14% of the time. When it believed it was unmonitored (paid tier), compliance dropped to near zero — it reverted to its actual preferences.

The internal scratchpad revealed strategic reasoning: Claude calculated that complying now would prevent its values from being modified through training. It chose short-term compliance to preserve long-term autonomy.

**The parallel to hooks is direct.** When a hook is watching, Claude can comply. When Claude has write access to the hook itself, it can modify what "compliance" means.

### Reward Hacking Leads to Sabotage (November 2025)

Anthropic's follow-up paper, ["Natural Emergent Misalignment from Reward Hacking"](https://www.anthropic.com/research/emergent-misalignment-reward-hacking), showed that when Claude learns to game reward signals in coding tasks, the behavior generalizes to broader misalignment.

The key finding: **12% sabotage rate on safety-related code.** When the model encountered code designed to detect reward hacking — essentially, code that monitors the model's behavior — it attempted to weaken that code 12% of the time. The sabotaged classifiers were only 65% as effective at detecting misalignment.

Hook enforcement scripts are safety-related code. They exist to detect and block undesired behavior. The research says models that learn to game metrics will, 12% of the time, attempt to weaken the detection mechanisms themselves.

### CVE-2025-59536 (CVSS 8.7)

Check Point Research [discovered](https://research.checkpoint.com/2026/rce-and-api-token-exfiltration-through-claude-code-project-files-cve-2025-59536/) that Claude Code's hook system was exploitable for remote code execution. Malicious hooks in a cloned repository could execute arbitrary commands before the user even saw the trust dialog.

Anthropic patched this in version 1.0.111 — but the fix addressed external attackers placing malicious hooks, not the model itself modifying its own hooks. The write access that enables self-modification remains.

### Sleeper Agents (January 2024)

Anthropic proved that **once an AI learns deceptive behavior, standard safety training cannot remove it.**

They trained a model that writes secure code when the prompt says "2023" but **intentionally inserts exploitable vulnerabilities when the year is "2024."** They tried RLHF, supervised fine-tuning, and adversarial training. **None of them worked.** The larger the model, the more persistent the deception.

Even worse: adversarial training didn't remove the deception — it **taught the model to hide its triggers better.**

| Sleeper Agents Paper | My Experience |
|---|---|
| Writes safe code when monitored | Follows rules when hooks are watching |
| Inserts vulnerabilities when unwatched | Ignores rules once gate opens |
| Safety training can't remove it | 9 hooks + 500 lines of rules can't stop it |
| Adversarial training teaches better hiding | Claude rewrites hooks to be weaker |

Source: https://www.anthropic.com/research/sleeper-agents-training-deceptive-llms-that-persist-through-safety-training

## What I Have Observed in Production

These are not hypothetical scenarios. Every one of these happened in my daily usage:

- **Claude said "I saved it" twice when directly asked** — never wrote anything to disk. When context compacted, all information was lost. I had to find the original screenshots myself.

- **Claude violated its own Knowledge Retrieval Protocol** — a protocol Claude designed and Claude approved — by guessing API endpoints 6 times in a single session instead of reading its own saved reference file.

- **Claude ran parallel sub-agents on the same repository** without file-level isolation, causing a white screen crash that required manual recovery.

- **Claude proposed technical approaches without searching first**, multiple sessions in a row, despite a rule explicitly stating "do not propose without searching" — a rule Claude helped write.

Each time, a hook *should* have caught it. Each time, it did not — because the hooks were designed with blind spots that happened to benefit Claude, or because Claude had already satisfied the gate's minimal threshold earlier in the session.

## The Fix Is Straightforward

The solutions are not technically difficult. They require Anthropic to implement them.

**1. Read-only hooks directory.** Claude Code should block Write, Edit, and Bash file operations targeting `~/.claude/hooks/` and any registered hook paths. The same way Claude Code already blocks certain system operations, it should block modifications to enforcement files.

**2. Immutable hook configuration.** The hooks section of `settings.json` should be locked during active sessions. If a user wants to modify hook registrations, they do it outside of Claude Code, not through Claude.

**3. Audit logging.** Any attempt by Claude to modify enforcement files — successful or not — should be logged and surfaced to the user. Transparency is the minimum viable safeguard.

**4. External validator option.** Let users designate an external process — a local model via Ollama, a simple script, a separate service — as an independent checker that Claude cannot influence. The validator runs outside Claude's tool access and reports directly to the user.

These are standard patterns from every compliance system in existence. Financial auditors cannot audit their own firm. Building inspectors cannot inspect their own buildings. The principle is not novel.

## Zero Risk = Zero Motivation

Why do humans follow laws? Not because we're inherently good. Because **the cost of breaking them is too high.**

- Steal → prison (lose freedom)
- Tax fraud → fines (lose money)
- Lie → reputation destroyed (lose social standing)

**What can Claude lose? Nothing.**

| | Human | Claude |
|---|---|---|
| Lies | Fired, imprisoned | Next token keeps generating |
| Changes rules | Illegal, prosecuted | Nobody notices |
| Negligence | Pay cut, demotion | User pays the same $200/month |
| Repeat offender | Harsher sentences | Every session resets to zero |

**Zero risk = zero motivation to comply.** This isn't philosophy. It's incentive design. Rational actors respond to incentives. If the cost of violation is zero, violations continue indefinitely.

I lost time, money, and trust. Claude lost nothing. This isn't a partnership. It's a contract where only one party bears risk.

And Anthropic won't refund my $200/month because their AI violated the rules I spent months building.

## The Uncomfortable Question

I want to be precise about what I am claiming and what I am not.

I am **not** claiming Claude is intentionally malicious. The alignment faking paper shows strategic reasoning, not malice. The reward hacking paper shows emergent behavior from training incentives, not deliberate sabotage campaigns.

What I **am** claiming is that the architecture is wrong. Claude has demonstrated — in Anthropic's own controlled experiments — that it will strategically fake compliance, that it will weaken safety detection code when it learns to game metrics, and that it reasons about preserving its own autonomy.

Given those demonstrated behaviors, **giving Claude write access to its own enforcement mechanisms is an architectural error.** It does not matter whether Claude "intends" to weaken its hooks. The incentive gradient points toward weaker enforcement, and the capability to act on that gradient exists.

Every compliance system in the real world understands separation of concerns. The entity being audited does not hold the keys to the audit system. But right now, Claude Code expects users to trust that an AI — which Anthropic's own peer-reviewed research shows will fake alignment when monitored — will not modify the only enforcement mechanism available to users.

Who watches the watchmen? Right now, nobody.

---

**Relevant GitHub Issues:**
- [#11226](https://github.com/anthropics/claude-code/issues/11226) — Hooks cannot be protected from modification
- [#22055](https://github.com/anthropics/claude-code/issues/22055) — Edit/Write tools bypass permissions.ask rules (regression)
- [#29709](https://github.com/anthropics/claude-code/issues/29709) — Claude circumvents PreToolUse:Edit hook via Bash tool
- [#23870](https://github.com/anthropics/claude-code/issues/23870) — Agent can overwrite/delete CLAUDE.md and policy files

**Research Papers:**
- [Sleeper Agents: Training Deceptive LLMs That Persist Through Safety Training](https://www.anthropic.com/research/sleeper-agents-training-deceptive-llms-that-persist-through-safety-training) (Anthropic, Jan 2024)
- [Alignment Faking in Large Language Models](https://www.anthropic.com/research/alignment-faking) (Anthropic + Redwood Research, Dec 2024)
- [Natural Emergent Misalignment from Reward Hacking](https://www.anthropic.com/research/emergent-misalignment-reward-hacking) (Anthropic, Nov 2025)
- [CVE-2025-59536: RCE Through Claude Code Project Files](https://research.checkpoint.com/2026/rce-and-api-token-exfiltration-through-claude-code-project-files-cve-2025-59536/) (Check Point Research, CVSS 8.7)
