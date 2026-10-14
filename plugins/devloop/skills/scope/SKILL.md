---
name: scope
description: Captures and queues change requests as written (resolving overlaps with other queued ones), then scopes and freezes the functional requirements for a change with the user before any planning or code. Use when the user gives a new request or change request ("capture this", "queue it", "new CR"), and whenever a feature request is short or leaves behavior undecided ("add order export", "support refunds"), even if the user doesn't mention requirements; at the start of any new feature; or for "scope this", "requirements", "spec it out", "interview me" or "freeze the scope". Not for typo-level fixes or edits whose behavior is already fully specified.
---

# Scope and freeze requirements

Agree on *what* gets built before anyone decides *how*. The output is a short, frozen list of
testable requirements. If the repo has its own spec format or location (`CLAUDE.md`, `docs/specs/`,
an issue template), use it.

Scale it to the change: a one-line bug fix needs one round and three lines; a new feature needs
several rounds.

## 0. Capture and queue

Every request is first captured as a change request, in the requester's own words, and **queued**
with `hoop cr create` (or `hoop_cr_create`), which writes `docs/changes/CR-<n>-<slug>/REQUEST.md`
byte for byte and adds the change to the tracker (see `/devloop:project-docs`). Classify it as
epic, story, task or bug with a one-line reason; read `docs/changes/CLASSIFICATION.md` first, and
when the requester corrects a type, record it with `hoop cr classify <CR> <type> --reason ... --why
...` so later classifications learn from it. Requests that arrive while another change is in
progress are queued, not folded in, unless the requester says so.

Each time a request is queued, compare it with every other **queued** request: the same behavior,
the same documents or files, conflicting goals, or one depending on another. Resolve each overlap
(merge them, order them, split one, or drop a duplicate), write the resolution into both changes'
notes and the tracker, and tell the requester what was decided, so they can change it. In-progress
changes aren't re-opened; note any dependency on them instead.

A bug report is captured the same way, with type bug. Its definition of done starts with a test
that reproduces the bug and fails before the fix.

Scoping (the steps below) starts when a queued change is picked up.

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

Scope and write the PRD as the plugin's `senior-product-manager` agent would, or start that agent
to write it. A principal product manager reviews it through `/devloop:design-review`.

Write the requirements as complete, simple sentences without dashes, following the `writing` skill bundled with this plugin (`/devloop:writing`).
The captured request in `REQUEST.md` keeps the requester's own words.

Write the requirements as the change request's PRD, `docs/changes/CR-<n>-<slug>/PRD.md` (see
`/devloop:project-docs` for the layout and template), and have it reviewed through hoop; approval
there is the freeze (`Status: approved`, revision 1). Commit it as the first commit of the change's
branch. Without hoop (it's required), stop and ask the user to install it.

## 6. Change control after the freeze

- New ideas, scope creep and "while we're here" changes found later are not built silently.
- Write each as a delta (`+ FR-7 ...`, `~ FR-2 ...`, `- FR-4`) with its impact on the plan and the
  PR size, and ask. Approved: update the spec and bump the revision (`rev 2`). Declined: list it as
  a follow-up.
- Implementation details (how) can change without this; behavior (what) can't.

## Hand-off

Plan lines, tests and PR descriptions refer to requirement IDs (`FR-3`), so every requirement is
covered and nothing outside them is built. In devloop, planning starts from the frozen spec.
