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
| `devloop` | `/devloop:devloop` | Runs a change from request to a merged milestone: intake, scope, design documents, a short plan, small stacked PRs with tests, reviews, an acceptance run, merge and fold. |
| `devloop` | `/devloop:intake` | Captures a request or bug report in the requester's words, classifies it, queues it and resolves overlaps with other queued requests. |
| `devloop` | `/devloop:scope` | Scopes and freezes a queued change's requirements with the requester, asking wide then narrow questions. |
| `devloop` | `/devloop:project-docs` | Keeps the project's and each change's PRD, HLD, LLD and tracker current through hoop: layout, the shared review procedure with persona agents, tracker rules and the fold. |
| `devloop` | `/devloop:prd-review` | The PRD's standards, owner and reviewers, and its checks against the change request and the project's PRD. |
| `devloop` | `/devloop:hld-review` | The HLD's standards, owner and reviewer, and its checks against the PRD and the project's HLD. |
| `devloop` | `/devloop:lld-review` | The LLD's standards, owner and reviewers, and its checks against the PRD, the HLD, the project's LLD and today's code. |
| `devloop` | `/devloop:slice` | Splits a change into small PRs that each deliver working behavior, and keeps the stack moving. |
| `devloop` | `/devloop:pr-review` | Gets each PR reviewed by fresh-context reviewers before the next one stacks on it. |
| `devloop` | `/devloop:code-docs` | Comments and docs in code that describe it as it is now, briefly. |
| `devloop` | `/devloop:readme-check` | A pre-push gate that keeps the README's claims true. |
| `devloop` | `/devloop:writing-style` | The writing rules for documents, work items and PRs, with a checker: complete sentences, simple language, no dashes. |
| `devloop` | `/devloop:principles` | Working principles for all work, drawn from Google, Amazon, Anthropic and Databricks. |
| `devloop` | `/devloop:review-comments` | How to write and answer a review comment in any field, the two-cycle limit and who decides. |
| `devloop` | agents: `senior-product-manager`, `principal-product-manager`, `staff-engineer`, `principal-engineer`, `senior-engineer`, `engineer-l4` | Persona agents that own or review the design documents by commenting in hoop. Each preloads principles, review-comments and writing-style. |
| `create-skill` | `/create-skill:create-skill` | Creates or improves a skill: dedups against installed and popular skills, picks the cheapest home (skill, `CLAUDE.md` line, hook) and scope (project, personal, plugin), writes to the official authoring rules, agrees a reviewable design with you, tests triggering with a bundled headless script (near-misses and neighboring skills included) and behavior with and without the skill, reviews against a checklist, and packages and refreshes the local install. |

## Layout

```
.claude-plugin/marketplace.json     marketplace catalog
plugins/<plugin>/.claude-plugin/plugin.json
plugins/<plugin>/skills/<skill>/SKILL.md
```

Validate after changes: `claude plugin validate .`
