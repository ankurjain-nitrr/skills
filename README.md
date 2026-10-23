# skills

Claude Code skills, published as a plugin marketplace.

## Install

```bash
claude plugin marketplace add ankurjain-nitrr/skills
claude plugin install reflect@ankurjain-skills
claude plugin install update-stack@ankurjain-skills
claude plugin install create-skill@ankurjain-skills
claude plugin install devloop@ankurjain-skills
```

Or inside a session: `/plugin marketplace add ankurjain-nitrr/skills`, then `/plugin install <plugin>@ankurjain-skills`.

To have a project offer these to everyone who opens it, add to its `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "ankurjain-skills": { "source": { "source": "github", "repo": "ankurjain-nitrr/skills" } }
  },
  "enabledPlugins": { "reflect@ankurjain-skills": true, "update-stack@ankurjain-skills": true, "create-skill@ankurjain-skills": true, "devloop@ankurjain-skills": true }
}
```

devloop sends every decision and approval to a person through [hoop](https://github.com/ankurjain-nitrr/hoop),
so install hoop first.

## Skills

| Plugin | Skill | What it does |
|---|---|---|
| `reflect` | `/reflect:reflect` | End-of-session retrospective: finds the session's corrections, dead ends and decisions, routes each to the cheapest place that prevents the waste next time (project `CLAUDE.md`, path-scoped rule, user `CLAUDE.md`, skill or hook), prunes stale entries, and applies what you approve. Goal: fewer tokens spent re-discovering the same things. |
| `update-stack` | `/update-stack:update-stack` | Updates every pinned version in a repo (dependencies, build plugins, wrappers, CI actions, container images, language runtime) to its latest stable release: inventories pins by scanning instead of a fixed list, checks registries for the latest stable, does major bumps one at a time after reading release notes, keeps each version identical everywhere, verifies build, tests and images, and commits by area. A repo's own update skill or `CLAUDE.md` overrides it. |
| `create-skill` | `/create-skill:create-skill` | Creates or improves a skill: dedups against installed and popular skills, picks the cheapest home (skill, `CLAUDE.md` line, hook) and scope (project, personal, plugin), writes to the official authoring rules, agrees a reviewable design with you, tests triggering with a bundled headless script (near-misses and neighboring skills included) and behavior with and without the skill, reviews against a checklist, and packages and refreshes the local install. |
| `devloop` | `/devloop:devloop` | Takes a change from request to small, tested pull requests: requirements and a plan the user approves in hoop, slices of at most 10 files and 500 lines, a regression test for every defect, code review and an acceptance run. |
| `devloop` | `/devloop:scope` | Agrees testable requirements with the user before planning, asking wide then narrow questions in hoop. |
| `devloop` | `/devloop:slice` | Splits a change into small pull requests that each deliver working behavior, and keeps a stack moving. |
| `devloop` | `/devloop:pr-review` | Gets a pull request reviewed with fresh context and resolves every finding. |
| `devloop` | `/devloop:code-docs` | Keeps comments and docs about the current code, short, with no change history. |
| `devloop` | `/devloop:readme-check` | Fixes README claims that the commits about to be pushed made stale. |

## Layout

```
.claude-plugin/marketplace.json     marketplace catalog
plugins/<plugin>/.claude-plugin/plugin.json
plugins/<plugin>/skills/<skill>/SKILL.md
```

Validate after changes: `claude plugin validate .`
