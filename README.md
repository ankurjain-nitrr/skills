# skills

Claude Code skills, published as a plugin marketplace.

## Install

```bash
claude plugin marketplace add ankurjain-nitrr/skills
claude plugin install reflect@ankurjain-skills
claude plugin install update-stack@ankurjain-skills
claude plugin install devloop@ankurjain-skills
claude plugin install create-skill@ankurjain-skills
```

Or inside a session: `/plugin marketplace add ankurjain-nitrr/skills`, then `/plugin install <plugin>@ankurjain-skills`.

To have a project offer these to everyone who opens it, add to its `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "ankurjain-skills": { "source": { "source": "github", "repo": "ankurjain-nitrr/skills" } }
  },
  "enabledPlugins": { "reflect@ankurjain-skills": true, "update-stack@ankurjain-skills": true, "devloop@ankurjain-skills": true, "create-skill@ankurjain-skills": true }
}
```

## Skills

| Plugin | Skill | What it does |
|---|---|---|
| `reflect` | `/reflect:reflect` | End-of-session retrospective: finds the session's corrections, dead ends and decisions, routes each to the cheapest place that prevents the waste next time (project `CLAUDE.md`, path-scoped rule, user `CLAUDE.md`, skill or hook), prunes stale entries, and applies what you approve. Goal: fewer tokens spent re-discovering the same things. |
| `update-stack` | `/update-stack:update-stack` | Updates every pinned version in a repo (dependencies, build plugins, wrappers, CI actions, container images, language runtime) to its latest stable release: inventories pins by scanning instead of a fixed list, checks registries for the latest stable, does major bumps one at a time after reading release notes, keeps each version identical everywhere, verifies build, tests and images, and commits by area. A repo's own update skill or `CLAUDE.md` overrides it. |
| `devloop` | `/devloop:devloop` | Plan-to-PR loop: frozen requirements (`/devloop:scope`), read-only explore, a plan of at most 10 abstraction-level lines iterated with you ("go deeper" expands one line the same way), a branch from latest `origin/main`, baseline tests, API-first change with failing tests first (pauses for approval on public contract changes), tests on every commit via hook or directly, PRs sliced vertically (`/devloop:slice`) and capped at 10 files and 500 lines, concise code docs, self-review, README check, draft PRs with a standard description, marked ready when CI passes. |
| `devloop` | `/devloop:scope` | Scopes and freezes functional requirements before any plan or code: researches first, asks multiple-choice questions in rounds from wide (goal, actors, behaviors, data, edge cases, non-functional, constraints) to narrow, writes numbered testable requirements (`FR-1: When ..., the system shall ...` plus a check) with out-of-scope and assumptions, freezes them on approval, and puts later changes through approved, revisioned deltas. |
| `devloop` | `/devloop:slice` | Splits a change into a map of small PRs: vertical slices that each deliver requirements end to end, split by paths, interfaces, data or rules, a walking skeleton first for new surfaces, riskiest first; runs them as a stack with `gh stack` or `git rebase` with `rebase.updateRefs`, including restacking after squash merges. |
| `devloop` | `/devloop:readme-check` | Pre-push README gate, run by `devloop` before every push and usable on its own: checks the README's versions, requirements, commands, API names, defaults and sample output against the commits about to be pushed, fixes only what they made stale with minimal edits, and reports what changed or that nothing needed to. |
| `devloop` | `/devloop:code-docs` | Comments, docstrings and docs that describe the current code briefly: no change history ("previously", "now", "moved"), no chat or task narration, no restating the code, at most three lines; plus a grep check for history words on a diff's added lines. `devloop` uses it while implementing and at self-review. |
| `create-skill` | `/create-skill:create-skill` | Creates or improves a skill: dedups against installed and popular skills, picks the cheapest home (skill, `CLAUDE.md` line, hook) and scope (project, personal, plugin), writes to the official authoring rules, tests with and without the skill plus near-miss prompts in fresh subagents, reviews against a checklist, and packages for this marketplace. |

## Layout

```
.claude-plugin/marketplace.json     marketplace catalog
plugins/<plugin>/.claude-plugin/plugin.json
plugins/<plugin>/skills/<skill>/SKILL.md
```

Validate after changes: `claude plugin validate .`
