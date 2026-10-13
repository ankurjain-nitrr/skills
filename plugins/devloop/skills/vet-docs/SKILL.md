---
name: vet-docs
description: Critically reviews a PRD, HLD, LLD or tracker against industry practice before it goes to a human, and lists concrete findings with fixes. Use before submitting any of these documents for review, when asked to "vet", "critique" or "check" a PRD, HLD, LLD or tracker, or when a design document mixes levels (code detail in an HLD, solutions in a PRD).
---

# Vet design documents

Read the document as a demanding reviewer would, before a human spends time on it. Report findings,
then fix them (through hoop when the document is under review there). If the repo's `CLAUDE.md` sets
its own standards, apply those too.

## Writing comes first (strict)

Run the writing checker from the `writing` skill bundled with this plugin (`/devloop:writing`) on the document. Fix every finding by rewriting the
text as complete, simple sentences without dashes. The document isn't ready for review until the
checker reports nothing. Then read the sentences it can't judge (a phrase ending with a period is
still a phrase).

## Content

Each document has one job. Most problems are content at the wrong level: a solution in the PRD,
code in the HLD, requirements in the tracker.

## PRD: what and why, never how

- Starts from the **problem** and who has it, before any solution. A goal that describes the product
  instead of the problem is a finding.
- **Goals and non-goals** are explicit; out of scope is listed.
- **Success metrics** have a baseline, a target and how they're measured. "Faster" or "better" alone
  is a finding.
- Each requirement states one observable **behavior** (When <trigger>, the system shall <behavior>)
  with **acceptance criteria** a tester could run (Given / When / Then, or a checklist). A test file
  name is not an acceptance criterion.
- No **implementation**: no tool or function names, file paths, schemas, column lists, libraries or
  storage choices. Those belong in the HLD or LLD. User-facing names (a command the user types, a
  page they open) are fine.
- **Non-functional requirements** are measurable (security, privacy, performance, reliability,
  compatibility) and say how they're checked; an unmeasured target says so.
- Every requirement can be traced to the user's request; nothing is invented.

## HLD: components and how they interact

- Shows the system in its **context** (people and external systems) and its **containers or
  components** with their responsibilities, at the level of C4's context and container views.
- Describes **interactions** for each key scenario: who calls whom, in what order, carrying what
  (a sequence of steps or a diagram), including failure paths.
- States **interfaces between components** by purpose and protocol (MCP over stdio, HTTP on
  localhost, files on disk, a GitHub PR), not by function signatures or field lists.
- Covers **cross-cutting concerns**: security and trust boundaries, privacy, observability,
  testing strategy, deployment and operation.
- Records **alternatives** (including doing nothing) and **decisions** with their reasons.
- Traces every requirement to the components that meet it.
- **No code-level detail**: no source file names, class or function names, data structures, field
  lists, file formats, algorithms, environment variables or CLI flags. Each one found is a finding to
  move into the LLD.

## LLD: how each component is built

- Per component: responsibility, data model with invariants, interfaces (signatures, endpoints,
  formats), behavior and algorithms with edge cases, errors and how they surface.
- Consistent with the HLD: same components, same interactions; anything new is a finding against
  the HLD.
- A **test plan** maps every requirement to tests at the right level (unit, integration,
  end to end), each with what it proves.

## Tracker: work items, not requirements

- Rows are **work items**: epics, stories, tasks, sub-tasks and bugs. Requirements live in the PRD
  and are referenced from the items that deliver them, not copied in as rows.
- One **parent** per row, so the hierarchy is a tree (epic → story → task → sub-task; a bug under
  the item it affects).
- Stories meet **INVEST** (independent, negotiable, valuable, estimable, small, testable) and state
  the user value; a story with no user benefit is a task.
- Each story or bug has **acceptance criteria**, or points to the PRD's; the tracker states one
  **definition of done** for all items.
- Status, phase and dates are current; nothing is `done` without its PR.

## Report

List findings by severity (must fix, should fix, consider), each with the line, what's wrong, which
practice it breaks, and the fix. Then apply the fixes: as hoop edits when the document is under
review there, otherwise in the draft before it's submitted. Finish with what changed, the writing checker's result
(it must be zero findings), and anything left for the user to decide.
