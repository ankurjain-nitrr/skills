---
name: reflect
description: Session retrospective that cuts future token use. Finds this session's corrections, failed attempts, repeated lookups and decisions, saves each to the cheapest place (project CLAUDE.md, path-scoped rule, user CLAUDE.md, skill, hook) and prunes stale entries. Use for /reflect, retros, "save learnings", "remember this next time", or wrapping up a long session.
---

# Reflect

Turn this session's hard-won context into a few precise instructions, so the next session doesn't pay for it again.

Every line in a CLAUDE.md is re-read on every turn of every future session, so an entry only earns its place if
the waste it prevents is larger than what it costs to carry. A good reflect run usually adds 2-6 short lines and
removes some. Adding a lot is a sign of over-capture, not thoroughness.

## 1. Mine the session for waste

Read back through the conversation and list moments that cost tokens and would recur. The highest-value signals:

- **Corrections**: the user said "no", "actually", "always/never", changed your approach, or answered a question you
  had to ask. A future session will ask or guess wrong again.
- **Dead ends**: a command, tool or approach failed and you retried, e.g. auth that only works one way, a shell quirk,
  a tool version that behaves differently, a path that doesn't exist.
- **Expensive discovery**: files read repeatedly to find something, web research whose conclusion will be needed
  again, a non-obvious command that finally worked.
- **Decisions**: conventions or design choices the user settled that aren't obvious from the code.

Skip what is cheap to rediscover: anything in the code, git history, README or existing docs, one-off task details,
and general best practice the model already follows.

For each candidate, ask: *without this, would a future session plausibly waste a tool call, a question to the user,
or a wrong attempt?* If not, drop it.

## 2. Route each learning to the cheapest home

The same fact costs very different amounts depending on where it lives. Pick the first row that fits:

| Learning | Home | Context cost |
|---|---|---|
| Must happen every time, mechanically checkable (format before commit, block a command) | suggest a hook in settings.json | none: enforced outside the context |
| Only matters when touching certain files or directories | `.claude/rules/<topic>.md` with `paths:` frontmatter | loads only when matching files are used |
| A multi-step procedure or reference material | a skill, or a doc in the repo linked from CLAUDE.md by path in backticks | loads only when needed |
| Project fact needed in most sessions (build/test commands, conventions, gotchas, where things live) | project `CLAUDE.md` | every turn of every session in that project |
| Personal preference that applies across projects | `~/.claude/CLAUDE.md` | every turn of every session everywhere |
| Only relevant to this session | nowhere | none |

Notes that matter:

- Project-specific learnings go in the project's CLAUDE.md (or its rules), never the user file. Mixing them makes
  every other project pay for them.
- `@path` imports don't save tokens: imported files load at launch too. To make a doc load on demand, mention its
  path in backticks and say when to read it.
- If the session uses an auto memory directory, don't duplicate entries there. Prefer CLAUDE.md for project facts
  and remove a memory entry you promote into CLAUDE.md.
- New skills, hooks and rule files are bigger changes. Propose them with a one-line rationale and create them only
  if the user approves.

## 3. Write entries that are cheap to carry

- One line each, imperative, specific: commands, paths, versions, the exact flag.
- Add the *why* only when the instruction looks arbitrary without it, in a few words.
- Put each entry under the existing heading it belongs to. Don't add a "Learnings" dump section.
- Use an HTML comment (`<!-- ... -->`) for notes meant for humans only. They're stripped before loading and cost nothing.

Good, from a real session:

```markdown
- Push with gh credentials over HTTPS (`git -c credential.helper='!gh auth git-credential' push`); SSH is rejected.
- Use buf >= 1.73: older `buf lint` can't compile protovalidate CEL that references buf.validate types.
```

Bad: `- We added moderation to comments` (that's in git history), or `- Write clean, well-tested code` (no effect on behavior).

## 4. Prune while you're there

Read each file you're about to change, in full. Then:

- Merge duplicates and near-duplicates into one line.
- Remove or fix entries this session showed are wrong or outdated. A wrong instruction costs more than a missing one.
- Check that paths, commands and file names in entries still exist.
- Keep each CLAUDE.md under about 200 lines. If it's over, move section-specific parts into path-scoped rules or
  linked docs rather than deleting useful content.

## 5. Propose, then apply

CLAUDE.md files are often committed and shared, so show changes before writing them. Present one compact list,
grouped by target file, with each item as an add, edit or remove, plus a few words on the waste it prevents:

```
CLAUDE.md (project)
  + Use buf >= 1.73 ...                       prevents: failed lint + version debugging
  - "Run make lint" (Makefile target removed) prevents: failed command
~/.claude/CLAUDE.md
  + Push with gh credentials over HTTPS ...   prevents: SSH failure + retry in every repo
Proposed, needs approval: path-scoped rule `.claude/rules/protos.md` for proto conventions
```

Ask which to apply, with a multi-select question if available, defaulting to all. Apply the approved changes with
minimal edits that keep the files' existing structure.

## 6. Report

End with what changed per file and the net line change of each CLAUDE.md (e.g. `CLAUDE.md: +2 -1 (now 41 lines)`).
If nothing was worth keeping, say so in one line. That is a fine result.
