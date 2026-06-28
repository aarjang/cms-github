# ato — AI Token Optimizer

**کاهش ۷۰-۹۰٪ مصرف توکن در Claude Code**  
**Reduce Claude Code token usage by 70–90% per session**

---

## مشکل / The Problem

وقتی Claude Code روی پروژه‌های بزرگ کار می‌کنه، هر session کل codebase رو می‌خونه:

```
Session معمولی — بدون ato:
  Claude میخونه: src/ + tests/ + configs = ~50,000 tokens
  ولی task شما فقط به 2 فایل نیاز داشت = ~3,000 tokens
  اتلاف: ~94%
```

When Claude Code works on large projects, it reads the entire codebase each session — even when your task only touches 2 files.

---

## راه‌حل / The Solution

یه `CONTEXT.md` کوچیک توی هر پروژه + یه CLI ابزار که خودش مدیریتش می‌کنه.

One lean `CONTEXT.md` per project + a CLI that keeps it current automatically.

Claude فقط همین فایل رو می‌خونه — نه کل codebase.

---

## نصب / Install

```bash
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash
source ~/.zshrc   # or ~/.bashrc
```

---

## روند کار / Workflow

### ۱. اول بار توی هر پروژه / First time in a project

```bash
cd ~/projects/my-project
ato init
```

پروژه رو اسکن می‌کنه و `CONTEXT.md` رو با داده‌های واقعی پر می‌کنه:
- Stack و entry points
- ساختار پوشه‌ها
- Hot files — فایل‌هایی که بیشترین تغییر رو داشتن (از git)
- Commands، env vars، dependencies
- Stop-hook برای auto-sync بعد از هر session

اگه `CONTEXT.md` از قبل وجود داشته باشه، می‌پرسه می‌خوای regenerate کنی یا نه.  
If `CONTEXT.md` already exists, it prompts before overwriting (and backs up first).

---

### ۲. قبل از هر session / Before each Claude Code session

```bash
ato focus
```

**بدون هیچ آرگومانی** — ato از روی git تشخیص می‌ده روی چی کار می‌کنی:
- فایل‌های modified در `git status`
- فایل‌هایی که در ۷ روز اخیر لمس شدن
- نام branch برای تشخیص area

یه فایل `.ato_focus_auto.md` می‌سازه. این رو به Claude بده:

```
Read .ato_focus_auto.md and follow the session rules inside it.
```

Claude دقیقاً می‌دونه کجا نگاه کنه — نه کل codebase.

---

### ۳. بعد از session / After session ends

Stop-hook به صورت خودکار `ato sync` می‌زنه:
- CONTEXT.md آپدیت می‌شه (branch، فایل‌های تغییرکرده، git log)
- توکن‌های صرفه‌جویی‌شده ثبت می‌شن

نیازی به کار اضافه نیست.

---

### ۴. پیگیری صرفه‌جویی / Track your savings

```bash
ato stats
```

```
ATO Token Savings

  📁 Project: my-app
  ┌─────────────────────────────────────┐
  │  Sessions run                    12  │
  │  Tokens saved               ~847k  │
  │  Tasks completed                 8  │
  │  Last session           2026-06-28  │
  └─────────────────────────────────────┘
  avg ~70k tokens saved per session
  ≈ $2.54 saved in API costs (@ $3/MTok)
```

---

## بررسی token budget / Check token budget

```bash
ato trim
```

```
Section                        Lines  Tokens  Share
──────────────────────────────────────────────────────────
Identity                           6     ~36    7%
Commands                          10     ~60   12%
Structure                         25    ~150   29%  ← trim
Key dependencies                  14     ~84   16%
Hot files                          9     ~54   10%
...
──────────────────────────────────────────────────────────
Total                             89    ~534
```

نشون می‌ده کدوم section بیشترین توکن مصرف می‌کنه تا بدونی کجا trim کنی.

---

## MCP Server Mode

ato می‌تونه به عنوان یه MCP server اجرا بشه — یعنی Claude Code می‌تونه مستقیماً دستورات ato رو صدا بزنه بدون اینکه کاربر چیزی تایپ کنه.

```bash
ato mcp install   # ato رو به .claude/settings.json اضافه می‌کنه
```

بعد از restart کردن Claude Code، این tools در دسترس Claude هستن:

| Tool | کار |
|---|---|
| `ato_focus` | auto-focus از git signals |
| `ato_sync` | sync CONTEXT.md + ثبت savings |
| `ato_note` | ثبت تصمیم در CONTEXT.md |
| `ato_status` | وضعیت پروژه |
| `ato_doctor` | audit startup tokens |
| `ato_checkpoint` | برآورد context usage |

---

## دستورات / Commands

```
ato init                اسکن پروژه → CONTEXT.md + CLAUDE.md + stop-hook
ato focus               auto-detect work area از git → focused session
ato focus <topic>       focus روی یه topic مشخص (جستجو در git history)
ato focus --budget 40k  trim scope برای Pro plan (محدودیت توکن)
ato sync                آپدیت CONTEXT.md + ثبت savings
ato note "text"         ثبت تصمیم در CONTEXT.md (بعد از compaction باقی می‌مونه)
ato status              وضعیت کلی پروژه + token budget
ato stats               آمار صرفه‌جویی توکن + معادل دلاری
ato trim                token budget per section + آدیت CONTEXT.md
ato slim [file]         نمایش sections CLAUDE.md بر اساس اندازه
ato doctor              audit overhead startup (CLAUDE.md، memory files)
ato checkpoint          برآورد context usage + پیشنهاد stopping point
ato scope <pattern>     هزینه توکن یه مجموعه فایل
ato mcp install         ثبت ato به عنوان MCP server در Claude Code
ato update              آپدیت ato به آخرین نسخه
ato add "task"          اضافه کردن task به TASKS.md
ato focus <id>          focused session برای یه task مشخص
ato done <id>           archive کردن task
```

---

## مجوز / License

MIT — [Arjang Mousavi](https://github.com/aarjang)
