# PROJECT CONTEXT — [PROJECT_NAME]
<!-- Claude reads this FIRST. Keep it under 200 lines. -->
<!-- Last updated: [DATE] by [WHO] -->

## TL;DR (5 lines max)
<!-- What does this project do? What's the core loop? -->
[ONE_SENTENCE_PURPOSE]

Stack: [TECH_STACK]
Entry points: [MAIN_FILES_CLAUDE_NEEDS]
Active branch: [GIT_BRANCH]
Last meaningful change: [WHAT_CHANGED]

---

## Architecture snapshot
<!-- Folder structure — only folders Claude needs to touch -->
```
[PROJECT_ROOT]/
├── [FOLDER_1]/          # [ONE_LINE_PURPOSE]
│   ├── [KEY_FILE]       # [WHAT_IT_DOES]
│   └── [KEY_FILE]       # [WHAT_IT_DOES]
├── [FOLDER_2]/          # [ONE_LINE_PURPOSE]
└── [CONFIG_FILE]        # [WHAT_IT_DOES]
```

## Contracts (do not break)
<!-- API signatures, DB schema, env vars — things Claude must not change without asking -->

### Environment variables needed
```
[VAR_NAME]=[DESCRIPTION_NOT_VALUE]
[VAR_NAME]=[DESCRIPTION_NOT_VALUE]
```

### Key interfaces / types
```typescript
// [INTERFACE_NAME] — used by [WHO]
interface [NAME] {
  [FIELD]: [TYPE]; // [EXPLANATION]
}
```

### DB tables (touch with care)
- `[TABLE]`: [purpose], PK=[field], critical indexes=[fields]

---

## What Claude should NOT do
<!-- Anti-patterns, known footguns, things that broke before -->
- ❌ [THING_TO_AVOID] — because [REASON]
- ❌ Never run `[DANGEROUS_COMMAND]` — it [BAD_OUTCOME]
- ❌ Do not modify `[FILE]` directly — use `[CORRECT_WAY]` instead

---

## How to run locally
```bash
# Setup (once)
[SETUP_COMMAND]

# Dev
[DEV_COMMAND]

# Test
[TEST_COMMAND]
```

---

## Active work area
<!-- Point Claude here — reduces file scanning -->
Current focus: `[PATH/TO/CURRENT_WORK]`
Files in scope for current task: 
- `[FILE_1]` — [why relevant]
- `[FILE_2]` — [why relevant]

---
<!-- Claude: read TASKS.md for what to do, DECISIONS.md if you need to understand why -->
