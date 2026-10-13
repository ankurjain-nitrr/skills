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

Run it after `/devloop:vet-docs` (which checks the writing and the document's own level) and
before submitting the document through hoop. The writing rules in `/devloop:writing` apply to its
findings.

## 1. Gather the inputs

- The change folder: `docs/changes/CR-<n>-<slug>/` with `REQUEST.md`, `NOTES.md` and the approved
  documents above the one under review.
- The document under review.
- The project's `docs/PRD.md`, `docs/HLD.md` and `docs/LLD.md`, if they exist.

## 2. Review in a fresh context

Start a reviewer that didn't write the document, such as a subagent with only these files. Give it
the paths and the checks below, and ask for findings only, each with the line, the source it
conflicts with, and a fix. Don't let it edit files.

Give the reviewer its role, from `../project-docs/references/ROLES.md` in this plugin. An HLD is
reviewed as a principal engineer (L7), who asks whether it is the right design for the
organization. An LLD is reviewed as a staff engineer (L6), who asks whether it is sound, fits the
HLD and will hold up in use. Paste that role's section into the reviewer's prompt, together with
the checks below.

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

## 3. Resolve before review

Fix every finding in the draft, or keep the text and record why in the document's assumptions or
in the hoop submission note. Then submit through hoop as `/devloop:project-docs` describes. Tell the
human reviewer what the design review found and how each finding was resolved.

## 4. Report

List the findings by severity (must fix, should fix, consider). For each, give the line, the source
(the request, an approved document or a project document, with its ID), the problem and the fix.
End with "Design review: N findings, all resolved" or the ones left for the human to decide.
