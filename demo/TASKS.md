# TASKS — TodoAPI

## 🔴 Blocked
| ID | Task | Blocked by |
|----|------|------------|
| B-1 | Add file attachments to todos | Waiting for S3 bucket setup |

## 🟡 In Progress
| ID | Task | Files touched |
|----|------|--------------|
| P-1 | Fix pagination bug | `src/routes/todos.ts` |

## 🟢 Up Next
| ID | Task | Priority |
|----|------|----------|
| N-1 | Add due_date field to todos | P0 |
| N-2 | Rate limiting on auth routes | P1 |
| N-3 | Soft delete instead of hard delete | P2 |

---

## Current task detail

### N-1: Add due_date field to todos
**Goal:** Todos can have an optional due date; API accepts and returns it; overdue todos flagged.

**Scope:**
- `src/db/schema.ts` — add `dueDate: timestamp (nullable)`
- `src/services/todo.service.ts` — include dueDate in create/update/list
- `src/routes/todos.ts` — add dueDate to Zod validation schemas

**Do NOT touch:** `src/middleware/`, `src/routes/auth.ts`, migrations/ (auto-generated)

**Done when:**
- [ ] `POST /api/todos` accepts `dueDate` (ISO string, optional)
- [ ] `GET /api/todos` returns `dueDate` and `isOverdue` boolean
- [ ] Migration generated: `pnpm db:generate` runs clean
- [ ] `pnpm test` passes

**Test:** `pnpm test -- --grep "due_date"`
