# create-skill

Creates or improves agent skills. See [`skills/create-skill/SKILL.md`](skills/create-skill/SKILL.md).

## References

What the skill draws on, and what it leaves to them:

1. [Skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) (Anthropic): conciseness, degrees of freedom, naming, descriptions, progressive disclosure, evaluation-first, checklist.
2. [Extend Claude with skills](https://code.claude.com/docs/en/skills) (Claude Code docs): frontmatter fields, locations and precedence, substitutions, dynamic context, description truncation.
3. [Agent Skills specification](https://agentskills.io/specification): `name` and `description` rules, optional fields, directory layout.
4. [Optimizing skill descriptions](https://agentskills.io/skill-creation/optimizing-descriptions): should/should-not trigger queries, near-misses, train/validation split.
5. [Evaluating skill output quality](https://agentskills.io/skill-creation/evaluating-skills): with/without-skill baselines, assertions, grading, iterating lean.
6. [anthropics/skills `skill-creator`](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md): automated eval and description-optimization loop; this skill defers to it for rigorous tuning.
7. [obra/superpowers `writing-skills`](https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md): test-first skills with subagent pressure scenarios, "don't summarize the workflow in the description".
8. [The Complete Guide to Building Skills for Claude](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf) (Anthropic).
9. [PostHog: Writing skills](https://posthog.com/handbook/engineering/ai/writing-skills): fix tool prompts before writing a skill, limit skill count, merge near-duplicates.
10. Claude Code plugin docs and `claude plugin validate`: marketplace and plugin packaging.
