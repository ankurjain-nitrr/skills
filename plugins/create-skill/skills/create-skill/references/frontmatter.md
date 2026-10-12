# Frontmatter reference (Claude Code)

Frontmatter must start on line 1; if the YAML fails to parse, the skill loads with no fields.
Unknown fields are ignored silently. Check https://code.claude.com/docs/en/skills for fields added
since this was written.

| Field | Use |
|---|---|
| `name` | Slash-command name; defaults to the directory name |
| `description` | What it does and when to use it; drives automatic triggering |
| `when_to_use` | Extra trigger phrases, appended to `description` in the listing |
| `argument-hint`, `arguments` | Autocomplete hint; named positional arguments for `$name` |
| `disable-model-invocation` | `true`: only the user can invoke it (deploys, commits, sends) |
| `user-invocable` | `false`: hidden from the `/` menu; background knowledge only Claude loads |
| `allowed-tools` | Tools pre-approved while the skill runs (e.g. `Bash(${CLAUDE_SKILL_DIR}/scripts/x.sh *)`) |
| `disallowed-tools` | Tools removed while the skill is active |
| `model`, `effort` | Model or effort override for the turn |
| `context: fork`, `agent`, `background` | Run as a subagent; only for skills with an explicit task |
| `hooks` | Hooks registered when the skill is invoked |
| `paths` | Globs limiting automatic activation to matching files |
| `license`, `compatibility`, `metadata` | Agent Skills spec fields; accepted, not acted on |

Portable subset for claude.ai and the Skills API: `name`, `description`, `license`,
`compatibility`, `metadata`, `allowed-tools`. Claude Code-only fields fail packaging there.

Body substitutions: `$ARGUMENTS`, `$0`/`$ARGUMENTS[N]`, `$name`, `${CLAUDE_SKILL_DIR}`,
`${CLAUDE_PROJECT_DIR}`, `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_SESSION_ID}`.
Dynamic context: `` !`command` `` at line start (or a ```` ```! ```` block) runs before the skill
loads and inlines its output; a non-zero exit aborts the skill, so append `|| true` where needed.

Placement and precedence: enterprise over personal (`~/.claude/skills/`) over project
(`.claude/skills/`); plugin skills are namespaced (`/plugin:skill`) and never conflict.
