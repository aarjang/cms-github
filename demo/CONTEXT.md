# PROJECT CONTEXT — TodoAPI
<!-- Keep under 200 lines. Claude reads this first. -->
<!-- Updated: 2025-01-15 -->

## TL;DR
A simple REST API for todo management — Express + PostgreSQL + TypeScript.
Used as CMS demo to show focused Claude Code sessions.

Stack: Node.js 20, Express 5, PostgreSQL 16, Drizzle ORM, TypeScript strict
Entry: src/index.ts
Branch: main

## Architecture
```
src/
  index.ts         → app bootstrap, port 3000
  routes/
    todos.ts       → CRUD endpoints /api/todos
    auth.ts        → JWT login/register
  services/
    todo.service.ts → business logic
    auth.service.ts → token handling
  db/
    schema.ts      → Drizzle table definitions
    migrations/    → SQL migration files
  middleware/
    auth.ts        → JWT verify middleware
    validate.ts    → Zod request validation
```

## Contracts

### Environment variables
```
DATABASE_URL=postgres connection string
JWT_SECRET=signing secret (min 32 chars)
PORT=3000 (default)
```

### Key types
```typescript
// Todo — main entity
interface Todo {
  id: string;        // uuid
  userId: string;    // FK → users.id
  title: string;
  done: boolean;
  createdAt: Date;
}

// API response shape
interface ApiResponse<T> {
  data: T | null;
  error: string | null;
}
```

### DB tables
- `todos`: PK=id(uuid), FK=user_id, indexes: (user_id, done)
- `users`: PK=id(uuid), unique: email

## Anti-patterns
- ❌ Never use `SELECT *` — always select explicit columns
- ❌ Never skip the `authMiddleware` on /api/todos routes
- ❌ Never run raw SQL — use Drizzle query builder
- ❌ Never modify migrations/ directly — use: `pnpm db:generate`

## Run locally
```bash
pnpm install
pnpm db:migrate
pnpm dev          # → http://localhost:3000
pnpm test         # vitest
```

## Active scope
Current focus: `src/routes/todos.ts`, `src/services/todo.service.ts`
<!-- Claude: read TASKS.md for what to do -->
