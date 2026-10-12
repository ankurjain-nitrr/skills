---
name: devloop
description: Plan-to-PR development loop for a code change. Short abstraction-level plan (max 10 lines, iterated with the user), branch from latest main, baseline tests, API-first change with tests, tests on every commit, PRs capped at 10 files and 500 lines (stacked when larger), self-review, push and open the PR. Use for implementing a feature or fix end to end, "devloop", or "plan and ship this".
---

# Devloop

From request to reviewed PR in small, tested steps. If the repo's `CLAUDE.md` or its own skills
say otherwise (branch names, test commands, PR template), follow them.

## 1. Explore

Read the code, tests and docs the change touches before planning. Don't edit anything yet. Find
the test command and whether a pre-commit hook runs tests (`.pre-commit-config.yaml`, `.husky/`,
`lefthook.yml`, `.git/hooks/pre-commit`).

## 2. Plan: at most 10 lines

- Each line is one unit of behavior at a meaningful level of abstraction ("orders can be cancelled
  while unpaid"), not a file edit ("edit OrderService.java"), and ends with how it will be checked.
- Show the plan and iterate with the user until they approve it. Don't start step 3 before that.
- When asked to go deeper on a line, expand only that line into at most 10 sub-lines under the
  same rules. Keep the top level as it is.
- If the work needs more than 10 top-level lines, it is more than one change: plan the first slice
  and list the rest as follow-ups.
- Estimate the size. If it will exceed the budget in step 6, decide the slices now, along plan
  lines.

## 3. Branch and baseline

```sh
git fetch origin
git switch -c <type>/<slug> origin/main    # e.g. feat/cancel-unpaid-orders
```

Never commit on `main`. Run the full test suite on the new branch before changing anything. If it
already fails, stop and report; don't build on a red baseline.

## 4. API first

- Define or change the contract before the implementation: public signatures and types,
  interfaces, OpenAPI or schema files, CLI flags, events.
- Write tests against the contract that fail for the right reason.
- If a public contract changes (consumers have to adapt), show the contract diff and get the user's
  approval before implementing.

## 5. Implement

Write the smallest code that makes the tests pass, one plan line at a time. Commit per plan line
or logical step; every commit builds and passes tests.

## 6. Gates (before every commit and push)

- **Tests:** if a pre-commit hook runs the tests, let it; otherwise run them directly before each
  commit. Never use `--no-verify` or skip failing tests. Don't install hooks without asking.
- **Size:** each PR changes at most **10 files and 500 lines** (additions plus deletions):

  ```sh
  git diff --stat --numstat <base>...HEAD
  ```

  Lockfiles, generated code and snapshots don't count toward the budget, but list them in the PR.
  If a slice goes over, split it further rather than raising the budget.

## 7. Self-review

Read the whole branch diff with fresh eyes: anything outside the plan, debug leftovers, missing
tests for a plan line, contract changes the user hasn't approved. Fix before pushing.

## 8. Push and open the PR

1. Run the `readme-check` skill bundled with this plugin (`/devloop:readme-check`) against the
   branch's commits: it checks the README's versions, requirements, commands, API names, defaults
   and sample output against the diff and fixes only what this branch made stale, in its own commit
   (which counts toward the size budget). Include its result in the PR body.
2. `git push -u origin <branch>`
3. `gh pr create --base <base> --title "<summary>" --body "<plan, tests run, size>"`, following the
   repo's PR template if there is one.

**Stacked PRs** when the change is more than one slice:

- Slice 1 branches from `origin/main` and targets `main`. Each next slice branches from the
  previous slice's branch and targets it (`--base <previous branch>`).
- Each slice passes the gates on its own. Note in each PR body its position ("2/3, depends on #12").
- When a lower slice merges, rebase the next onto main and retarget it:

  ```sh
  git rebase --onto origin/main <merged-branch> <next-branch>
  git push --force-with-lease
  gh pr edit <next-pr> --base main
  ```

## 9. Report

Plan lines done, tests run and results, the readme-check result, size per PR against the budget, and PR links. Mention
anything skipped and why.
