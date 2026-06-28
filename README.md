<p align="center">
  <pre align="center">
   ___  ____  ___
  / _ \/ ___||__ \
 / /_\/\___ \  / /
/ /_\ \___) |/ /
\____/|____//_/   v3.4.3
  </pre>
</p>

<p align="center">
  <strong>AI Token Optimizer for Claude Code</strong><br/>
  In large codebases, repeated exploration wastes tokens and slows Claude down.<br/>
  ato pre-curates your architecture so Claude starts every session with full context — automatically.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-3.4.1-blue?style=flat-square" alt="version"/>
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="license"/>
  <img src="https://img.shields.io/badge/macOS-✓-black?style=flat-square&logo=apple" alt="macOS"/>
  <img src="https://img.shields.io/badge/Linux-✓-yellow?style=flat-square&logo=linux&logoColor=black" alt="Linux"/>
  <img src="https://img.shields.io/badge/Windows_WSL2-✓-0078d4?style=flat-square&logo=windows" alt="WSL2"/>
  <img src="https://img.shields.io/badge/shell-bash-orange?style=flat-square&logo=gnu-bash" alt="bash"/>
  <img src="https://img.shields.io/badge/deps-zero-brightgreen?style=flat-square" alt="zero deps"/>
</p>

<p align="center">
  🧠 <strong>Code intelligence graph</strong> — Claude understands your architecture instantly &nbsp;·&nbsp;
  🔗 <strong>Auto-wired hooks</strong> — zero manual steps &nbsp;·&nbsp;
  💾 <strong>Persistent memory</strong> — survives context resets
</p>

---

## 🇬🇧 English

