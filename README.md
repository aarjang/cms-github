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

## استفاده / Usage

### اول بار توی هر پروژه / First time in a project

```bash
cd ~/projects/my-project
ato init
```

`ato init` پروژه رو اسکن می‌کنه و `CONTEXT.md` رو **با داده‌های واقعی** پر می‌کنه:
- Stack و entry points
- ساختار پوشه‌ها
- Hot files — فایل‌هایی که بیشترین تغییر رو داشتن (از git)
- Commands، env vars، dependencies
- Stop-hook برای auto-sync بعد از هر session

`ato init` scans the project and fills `CONTEXT.md` with **real data** — stack, structure, hot files from git history, commands, and env vars.

اگه `CONTEXT.md` از قبل وجود داشته باشه، می‌پرسه می‌خوای regenerate کنی یا نه.  
If `CONTEXT.md` already exists, it prompts before overwriting (and backs up first).

### قبل از هر session / Before each Claude Code session

```bash
ato focus
```

**بدون هیچ آرگومانی** — ato از روی git تشخیص می‌ده روی چی کار می‌کنی:

- فایل‌های modified در `git status`
- فایل‌هایی که در ۷ روز اخیر لمس شدن
- نام branch برای تشخیص area

یه فایل focused session می‌سازه و Claude دقیقاً می‌دونه کجا نگاه کنه.

**No arguments needed** — ato reads your git signals to auto-detect the work area and generate a focused context file for Claude.

### بعد از session / After session ends

Stop-hook به صورت خودکار `ato sync` می‌زنه — نیازی به کار اضافه نیست.

The stop-hook runs `ato sync` automatically — no manual action needed.

### بررسی token budget / Check token budget

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

Shows exactly which section is eating the most tokens so you know where to cut.

---

## دستورات / Commands

```
ato init              اسکن پروژه → CONTEXT.md + CLAUDE.md + stop-hook
ato focus             auto-detect work area از git → focused session
ato sync              آپدیت CONTEXT.md (branch، فایل‌های تغییرکرده، git log)
ato status            وضعیت کلی پروژه + token budget
ato stats             آمار صرفه‌جویی توکن
ato scope <pattern>   هزینه توکن یه مجموعه فایل
ato trim              token budget per section + آدیت CONTEXT.md
ato update            آپدیت ato به آخرین نسخه
ato add "task"        اضافه کردن task به TASKS.md
ato focus <id>        focused session برای یه task مشخص
ato done <id>         archive کردن task
```

---

## آمار نمونه / Example Stats Output

```
ATO Token Savings

  📁 Project: my-app
  ┌─────────────────────────────────────┐
  │  Sessions run                    12  │
  │  Tokens saved               ~847k  │
  │  Tasks completed                 8  │
  │  Last session           2026-06-27  │
  └─────────────────────────────────────┘
  avg ~70k tokens saved per session
```

---

## نمونه / Demo

پوشه `demo/` یه پروژه نمونه کامل داره با CONTEXT.md پر شده.

The `demo/` folder contains a complete example project with a filled CONTEXT.md.

---

## مجوز / License

MIT — [Arjang Mousavi](https://github.com/aarjang)
