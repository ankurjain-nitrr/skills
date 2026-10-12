---
name: devloop
description: Takes a code change from request to small, tested, reviewable pull requests on a new branch, starting from frozen requirements and a short plan agreed with the user. Use for implementing a feature, fix or refactor end to end, "devloop", "plan and ship this", or when a change should land as PRs of at most 10 files and 500 lines.
---

# Devloop

From request to reviewed PR in small, tested steps. If the repo's `CLAUDE.md` or its own skills
say otherwise (branch names, test commands, PR template), follow them. `main` below means the
default branch (`git symbolic-ref refs/remotes/origin/HEAD`; if unset, `git remote set-head origin -a`).

## 1. Scope and freeze

Run the `scope` skill bundled with this plugin (`/devloop:scope`): research, ask questions from
wide to narrow, and freeze numbered requirements (`FR-1`, ...) with the user's approval. Nothing
below starts before the freeze. After it, changes to what gets built go through its change control.

## 2. Explore

Read the code, tests and docs the change touches, beyond what scoping already covered. Don't edit
anything yet. Find the test command and whether a pre-commit hook runs tests
(`.pre-commit-config.yaml`, `.husky/`, `lefthook.yml`, `.git/hooks/pre-commit`).

## 3. Plan: at most 10 lines

- Plan from the frozen requirements; each line names the requirement IDs it covers, and every
  requirement is covered by some line.
- Each line is one unit of behavior at a meaningful level of abstraction ("orders can be cancelled
  while unpaid"), not a file edit ("edit OrderService.java"), and ends with how it will be checked.
- Show the plan and iterate with the user until they approve it. Don't start step 4 before that.
- When asked to go deeper on a line, expand only that line into at most 10 sub-lines under the
  same rules. Keep the top level as it is.
- If the work needs more than 10 top-level lines, it is more than one change: plan the first slice
  and list the rest as follow-ups.
- Group the plan lines into PR slices with the `slice` skill bundled with this plugin
  (`/devloop:slice`): vertical slices that each deliver requirements end to end, a walking
  skeleton first for new surfaces, riskiest first. Show the plan and the slice map together.

## 4. Branch and baseline

```sh
git fetch origin
git switch -c <type>/<slug> origin/main    # e.g. feat/cancel-unpaid-orders
```

Never commit on `main`. Commit the frozen spec first if it is kept as a file. Run the full test suite on the new branch before changing anything. If it
already fails, stop and report; don't build on a red baseline.

## 5. API first

- Define or change the contract before the implementation: public signatures and types,
  interfaces, OpenAPI or schema files, CLI flags, events.
- Write tests against the contract that fail for the right reason, named or tagged by requirement
  ID where the test framework allows.
- If a public contract changes (consumers have to adapt), show the contract diff and get the user's
  approval before implementing.

## 6. Implement

Write the smallest code that makes the tests pass, one plan line at a time. Write comments and docs
by the `code-docs` skill bundled with this plugin (`/devloop:code-docs`): current code only, no
change history or narration, as short as possible. Commit per plan line or logical step; every
commit builds and passes tests.

## 7. Gates (before every commit and push)

- **Tests:** if a pre-commit hook runs the tests, let it; otherwise run them directly before each
  commit. Never use `--no-verify` or skip failing tests. Don't install hooks without asking.
- **Size:** each PR changes at most **10 files and 500 lines** (additions plus deletions):

  ```sh
  git diff --numstat <base>...HEAD -- . ':(exclude)*.lock' ':(exclude)package-lock.json'
  ```

  Lockfiles, generated code and snapshots don't count toward the budget (extend the excludes for
  the repo's generated paths), but list them in the PR.
  If a slice goes over, split it further with `/devloop:slice` rather than raising the budget.

## 8. Self-review

Read the whole branch diff with fresh eyes: anything outside the frozen requirements or the plan,
debug leftovers, a requirement without a test, contract changes the user hasn't approved. Run the diff check from
`/devloop:code-docs` and fix history, narration and redundant comments. Fix before pushing.

## 9. Push and open the PR

1. Run the `readme-check` skill bundled with this plugin (`/devloop:readme-check`) against the
   branch's commits: it checks the README's versions, requirements, commands, API names, defaults
   and sample output against the diff and fixes only what this branch made stale, in its own commit
   (which counts toward the size budget). Include its result in the PR body.
2. `git push -u origin <branch>`
3. Open it as a draft: `gh pr create --draft --base <base> --title "<summary>" --body-file <file>`.
   Use the repo's PR template if there is one; otherwise:

   ```markdown
   ## What and why
   <one short paragraph>

   ## Requirements
   FR-1, FR-2 (spec: docs/specs/<slug>.md, rev <n>)

   ## How to verify
   <commands or steps a reviewer can run>

   ## Risk and rollback
   <what could break and how to revert>

   ## Checks
   Tests: <command>, passing · Size: <files> files, <lines> lines · README check: <result>
   Slice <n>/<m>, depends on #<pr>   (omit for a single PR)
   ```

4. When CI passes (`gh pr checks --watch`), mark it ready: `gh pr ready`.

## 10. Fresh-session review

Run the `fresh-review` skill bundled with this plugin (`/devloop:fresh-review`): a reviewable title
and description, a code review in a new session (never this one), and every finding fixed or
answered. Don't create the next slice's PR until then.

Multi-slice changes run as a stack, one slice at a time through steps 6-10; branching, restacking
and retargeting are in `/devloop:slice`.

## 11. Report

Requirements covered (and any deltas approved after the freeze), plan lines done, tests run and results,
the review outcome per PR, the readme-check result, size per PR against the budget,
and PR links. Mention anything skipped and why.
