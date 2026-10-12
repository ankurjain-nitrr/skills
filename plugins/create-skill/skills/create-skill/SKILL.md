---
name: create-skill
description: Creates a new agent skill (SKILL.md) or improves an existing one so it triggers when it should, stays lean and works across repos. Use for "create/write/make a skill", turning a workflow or session into a skill, or reviewing, auditing, trimming, generalizing or fixing a skill that triggers wrongly or gets ignored.
---

# Create or improve a skill

Two modes: **create** (steps 1-7) and **improve** (step 8, then 5-7). Both end with the checklist in
[references/checklist.md](references/checklist.md).

## 1. Decide whether it should be a skill

- **Dedup first.** List the skills already installed (personal `~/.claude/skills/`, project
  `.claude/skills/`, plugins) and search the web for popular ones that do the same job. Show a
  short table (existing skill, what it does, what's missing for this need) and build only the gap.
  Extend or reference an existing skill instead of adding a near-duplicate; a new skill needs a
  trigger you can describe apart from every existing one.
- **Prefer a subskill.** If a related plugin exists, add the skill to it
  (`plugins/<plugin>/skills/<skill>/`, invoked as `/<plugin>:<skill>`) rather than creating a new
  plugin. Keep one copy: when moving a skill, update every reference to it and remove the old one.
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

## 3. Agree the design

Before writing files, show a reviewable outline: the steps in order, which come from the user's ask
and which you added (with the source that motivated each), and the open decisions as
multiple-choice questions with a recommended option. Write once the user approves.

## 4. Write it

- **Frontmatter:** see [references/frontmatter.md](references/frontmatter.md) for the fields and limits.
  - `name`: lowercase, digits, hyphens, at most 64 characters, matches the directory. Prefer a
    gerund or verb phrase; avoid vague names (`helper`, `utils`) and "claude" or "anthropic".
  - `description`: third person; what it does and when to use it, key use case first; trigger
    phrases and contexts, including ones where the user doesn't name the domain. Don't summarize
    the steps (the model may follow the summary instead of the body). Short: it is always in
    context. After writing it, reread it: if it reads as a sequence of steps ("checks..., then
    writes..., then..."), rewrite it as what plus when. Name situations, not just keywords, so it
    fires on requests that never use the skill's own words ("add order export" for a scoping
    skill).
- **Body:** instructions, not narration. Only what the model doesn't already know; challenge every
  paragraph's token cost. Match the freedom to the risk: heuristics where many approaches work,
  exact commands where a step is fragile. One default per decision, with an escape hatch, not a
  menu. Explain the why behind non-obvious rules.
- **Keep it durable:** no hard-coded versions, dates or "latest" values; tell the model where to
  look them up. Use placeholders (`<version>`, `@vN`) in examples.
- **Size:** keep `SKILL.md` well under 500 lines. Move reference material to files linked directly
  from `SKILL.md` (one level deep), with a table of contents if over 100 lines. Bundle a script for
  deterministic or repeated work, and say whether to run it or read it.
- **Cross-references:** refer to other skills by name and plugin (`/devloop:readme-check` from
  `devloop@<marketplace>`), say what they do, and say what to do if they aren't installed. Don't
  `@`-include files.
- **Respect the host repo:** say that the repo's `CLAUDE.md` or own skills override this one.

## 5. Test

Scale the testing to the change: a new skill or a changed description or workflow gets the runs
below; a wording fix or typo needs only a re-read against the checklist.

- **Triggering:** run [scripts/trigger-test.sh](scripts/trigger-test.sh) (run it, don't read it):

  ```sh
  bash ${CLAUDE_SKILL_DIR}/scripts/trigger-test.sh queries.tsv <plugin-dir>...   # REPO=<dir> RUNS=3 optional
  ```

  `queries.tsv` lines are `<skill>\t<T|N>\t<prompt>`. Include 2-3 prompts that should trigger,
  at least one of which doesn't use the skill's own words; 2-3 near-misses that share keywords but
  need something else; and the trigger prompts of neighboring skills, to catch the new one taking
  over theirs. Each prompt runs in a fresh headless session with only the given plugins, in a
  throwaway copy of `REPO` (put a project skill under its `.claude/skills/`), with editing tools
  blocked.
- **Behavior:** run 2-3 realistic prompts with the skill and without it (or against the previous
  version when improving), on fresh copies of a sample repo, and compare the outputs on the gap
  from step 2. Headless sessions can't show AskUserQuestion; the skill's fallback (a numbered list)
  is what you'll see.
- Read the transcripts: instructions it ignored are unclear or buried; work it did that the skill
  didn't need is a line to delete.
- For rigorous trigger tuning (eval sets, train/validation split, repeated runs), use Anthropic's
  `skill-creator` if it is installed.

## 6. Review

Go through [references/checklist.md](references/checklist.md) and fix every miss.

## 7. Package and ship

- **Plugin marketplace:** `plugins/<plugin>/.claude-plugin/plugin.json` (name, description,
  version, author, repository), an entry in `.claude-plugin/marketplace.json`, and the
  marketplace README's install line, `enabledPlugins` example and skills table. Bump the plugin
  `version` on every change so installs pick it up. Run `claude plugin validate .` and
  `claude plugin validate plugins/<plugin>`.
- Project or personal skill: nothing to package; it loads from its directory.
- Commit and push only as the user asks. After pushing a marketplace plugin, refresh the local
  install: `claude plugin marketplace update <marketplace>`, then
  `claude plugin update <plugin>@<marketplace>` (restart to load it).
- Report what changed and the test results.

## 8. Improve an existing skill

1. Read the whole skill and its supporting files. Collect evidence of how it fails: the user's
   complaint, transcripts where it misfired or was ignored, trigger misses.
2. Snapshot the current version as the baseline for step 5.
3. Check it against [references/checklist.md](references/checklist.md) and the dedup in step 1 (it
   may belong merged into another skill, split, or turned into a `CLAUDE.md` line or hook).
4. Fix the underlying cause, not the one example: generalize from feedback, prefer deleting lines
   to adding them, and when results plateau try removing rules rather than adding more.
5. Test (step 5) against the snapshot, review (step 6), package (step 7).
