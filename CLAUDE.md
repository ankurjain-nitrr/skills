# CLAUDE.md

Plugin marketplace `ankurjain-skills`; layout in `README.md`. Write and improve skills with the
create-skill plugin; dev-workflow skills belong in `devloop` as subskills.

## After changing a plugin

1. Bump `version` in `plugins/<plugin>/.claude-plugin/plugin.json`.
2. Keep `.claude-plugin/marketplace.json` and the `README.md` install lines, `enabledPlugins`
   example and skills table in sync with the plugins and their skills.
3. `claude plugin validate .` and `claude plugin validate plugins/<plugin>`.
4. Trigger-test changed descriptions:
   `bash plugins/create-skill/skills/create-skill/scripts/trigger-test.sh <queries.tsv> plugins/<plugin>...`
5. Commit and push to `main`, then refresh the local install:
   `claude plugin marketplace update ankurjain-skills && claude plugin update <plugin>@ankurjain-skills`.
