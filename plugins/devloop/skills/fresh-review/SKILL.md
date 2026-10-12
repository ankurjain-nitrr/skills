---
name: fresh-review
description: Gets a pull request reviewed by fresh-context reviewers that didn't write it, with a title and description a reviewer can work from, and resolves the findings before more work stacks on top. Use after opening a PR, before starting the next PR in a stack, or for "get this PR reviewed", "review in a fresh session" or "independent review".
---

# Fresh-context review

The session that wrote the code reviews it with its own assumptions. Have each PR reviewed by
reviewers with fresh context that see only the title, description and diff, and settle the findings before the next
slice builds on it. If the repo's `CLAUDE.md` names a review process or reviewer, use that.

## 1. Make the PR reviewable

The reviewer knows nothing else, so the PR must carry the context:

- **Title:** imperative, specific, at most about 72 characters, no trailing period, following the
  repo's convention (e.g. `feat(orders): stream CSV export of all orders (1/3)`).
- **Description:** what and why, requirements covered, how to verify, risk and rollback, breaking
  changes called out at the top, what is deliberately left for later slices. Fix them with
  `gh pr edit <pr> --title ... --body-file ...`.

## 2. Mark it ready

Once CI passes (`gh pr checks <pr> --watch`), `gh pr ready <pr>`. Anthropic's `code-review` plugin
skips draft PRs.

## 3. Start the review

Use the first that applies:

1. **The repo already reviews in CI** (a workflow using `anthropics/claude-code-action`, or the
   Claude Code Review app): wait for its review on the PR.
2. **Otherwise run Anthropic's `code-review` plugin:** `/code-review:code-review <pr-url>`. Its
   reviewers are subagents with fresh context that never saw this conversation. Pass only the PR
   URL; don't explain the change or your choices. If the plugin isn't installed, or for a
   re-review (the plugin skips PRs it already reviewed), use the built-in
   `/code-review <pr-number> --comment`.

For risky slices (security, data migration, public API), suggest the user run
`/code-review ultra <pr-number>`, a deeper cloud review that only the user can start.

## 4. Read the findings

```sh
gh pr view <pr> --comments
gh api repos/{owner}/{repo}/pulls/<pr>/comments --jq '.[] | "\(.path):\(.line) \(.body)"'
```

The plugin posts nothing when it finds no issue above its confidence threshold: if it ran without
errors and posted no new comment, the review is clean.

## 5. Resolve every finding

- Fix it in a new commit on the PR's branch (the gates still apply), or reply on the PR with the
  reason it stays as is. Don't silently drop a finding.
- If the fixes go beyond small, local changes, review again with the built-in
  `/code-review <pr-number> --comment` (the plugin skips PRs it already reviewed).
- If a fix changes what gets built, it goes through scope's change control.

## 6. Then move on

Start the next slice only when every finding on this PR is fixed or answered. Note the review
outcome in the report (`review: 2 findings fixed, 1 answered`, or `review: clean`).
