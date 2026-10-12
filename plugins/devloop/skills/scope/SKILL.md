---
name: scope
description: Scopes and freezes the functional requirements for a change with the user before any planning or code. Use whenever a feature request is short or leaves behavior undecided ("add order export", "support refunds"), even if the user doesn't mention requirements; at the start of any new feature; or for "scope this", "requirements", "spec it out", "interview me" or "freeze the scope". Not for typo-level fixes or edits whose behavior is already fully specified.
---

# Scope and freeze requirements

Agree on *what* gets built before anyone decides *how*. The output is a short, frozen list of
testable requirements. If the repo has its own spec format or location (`CLAUDE.md`, `docs/specs/`,
an issue template), use it.

Scale it to the change: a one-line bug fix needs one round and three lines; a new feature needs
several rounds.

## 1. Research before asking

Don't ask what you can look up. Read the request, linked issues, and the code, tests and docs
around the change; check how similar features in the repo behave; search the web when the domain
or an external API is unfamiliar. Note what you learned and what is still unknown. Every question
you ask should be one only the user can answer.

## 2. Ask: go wide first

Use the AskUserQuestion tool (otherwise a numbered list), up to 4 questions per round, each with
2-4 concrete options and your recommended one first, so answering is quick. Ask about decisions,
not facts you could find.

Round 1 covers the breadth, picking the dimensions that matter for this change:

- **Goal:** the problem, who has it, and what success looks like.
- **Actors and entry points:** users, roles, other systems; UI, API, CLI, jobs, events.
- **Behaviors:** the main flows, and what is explicitly out of scope.
- **Data:** inputs, outputs, validation, persistence, migration of existing data.
- **Edge cases and errors:** empty, duplicate, concurrent, partial failure, permissions.
- **Non-functional:** performance, security, privacy, compatibility, observability, limits.
- **Constraints:** deadlines, dependencies, things that must not change.

## 3. Narrow down

Each later round asks only about what is still open: answers that raised new questions, options
that need a detail, conflicts between answers. Drill into one area at a time.

Stop when every requirement is testable and no open question would change what gets built. If the
user wants to move on earlier, record the remaining unknowns as explicit assumptions.

## 4. Write the requirements

Keep it to about a page:

```markdown
# <Change>: requirements

Goal: <one sentence>

## Functional
- FR-1: When <trigger or condition>, the system shall <behavior>.
  Check: <how a test or reviewer verifies it>
- FR-2: ...

## Non-functional
- NFR-1: <measurable constraint>. Check: <how>

## Out of scope
- <explicitly excluded behavior>

## Assumptions
- <decided without the user's answer; flip it if wrong>

Status: frozen (rev 1)
```

Each requirement states one observable behavior in the present tense, not an implementation
choice; split anything with "and". No open questions remain in a frozen spec.

## 5. Freeze

Show the requirements and get explicit approval; revise until the user approves. Then mark it
`Status: frozen (rev 1)`. Save it where the repo keeps specs, otherwise `docs/specs/<slug>.md`, as
the first commit of the change's branch (or in the PR description if the user prefers no spec
files).

## 6. Change control after the freeze

- New ideas, scope creep and "while we're here" changes found later are not built silently.
- Write each as a delta (`+ FR-7 ...`, `~ FR-2 ...`, `- FR-4`) with its impact on the plan and the
  PR size, and ask. Approved: update the spec and bump the revision (`rev 2`). Declined: list it as
  a follow-up.
- Implementation details (how) can change without this; behavior (what) can't.

## Hand-off

Plan lines, tests and PR descriptions refer to requirement IDs (`FR-3`), so every requirement is
covered and nothing outside them is built. In devloop, planning starts from the frozen spec.
