# ato — AI Token Optimizer

**کاهش ۷۰-۹۰٪ مصرف توکن در Claude Code**  
**Reduce Claude Code token usage by 70–90% per session**

---

## مشکل / The Problem

وقتی Claude Code روی پروژه‌های بزرگ کار می‌کنه، هر session کل codebase رو می‌خونه:

```
بدون ato:
  Claude میخونه: src/ + tests/ + configs = ~50,000 tokens
  ولی task شما فقط به 2 فایل نیاز داشت = ~3,000 tokens
  اتلاف: ~94%
```

---

## نصب / Install

```bash
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.zshrc   # or ~/.bashrc
```

---

## روند کار / Workflow

دو مرحله‌ست. همین.

### مرحله ۱ — یه بار توی هر پروژه

```bash
cd ~/projects/my-project
ato init
```

پروژه رو اسکن می‌کنه و همه چیز رو وایر می‌کنه:
- `CONTEXT.md` با داده‌های واقعی (stack، entry points، hot files)
- `CLAUDE.md` با دستورالعمل auto-focus
- دو hook در `.claude/settings.json`:
  - **UserPromptSubmit** → `ato go --quiet` (focus قبل از هر session)
  - **Stop** → `ato sync` (sync بعد از هر session)

---

### مرحله ۲ — هر session

```bash
claude
```

همین. دیگه هیچ.

- `ato go --quiet` خودکار اجرا می‌شه
- Claude فایل focus رو خودکار می‌خونه
- فقط روی فایل‌های مرتبط با کار الان کار می‌کنه
- بعد از session، sync خودکاره

**بدون copy-paste. بدون `ato go`. فقط Claude رو باز کن و تایپ کن.**

---

## چطور کار می‌کنه / How It Works

```
[باز کردن Claude Code]
        ↓
UserPromptSubmit hook → ato go --quiet
        ↓
ato از git می‌خونه: modified files + recent commits + branch name
        ↓
.ato_focus_auto.md ساخته می‌شه
        ↓
CLAUDE.md به Claude می‌گه: این فایل رو بدون پرسیدن بخون
        ↓
[Claude فقط روی فایل‌های مرتبط کار می‌کنه]
        ↓
[Session تموم]
        ↓
Stop hook → ato sync → CONTEXT.md آپدیت + savings ثبت
```

فعالیت auto-focus رو می‌تونی live ببینی:
```bash
tail -f ~/.ato/run.log
```

---

## دستورات / Commands

| دستور | کار |
|---|---|
| `ato init` | یه بار — setup کامل پروژه |
| `ato note "text"` | ثبت تصمیم مهم حین session |
| `ato check` | وضعیت پروژه + context usage + savings |
| `ato audit` | token budget per section |
| `ato update` | آپدیت به آخرین نسخه |

دستورات power (نیازی نیست بدونی، ولی وجود دارن):

```bash
ato go                    # manual focus (auto runs on session start)
ato go auth               # focus روی یه topic مشخص
ato go --budget 40k       # محدود کردن scope برای Pro plan
ato audit --scope "*.ts"  # token cost یه مجموعه فایل
ato mcp install           # ثبت به عنوان MCP server
ato task add/done         # task tracking اختیاری
```

---

## `ato check` — وضعیت کامل

```
╔══════════════════════════════════════════════════╗
║  ATO v2.9.0 — my-project                       ║
╚══════════════════════════════════════════════════╝

  Context
  ──────────────────────────────────────────────
  ✓  CONTEXT.md      89 lines  ~534    lean ✓
  ✓  CLAUDE.md       17 lines  ~102    lean ✓
  ✓  Auto-sync       active  (Stop hook)
  ✓  Auto-focus      active  (UserPromptSubmit hook)

  Available for work: ~166k / ~200k tokens (83% free)

  Session
  ──────────────────────────────────────────────
  ██████░░░░░░░░░░░░░░░░░░  25%  safe to continue

  Git
  ──────────────────────────────────────────────
  Branch          main
  Status          clean
  Last commit     "fix: auth middleware" (2 hours ago)

  Savings
  ──────────────────────────────────────────────
  Sessions        12
  Saved           ~847k tokens  ≈ $2.54
  Last session    2026-06-28
```

---

## `ato audit` — بررسی token budget

```
Section                        Lines  Tokens  Share
──────────────────────────────────────────────────────────
Architecture snapshot             25    ~150   29%  ← trim
Key dependencies                  14     ~84   16%
Commands                          10     ~60   12%
Hot files                          9     ~54   10%
Identity                           6     ~36    7%
──────────────────────────────────────────────────────────
Total                             89    ~534
```

---

## MCP Server Mode

ato می‌تونه به عنوان MCP server اجرا بشه — Claude Code مستقیماً می‌تونه ato رو صدا بزنه:

```bash
ato mcp install
# → .claude/settings.json رو آپدیت می‌کنه
# → Claude Code رو restart کن
```

بعد Claude می‌تونه مستقیم از این tools استفاده کنه:
`ato_focus` · `ato_sync` · `ato_note` · `ato_status` · `ato_doctor` · `ato_checkpoint`

---

## مجوز / License

MIT — [Arjang Mousavi](https://github.com/aarjang)
