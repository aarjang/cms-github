
<p align="center">
  <pre align="center">
   ___  ____  ___
  / _ \/ ___||__ \
 / /_\/\___ \  / /
/ /_\ \___) |/ /
\____/|____//_/   v3.3.0
  </pre>
</p>

<p align="center">
  <strong>AI Token Optimizer for Claude Code</strong><br/>
  Reduce your Claude Code token usage by <strong>70–90%</strong> per session — automatically.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-3.3.0-blue?style=flat-square" alt="version"/>
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="license"/>
  <img src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL2-lightgrey?style=flat-square" alt="platform"/>
  <img src="https://img.shields.io/badge/shell-bash-orange?style=flat-square&logo=gnu-bash" alt="bash"/>
  <img src="https://img.shields.io/badge/deps-zero-brightgreen?style=flat-square" alt="zero deps"/>
</p>

<p align="center">
  🧠 Builds a <strong>code intelligence graph</strong> so Claude understands your project instantly &nbsp;·&nbsp;
  🔗 <strong>Auto-wires hooks</strong> — zero copy-paste, zero manual steps &nbsp;·&nbsp;
  💾 <strong>Persistent memory</strong> that survives context resets
</p>

---

## 🇬🇧 English

---

### ⚡ The Problem

Every Claude Code session, Claude reads your entire codebase to understand your project:

```
❌ Without ato
   Claude reads: src/ + tests/ + configs + node_modules hints = ~50,000 tokens
   Your task needed: 2 files = ~3,000 tokens
   Wasted: ~94% of your token budget

✅ With ato
   Claude reads: CONTEXT.md + focus file = ~2,000 tokens
   Available for actual work: ~198,000 tokens
   Saved: ~91%
```

| | Without ato | With ato |
|---|---|---|
| Session startup | ~50k tokens | ~2k tokens |
| Claude reads | Entire codebase | Focused context only |
| Architecture known | ❌ Has to explore | ✅ Pre-mapped |
| Setup per session | Manual copy-paste | Fully automatic |
| Survives context reset | ❌ Lost | ✅ DECISIONS.md |

---

### 📦 Install

```bash
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.zshrc   # or ~/.bashrc
```

---

### 🚀 Quick Start

```bash
# Step 1 — once per project
cd ~/your-project
ato init

# Step 2 — every session
claude
```

That's it. No copy-paste. No manual `ato go`. Just open Claude and type.

> **Working on another machine?** Just `git pull` — context and memory sync automatically.

---

### 🔬 What `ato init` does

#### 🧠 Builds a Code Intelligence Graph → `CONTEXT.md`

```markdown
## Architecture
  controllers/   3 files   AuthController, UserController, OrderController
  services/      5 files   AuthService, PaymentService, EmailService ...
  models/        4 files   User, Order, Product, Session

## Critical path (read these first)
   12  src/services/auth.ts
        exports: authenticateUser · validateToken · hashPassword
    9  src/lib/db.ts
        exports: getConnection · query · transaction

## Coupling map (change these together)
  auth.service.ts ↔ auth.controller.ts    18 commits
  user.model.ts   ↔ user.service.ts       11 commits
```

Claude reads this and immediately knows your architecture — **without opening a single file**.

#### 🔗 Auto-wires Hooks → `.claude/settings.json`

| Hook | Command | When |
|---|---|---|
| `UserPromptSubmit` | `ato go --quiet` | Before every session — auto-generates focus file |
| `Stop` | `ato sync` | After every session — updates CONTEXT.md + auto-commits |

#### 📋 `CLAUDE.md` — Standing Instruction

Tells Claude to read `.ato_focus_auto.md` at session start — automatically, every time.

#### 💾 `DECISIONS.md` — Persistent Memory

A separate memory file that survives context resets (see below).

---

### 💾 Persistent Memory `ato mem`

**The problem:** Claude Code context resets wipe out everything — decisions made, work in progress, gotchas discovered. You have to re-explain it all from scratch.

**The solution:** `DECISIONS.md` — committed to git, auto-synced, loaded at every session start.

```bash
# Log a decision
ato mem "decided to use Redis instead of Postgres for session storage"

# Track work in progress
ato mem --wip "auth middleware — 70% done, next: token refresh"

# Add a gotcha / watch-out
ato mem --warn "never touch bin/legacy-migrate.sh — breaks prod silently"

# Mark WIP as complete
ato mem --done "auth middleware"

# See everything
ato mem --list

# Start fresh
ato mem --clear
```

