---
title: "I Set Up a $7000 RTX 5090 PC with Claude Code — Here's Everything I Learned"
published: true
description: "First PC build in 15 years. 6-layer security, full local AI stack, and a 5-hour setup guided entirely by Claude Code."
tags: [claudecode, windows, security, ai]
---

I hadn't built a PC in 15 years.

RTX 5090, 64GB RAM, 6TB NVMe. Over $7000 for a custom-built monster. The problem? **Setting it up.** The PC world in 2026 is nothing like it was in 2011. BitLocker? Windows Sandbox? Hyper-V? Controlled Folder Access? I didn't know any of this.

Let me be honest. **Without Claude Code, this setup would have taken me a week.**

---

## The Full Picture

I ran Claude Code on my old laptop while setting up the new PC. Claude gave step-by-step instructions. I executed them on the new machine. It felt like **having a senior engineer sitting next to me** — one who never gets impatient and explains everything at exactly the level you need.

| Phase | What | Time |
|-------|------|------|
| Backup | System Image + Recovery USB + Restore Point | 2 hours |
| BIOS | XMP, Resize BAR verification | 10 min |
| Security | BitLocker, Sandbox, Hyper-V, Controlled Folder Access | 1 hour |
| Data Migration | Old PC → USB → New PC | 30 min |
| Dev Environment | Git, Node, Rust, Python, Claude Code | 1 hour |
| AI/ML | Ollama, ComfyUI | 30 min |

**Total: about 5 hours.**

---

## Security: 6 Layers of Defense

Security was the top priority. I run emulators, download files from sketchy sources sometimes, and test random tools. **I needed the main environment to be untouchable.**

Claude Code designed a 6-layer defense model:

| Layer | What It Prevents |
|-------|-----------------|
| **Windows Sandbox** | Test suspicious `.exe` files in a disposable environment. Close it, everything's gone |
| **Hyper-V VM** | Isolated environment for emulators. Completely separate from the main OS |
| **Windows Defender** | Real-time scanning blocks known threats |
| **Controlled Folder Access** | Even if malware gets in, personal files **can't be modified** |
| **BitLocker** | If the PC is physically stolen, data is encrypted and unreadable |
| **System Image** | Worst case: one-click restore to a clean state |

### Sandbox, Explained Simply

Imagine you have an expensive desk. You're afraid of scratching it.

**Sandbox is a vinyl sheet you lay on top.** Make whatever mess you want on the sheet. Peel it off, the desk is spotless.

Download something suspicious? Open it in Sandbox first. If it's fine, move it to the real environment. If it's malware, close Sandbox. **Nothing happened.**

### Controlled Folder Access Is Surprisingly Important

This was the unexpected takeaway. BitLocker protects you when the PC is **stolen**. But if malware is **already running on your system**, BitLocker does nothing.

Controlled Folder Access is different. You designate folders (photos, backups, documents), and **only whitelisted apps can write to them**. Ransomware could be running and your personal files stay untouched — it simply can't encrypt them.

There's a catch though. During setup, PowerShell and even Notepad got flagged as "unauthorized apps." **Turn it off while setting up your dev environment, then turn it back on when done.**

---

## Data Migration: 4.8GB to Move Your Entire Life

Moving 15 years of data sounds overwhelming. But when Claude Code analyzed what actually needed to be transferred, **only 4.8GB mattered.**

| What | Size | Method |
|------|------|--------|
| SSH keys | 14KB | USB copy |
| Claude Code settings (37 projects worth of memory) | 1.3GB | USB copy |
| `.env` files (8 projects) | 21KB | USB copy |
| Local repos (24) | 3.2GB | USB copy |
| Obsidian vault | 17MB | USB copy |
| Git repos (23) | — | Clone from GitHub |

Anything on GitHub gets cloned fresh. No `node_modules`. **Just config files and source code.**

Claude Code's standout moves here:

- **Auto-detected which repos had remotes** — only flagged the ones that needed USB copying
- **Designed the transfer folder structure** and auto-generated a restore guide for the new PC
- **Organized `.env` files by project name** — since they're not in git, they need manual handling

---

## AI/ML: Everything Runs Locally

With 32GB of VRAM on the RTX 5090, local AI is the obvious play.

| Tool | Purpose | Cost |
|------|---------|------|
| **Ollama** + Qwen 2.5 32B | Local LLM (chat, code generation) | Free |
| **ComfyUI** | Image generation (Stable Diffusion, FLUX) | Free |

**All local. Zero API cost. Zero monthly fees.**

Ollama models go to `D:\AI\models\ollama` via environment variable — keeps the C: drive clean.

ComfyUI was a straightforward `git clone` setup. The RTX 5090 is so new that PyTorch stable doesn't fully support it yet, but it works. PyTorch nightly fixes that.

---

## Drive Strategy

| Drive | Purpose |
|-------|---------|
| **C: (2TB)** "System" | Windows + apps + `C:\dev\` (all code) |
| **D: (4TB)** "Data" | AI models, Steam games, photos, backups, VMs |

Key decisions Claude Code suggested:

- **Risky downloads go to `D:\Downloads\Risky\`** — test in Sandbox before moving anywhere permanent
- **Steam app on C:, games on D:** — individual games are 50-100GB each, you don't want that on your system drive
- **VMs on `D:\VMs\`** — emulator environments completely isolated from the main OS

---

## Dev Environment: Git's Installer Was the Most Annoying Part

Honestly, the single most time-consuming step was **the Git for Windows installer.**

Editor choice, default branch name, PATH settings, SSH library, line endings, terminal emulator, credential helper... **Over 10 questions.** For someone who hasn't set up a PC in 15 years, it's impossible to know the right answer for each one.

Claude Code answered every choice instantly with reasoning. "Pick this one, because X." Going through them one by one meant **zero wrong settings that blow up later.**

Everything else — Node, Rust, Python, Claude Code itself — was basically one command each. Git was the outlier.

---

## Claude Code's Best Moment

During setup, **Controlled Folder Access blocked PowerShell.** I was trying to set up Node.js with `fnm` and got `Access Denied` when it tried to write a config file.

Normally, diagnosing that takes 30 minutes of searching. Claude Code identified it instantly: "Controlled Folder Access is blocking PowerShell. Either temporarily disable it or add PowerShell to the whitelist."

**30 seconds from problem to solution.** That's the real value of setting up with AI.

---

## Summary

| Item | Details |
|------|---------|
| Total time | ~5 hours (security included) |
| Data migrated | 4.8GB (one USB drive) |
| Security | 6-layer defense (Sandbox, VM, Defender, CFA, BitLocker, Image) |
| AI setup | Ollama + ComfyUI, fully local, $0 cost |
| Key lesson | Controlled Folder Access: off during dev setup, on after |

Setting up a PC after 15 years felt intimidating.

But with Claude Code, **unfamiliar tech isn't scary.** Ask "what is this?" one thing at a time, and you get an explanation that actually makes sense. BIOS settings, BitLocker, Hyper-V — all of it becomes "oh, that's what that does" instead of a wall of confusion.

**Setup cost for a $7000 monster PC: $0. Claude Code handled everything.**

---

*Questions or feedback? Find me on X ([@DavidAi311](https://x.com/DavidAi311)).*
