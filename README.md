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

پروژه رو اسکن می‌کنه، کد رو آنالیز می‌کنه، و همه چیز رو وایر می‌کنه:

**Code Intelligence Graph** — داخل `CONTEXT.md` ذخیره می‌شه:
- معماری پروژه (MVC layers, module structure)
- Critical path — فایل‌هایی که بیشترین dependency دارن + API‌شون
- Coupling map — فایل‌هایی که همیشه با هم تغییر می‌کنن (از git history)

**Auto-focus hooks** — داخل `.claude/settings.json`:
- `UserPromptSubmit` → `ato go --quiet` (focus قبل از هر session)
- `Stop` → `ato sync` (sync بعد از هر session)

---

### مرحله ۲ — هر session

```bash
claude
```

همین. دیگه هیچ.

- Claude معماری پروژه رو از اول می‌دونه
- focus file خودکار ساخته و خونده می‌شه
- بعد از session، sync خودکاره

**بدون copy-paste. بدون `ato go`. فقط Claude رو باز کن و تایپ کن.**

روی machine دیگه‌ای کار می‌کنی؟ فقط `git pull` بزن — context و stats خودکار sync می‌شن.

---

## Code Intelligence Graph

```
## Architecture
  controllers/     3 files   AuthController, UserController, OrderController
  services/        5 files   AuthService, PaymentService, EmailService ...
  models/          4 files   User, Order, Product, Session
  middleware/      2 files

## Critical path (read these first)
   12  src/services/auth.ts
        exports: authenticateUser · validateToken · hashPassword
    9  src/lib/db.ts
        exports: getConnection · query · transaction
    8  src/types/index.ts
        exports: User · Order · ApiResponse · PaginatedResult

## Coupling map (change these together)
  auth.service.ts ↔ auth.controller.ts    18 commits
  user.model.ts   ↔ user.service.ts       11 commits
  config.ts       ↔ .env.example           8 commits
```

Claude این رو می‌خونه و بدون باز کردن یه فایل می‌فهمه معماری چیه، کدوم فایل‌ها critical هستن، و کدوم‌ها با هم coupled هستن.

---

## چطور کار می‌کنه / How It Works

```
[ato init]
    ↓
  اسکن پروژه: stack، entry points، dependencies
  آنالیز کد: import graph → hub files → export surface
  آنالیز git: co-change clusters (90 days)
  CONTEXT.md ← code intelligence graph
  CLAUDE.md  ← standing instruction to auto-read focus file
  settings.json ← UserPromptSubmit + Stop hooks
    ↓
[باز کردن Claude Code]
    ↓
  UserPromptSubmit hook → ato go --quiet → .ato_focus_auto.md
    ↓
  CLAUDE.md: "if .ato_focus_auto.md exists, read it — no questions"
    ↓
[Claude می‌خونه CONTEXT.md: معماری + critical path + coupling]
[Claude می‌خونه focus file: فقط فایل‌های مرتبط با کار الان]
    ↓
[کار با Claude — بدون exploration]
    ↓
  Stop hook → ato sync → CONTEXT.md آپدیت + savings ثبت
                      → git commit "chore: auto-sync ato context [skip ci]"
```

فعالیت auto-focus رو می‌تونی live ببینی:
```bash
tail -f ~/.ato/run.log
```

---

## دستورات / Commands

| دستور | کار |
|---|---|
| `ato init` | یه بار — code graph + hooks + CLAUDE.md + DECISIONS.md |
| `ato mem "decision"` | ثبت تصمیم که context reset رو survive می‌کنه |
| `ato note "text"` | ثبت تصمیم مهم حین session در CONTEXT.md |
| `ato check` | وضعیت پروژه + context usage + savings |
| `ato audit` | token budget per section |
| `ato audit --reset` | ریست کردن آمار sessions |
| `ato update` | آپدیت به آخرین نسخه |

