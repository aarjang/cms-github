# PROJECT CONTEXT — ato
<!-- Claude reads this FIRST. Keep it under 200 lines. -->
<!-- Last updated: 2026-06-27 by Arjang -->

## TL;DR (5 lines max)
**ato** (AI Token Optimizer) — یک CLI ابزار bash برای کاهش ۷۰-۹۰٪ مصرف توکن در Claude Code.
با مدیریت `CONTEXT.md` در هر پروژه، کلود فقط اطلاعات ضروری رو می‌خونه نه کل کدبیس.

Stack: Pure Bash (POSIX-compatible, no external deps)
Entry points: `bin/ato`, `install.sh`
Active branch: main
Last meaningful change: rename از cms به ato (v2.0.0)

---

## Architecture snapshot
```
ato/
├── bin/
│   ├── ato              # اسکریپت اصلی CLI (~40KB, همه commands اینجاست)
│   └── cms              # migration shim — هدایت به ato
├── templates/           # تمپلیت‌های پیش‌فرض برای پروژه‌های جدید
│   ├── CONTEXT.md       # تمپلیت خالی CONTEXT.md
│   ├── CLAUDE.md        # تمپلیت CLAUDE.md با on-startup rules
│   ├── TASKS.md         # تمپلیت جدول وظایف
│   └── DECISIONS.md     # تمپلیت ثبت تصمیمات
├── demo/                # پروژه نمونه برای تست و demo
├── install.sh           # نصب یک‌خطی (curl | bash)
└── README.md            # مستندات عمومی
```

## Contracts (do not break)

### Environment variables
```
ATO_TEMPLATES=$HOME/.ato/templates   # مسیر تمپلیت‌های global
ATO_INSTALL_DIR=$HOME/bin            # مسیر نصب باینری
```

### فایل‌های stats
```
$HOME/.ato/stats.json   # آمار global (همه پروژه‌ها)
.ato-stats.json         # آمار local (همین پروژه)
```

### Commands اصلی
```
ato init [name]     → تولید CONTEXT.md + CLAUDE.md + نصب stop-hook
ato sync            → آپدیت CONTEXT.md (branch, changed files, git log)
ato status          → نمایش وضعیت پروژه + token budget
ato update          → self-update از GitHub
ato add / focus / done  → مدیریت اختیاری tasks
```

---

## What Claude should NOT do
- ❌ استفاده از `jq` یا هر ابزار خارجی — ato باید بدون dependency کار کنه
- ❌ استفاده از `sed -i` بدون suffix روی macOS — BSD sed فرق داره با GNU
- ❌ تغییر مستقیم `install.sh` بدون بررسی PATH و shell detection
- ❌ شکستن سازگاری POSIX — باید روی macOS (BSD tools) و Linux هر دو کار کنه

---

## How to run locally
```bash
# نصب
curl -fsSL https://raw.githubusercontent.com/aarjang/ato/main/install.sh | bash

# تست روی پروژه جاری
ato init
ato sync
ato status

# تست self-update
ato update
```

---

## Active work area
Current focus: `nothing modified`
Files in scope for current task:
- `bin/ato` — اسکریپت اصلی، همه commands اینجاست
- `bin/cms` — migration shim از cms به ato
- `templates/` — تمپلیت‌هایی که با `ato init` کپی می‌شن

---
<!-- Claude: read TASKS.md for what to do, DECISIONS.md if you need to understand why -->