Your `DECISIONS.md` after the above:

```markdown
## Active work
- [ ] auth middleware — 70% done, next: token refresh

## Decisions
- 2026-06-28  decided to use Redis instead of Postgres for session storage

## Watch out
- never touch bin/legacy-migrate.sh — breaks prod silently
```

After any context reset, Claude reads this and picks up exactly where you left off.

---

### 🔄 How It Works

```
┌─────────────────────────────────────────────────────────┐
│  ato init  (once per project)                           │
│                                                         │
│  Scan project → analyze imports → git co-change        │
│       ↓                                                 │
│  CONTEXT.md      ← architecture + critical path         │
│  DECISIONS.md    ← persistent memory (empty to start)  │
│  CLAUDE.md       ← standing session instruction        │
│  settings.json   ← UserPromptSubmit + Stop hooks       │
└───────────────────┬─────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────┐
│  open claude  (every session)                           │
│                                                         │
│  UserPromptSubmit hook fires                            │
│       ↓                                                 │
│  ato go --quiet → .ato_focus_auto.md                   │
│    contains: CONTEXT.md + DECISIONS.md + file contents  │
│       ↓                                                 │
│  CLAUDE.md: "read .ato_focus_auto.md — no questions"   │
│       ↓                                                 │
│  Claude starts with full context. No exploration.       │
└───────────────────┬─────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────┐
│  session ends                                           │
│                                                         │
│  Stop hook → ato sync                                   │
│    → CONTEXT.md updated                                 │
│    → git commit "chore: auto-sync ato context [skip ci]"│
│    → lock cleared for next session                      │
└─────────────────────────────────────────────────────────┘
```

Watch auto-focus activity live:
```bash
tail -f ~/.ato/run.log
```

---

### 📊 `ato check` — Health Dashboard

```
╔══════════════════════════════════════════════════╗
║  ATO v3.2.0 — my-project                       ║
╚══════════════════════════════════════════════════╝

  Context
  ──────────────────────────────────────────────
  ✓  CONTEXT.md       95 lines  ~570    lean ✓
  ✓  CLAUDE.md        18 lines  ~108    lean ✓
  ✓  DECISIONS.md     14 lines  ~84     lean ✓
  ✓  Auto-sync        active  (Stop hook)
  ✓  Auto-focus       active  (UserPromptSubmit hook)
  ✓  Focus file       ~2k

  Available for work: ~166k / ~200k tokens (83% free)

  Session
  ──────────────────────────────────────────────
  ██████░░░░░░░░░░░░░░░░░░  26%  safe to continue
  (estimate — for exact: /context inside Claude Code)

  Git
  ──────────────────────────────────────────────
  Branch          main
  Status          clean
  Last commit     "feat: add payment integration" (2 hours ago)

  Savings  (estimate — based on project size vs. focus file size)
  ──────────────────────────────────────────────
  Sessions        47
  Saved           ~820k tokens  ≈ $2.46
  Last session    2026-06-28
```

---

### 📋 Commands Reference

| Command | Description |
|---|---|
| `ato init` | Scan project, build code graph, wire hooks |
| `ato mem "decision"` | Log a decision that survives context reset |
| `ato mem --wip "text"` | Track work in progress |
| `ato mem --done "text"` | Mark WIP item as complete |
| `ato mem --warn "text"` | Add a gotcha / watch-out |
| `ato mem --list` | Show all memory |
| `ato note "text"` | Append a note to CONTEXT.md |
| `ato go` | Manual focus (runs automatically on session start) |
| `ato go auth` | Focus on a specific topic |
| `ato check` | Full health dashboard — context + session + savings |
| `ato audit` | Token budget breakdown per section |
| `ato audit --reset` | Reset session stats |
| `ato update` | Self-update to latest version |

<details>
<summary>⚙️ Power options</summary>

```bash
ato go --budget 40k       # trim scope for Claude Pro token limits
ato audit --scope "*.ts"  # token cost of a specific file set
ato mcp install           # register ato as MCP server in Claude Code
ato task add "text"       # optional task tracking
ato task done 1           # mark task complete
tail -f ~/.ato/run.log    # watch auto-focus activity live
```

</details>

---

### 📈 Token Savings — Honest Numbers

Savings are **estimates**, not exact measurements. The calculation:

```
saved = (all source files in project × ~6 tokens/line)
      − (CONTEXT.md + DECISIONS.md + focus file overhead)
```