دستورات power:

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
║  ATO v3.0.0 — my-project                       ║
╚══════════════════════════════════════════════════╝

  Context
  ──────────────────────────────────────────────
  ✓  CONTEXT.md      95 lines  ~570    lean ✓
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

  Savings  (estimate — based on project size vs. focus file size)
  ──────────────────────────────────────────────
  Sessions        12
  Saved           ~847k tokens  ≈ $2.54
  Last session    2026-06-28
```

> **درباره اعداد savings:** این‌ها تخمین هستن، نه اندازه‌گیری دقیق. محاسبه اینطوره:
> `saved = (همه سورس فایل‌ها) − (CONTEXT.md + focus file)`. در واقع Claude بدون ato هم لزوماً کل codebase رو نمی‌خونه — ولی ato مطمئن می‌شه که فقط چیز مرتبط رو می‌خونه.

---

## حافظه دائمی / Persistent Memory

وقتی Claude Code history رو پاک می‌کنه یا context reset می‌شه، تصمیمات و کارهای نیمه‌تمام از دست می‌رن. `DECISIONS.md` این مشکل رو حل می‌کنه — جدا از `CONTEXT.md`، خودکار sync می‌شه، و بعد از هر reset Claude دوباره می‌خونتش.

```bash
ato mem "decided to use Redis instead of Postgres for session storage"
ato mem --wip "auth middleware — 70% done, next: token refresh"
ato mem --warn "never touch bin/legacy-migrate.sh — breaks prod silently"
```

بعد از هر session که context reset بشه، Claude این رو می‌خونه و از همون جایی که بودی ادامه می‌ده.

```
## Active work
- [ ] auth middleware — 70% done, next: token refresh

## Decisions
- 2026-06-28  Redis (not Postgres) for session storage — latency req

## Watch out
- never touch bin/legacy-migrate.sh — breaks prod silently
```

| دستور | کار |
|---|---|
| `ato mem "decision"` | ثبت تصمیم با تاریخ |
| `ato mem --wip "text"` | کار در جریان |
| `ato mem --done "text"` | حذف WIP تموم‌شده |
| `ato mem --warn "text"` | هشدار / gotcha |
| `ato mem --list` | نمایش همه حافظه |
| `ato mem --clear` | پاک کردن همه |

`DECISIONS.md` توسط `ato sync` بعد از هر session خودکار commit و push می‌شه — روی هر machine‌ای `git pull` کافیه.

---

## بهینه‌سازی توکن / Token Optimizations

### Focus file با محتوای فایل‌ها

`ato go` محتوای فایل‌های مرتبط رو (حداکثر ۸۰ خط هر فایل) مستقیم داخل focus file می‌ذاره. Claude از اول کد رو می‌بینه — بدون نیاز به tool call برای خوندن فایل‌ها.

```
## File contents (first 80 lines each — ask to see more):

### `src/services/auth.ts`  (142 lines)
```ts
export async function authenticateUser(email: string, password: string) {
  ...
}
... (62 more lines — ask to see them)
```
```

هر tool call که avoid می‌شه = **~500 توکن** صرفه‌جویی. روی ۱۰ پیام = ~5k توکن.

### Focus file size warning

```
✓  Focus file       ~2k        ← lean
!  Focus file       ~8k    ⚠ large — run: ato go --budget 40k
```

`ato check` اندازه focus file رو نشون می‌ده. بزرگ‌تر از 3k = هشدار.

> **آمار در:** `.ato-stats.json` (این پروژه) و `~/.ato/stats.json` (همه پروژه‌ها)

---

## MCP Server Mode

ato می‌تونه به عنوان MCP server اجرا بشه — Claude Code مستقیماً صداش می‌زنه:

```bash
ato mcp install
# → .claude/settings.json رو آپدیت می‌کنه
# → Claude Code رو restart کن
```

Tools در دسترس Claude:
`ato_focus` · `ato_sync` · `ato_note` · `ato_status` · `ato_doctor` · `ato_checkpoint`

---

## مجوز / License

MIT — [Arjang Mousavi](https://github.com/aarjang)
