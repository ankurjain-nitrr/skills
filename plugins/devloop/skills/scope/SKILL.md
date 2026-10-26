---
name: scope
description: Agrees testable requirements for a change with the user before any planning or code, by researching, asking wide then narrow questions, and getting them approved in hoop. Use when a change is picked up, whenever a feature request is short or leaves behavior undecided ("add order export", "support refunds"), or for "scope this", "requirements", "spec it out" or "interview me". Not for typo-level fixes or edits whose behavior is already fully specified.
---

# Scope

Agree on *what* gets built before anyone decides *how*. The output is a short list of testable
requirements the user approved. If the repo has its own spec format or location, use it.

Scale it to the change: a one-line bug fix needs three lines; a new feature needs several rounds.

A request with no issue yet goes through `/devloop:intake` first, so it's filed and reconciled with
the backlog. Scope starts from that issue.

## 1. Research before asking

Don't ask what you can look up. Read the request, linked issues, and the code, tests and docs around
the change; check how similar features in the repo behave; search the web when the domain or an
external API is unfamiliar. Every question you ask should be one only the user can answer.

## 2. Ask: wide first, then narrow

Ask in hoop: write a short document of what you learned, with each open decision as a section
headed `Question: ...`, two to four lettered options and your recommendation, so the user answers on
the page. For a quick single question in conversation, the AskUserQuestion tool is fine.

The first round covers the breadth, picking what matters for this change: the goal and who has the
problem, actors and entry points, the main flows and what is out of scope, data and validation,
edge cases and errors, non-functional limits, and constraints. Later rounds ask only about what is
still open. Stop when every requirement is testable and no open question would change what gets
built. If the user wants to move on earlier, record the rest as assumptions.

## 3. Write the requirements

About a page, in whatever shape suits the change. Each requirement states one observable behavior
in the present tense, with how a test or a person checks it:

```markdown
- FR-1: When <trigger or condition>, the system <behavior>. Check: <how>
- NFR-1: <measurable constraint>. Check: <how>
```

Add what is out of scope and the assumptions. No open questions remain.

## 4. Approve

Submit the requirements to hoop and revise from the user's comments until they approve. Ask where
the approved requirements should be kept (a file in the project, a Google Doc, or nowhere) and save
them there.

## After approval

New ideas found later are not built silently. Write each as a change (`+ FR-7`, `~ FR-2`, `- FR-4`)
with its impact on the plan, and ask the user in hoop. How the code works can change freely; what it
does can't without the user.

Plan lines, tests and PR descriptions refer to requirement IDs, so every requirement is covered and
nothing outside them is built.
