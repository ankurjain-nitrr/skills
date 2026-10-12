---
name: fresh-review
description: Gets a pull request reviewed by a Claude session that didn't write it, with a title and description a reviewer can work from, and resolves the findings before more work stacks on top. Use after opening a PR, before starting the next PR in a stack, or for "get this PR reviewed", "review in a fresh session" or "independent review".
---

# Fresh-session review

The session that wrote the code reviews it with its own assumptions. Review each PR in a new
session that sees only the title, description and diff, and settle the findings before the next
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

## 3. Start the review in a new session

Never review in the development session. Use the first that applies:

1. **The repo already reviews in CI** (a workflow using `anthropics/claude-code-action`, or the
   Claude Code Review app): wait for its review on the PR.
2. **`code-review` plugin installed** (`/code-review:code-review`): run it headless in the repo, in
   the background, and wait for it to finish:

   ```sh
   claude -p "/code-review:code-review <pr-url>" --output-format json > <scratch>/review-<pr>.json
   ```

3. **Otherwise** use the built-in skill, which also re-reviews a PR the plugin already reviewed:

   ```sh
   claude -p "/code-review <pr-number> --comment" \
     --allowedTools "Bash(gh pr:*)" "Bash(gh api:*)" "Bash(git:*)" --output-format json > <scratch>/review-<pr>.json
   ```

For risky slices (security, data migration, public API), suggest the user run
`/code-review ultra <pr-number>`, a deeper cloud review that only the user can start.

## 4. Read the findings

```sh
gh pr view <pr> --comments
gh api repos/{owner}/{repo}/pulls/<pr>/comments --jq '.[] | "\(.path):\(.line) \(.body)"'
```

The plugin posts nothing when it finds no issue above its confidence threshold: if the session
finished without errors (check its JSON `result` and `is_error`) and there is no new comment, the
review is clean.

## 5. Resolve every finding

- Fix it in a new commit on the PR's branch (the gates still apply), or reply on the PR with the
  reason it stays as is. Don't silently drop a finding.
- If the fixes go beyond small, local changes, review again in a new session (option 3, since the
  plugin skips PRs it already reviewed).
- If a fix changes what gets built, it goes through scope's change control.

## 6. Then move on

Start the next slice only when every finding on this PR is fixed or answered. Note the review
outcome in the report (`review: 2 findings fixed, 1 answered`, or `review: clean`).
