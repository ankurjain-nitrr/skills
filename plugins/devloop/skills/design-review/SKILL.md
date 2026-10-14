---
name: design-review
description: Reviews a change's new PRD, HLD or LLD in a fresh context against the change request and the documents above it, and against the project's existing PRD, HLD and LLD, before a human reviews it. It finds gaps, scope creep, conflicts, duplicates and silent changes to settled behavior. Use before submitting any change's PRD, HLD or LLD for review, after vet-docs, or for "review this PRD against the CR", "check the HLD against the project docs" or "design review".
---

# Design review

A new design document can be well written and still be wrong for its change. It can miss what was
asked, add what wasn't, or contradict what the project already settled. This review checks each new
PRD, HLD and LLD against two sources before a human sees it:

- **The change's own chain:** Its `REQUEST.md` and every approved document above it. A PRD answers
  to the request. An HLD answers to the request and the PRD. An LLD answers to all three.
- **The project's materialized documents:** `docs/PRD.md`, `docs/HLD.md` and `docs/LLD.md`, which
  describe what is already built and approved.

Run it after `/devloop:vet-docs`, which checks the writing and the document's own level. The writing rules in `/devloop:writing` apply to its
findings.

The review runs in hoop, with one agent per role. Each reviewer comments on the document itself,
the owner answers in the threads, and the requester sees the whole discussion before approving.
Every agent preloads the shared skills `devloop:principles`, `devloop:review-comments` and
`devloop:writing`, so they all work by the same rules. How to comment in hoop is documented in
hoop's CLAUDE.md, in "Reviewing documents in hoop".

## 1. Roles

| Document | Owner (author agent) | Reviewers (agents) |
|---|---|---|
| PRD | `senior-product-manager` | `principal-product-manager`, `staff-engineer` |
| HLD | `staff-engineer` | `principal-engineer` |
| LLD | `senior-engineer` | `staff-engineer`, `engineer-l4` |

The owner writes the document and makes the final call on every comment. Write the document as the
owner agent, or in its role yourself. Each agent file in this plugin's `agents/` folder defines its
role.

## 2. Open the review in hoop

Submit the document linked to its change, as `/devloop:project-docs` describes. The command is
`hoop submit <file> --cr <CR> --doc <prd|hld|lld>`. Note the review ID. To review a revision of
an approved document, open a new review in two steps. Its first revision is the approved text, and
its second is the new one. Then the threads sit on what changed.

## 3. Cycle one: reviewers comment

Start every reviewer agent for the document at once, each in a fresh context. Give each one these
inputs:
- The review ID and the hoop address.
- The paths of the change's `REQUEST.md`, `NOTES.md` and approved documents above this one.
- The project's `docs/PRD.md`, `docs/HLD.md` and `docs/LLD.md`.
- The checks below. Reviewers also judge the work against `devloop:principles`.

Each reviewer posts its comments to hoop with the verdict "comment" and returns a one-line summary.
No reviewer approves; only the requester does.

## The checks reviewers apply

### Against the change's own chain

- **Coverage:** Every ask in `REQUEST.md`, and every requirement in the documents above, is
  covered. A PRD covers each ask with a requirement or names it as out of scope. An HLD gives each
  requirement a component. An LLD designs each component and tests each requirement.
- **Scope creep:** Nothing is added that the request and the documents above didn't ask for,
  unless it is named as an assumption for the reviewer to confirm.
- **Faithfulness:** The document doesn't narrow, widen or reword an ask so that it means something
  else. Quote the request where they differ.
- **Notes:** Each overlap decision in `NOTES.md` is respected (for example, work moved to another
  change stays out).

### Against the project's documents

- **Conflicts:** A new requirement, component or decision contradicts an existing one.
- **Silent changes:** The document changes settled behavior, an interface, a stored format or a
  decision without saying so. Each such change must be named, with the existing ID it changes.
- **Duplicates:** A new requirement or component repeats an existing one under a new name. Reuse
  the existing one instead.
- **Consistency:** Names, IDs, terms and component boundaries match the project's documents. A new
  ID doesn't clash with an existing one.

## 4. The owner answers

As the owner, read the comments with `hoop feedback <review_id>`. Answer every thread with
`hoop reply`: accept and change the document, decline with a reason, or ask. Submit document changes
as a new revision with `hoop submit <file> --review <review_id>`, or as tracked changes with
`hoop propose`. Check the writing again before each revision.

## 5. Cycle two, then the owner's call

Start each reviewer whose threads got an answer once more, with the review ID. It replies once on
each of its threads: agree, or say what still worries it. The owner answers again. After that, a
thread that still disagrees gets the owner's reply "Decision: <what and why>." The reviewer
disagrees and commits, and no third cycle runs.

## 6. Hand over to the requester

Tell the requester the review's address and a short summary: how many comments each reviewer made,
how many were accepted or declined, and each "Decision:". The requester reads the threads on the
document and approves, comments or requests changes. A requester's comment starts a new cycle with
the owner.
