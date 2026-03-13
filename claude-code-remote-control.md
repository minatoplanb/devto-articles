---
title: "Claude Code Remote Control: Run AI on Your PC, Control It from Your Phone"
published: true
description: "How I set up Claude Code's Remote Control to operate my local dev environment from anywhere. No SSH, no tmux, no Tailscale. Just scan a QR code."
tags: [ai, claudecode, productivity, remote]
---

I was at the grocery store when I remembered. The deploy. I forgot to run it.

Three seconds if I were at my desk. But I was standing in the fish aisle, staring at salmon, and all I could think about was that build sitting undeployed.

Go home and do it later? I'd forget in 30 minutes. I know myself.

**I pulled out my phone, scanned a QR code, and my Claude Code session — running on my PC at home — appeared in my mobile browser.**

Typed: "Deploy dist/ to the VM." It ran. Logs streamed. Done.

Bought the salmon too.

---

## What Is Remote Control?

**It lets you operate a Claude Code session running on your PC from any phone or browser.**

Think of it as a **baby monitor for your AI**. The baby (Claude) keeps working in the nursery (your PC). You (the parent) can peek in from the living room, the train, the grocery store — watch what it's doing, talk to it, give it instructions.

The key insight: **all execution happens on your PC.** Your phone is just a remote control. Files, tools, MCP servers — everything stays local. The phone only shows the text conversation.

```
Your phone (remote control)
    ↕ HTTPS (via Anthropic API)
Your PC (the actual workspace)
    ├── File system
    ├── MCP servers
    ├── Git, Node, etc.
    └── Claude Code session
```

---

## Setup: 3 Steps, 3 Minutes

**No server to configure. No ports to open. No software to install.**

### Step 1: Enable in config (optional)

To auto-enable Remote Control for every session:

```json
// ~/.claude/settings.json
{
  "enableRemoteControl": true
}
```

One line. Every Claude Code session becomes remotely accessible.

### Step 2: Run the command

In an existing session:

```bash
/rc
```

Or when starting a new session:

```bash
claude remote-control
```

`/rc` is shorthand for `/remote-control`.

### Step 3: Scan the QR code

Your terminal displays a **URL and QR code**. Scan it with your phone camera. It opens `claude.ai/code` in your browser.

**That's it. Your PC's Claude Code session is now on your phone.**

---

## Why This Kills SSH, tmux, and Tailscale

I used to maintain a whole stack for remote access:

- SSH server on my PC
- tmux to persist sessions
- Tailscale for VPN tunneling
- Router port forwarding rules

**Haven't touched any of them since setting up Remote Control.**

| | SSH + tmux | Tailscale | Remote Control |
|---|---|---|---|
| **Open ports** | Yes (port 22) | No (P2P) | **No (outbound only)** |
| **VPN / network config** | Required | Required | **None** |
| **Client needed** | Terminal app | Dedicated app | **Any browser** |
| **Setup time** | 30-60 min | 10 min | **3 min** |
| **Reconnect on drop** | Manual / autossh | Automatic | **Automatic (~10 min timeout)** |
| **File access** | Full (SSH) | Full (VPN) | **Via Claude** |
| **Local tools** | Yes | Yes | **Yes (including MCP)** |

**The killer difference: zero open ports.**

Remote Control works by having your local Claude Code make an **outbound HTTPS connection** to the Anthropic API. Nothing inbound. No router configuration. No firewall rules. Your PC doesn't accept any incoming connections.

---

## My Actual Setup

I use Claude Code 12+ hours daily. Multiple sessions running simultaneously. Here's the full picture.

### PC Configuration

- **Sleep: disabled** — machine runs 24/7
- **Screen off: 1 hour** — saves power, doesn't affect sessions
- **Claude Code: launched with `--dangerously-skip-permissions`** — no confirmation prompts

### Combined with Pixel Office

I built an Electron-based visual launcher called Pixel Office. It's a pixel art office on my desktop — click a room to launch a Claude Code session for that project.

**With `enableRemoteControl: true` in `settings.json`, every session launched from Pixel Office is automatically controllable from my phone.**

The daily workflow:

1. Morning: launch projects from Pixel Office
2. Work at desk
3. Leave for lunch — scan QR code on phone (or open bookmarked URL)
4. On the train: direct a code review
5. At the store: check deploy status
6. Get home, sit at desk — pick up right where I left off

**Leaving my desk no longer means leaving my work.** The flow is unbroken.

---

## Security: Why This Is Safe

**Zero open ports + TLS + Anthropic API auth. That's the entire attack surface.**

| Layer | Mechanism |
|-------|-----------|
| **Transport** | Outbound HTTPS only (TLS encrypted) |
| **Authentication** | Via Anthropic API (your claude.ai account) |
| **Network** | Zero inbound ports. No router changes |
| **Session URL** | Unique, unguessable per session |

SSH exposes port 22 to brute force attacks. VPN misconfigurations can expose your entire network.

**Remote Control opens nothing to the outside world.** There is no attack surface to target.

One caveat: combined with `--dangerously-skip-permissions`, anyone with your session URL can execute arbitrary commands without confirmation. Don't share the URL. Don't leave it bookmarked on shared devices.

---

## Limitations: What You Should Know

Powerful, but not magic.

| Limitation | Details |
|-----------|---------|
| **Terminal closes = session ends** | If Claude Code exits on your PC, the remote connection dies |
| **Network interruption** | ~10 minute timeout, then auto-reconnect attempt |
| **One device per session** | Can't connect multiple devices to the same session simultaneously |
| **Text only** | No drag-and-drop files, no direct image upload |
| **PC must be running** | Obvious, but worth stating |

My PC runs 24/7 with sleep disabled, so the first and last limitations don't apply. Network drops are rare on Tokyo's 4G/5G. The text-only limitation hasn't been an issue — I'm sending instructions, not files.

---

## Summary

| Aspect | Detail |
|--------|--------|
| **What it does** | Control your PC's Claude Code from phone/browser |
| **Setup** | One line in `settings.json` + `/rc` + scan QR |
| **Replaces** | SSH, tmux, Tailscale, VPN, port forwarding |
| **Security** | Outbound HTTPS only, zero open ports |
| **Limitations** | Terminal must stay open, ~10 min network timeout |

**I now operate my dev environment from the couch, the train, and the grocery store.**

The era of "working hours = time at my desk" is over. Remote Control erases that boundary. Like a baby monitor — your AI keeps building in the nursery. You just check in whenever you want, from wherever you are.

One line in `settings.json`. That's all it takes.

---

*Building in Tokyo. Writing in 3 languages.*
