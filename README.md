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

سه مرحله‌ست. همین.

### مرحله ۱ — یه بار توی هر پروژه

```bash
cd ~/projects/my-project
ato init
```

پروژه رو اسکن می‌کنه و `CONTEXT.md` رو با داده‌های واقعی پر می‌کنه:
- Stack، entry points، ساختار پوشه‌ها
- Hot files — فایل‌هایی که بیشترین تغییر رو داشتن
- Commands، env vars، stop-hook برای auto-sync

اگه `CONTEXT.md` قبلاً وجود داشته باشه، می‌پرسه می‌خوای regenerate کنی یا نه.

---

### مرحله ۲ — قبل از هر session با Claude

```bash
ato go
```

ato از git می‌خونه و تشخیص می‌ده الان روی چی کار می‌کنی:
- فایل‌های modified در `git status`
- فایل‌هایی که در ۷ روز اخیر تغییر کردن
- نام branch برای تشخیص area

یه فایل `.ato_focus_auto.md` می‌سازه. **این رو اول بده به Claude:**

```
Read .ato_focus_auto.md and follow the session rules inside it.
```

Claude فقط روی همون فایل‌ها focus می‌کنه — نه کل codebase.

خروجی `ato go`:

```
✓ Auto-focused: current changes

→ Files in scope:
    src/auth.ts       (142 lines)
    src/middleware.ts  (89 lines)
    tests/auth.test.ts (61 lines)

  Startup cost: CONTEXT ~534 + CLAUDE.md ~102 + focus file ~756 = ~1k tokens
  Available for work: ~165k / ~200k tokens

→ Paste into Claude Code:

    Read .ato_focus_auto.md and follow the session rules inside it.
```

---

### مرحله ۳ — بعد از session

هیچ کاری نکن. stop-hook خودکار `ato sync` می‌زنه:
- CONTEXT.md آپدیت می‌شه
- savings ثبت می‌شه

---

## دستورات اصلی / Commands

| دستور | کار |
|---|---|
| `ato init` | یه بار — setup پروژه |
| `ato go` | قبل از هر session |
| `ato note "text"` | ثبت تصمیم مهم حین session |
| `ato check` | وضعیت پروژه + context usage + savings |
| `ato audit` | token budget per section |
| `ato update` | آپدیت به آخرین نسخه |

---

## `ato check` — وضعیت کامل

```bash
ato check
```

```
╔══════════════════════════════════════════════════╗
║  ATO v2.7.0 — my-project                       ║
╚══════════════════════════════════════════════════╝

  Context
  ──────────────────────────────────────────────
  ✓  CONTEXT.md      89 lines  ~534    lean ✓
  ✓  CLAUDE.md       17 lines  ~102    lean ✓
  ✓  Stop-hook       active

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

```bash
ato audit
```

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

sections بزرگ رو شناسایی می‌کنه تا بدونی کجا trim کنی.

---

## گزینه‌های پیشرفته / Power Options

```bash
# focus روی یه topic مشخص
ato go auth

# محدود کردن scope برای Pro plan
ato go --budget 40k

# ثبت تصمیم که بعد از compaction باقی بمونه
ato note "decided to use optimistic locking"

# token cost یه مجموعه فایل
ato audit --scope "src/**/*.ts"

# ثبت ato به عنوان MCP server (Claude مستقیم صداش می‌زنه)
ato mcp install

# task tracking اختیاری
ato task add "fix login bug"
ato task done 1
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
