---
name: devloop
description: Takes a code change from request to small, tested, reviewed pull requests, starting from requirements and a short plan the user approves in hoop. Every defect found on the way, and every reported bug, gets a regression test. Use for implementing a feature, fix or refactor end to end, "devloop", "plan and ship this", or when a change should land as PRs of at most 10 files and 500 lines.
---

# Devloop

From request to merged pull requests in small, tested steps. If the repo's `CLAUDE.md` or its own
skills say otherwise (branch names, test commands, PR template), follow them. `main` below means the
default branch.

## People decide, in hoop

Only people review and decide. Every decision and approval the loop needs goes to the user through
hoop: write it as a document, submit it with `hoop_submit` (or `hoop submit <file>`), share the
link, wait with `hoop_wait`, answer every comment and revise until the user approves. Never approve
on the user's behalf, and never ask other agents to review a document.

Pick each document's shape for the task: no fixed templates. A question that needs the user's
answer goes in the document as a section headed `Question: ...` with lettered options and your
recommendation, so the user answers on the page.

hoop keeps a document only while it is under review. When the approved text should last, the
document asks where it goes (a file in this project, a Google Doc, or nowhere), and you save it
there after approval with `hoop export`.

## 1. Scope

Run `/devloop:scope`: research, then agree on numbered, testable requirements (`FR-1`, ...) with the
user in hoop. Nothing below starts before the user approves them. After that, a change to what gets
built goes back to the user the same way.

## 2. Explore

Read the code, tests and docs the change touches. Find the test command and whether a pre-commit
hook runs tests. The stack references in [references/stacks/](references/stacks/README.md) say
where to look for each language.

Preflight the environment now, not mid-slice: runtime versions against what the project and its
test tools need, browsers for UI tests, and the CLI tools scripts call (`gh`, `timeout`, `jq`).

## 3. Plan: at most 10 lines

- Each line covers named requirement IDs, is one unit of behavior ("orders can be cancelled while
  unpaid"), not a file edit, and ends with how it will be checked. Every requirement is covered.
- More than 10 lines means more than one change: plan the first and list the rest as follow-ups.
- Group the lines into pull requests with `/devloop:slice`.
- Note whether the change adds a server, web UI, external input, auth, or file paths built from
  input; if so, the security gate in step 7 applies to every slice.
- Submit the plan and the slice map to hoop together, and start only after the user approves.

## 4. Branch and baseline

```sh
git fetch origin
git switch -c <type>/<slug> origin/main    # e.g. feat/cancel-unpaid-orders
```

Never commit on `main`. Before every commit, check `git branch --show-current`. Run the full test
suite before changing anything. If it already fails, stop and tell the user.

## 5. Contract first

Define or change the contract before the implementation: public signatures and types, schemas, CLI
flags, events. Write tests against it that fail for the right reason. If a public contract changes,
show the user the contract diff in hoop and wait for approval before implementing.

## 6. Implement

Write the smallest code that makes the tests pass, one plan line at a time. Write comments by
`/devloop:code-docs`. Commit per plan line; every commit builds and passes tests. Write multi-line
commit messages to a file and use `git commit -F`. After each slice, give the user a one-line
status (slice n/m, tests, what's next).

**Every defect gets a regression test.** Whether a review, a test or the user found it: first write
a test that fails because of the defect, then fix it and see the test pass. If no automated test can
reach it, say why in the PR.

**A test for new behavior must fail on the base.** Run it against the base branch's code and see it
fail; a test that passes there doesn't prove the requirement.

**Requests that arrive mid-build** are new scope: ask the user whether to fold them in or keep them
for later.

## 7. Gates (before every commit and push)

- **Tests:** let the pre-commit hook run them, or run them yourself. Never use `--no-verify` or skip
  failing tests. Gate on the test command's own exit status, not a pipe.
- **Size:** each PR changes at most **10 files and 500 lines**, lockfiles and generated files
  excluded (`git diff --numstat <base>...HEAD`). If a slice goes over, split it with
  `/devloop:slice`.
- **Security** (when step 3 flagged it): servers check Host and Origin and refuse cross-site
  writes; every value put into HTML is escaped; IDs and names used in paths are validated;
  subprocesses get argument arrays, never shell strings; secrets stay out of logs, files and
  commits. Add a test for each.

## 8. Self-review

Read the whole branch diff with fresh eyes: anything outside the requirements or the plan, debug
leftovers, a requirement without a test, comments that narrate history. Fix before pushing.

## 9. Push and open the PR

1. Run `/devloop:readme-check` against the branch's commits.
2. `git push -u origin <branch>`, then `gh pr create --draft` with what and why, the requirements
   covered, how to verify, risk and rollback, and the checks (tests, size, README check).
3. When CI passes, `gh pr ready`.

## 10. Code review

Run `/devloop:pr-review` before merging. For changes that touch security, data migration or a
public API, suggest the user run `/code-review ultra <pr-number>`, which only they can start.

## 11. Acceptance run

Before merging, run the change end to end against real systems, as a user would: the real server or
CLI, a browser for UIs, a sandbox for external services. Keep it as a script in the repo, mapped to
the requirement IDs, and run it again after review fixes.

## 12. Merge and stop

Merging is the user's call. When they merge a stack, merge in order, retarget the next PR to `main`
and only then delete the merged branch (GitHub closes a PR whose base is deleted). Check `main`
passes its tests. Report requirements covered, tests and the acceptance run, review findings and
how each was resolved, size per PR, and anything skipped and why. Then stop.
