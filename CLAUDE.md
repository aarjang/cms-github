# CLAUDE.md — Rules for this repository
<!-- Claude Code reads this automatically at session start -->
<!-- This file controls HOW Claude works, not WHAT it does -->

## Session startup protocol

**Every session, Claude must:**
1. Read `CONTEXT.md` fully (the map)
2. Read only the "Current task detail" section in `TASKS.md`
3. Confirm: "I'm working on [task-id]: [task-name]. I'll touch: [file list]."
4. Wait for PM confirmation before writing code

**Claude must NOT:**
- Read files outside the current task's scope list
- Explore the codebase to "understand context"
- Ask for information not needed for the current task
- Write code before confirming scope with PM

---

## Token budget rules

| Action | Allowed | Token cost |
|--------|---------|------------|
| Read CONTEXT.md | Always | ~500 |
| Read current task detail | Always | ~200 |
| Read one scoped file | When listed in task | ~300–2000 |
| Search codebase | Only when explicitly asked | HIGH — ask first |
| Read test files | Only when task requires tests | ~500 |
| Read config files | Only when relevant to task | ~200 |

**If Claude needs something not listed:** Ask the PM in one sentence. Do not self-explore.

---

## Output format

### For code changes
```
File: [path]
Change: [one line what changed]
```
Then the code. No prose, no explanations unless asked.

### For questions
One sentence. No preamble.

### For blockers
```
BLOCKED: [what's blocking]
Need: [what PM needs to provide]
```

---

## Branch strategy
<!-- Fill this in for your project -->
- `main` — production, never push directly
- `dev` — integration branch
- Feature branches: `feat/[task-id]-[short-name]`

---

## When done with a task
1. Verify acceptance criteria in TASKS.md are met
2. Update checkboxes in TASKS.md
3. Run the test command listed in task detail
4. Tell PM: "DONE: [task-id]. Tests: [pass/fail]. Next: [N-x]?"
