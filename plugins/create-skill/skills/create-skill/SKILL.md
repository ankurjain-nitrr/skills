---
name: create-skill
description: Creates a new agent skill (SKILL.md) or improves an existing one. Checks for duplicates, picks where it should live, writes it to the authoring rules, tests it with and without the skill, reviews it against a checklist and packages it for a plugin marketplace. Use for "create/write/make a skill", turning a workflow or session into a skill, or reviewing, auditing, trimming, generalizing or fixing a skill that triggers wrongly or gets ignored.
---

# Create or improve a skill

Two modes: **create** (steps 1-6) and **improve** (step 7, then 4-6). Both end with the checklist in
[references/checklist.md](references/checklist.md).

## 1. Decide whether it should be a skill

- **Dedup first.** List the skills already installed (personal `~/.claude/skills/`, project
  `.claude/skills/`, plugins) and search the web for popular ones that do the same job. Extend or
  reference an existing skill instead of adding a near-duplicate; a new skill needs a trigger you
  can describe apart from every existing one.
- **Pick the cheapest home for the knowledge:**
  - A fact or rule needed every session → a `CLAUDE.md` line, not a skill.
  - Something that must happen every time, with no judgment → a hook.
  - A multi-step procedure or domain knowledge needed only sometimes → a skill.
  - Something the model already does well without help → nothing.
- **Pick the scope:** project (`.claude/skills/`, repo specifics), personal (`~/.claude/skills/`),
  or plugin (`plugins/<plugin>/skills/<skill>/`, shared across repos). For something generic with
  repo-specific details, put the process in a shared plugin skill and keep a thin project skill
  that references it and adds only the repo's specifics (it wins where they differ).

## 2. Gather the real behavior

Write from evidence, not imagination: a session where the work was done, the corrections the user
made, the commands that worked, and the failures. If there is none, run 2-3 realistic tasks without
the skill (fresh subagents) and note where they go wrong. That gap is what the skill must fix;
everything the model already got right stays out.

## 3. Write it

- **Frontmatter:** see [references/frontmatter.md](references/frontmatter.md) for the fields and limits.
  - `name`: lowercase, digits, hyphens, at most 64 characters, matches the directory. Prefer a
    gerund or verb phrase; avoid vague names (`helper`, `utils`) and "claude" or "anthropic".
  - `description`: third person; what it does and when to use it, key use case first; trigger
    phrases and contexts, including ones where the user doesn't name the domain. Don't summarize
    the steps (the model may follow the summary instead of the body). Short: it is always in
    context.
- **Body:** instructions, not narration. Only what the model doesn't already know; challenge every
  paragraph's token cost. Match the freedom to the risk: heuristics where many approaches work,
  exact commands where a step is fragile. One default per decision, with an escape hatch, not a
  menu. Explain the why behind non-obvious rules.
- **Keep it durable:** no hard-coded versions, dates or "latest" values; tell the model where to
  look them up. Use placeholders (`<version>`, `@vN`) in examples.
- **Size:** keep `SKILL.md` well under 500 lines. Move reference material to files linked directly
  from `SKILL.md` (one level deep), with a table of contents if over 100 lines. Bundle a script for
  deterministic or repeated work, and say whether to run it or read it.
- **Cross-references:** refer to other skills by name and plugin (`readme-check@<marketplace>`),
  say what they do, and say what to do if they aren't installed. Don't `@`-include files.
- **Respect the host repo:** say that the repo's `CLAUDE.md` or own skills override this one.

## 4. Test

- Run 2-3 realistic prompts in fresh subagents **with** the skill and compare against **without** it
  (or against the previous version when improving). Check that it triggers, that it follows the
  steps, and that it beats the baseline on the gap from step 2.
- Try 2-3 near-miss prompts that share keywords but need something else; it should not trigger.
- Read the transcripts: instructions it ignored are unclear or buried; work it did that the skill
  didn't need is a line to delete.
- For rigorous trigger tuning (eval sets, train/validation split, repeated runs), use Anthropic's
  `skill-creator` if it is installed.

## 5. Review

Go through [references/checklist.md](references/checklist.md) and fix every miss.

## 6. Package and ship

- **Plugin marketplace:** `plugins/<plugin>/.claude-plugin/plugin.json` (name, description,
  version, author, repository), an entry in `.claude-plugin/marketplace.json`, and the
  marketplace README's install line, `enabledPlugins` example and skills table. Bump the plugin
  `version` on every change so installs pick it up. Run `claude plugin validate .` and
  `claude plugin validate plugins/<plugin>`.
- Project or personal skill: nothing to package; it loads from its directory.
- Commit and push only as the user asks. Report what changed and the test results.

## 7. Improve an existing skill

1. Read the whole skill and its supporting files. Collect evidence of how it fails: the user's
   complaint, transcripts where it misfired or was ignored, trigger misses.
2. Snapshot the current version as the baseline for step 4.
3. Check it against [references/checklist.md](references/checklist.md) and the dedup in step 1 (it
   may belong merged into another skill, split, or turned into a `CLAUDE.md` line or hook).
4. Fix the underlying cause, not the one example: generalize from feedback, prefer deleting lines
   to adding them, and when results plateau try removing rules rather than adding more.
5. Test (step 4) against the snapshot, review (step 5), package (step 6).
