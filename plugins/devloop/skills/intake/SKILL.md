---
name: intake
description: Captures a request as GitHub bug or enhancement issues reconciled with the existing backlog and ordered for building, instead of building it. Use whenever the user asks for a feature, reports a bug, gives product or UI feedback in passing ("the tick isn't aligned", "names should look different"), or says "capture this", "file an issue" or "add to the backlog", and for defects Claude finds itself. Not for building the change; that's scope.
---

# Intake

Turn a request into the right GitHub issues, reconciled with what's already filed, and stop. Nothing
is built here: when the user asks to build, continue with `/devloop:scope` from the issue. The repo's
`CLAUDE.md`, issue templates and labels override anything below.

Run intake for every distinct request, including feedback the user gives in passing, comments on a
review page, and defects Claude notices itself (a flaky test, a bug found in review). Several asks in
one message are several intakes.

## 1. Research the system as it is now

- Find where the behaviour lives today: read the code, and run or open it where that's cheap.
- **Verify the claim.** Reproduce a bug, or confirm the behaviour in the code. Record the result as
  *confirmed*, *not reproduced*, or *needs more detail*. An unconfirmed report is filed as needing
  info, with what's missing, never as fact.
- For an enhancement, check that the product doesn't already do it.
- For a regression, name the change that introduced it when the history makes that cheap
  (`git log -S`, `git log -L`, the PR that touched the line).
- Gather the evidence: the user's own words, where they saw it (page, review, command), when, and
  any error text.

## 2. Reconcile with every related issue

Search open issues and recently closed ones by symptom, not by the user's wording: the behaviour,
the page or command, the error text, and a few word variants (`gh issue list --state all --search
"<terms>"`). Read each candidate against the current code, not just its text: an old issue can be
half done, obsolete, or wrong about how the system works now.

For each related issue, decide one outcome and say why:

- **Same ask:** add the new case and evidence to it as a comment. Don't file a new issue.
- **Changes the ask:** update that issue's scope or acceptance, and say what changed and why.
- **Made obsolete:** say so on it, and close it, or ask the user if closing is their call.
- **Duplicates of each other:** keep the older or better-discussed one, mark the other `duplicate`
  and close it with a link.
- **Turned down before** (closed as won't do): report that instead of refiling, unless something has
  changed. Say what.
- **New:** file a new issue only when nothing existing covers it.

## 3. Place it in the build order

Link the issue to what it depends on, what it blocks, and what edits the same code. Aim for the
fewest and smallest changes overall, not one PR per report: when two issues change the same files,
say they're built together or in which order. Record this with GitHub's own relationships, not just
mentions in prose (check `gh issue edit --help` for the flags):

```sh
gh issue edit <n> --add-blocked-by <m>   # or --add-blocking
gh issue edit <n> --parent <m>           # a part of a larger issue
```

## 4. Write it

- **Label:** exactly one of `bug` (behaves differently from what was designed or promised) or
  `enhancement` (new or different behaviour), using the repo's own label names. When it's unclear,
  decide from the evidence and say which you chose in one line, so the user can relabel.
- **Title:** names the behaviour precisely enough that anyone can tell when it's fixed ("The check
  icon in Notify me sits off its label", not "Notify me broken").
- **Body**, written for the person deciding, with no implementation plan beyond where the problem
  lives:
  - **Problem:** what happens, quoting the user.
  - **Evidence:** where and when, and the verification result.
  - **Ask:** the behaviour wanted.
  - **Done when:** acceptance a test can check.
  - **Order:** related issues and where this one fits.
- File it with `gh issue create`, or the repo's issue template, and add the relationships from step 3.

## 5. Report and stop

In chat, list what changed: issues filed, updated, merged or closed, each with its link, plus the
order. Then stop. Don't start building unless the user asks.

**Mid-build:** a request that arrives while other work is being built goes through intake and stays
out of the current work, unless the user says to fold it in.