- [The Problem](#-the-problem)
- [Install](#-install)
- [Quick Start](#-quick-start)
- [Why Not Just a CLAUDE.md?](#-why-not-just-a-claudemd)
- [What ato init does](#-what-ato-init-does)
- [Persistent Memory](#-persistent-memory-ato-mem)
- [How It Works](#-how-it-works)
- [Platform Support](#-platform-support)
- [ato check Dashboard](#-ato-check-dashboard)
- [Commands Reference](#-commands-reference)
- [Token Savings](#-token-savings)
- [License](#-license)

---

### ⚡ The Problem

Claude Code navigates your codebase on demand — reading files, grepping symbols, listing directories as needed. In small projects this works well. In larger ones (~30,000+ lines), it gets expensive:

- A single grep can return thousands of results; Claude reads many files to triangulate the right context
- Each session re-explores the same architecture from scratch
- Context resets wipe everything: decisions made, work in progress, discovered gotchas

Anthropic's own documentation recommends "curation at the harness layer" for large codebases. That's exactly what ato does: it pre-builds your architecture map, critical paths, and git-derived coupling data — and injects it before every session via hooks.

| | Without ato | With ato |
|---|---|---|
| Architecture knowledge | ❌ Re-explored each session | ✅ Pre-mapped at `ato init` |
| Coupling information | ❌ Hidden in git history | ✅ Auto-extracted and summarized |
| Session setup | Manual copy-paste | Fully automatic via hooks |
| Context reset | ❌ Start over from scratch | ✅ `DECISIONS.md` auto-loaded |
| Multi-machine sync | ❌ Manual | ✅ Auto git commit after every session |
| Stays current | ❌ Manual maintenance | ✅ Auto-updated via Stop hook |

---

### 📦 Install

```bash
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.zshrc   # or ~/.bashrc
```

> Works on macOS (Terminal + Claude Code App), Linux, and Windows via WSL2.
> See [Platform Support](#-platform-support) for Windows setup.

---

### 🚀 Quick Start

```bash
# Step 1 — once per project
cd ~/your-project
ato init

# Step 2 — every session (Terminal or Desktop App)
claude
```

That's it. No copy-paste. No manual steps. Just open Claude and type.

> **Working from another machine?** Run `git pull` — your context, memory, and stats sync automatically.

---

### 🤔 Why Not Just a `CLAUDE.md`?

You can write a `CLAUDE.md` by hand and `@import` specific files. For small projects, or if you're willing to maintain it manually, **that's a perfectly valid approach and ato may not be necessary**.

ato adds value when:

| | Manual `CLAUDE.md` | ato |
|---|---|---|
| Architecture map | Written once, drifts over time | Auto-generated from directory structure |
| Coupling information | Requires reading git history manually | Auto-extracted from 90 days of commits |
| Stays current | Only if you remember to update it | Auto-updated after every session |
| Persistent memory | Manual | `ato mem` + auto-committed `DECISIONS.md` |
| Setup time | 30–60 min per project | ~30 seconds |

The coupling map is the hardest part to maintain manually: it captures which files always change together — derived from actual git history. This is the kind of signal a developer builds up over months but rarely writes down explicitly.

> **Honest take:** For projects under ~10,000 lines, a well-written `CLAUDE.md` may be all you need. ato is most valuable for larger codebases and developers who prefer automation over manual curation.

---

### 🔬 What `ato init` Does

#### 🧠 Code Intelligence Graph → `CONTEXT.md`

Scans your project and builds a structured map Claude reads before every session:

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

Claude reads this and knows your architecture **without opening a single file**.

The graph is built from:
- **Architecture layers** — detected from directory names and filename patterns
- **Critical path** — files most imported across the project, with their export surface
- **Coupling map** — pairs that always change together, from the last 90 days of git history

#### 🔗 Auto-wires Hooks → `.claude/settings.json`

| Hook | Fires | Action |
|---|---|---|
| `UserPromptSubmit` | Before every session | `ato go --quiet` → generates focus file |
| `Stop` | After every session | `ato sync` → updates CONTEXT.md + auto-commits |

Hook commands use the **absolute path** to the ato binary, so they work correctly in both the Claude Code CLI and the Desktop App (which may not source your shell profile).

#### 📋 `CLAUDE.md` — Standing Session Instruction

Tells Claude to read `.ato_focus_auto.md` at the start of every session — automatically, with no user action required.

#### 💾 `DECISIONS.md` — Persistent Memory

A separate file for decisions, in-progress work, and gotchas. Committed to git. Loaded every session. See [Persistent Memory](#-persistent-memory-ato-mem).

---

### 💾 Persistent Memory `ato mem`

**The problem:** Claude Code context resets wipe everything — decisions made, work in progress, gotchas you discovered. You re-explain from scratch every time.

**The solution:** `DECISIONS.md` — committed to git, auto-synced, auto-loaded at every session start.

```bash
# Log a decision
ato mem "decided to use Redis instead of Postgres for session storage"

# Track work in progress
ato mem --wip "auth middleware — 70% done, next: token refresh"

# Add a gotcha
ato mem --warn "never touch bin/legacy-migrate.sh — breaks prod silently"

# Mark WIP as complete (removes it)
ato mem --done "auth middleware"

# View everything
ato mem --list

# Start fresh
ato mem --clear
```

After the above, your `DECISIONS.md` looks like:

```markdown
## Active work
- [ ] auth middleware — 70% done, next: token refresh

## Decisions
- 2026-06-28  decided to use Redis instead of Postgres for session storage

## Watch out
- never touch bin/legacy-migrate.sh — breaks prod silently
```

After any context reset, Claude reads this and continues exactly where you left off — no re-explaining needed.

---

### 🔄 How It Works

```
┌─────────────────────────────────────────────────────────────┐
│  ato init  (once per project)                               │
│                                                             │
│  Scan → import graph → git co-change analysis              │
│       ↓                                                     │
│  CONTEXT.md      ← architecture + critical path + coupling │
│  DECISIONS.md    ← persistent memory (starts empty)        │
│  CLAUDE.md       ← standing instruction: read focus file   │
│  settings.json   ← UserPromptSubmit + Stop hooks wired     │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  Open Claude (CLI or Desktop App — every session)           │
│                                                             │
│  UserPromptSubmit hook fires                                │
│       ↓                                                     │
│  ato go --quiet → builds .ato_focus_auto.md                │
│    contains: CONTEXT.md + DECISIONS.md + file contents      │
│       ↓                                                     │
│  CLAUDE.md: "read .ato_focus_auto.md immediately"          │
│       ↓                                                     │
│  Claude starts with full context. Zero exploration.         │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  Session ends                                               │
│                                                             │
│  Stop hook → ato sync                                       │
│    → CONTEXT.md updated with latest git activity           │
│    → git commit "chore: auto-sync ato context [skip ci]"   │
│    → session lock cleared for next session                  │
└─────────────────────────────────────────────────────────────┘
```

Watch live activity:
```bash
tail -f ~/.ato/run.log
```

---

### 🖥️ Platform Support

| Platform | CLI | Desktop App | Notes |
|---|---|---|---|
| **macOS (Terminal)** | ✅ Full | ✅ Full | Primary platform |
| **macOS (Claude Code App)** | ✅ Full | ✅ Full | Hooks use absolute path — works even when app doesn't source shell profile |
| **Linux** | ✅ Full | ✅ Full | |
| **Windows + WSL2** | ✅ Full | ✅ Full | Hooks use `wsl bash -lc` so Windows Claude Code App can call them |
| **Windows + Git Bash** | ⚠️ Partial | ❌ | Core commands work; hooks unreliable |
| **Windows (native)** | ❌ | ❌ | Bash required |

#### IDE Support

ato works wherever **Claude Code** runs. The rule: if it reads `.claude/settings.json` and fires hooks, ato works automatically.

| Environment | Works? | Notes |
|---|---|---|
| **VS Code** + Claude Code extension | ✅ | Same hook system — no extra setup |
| **JetBrains** + Claude Code extension | ✅ | Same hook system — no extra setup |
| **Cursor** | ❌ | Not Claude Code — different hook system |
| **GitHub Copilot** | ❌ | Different product entirely |
| **Windsurf** | ❌ | Different product entirely |

#### macOS — Desktop App

No extra steps. `ato init` stores the absolute path to the ato binary in hook commands, so the Desktop App can find it even without sourcing your shell profile:

```json
{
  "hooks": {
    "UserPromptSubmit": [{"hooks": [{"command": "/Users/you/bin/ato go --quiet"}]}],
    "Stop":             [{"hooks": [{"command": "/Users/you/bin/ato sync"}]}]
  }
}
```

#### Windows — Setup via WSL2

```bash
# Step 1 — Install WSL2 (PowerShell as Administrator)
wsl --install

# Step 2 — Inside WSL terminal, install ato
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.bashrc

# Step 3 — Work on projects via Windows filesystem path
#   ✅ Do this: accessible to both WSL and Claude Code Desktop
cd /mnt/c/Users/$USER/projects/my-project
ato init

#   ❌ Not this: Claude Code Desktop can't open WSL filesystem paths
# cd ~/projects/my-project
```

`ato init` automatically detects WSL and sets hooks to:
```json
{"command": "wsl bash -lc 'ato go --quiet'"}
{"command": "wsl bash -lc 'ato sync'"}
```

Claude Code Desktop for Windows calls these and WSL executes them — fully transparent.

#### `ato check` shows your platform

```
  Environment
  ──────────────────────────────────────────────
  Platform        macOS
  ato binary      /Users/you/bin/ato
  Hook command    /Users/you/bin/ato go --quiet
```

---

### 📊 `ato check` Dashboard

```
╔══════════════════════════════════════════════════╗
║  ATO v3.4.3 — my-project                       ║
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

  Environment
  ──────────────────────────────────────────────
  Platform        macOS
  ato binary      /Users/you/bin/ato
  Hook command    /Users/you/bin/ato go --quiet

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
| `ato init` | Scan project, build code graph, wire hooks, create all files |
| `ato mem "decision"` | Log a decision that survives context reset |
| `ato mem --wip "text"` | Track work in progress |
| `ato mem --done "text"` | Remove completed WIP item |
| `ato mem --warn "text"` | Add a gotcha / watch-out |
| `ato mem --list` | Show all memory |
| `ato mem --clear` | Reset all memory (with confirmation) |
| `ato note "text"` | Append a quick note to CONTEXT.md |
| `ato go` | Manually rebuild focus file (runs automatically on session start) |
| `ato go auth` | Focus on a specific topic |
| `ato check` | Full health dashboard: context + session + environment + savings |
| `ato audit` | Token budget breakdown per section |
| `ato audit --reset` | Reset session stats |
| `ato update` | Self-update to latest version |

<details>
<summary>⚙️ Power options</summary>

```bash
ato go --budget 40k       # trim scope to fit Claude Pro token limits
ato audit --scope "*.ts"  # token cost of a specific file set
ato mcp install           # register ato as MCP server in Claude Code
ato task add "text"       # optional task tracking
ato task done 1           # mark task complete
tail -f ~/.ato/run.log    # watch auto-focus activity live
```

</details>

---

### 📈 Token Savings — What to Expect

Claude Code reads files on demand, not all at once at session start — so there's no single "startup cost" to measure against. The real savings come from reducing repeated exploration across sessions:

- **Less re-exploration** — architecture in `CONTEXT.md` means Claude doesn't grep the same structure session after session
- **Less triangulation** — the coupling map and critical paths reduce how many files Claude reads to answer a question
- **Less context-reset overhead** — `DECISIONS.md` means you don't re-explain decisions after every compaction

To measure your own savings: run `/context` inside Claude Code at the start of a session with and without ato loaded. The difference is your actual number.

Stats are stored locally:
- `.ato-stats.json` — this project
- `~/.ato/stats.json` — all projects (aggregate)

> **Note:** The token estimate in `ato check` uses your project's line count as a rough proxy — not a measurement of actual session consumption. For precise numbers, use `/context` inside Claude Code.

Reset anytime with `ato audit --reset`.

---

### 📄 License

MIT © [Arjang Mousavi](https://github.com/aarjang)

---
---

## 🇮🇷 فارسی

- [مشکل](#-مشکل)
- [نصب](#-نصب)
- [شروع سریع](#-شروع-سریع)
- [چرا فقط CLAUDE.md کافی نیست؟](#-چرا-فقط-claudemd-کافی-نیست)
- [ato init چه می‌کنه](#-ato-init-چه-می‌کنه)
- [حافظه دائمی](#-حافظه-دائمی-ato-mem)
- [چطور کار می‌کنه](#-چطور-کار-می‌کنه)
- [پشتیبانی پلتفرم‌ها](#️-پشتیبانی-پلتفرم‌ها)
- [داشبورد ato check](#-داشبورد-ato-check)
- [مرجع دستورات](#-مرجع-دستورات)
- [صرفه‌جویی توکن](#-صرفه‌جویی-توکن)
- [مجوز](#-مجوز)

---

### ⚡ مشکل

Claude Code codebase رو on-demand می‌گرده — فایل می‌خونه، grep می‌زنه، دایرکتوری لیست می‌کنه. تو پروژه‌های کوچیک خوب کار می‌کنه. تو پروژه‌های بزرگ‌تر (~۳۰٬۰۰۰ خط به بالا) گرون می‌شه:

- یه grep ممکنه هزاران نتیجه برگردونه؛ Claude فایل‌های زیادی می‌خونه تا context رو پیدا کنه
- هر session دوباره همون معماری رو از صفر explore می‌کنه
- context reset همه چیز رو پاک می‌کنه: تصمیمات، کارهای نیمه‌تمام، هشدارهایی که پیدا کردی

مستندات Anthropic برای codebase های بزرگ «curation در لایه harness» رو توصیه می‌کنه. دقیقاً همین کاریه که ato می‌کنه: نقشه معماری، critical path، و اطلاعات coupling از git history رو می‌سازه و قبل از هر session inject می‌کنه.

| | بدون ato | با ato |
|---|---|---|
| دانش معماری | ❌ هر session دوباره explore | ✅ یه بار map شده در `ato init` |
| اطلاعات coupling | ❌ پنهان در git history | ✅ خودکار استخراج و خلاصه‌شده |
| تنظیم session | copy-paste دستی | کاملاً خودکار با hooks |
| بعد از context reset | ❌ از صفر شروع | ✅ `DECISIONS.md` خودکار لود |
| sync چند دستگاه | ❌ دستی | ✅ auto git commit بعد از هر session |
| به‌روز می‌مونه | ❌ نگهداری دستی | ✅ auto-update با Stop hook |

---

### 📦 نصب

```bash
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.zshrc   # یا ~/.bashrc
```

> روی macOS (Terminal + Desktop App)، Linux، و Windows از طریق WSL2 کار می‌کنه.
> برای راه‌اندازی ویندوز، [پشتیبانی پلتفرم‌ها](#️-پشتیبانی-پلتفرم‌ها) رو ببین.

---

### 🚀 شروع سریع

```bash
# مرحله ۱ — یه بار در هر پروژه
cd ~/your-project
ato init

# مرحله ۲ — هر session (Terminal یا Desktop App)
claude
```

همین. بدون copy-paste. بدون قدم دستی. فقط Claude رو باز کن و تایپ کن.

> **از دستگاه دیگه‌ای کار می‌کنی؟** `git pull` بزن — context، memory، و stats خودکار sync می‌شن.

---

### 🤔 چرا فقط `CLAUDE.md` کافی نیست؟

می‌تونی یه `CLAUDE.md` دستی بنویسی و فایل‌های خاص رو `@import` کنی. برای پروژه‌های کوچیک، یا اگه حاضری دستی نگهداریش کنی، **این کاملاً درسته و ato لازم نیست**.

ato کجا ارزش داره:

| | `CLAUDE.md` دستی | ato |
|---|---|---|
| نقشه معماری | یه بار نوشته، با زمان کهنه می‌شه | خودکار از ساختار directory |
| اطلاعات coupling | نیاز به خوندن git history دستی | خودکار از ۹۰ روز commit |
| به‌روز می‌مونه | فقط اگه یادت بمونه | بعد از هر session خودکار |
| حافظه دائمی | دستی | `ato mem` + `DECISIONS.md` auto-commit |
| زمان راه‌اندازی | ۳۰–۶۰ دقیقه | ~۳۰ ثانیه |

coupling map سخت‌ترین چیزیه که دستی نگه داری: نشون می‌ده کدوم فایل‌ها همیشه با هم تغییر می‌کنن — بر اساس git history واقعی. این نوع اطلاعاتیه که یه developer طی ماه‌ها جمع می‌کنه ولی معمولاً هیچ‌وقت نمی‌نویسه.

> **صادقانه:** برای پروژه‌های زیر ~۱۰٬۰۰۰ خط، یه `CLAUDE.md` خوب ممکنه کافی باشه. ato بیشترین ارزش رو برای codebase های بزرگ‌تر و کسایی داره که اتوماسیون رو ترجیح می‌دن.

---

### 🔬 `ato init` چه می‌کنه

#### 🧠 Code Intelligence Graph → `CONTEXT.md`

پروژه رو اسکن می‌کنه و یه نقشه ساختاری می‌سازه که Claude قبل از هر session می‌خونه:

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

Claude این رو می‌خونه و بدون باز کردن یه فایل معماری رو می‌فهمه.

Graph از اینا ساخته می‌شه:
- **Architecture layers** — از نام دایرکتوری‌ها و pattern‌های فایل‌ها
- **Critical path** — فایل‌هایی که بیشترین import رو دارن + export surface
- **Coupling map** — جفت‌هایی که همیشه با هم تغییر می‌کنن (۹۰ روز گذشته git)

#### 🔗 Hooks رو وایر می‌کنه → `.claude/settings.json`

| Hook | کِی می‌زنه | عمل |
|---|---|---|
| `UserPromptSubmit` | قبل از هر session | `ato go --quiet` → focus file می‌سازه |
| `Stop` | بعد از هر session | `ato sync` → CONTEXT.md آپدیت + auto-commit |

دستورات hook از **مسیر مطلق** binary ato استفاده می‌کنن — در هر دو CLI و Desktop App کار می‌کنه، حتی اگه app محیط shell رو source نکنه.

#### 📋 `CLAUDE.md` — دستور دائمی session

به Claude می‌گه اول هر session `.ato_focus_auto.md` رو بخونه — خودکار، بدون هیچ اقدامی از طرف کاربر.

#### 💾 `DECISIONS.md` — حافظه دائمی

یه فایل مجزا برای تصمیمات، کارهای در جریان، و هشدارها. Commit می‌شه. هر session لود می‌شه. ادامه در [حافظه دائمی](#-حافظه-دائمی-ato-mem).

---

### 💾 حافظه دائمی `ato mem`

**مشکل:** context reset در Claude Code همه چیز رو پاک می‌کنه — تصمیمات، کارهای نیمه‌تمام، مشکلاتی که پیدا کردی. هر بار از صفر توضیح می‌دی.

**راه‌حل:** `DECISIONS.md` — commit شده در git، خودکار sync، اول هر session لود می‌شه.

```bash
# ثبت تصمیم
ato mem "تصمیم گرفتیم Redis بجای Postgres برای session storage استفاده کنیم"

# ردیابی کار در جریان
ato mem --wip "auth middleware — ۷۰٪ تموم، بعدی: token refresh"

# اضافه کردن هشدار
ato mem --warn "bin/legacy-migrate.sh رو دست نزن — prod رو خاموش می‌کنه"

# تموم کردن WIP (حذف می‌شه)
ato mem --done "auth middleware"

# نمایش همه
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

بعد از هر context reset، Claude این رو می‌خونه و دقیقاً از همون جا ادامه می‌ده.

---

### 🔄 چطور کار می‌کنه

```
┌─────────────────────────────────────────────────────────────┐
│  ato init  (یه بار در هر پروژه)                            │
│                                                             │
│  اسکن → import graph → آنالیز git co-change               │
│       ↓                                                     │
│  CONTEXT.md      ← معماری + critical path + coupling       │
│  DECISIONS.md    ← حافظه دائمی (اول خالی)                │
│  CLAUDE.md       ← دستور: focus file رو بخون              │
│  settings.json   ← هوک‌های UserPromptSubmit + Stop         │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  باز کردن Claude (CLI یا Desktop App — هر session)         │
│                                                             │
│  UserPromptSubmit hook فایر می‌شه                          │
│       ↓                                                     │
│  ato go --quiet → .ato_focus_auto.md می‌سازه              │
│    شامل: CONTEXT.md + DECISIONS.md + محتوای فایل‌ها        │
│       ↓                                                     │
│  CLAUDE.md: ".ato_focus_auto.md رو فوری بخون"            │
│       ↓                                                     │
│  Claude با context کامل شروع می‌کنه. بدون exploration.    │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  پایان session                                              │
│                                                             │
│  Stop hook → ato sync                                       │
│    → CONTEXT.md آپدیت با آخرین فعالیت git                │
│    → git commit خودکار                                      │
│    → lock session پاک برای session بعدی                    │
└─────────────────────────────────────────────────────────────┘
```

فعالیت auto-focus رو live ببین:
```bash
tail -f ~/.ato/run.log
```

---

### 🖥️ پشتیبانی پلتفرم‌ها

| پلتفرم | CLI | Desktop App | توضیح |
|---|---|---|---|
| **macOS (Terminal)** | ✅ کامل | ✅ کامل | Platform اصلی |
| **macOS (Claude Code App)** | ✅ کامل | ✅ کامل | Hooks از مسیر مطلق استفاده می‌کنن |
| **Linux** | ✅ کامل | ✅ کامل | |
| **Windows + WSL2** | ✅ کامل | ✅ کامل | Hooks از `wsl bash -lc` استفاده می‌کنن |
| **Windows + Git Bash** | ⚠️ ناقص | ❌ | دستورات اصلی کار می‌کنن؛ hooks نه |
| **Windows (native)** | ❌ | ❌ | Bash لازمه |

#### پشتیبانی IDE

ato هر جا **Claude Code** باشه کار می‌کنه. قانون: اگه `.claude/settings.json` خونده بشه و hooks فایر بشن، ato خودکار کار می‌کنه.

| محیط | کار می‌کنه؟ | توضیح |
|---|---|---|
| **VS Code** + Claude Code extension | ✅ | همون hook system — نیاز به تنظیم اضافه نیست |
| **JetBrains** + Claude Code extension | ✅ | همون hook system — نیاز به تنظیم اضافه نیست |
| **Cursor** | ❌ | Claude Code نیست — hook system متفاوت |
| **GitHub Copilot** | ❌ | محصول کاملاً متفاوت |
| **Windsurf** | ❌ | محصول کاملاً متفاوت |

#### macOS — Desktop App

قدم اضافه‌ای لازم نیست. `ato init` مسیر مطلق binary ato رو در hook ها ذخیره می‌کنه:

```json
{
  "hooks": {
    "UserPromptSubmit": [{"hooks": [{"command": "/Users/you/bin/ato go --quiet"}]}],
    "Stop":             [{"hooks": [{"command": "/Users/you/bin/ato sync"}]}]
  }
}
```

#### ویندوز — راه‌اندازی از طریق WSL2

```bash
# ۱. نصب WSL2 (PowerShell به عنوان Administrator)
wsl --install

# ۲. داخل WSL terminal، نصب ato
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.bashrc

# ۳. روی پروژه‌ها از طریق path ویندوز کار کن
#   ✅ درست: هم WSL هم Claude Code Desktop می‌تونن دسترسی داشته باشن
cd /mnt/c/Users/$USER/projects/my-project
ato init

#   ❌ اشتباه: Claude Code Desktop نمی‌تونه WSL filesystem path رو باز کنه
# cd ~/projects/my-project
```

`ato init` به‌صورت خودکار WSL رو detect می‌کنه و hooks رو اینطوری می‌نویسه:
```json
{"command": "wsl bash -lc 'ato go --quiet'"}
{"command": "wsl bash -lc 'ato sync'"}
```

Claude Code Desktop ویندوز اینا رو صدا می‌زنه و WSL اجراشون می‌کنه — کاملاً شفاف.

#### بخش Environment در `ato check`

```
  Environment
  ──────────────────────────────────────────────
  Platform        macOS
  ato binary      /Users/you/bin/ato
  Hook command    /Users/you/bin/ato go --quiet
```

---

### 📊 داشبورد `ato check`

```
╔══════════════════════════════════════════════════╗
║  ATO v3.4.3 — my-project                       ║
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

  Environment
  ──────────────────────────────────────────────
  Platform        macOS
  ato binary      /Users/you/bin/ato
  Hook command    /Users/you/bin/ato go --quiet

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
| `ato init` | اسکن پروژه، code graph، وایر hooks، ساخت همه فایل‌ها |
| `ato mem "decision"` | ثبت تصمیم که context reset رو survive می‌کنه |
| `ato mem --wip "text"` | ردیابی کار در جریان |
| `ato mem --done "text"` | حذف WIP تموم‌شده |
| `ato mem --warn "text"` | اضافه کردن هشدار / gotcha |
| `ato mem --list` | نمایش همه حافظه |
| `ato mem --clear` | پاک کردن همه حافظه (با تأیید) |
| `ato note "text"` | اضافه کردن یادداشت سریع به CONTEXT.md |
| `ato go` | ساخت دستی focus file (خودکار اجرا می‌شه) |
| `ato go auth` | focus روی topic مشخص |
| `ato check` | داشبورد کامل: context + session + environment + savings |
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

### 📈 صرفه‌جویی توکن — چی انتظار داشته باشی

Claude Code فایل‌ها رو on-demand می‌خونه، نه همه رو اول session — پس یه «هزینه شروع» ثابت قابل اندازه‌گیری وجود نداره. صرفه‌جویی واقعی از کاهش exploration تکراری میاد:

- **کمتر re-exploration** — معماری در `CONTEXT.md` یعنی Claude session به session همون ساختار رو grep نمی‌کنه
- **کمتر triangulation** — coupling map و critical paths تعداد فایل‌هایی که Claude می‌خونه رو کم می‌کنه
- **کمتر context-reset overhead** — `DECISIONS.md` یعنی بعد از هر compaction تصمیمات رو دوباره توضیح نمی‌دی

برای اندازه‌گیری دقیق: `/context` رو داخل Claude Code با و بدون ato اجرا کن. فرق همون عدد واقعی توئه.

آمار ذخیره می‌شه در:
- `.ato-stats.json` — این پروژه
- `~/.ato/stats.json` — همه پروژه‌ها

> **توجه:** عدد توکن در `ato check` بر اساس تعداد خط‌های پروژه‌ست — نه اندازه‌گیری واقعی مصرف session. برای عدد دقیق، `/context` رو داخل Claude Code استفاده کن.

هر وقت خواستی با `ato audit --reset` ریست کن.

---

### 📄 مجوز

MIT © [Arjang Mousavi](https://github.com/aarjang)
