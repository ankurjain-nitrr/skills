---
name: project-docs
description: Keeps a project's PRD, HLD, LLD and execution tracker current, at project level and for each change request, with every change to them reviewed and materialized through hoop. Use when setting up a project's design docs, writing a change's PRD, HLD, LLD or tracker, updating the tracker, folding a merged change's docs into the project docs, or for "PRD", "HLD", "LLD", "design doc", "tracker" or "fold CR-n".
---

# Project docs: PRD, HLD, LLD and tracker

Every project keeps four living documents, and every change request (CR) keeps the same four for
its own scope. A CR's documents are folded into the project's right after the CR merges, so the
project documents always describe what is on `main`. If the repo's `CLAUDE.md` sets another
layout, follow it.

| Document | Says | Template |
|---|---|---|
| `PRD.md` | What and why: goal, users, numbered requirements (`FR-n`, `NFR-n`) with checks, out of scope | [references/PRD.md](references/PRD.md) |
| `HLD.md` | Components and how they interact, cross-cutting concerns, alternatives, decisions; no code-level detail | [references/HLD.md](references/HLD.md) |
| `LLD.md` | Per module: data models, signatures, algorithms, error handling, test plan by requirement | [references/LLD.md](references/LLD.md) |
| `TRACKER.md` | Execution: work items (epic, story, task, sub-task, bug) as a tree, with status, phase, PR, dates | [references/TRACKER.md](references/TRACKER.md) |

## Layout

```
docs/PRD.md  docs/HLD.md  docs/LLD.md  docs/TRACKER.md      project level: what is on main
docs/changes/CR-<n>-<slug>/{PRD,HLD,LLD,TRACKER}.md         one folder per change request
```

`<n>` is the next unused number. A CR's `PRD.md` starts with
`Status: proposed | approved | implementing | merged | folded | rejected | withdrawn` and
`Revision: <n>`; nothing builds before `approved`, and a change after approval is a new revision.

## Every change gets all four, in order

Every change gets a PRD, HLD, LLD and tracker rows, sized to it: a bug's HLD and LLD can be a few
lines. They are written and approved strictly in order. Don't write the HLD until the PRD is
approved, or the LLD until the HLD is. hoop enforces this when each review is linked to its change,
and when an approved document is revised, the documents after it need approval again.

## Every change goes through hoop

hoop is required: its MCP tools, or the same operations as `hoop` terminal commands (`hoop help`)
when the tools aren't loaded. If neither is available, stop and ask the user to install it
(`claude mcp add hoop -- hoop mcp`).

1. Write or change the document locally and vet it with the `vet-docs` skill bundled with this
   plugin (`/devloop:vet-docs`): fix its findings first. For a change's PRD, HLD or LLD, then run
   `/devloop:design-review`, which checks it in a fresh context against the change request, the
   approved documents above it and the project's PRD, HLD and LLD. Fix or record its findings, and
   tell the reviewer what it found. Then submit it, linked to its change:
   `hoop submit <file> --cr <CR> --doc <prd|hld|lld>` (or `hoop_submit_markdown` with `change`;
   `--channel github` for team review). A refusal names what to approve first. Give the user the
   URL and run `hoop wait <review_id>` in the background.
2. Read the review with `hoop_feedback`. Answer instruction comments with `hoop_propose_edits`
   (minimal span edits) and reply in threads with `hoop_reply`; reviewers apply suggestions and
   accept edits themselves.
3. To revise beyond the comments, submit the whole document again with the same `review_id`; the
   reviewer sees "Changes since rev N".
4. On approval, `hoop export <review_id> --out <file>` (or `hoop_export`) and commit the file
   unchanged. Record the
   review in `docs/.hoop.json` (`{ "<path>": "<review_id>" }`) for traceability.

All text in these documents and in tracker items follows the `writing` skill bundled with this plugin (`/devloop:writing`): complete
sentences, simple language and no dashes. A tracker item's title is a sentence. `REQUEST.md` is
exempt because it keeps the requester's words.

Never edit an approved document's content by hand; every content change is a new hoop review.
Bookkeeping is the exception: a CR's `Status:` line and the tracker's Status, PR, Start and Done
cells are updated directly, in the PR that changes them, with `hoop tracker set <ID> Status=done
PR=#41 ...` (it changes only that row). Record each devloop step with `hoop cr step <CR> <step>`;
build is refused until the PRD, HLD and LLD are approved and current, and fold until every PR
linked with `hoop cr link-pr` is merged.

## Tracker rules

- Rows are work items, not requirements; `Covers` references the PRD's requirements, and one
  `Parent` per row builds the tree (epic → story → task → sub-task; bugs under what they affect).
- Status is one of `todo`, `in progress`, `in review`, `blocked`, `done`, `dropped`; update the rows
  a slice touches in that slice's own PR, so the tracker on `main` matches what merged.
- A CR's rows move into the project `TRACKER.md` when it folds; done rows stay as history.
- Every epic, story, task, sub-task and bug has a block under "Items" (`### <ID>: <title>`) with a
  short description and its own definition of done. The definition fits the item's level. An
  epic's is about outcomes, its stories and the fold. A story's is its acceptance criteria. A
  task's is the specific change and its tests. A bug's starts with a test that reproduces it. Write
  the block when the item is added, and don't mark the item done until every point in it holds.
  The template in `references/TRACKER.md` shows the format.

## Fold a merged CR into the project docs

Right after the CR's last PR merges, in its own PR (`docs/fold-cr-<n>`):

1. For each of the four documents, merge the CR's content into the project document: add new
   requirements, update changed sections, record new decisions, move tracker rows. Change as
   little existing text as possible.
2. Submit through hoop as a diff: `hoop_submit_markdown` with the current project document, then
   again with the folded version and the same `review_id`, so the reviewer reviews only what changed.
3. On approval, export and commit each document; set the CR's status to `folded`; open and merge the
   fold PR (it's docs-only, so devloop's self-review tier applies).

## Bootstrap

A project without these documents gets them before its first CR: draft each from the code, README
and history (describe what exists; mark unknowns as open questions), and review each through hoop
as above.