In practice, Claude without ato doesn't necessarily read your entire codebase — but ato ensures it reads *only* what's relevant, and starts with full architectural context. The real benefit is **faster, more accurate responses** with less back-and-forth exploration.

Stats are stored in:
- `.ato-stats.json` — this project
- `~/.ato/stats.json` — all projects (aggregate)

---

### 🪟 Windows Support

ato is a Bash script — it does not run natively on PowerShell or CMD. Windows support is via WSL2.

| Environment | Status | Notes |
|---|---|---|
| **WSL2** | ✅ Full support | Recommended for Windows |
| **Git Bash** | ⚠️ Partial | Core commands work, hooks may not |
| **PowerShell / CMD** | ❌ Not supported | Bash required |
| **macOS** | ✅ Full support | Primary platform |
| **Linux** | ✅ Full support | |

#### Setup on Windows (WSL2)

```bash
# 1. Install WSL2 (PowerShell as Administrator)
wsl --install

# 2. Inside WSL, install ato
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.bashrc

# 3. Work on projects via Windows path (accessible to both WSL and Windows)
cd /mnt/c/Users/$USER/projects/my-project
ato init
```

`ato init` automatically detects WSL and sets hooks to `wsl ato go --quiet` and `wsl ato sync` so Claude Code Desktop for Windows can call them correctly.

> **Project location matters:** Keep projects under `/mnt/c/...` (Windows filesystem), not `~/projects` (WSL filesystem). Claude Code Desktop can only open Windows paths.

---

### 📄 License

