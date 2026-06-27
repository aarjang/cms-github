# TASKS — cms-github
<!-- Current sprint / active work only. No history here. -->
<!-- Completed tasks → archive with `cms done [TASK_ID]` -->

## 🔴 Blocked
<!-- Tasks waiting on something — Claude should flag these, not guess through them -->
| ID | Task | Blocked by | Since |
|----|------|------------|-------|
| B-1 | [TASK] | [WHAT_IS_BLOCKING] | 2026-06-27 |

## 🟡 In Progress
<!-- What's actively being worked on RIGHT NOW -->
| ID | Task | Owner | Files touched |
|----|------|-------|--------------|
| P-1 | [TASK] | [HUMAN/CLAUDE] | `[FILE1]`, `[FILE2]` |

## 🟢 Up Next
<!-- Prioritized queue — Claude picks from top -->
| ID | Task | Priority | Estimated scope |
|----|------|----------|----------------|
| N-1 | [TASK] | P0 | [small/medium/large] |
| N-2 | [TASK] | P1 | [small/medium/large] |

---

## Current task detail
<!-- Only expand the ONE task Claude is working on right now -->

### N-1: Fix install.sh and cms focus compatibility
**Goal:** installer downloads from correct repo; cms focus works on macOS
**Scope:** Only these files:
- `install.sh` — fix repo URL
- `bin/cms` — replace BSD-incompatible sed with awk

**Do NOT touch:** `templates/`, `README.md`

**Done when:**
- [x] install.sh points to aarjang/cms-github
- [x] cms focus N-1 runs without sed error on macOS

**Test command:** `cms focus N-1`

---
<!-- Claude: do NOT ask for context outside the files listed above -->
<!-- If you need something not listed, ask the PM — do not explore the codebase -->
