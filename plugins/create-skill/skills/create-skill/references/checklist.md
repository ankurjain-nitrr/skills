# Skill review checklist

## Need and placement
- [ ] Does something the model doesn't already do well; gap observed, not imagined
- [ ] No near-duplicate among installed or popular skills; distinct trigger
- [ ] Added as a subskill of a related plugin when one exists; exactly one copy, all references updated
- [ ] Right home: skill, not a `CLAUDE.md` line (always needed) or hook (no judgment)
- [ ] Right scope (project, personal, plugin); shared process separate from repo specifics

## Frontmatter
- [ ] `name` lowercase-hyphenated, at most 64 characters, matches directory, not vague, no "claude"/"anthropic"
- [ ] `description` third person, what plus when, key use first, trigger phrases, no workflow summary
- [ ] `description` names situations, so it fires on requests that don't use the skill's own words
- [ ] `description` short (well under 1024 characters; listing truncates description + `when_to_use` at 1536)
- [ ] Invocation fits: `disable-model-invocation: true` for side-effect actions only the user should start; `user-invocable: false` for background knowledge
- [ ] Only portable fields if it must also run on claude.ai or the API

## Body
- [ ] Instructions, not narration; nothing the model already knows
- [ ] One default per decision, escape hatch where needed; the why behind non-obvious rules
- [ ] Exact commands only where steps are fragile; heuristics elsewhere
- [ ] No hard-coded versions, dates or "latest" values; placeholders in examples
- [ ] Consistent terminology; forward-slash paths; fully qualified MCP tool names (`Server:tool`)
- [ ] Defers to the repo's `CLAUDE.md` and own skills
- [ ] Other skills referenced by name and plugin, with a fallback if not installed
- [ ] Verification step or feedback loop for anything that can fail silently

## Structure
- [ ] `SKILL.md` well under 500 lines; frontmatter on line 1
- [ ] Reference files linked directly from `SKILL.md` (one level deep); TOC if over 100 lines
- [ ] Scripts for deterministic work, invoked via their interpreter, run-vs-read stated; dependencies listed

## Tested
- [ ] Triggers on 2-3 realistic prompts, including ones that don't name the domain
- [ ] Doesn't trigger on 2-3 near-misses
- [ ] Neighboring skills' trigger prompts still go to them (`scripts/trigger-test.sh`)
- [ ] Beats the baseline (no skill, or the previous version) on the observed gap
- [ ] Transcripts read: ignored instructions clarified, unneeded work removed

## Shipped (plugin)
- [ ] `plugin.json` version bumped; marketplace entry and README rows updated
- [ ] `claude plugin validate` passes for the marketplace and the plugin
- [ ] Local install refreshed (`claude plugin marketplace update`, `claude plugin update`)