MIT © [Arjang Mousavi](https://github.com/aarjang)

---
---

## 🇮🇷 فارسی

---

### ⚡ مشکل

هر بار که Claude Code شروع می‌کنه، کل codebase رو می‌خونه تا پروژه رو بفهمه:

```
❌ بدون ato
   Claude می‌خونه: src/ + tests/ + configs = ~۵۰٬۰۰۰ توکن
   task شما فقط نیاز داشت: ۲ فایل = ~۳٬۰۰۰ توکن
   هدر رفته: ~۹۴٪ از budget توکن

✅ با ato
   Claude می‌خونه: CONTEXT.md + focus file = ~۲٬۰۰۰ توکن
   موجود برای کار واقعی: ~۱۹۸٬۰۰۰ توکن
   صرفه‌جویی: ~۹۱٪
```

| | بدون ato | با ato |
|---|---|---|
| شروع session | ~۵۰k توکن | ~۲k توکن |
| Claude می‌خونه | کل codebase | فقط context مرتبط |
| معماری شناخته‌شده | ❌ باید explore کنه | ✅ از قبل map شده |
| تنظیم هر session | copy-paste دستی | کاملاً خودکار |
| بعد از context reset | ❌ از دست رفته | ✅ DECISIONS.md |

---

### 📦 نصب

```bash
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.zshrc   # یا ~/.bashrc
```

---

### 🚀 شروع سریع

```bash
# مرحله ۱ — یک بار در هر پروژه
cd ~/your-project
ato init

# مرحله ۲ — هر session
claude
```

همین. بدون copy-paste. بدون `ato go` دستی. فقط Claude رو باز کن و تایپ کن.

> **روی machine دیگه‌ای کار می‌کنی؟** فقط `git pull` بزن — context و memory خودکار sync می‌شن.

---

### 🔬 `ato init` چه کاری انجام می‌ده

#### 🧠 Code Intelligence Graph می‌سازه → `CONTEXT.md`

```markdown
## Architecture
  controllers/   ۳ فایل   AuthController, UserController, OrderController
  services/      ۵ فایل   AuthService, PaymentService, EmailService ...
  models/        ۴ فایل   User, Order, Product, Session

## Critical path (اول اینا رو بخون)
   ۱۲  src/services/auth.ts
        exports: authenticateUser · validateToken · hashPassword
    ۹  src/lib/db.ts
        exports: getConnection · query · transaction

## Coupling map (اینا رو با هم تغییر بده)
  auth.service.ts ↔ auth.controller.ts    ۱۸ commit
  user.model.ts   ↔ user.service.ts       ۱۱ commit
```

Claude این رو می‌خونه و فوری معماری پروژه رو می‌فهمه — **بدون باز کردن یک فایل**.

#### 🔗 Hooks رو وایر می‌کنه → `.claude/settings.json`

| Hook | دستور | کِی |
|---|---|---|
| `UserPromptSubmit` | `ato go --quiet` | قبل از هر session — focus file می‌سازه |
| `Stop` | `ato sync` | بعد از هر session — CONTEXT.md آپدیت + auto-commit |

#### 📋 `CLAUDE.md` — دستور دائمی

به Claude می‌گه هر session `.ato_focus_auto.md` رو بخونه — خودکار، هر بار.

#### 💾 `DECISIONS.md` — حافظه دائمی

یه فایل memory مجزا که context reset رو survive می‌کنه (ببین پایین‌تر).

---

### 💾 حافظه دائمی `ato mem`

**مشکل:** context reset در Claude Code همه چیز رو پاک می‌کنه — تصمیمات، کارهای نیمه‌تمام، مشکلات کشف‌شده. باید از اول همه چیز رو توضیح بدی.

**راه‌حل:** `DECISIONS.md` — commit شده در git، خودکار sync، هر session لود می‌شه.

```bash
# ثبت یه تصمیم
ato mem "تصمیم گرفتیم Redis بجای Postgres برای session storage استفاده کنیم"

# ردیابی کار در جریان
ato mem --wip "auth middleware — ۷۰٪ تموم، بعدی: token refresh"

# اضافه کردن هشدار
ato mem --warn "bin/legacy-migrate.sh رو دست نزن — prod رو خاموش می‌کنه"

# تموم کردن WIP
ato mem --done "auth middleware"

# نمایش همه حافظه
ato mem --list

# پاک کردن همه
ato mem --clear
```

`DECISIONS.md` بعد از دستورات بالا:

```markdown
## Active work
- [ ] auth middleware — ۷۰٪ تموم، بعدی: token refresh

## Decisions
- ۱۴۰۵-۰۴-۰۷  Redis بجای Postgres برای session storage

## Watch out
- bin/legacy-migrate.sh رو دست نزن — prod رو خاموش می‌کنه
```

بعد از هر context reset، Claude این رو می‌خونه و دقیقاً از همون جایی که بودی ادامه می‌ده.

---

### 🔄 چطور کار می‌کنه

```
┌─────────────────────────────────────────────────────────┐
│  ato init  (یک بار در هر پروژه)                        │
│                                                         │
│  اسکن پروژه → آنالیز imports → git co-change          │
│       ↓                                                 │
│  CONTEXT.md      ← معماری + critical path              │
│  DECISIONS.md    ← حافظه دائمی (اول خالی)             │
│  CLAUDE.md       ← دستور دائمی session                 │
│  settings.json   ← هوک‌های UserPromptSubmit + Stop      │
└───────────────────┬─────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────┐
│  باز کردن claude  (هر session)                         │
│                                                         │
│  UserPromptSubmit hook فایر می‌شه                      │
│       ↓                                                 │
│  ato go --quiet → .ato_focus_auto.md                   │
│    شامل: CONTEXT.md + DECISIONS.md + محتوای فایل‌ها    │
│       ↓                                                 │
│  CLAUDE.md: ".ato_focus_auto.md رو بخون — بدون سوال"  │
│       ↓                                                 │
│  Claude با context کامل شروع می‌کنه. بدون exploration. │
└───────────────────┬─────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────┐
│  پایان session                                          │
│                                                         │
│  Stop hook → ato sync                                   │
│    → CONTEXT.md آپدیت می‌شه                           │
│    → git commit خودکار                                  │
│    → lock برای session بعدی پاک می‌شه                  │
└─────────────────────────────────────────────────────────┘
```

فعالیت auto-focus رو live ببین:
```bash
tail -f ~/.ato/run.log
```

---

### 📊 `ato check` — داشبورد سلامت

```
╔══════════════════════════════════════════════════╗
║  ATO v3.2.0 — my-project                       ║
╚══════════════════════════════════════════════════╝

  Context
  ──────────────────────────────────────────────
  ✓  CONTEXT.md       ۹۵ خط   ~۵۷۰    lean ✓
  ✓  CLAUDE.md        ۱۸ خط   ~۱۰۸    lean ✓
  ✓  DECISIONS.md     ۱۴ خط   ~۸۴     lean ✓
  ✓  Auto-sync        فعال  (Stop hook)
  ✓  Auto-focus       فعال  (UserPromptSubmit hook)
  ✓  Focus file       ~۲k

  موجود برای کار: ~۱۶۶k / ~۲۰۰k توکن (۸۳٪ آزاد)

  Session
  ──────────────────────────────────────────────
  ██████░░░░░░░░░░░░░░░░░░  ۲۶٪  ادامه بده

  Git
  ──────────────────────────────────────────────
  Branch          main
  Status          clean
  آخرین commit   "feat: add payment integration" (۲ ساعت پیش)

  صرفه‌جویی  (تخمین)
  ──────────────────────────────────────────────
  Sessions        ۴۷
  صرفه‌جویی       ~۸۲۰k توکن  ≈ $۲.۴۶
  آخرین session   ۱۴۰۵-۰۴-۰۷
```

---

### 📋 مرجع دستورات

| دستور | توضیح |
|---|---|
| `ato init` | اسکن پروژه، ساخت code graph، وایر کردن hooks |
| `ato mem "decision"` | ثبت تصمیم که context reset رو survive می‌کنه |
| `ato mem --wip "text"` | ردیابی کار در جریان |
| `ato mem --done "text"` | تموم کردن WIP |
| `ato mem --warn "text"` | اضافه کردن هشدار / gotcha |
| `ato mem --list` | نمایش همه حافظه |
| `ato note "text"` | اضافه کردن یادداشت به CONTEXT.md |
| `ato go` | focus دستی (خودکار اجرا می‌شه) |
| `ato go auth` | focus روی topic مشخص |
| `ato check` | داشبورد کامل سلامت |
| `ato audit` | breakdown budget توکن هر بخش |
| `ato audit --reset` | ریست آمار sessions |
| `ato update` | آپدیت به آخرین نسخه |

<details>
<summary>⚙️ گزینه‌های پیشرفته</summary>

```bash
ato go --budget 40k       # محدود کردن scope برای Claude Pro
ato audit --scope "*.ts"  # هزینه توکن یه مجموعه فایل
ato mcp install           # ثبت به عنوان MCP server
ato task add "text"       # task tracking اختیاری
ato task done 1           # تموم کردن task
tail -f ~/.ato/run.log    # مشاهده live فعالیت auto-focus
```

</details>

---

### 📈 صرفه‌جویی توکن — اعداد واقعی

صرفه‌جویی‌ها **تخمین** هستن، نه اندازه‌گیری دقیق. محاسبه:

```
صرفه‌جویی = (همه فایل‌های سورس پروژه × ~۶ توکن/خط)
           − (CONTEXT.md + DECISIONS.md + focus file)
```

در عمل، Claude بدون ato لزوماً کل codebase رو نمی‌خونه — ولی ato مطمئن می‌شه فقط چیز مرتبط خونده می‌شه، و با context معماری کامل شروع می‌کنه. سود واقعی **پاسخ‌های سریع‌تر و دقیق‌تر** با کمتر exploration هست.

آمار ذخیره می‌شه در:
- `.ato-stats.json` — این پروژه
- `~/.ato/stats.json` — همه پروژه‌ها (کلی)

---

### 🪟 پشتیبانی از ویندوز

ato یه Bash script هست — روی PowerShell یا CMD کار نمی‌کنه. پشتیبانی ویندوز از طریق WSL2 هست.

| محیط | وضعیت | توضیح |
|---|---|---|
| **WSL2** | ✅ پشتیبانی کامل | توصیه‌شده برای ویندوز |
| **Git Bash** | ⚠️ ناقص | دستورات اصلی کار می‌کنن، hooks شاید نه |
| **PowerShell / CMD** | ❌ پشتیبانی نمی‌شه | Bash لازمه |
| **macOS** | ✅ پشتیبانی کامل | Platform اصلی |
| **Linux** | ✅ پشتیبانی کامل | |

#### راه‌اندازی روی ویندوز (WSL2)

```bash
# ۱. نصب WSL2 (PowerShell به عنوان Administrator)
wsl --install

# ۲. داخل WSL، نصب ato
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.bashrc

# ۳. روی پروژه‌ها از طریق path ویندوز کار کن
cd /mnt/c/Users/$USER/projects/my-project
ato init
```

`ato init` به‌صورت خودکار WSL رو detect می‌کنه و hooks رو با prefix `wsl` می‌نویسه تا Claude Code Desktop بتونه اونها رو صدا بزنه.

> **مکان پروژه مهمه:** پروژه‌ها رو زیر `/mnt/c/...` نگه‌دار (filesystem ویندوز)، نه `~/projects` (filesystem WSL). Claude Code Desktop فقط path‌های ویندوز رو می‌تونه باز کنه.

---

### 📄 مجوز

MIT © [Arjang Mousavi](https://github.com/aarjang)
