# CMS — Context Management System

**کاهش ۷۰-۹۰٪ مصرف توکن در Claude Code**  
**Reduce Claude Code token usage by 70–90% per session**

---

## مشکل / The Problem

وقتی Claude Code روی پروژه‌های بزرگ کار می‌کنه، هر session کل codebase رو می‌خونه:

```
Session معمولی — بدون CMS:
  Claude میخونه: src/ + tests/ + configs = ~50,000 tokens
  ولی task شما فقط به 2 فایل نیاز داشت = ~3,000 tokens
  اتلاف: ~94%
```

When Claude Code works on large projects, it reads the entire codebase each session — even when your task only touches 2 files.

---

## راه‌حل / The Solution

سه فایل ساده توی هر پروژه + یه CLI ابزار:

Three simple files per project + a CLI tool:

| فایل | کار | Lines |
|------|-----|-------|
| `CONTEXT.md` | نقشه پروژه — معماری، contracts، anti-patterns | < 200 |
| `TASKS.md` | task جاری با scope دقیق | < 50 |
| `DECISIONS.md` | چرای تصمیمات معماری | هر چقدر |

Claude فقط همین‌ها رو می‌خونه — نه کل codebase.

---

## نصب / Install

### یه‌خطی / One-liner
```bash
curl -fsSL https://raw.githubusercontent.com/aarjang/cms/main/install.sh | bash
source ~/.zshrc   # or ~/.bashrc
```

### دستی / Manual
```bash
# Clone
git clone https://github.com/aarjang/cms.git
cd cms

# Install
cp bin/cms ~/bin/cms
chmod +x ~/bin/cms
mkdir -p ~/.cms
cp -r templates ~/.cms/

# Add to shell (~/.zshrc or ~/.bashrc)
export PATH="$HOME/bin:$PATH"
export CMS_TEMPLATES="$HOME/.cms/templates"
```

### لینوکس / Linux (same steps)
```bash
# اگه sudo داری
sudo cp bin/cms /usr/local/bin/cms
sudo chmod +x /usr/local/bin/cms

# بدون sudo
cp bin/cms ~/bin/cms && chmod +x ~/bin/cms
```

---

## استفاده / Usage

### اول بار توی هر پروژه / First time in a project
```bash
cd ~/projects/my-project
cms init MyProject
# → CONTEXT.md, TASKS.md, DECISIONS.md, CLAUDE.md ساخته می‌شن
# → CONTEXT.md رو پر کن (10 دقیقه)
```

### قبل از هر session در Claude Code / Before each session
```bash
cms focus N-1
# → یه prompt بهینه می‌سازه + session رو ثبت می‌کنه
```

اون prompt رو به عنوان **اولین پیام** توی Claude Code paste کن.

### بعد از اتمام task / After task complete
```bash
cms done N-1
# → task archive می‌شه + آمار update می‌شه
```

### دیدن آمار / View savings
```bash
cms stats           # هر دو / both
cms stats local     # این پروژه / this project
cms stats global    # همه پروژه‌ها / all projects
```

---

## آمار نمونه / Example Stats Output

```
CMS Token Savings

  📁 Project: osta
  ┌─────────────────────────────────────┐
  │  Sessions run                    12  │
  │  Tokens saved               ~847k  │
  │  Tasks completed                 8  │
  │  Last session           2025-01-15  │
  └─────────────────────────────────────┘
  avg ~70k tokens saved per session
  ≈ $2.54 saved in API costs (@ $3/MTok)

  🌍 All projects (since 2025-01-01)
  ┌─────────────────────────────────────┐
  │  Total sessions                  34  │
  │  Total tokens saved           ~2.1M  │
  │  Total tasks done               23  │
  └─────────────────────────────────────┘
  ≈ $6.30 total API cost saved
```

---

## دستورات / Commands

```
cms init [name]          پروژه جدید راه‌اندازی کن
cms focus <task-id>      session بهینه برای یه task
cms done <task-id>       task رو archive کن
cms stats [local|global] آمار صرفه‌جویی توکن
cms status               وضعیت کلی پروژه
cms scope <pattern>      هزینه توکن یه مجموعه فایل
cms trim                 آدیت CONTEXT.md
cms prompt               startup message برای Claude Code
cms reset-stats [global] ریست آمار
```

---

## Sync بین Mac و Linux

فایل‌های CMS توی پروژه‌ان → با git sync می‌شن:

```bash
git add CONTEXT.md TASKS.md DECISIONS.md CLAUDE.md
git commit -m "chore: add CMS context files"
git push
# روی سرور: git pull → همه چیز sync‌ه
```

فقط `cms` script رو روی هر دستگاه یه بار نصب کن.

---

## نمونه / Demo

پوشه `demo/` یه پروژه نمونه کامل داره با CONTEXT.md و TASKS.md پر شده.

The `demo/` folder contains a complete example project with filled CONTEXT.md and TASKS.md.

---

## مجوز / License

MIT — [Arjang Mousavi](https://github.com/aarjang)
