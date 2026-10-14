---
name: lld-review
description: Reviews a change's LLD in hoop with persona agents: a staff engineer for soundness and an engineer (L4) who checks it against today's code. It holds the LLD's standards and checks it against its PRD, HLD and the project's LLD. Use before a change's LLD goes to the requester, or for "review this LLD".
---

# LLD review

The owner is the `senior-engineer` agent. The reviewers are `staff-engineer` and `engineer-l4`. The staff engineer asks
whether it is sound and fits the HLD. The engineer (L4) checks every claim against today's code. Run the review as "Review in hoop with persona
agents" in `/devloop:project-docs` describes, and give each reviewer this skill.

## Standards for an LLD

- Per component: responsibility, data model with invariants, interfaces (signatures, endpoints,
  formats), behavior and algorithms with edge cases, errors and how they surface.
- Consistent with the HLD: same components, same interactions; anything new is a finding against
  the HLD.
- A **test plan** maps every requirement to tests at the right level (unit, integration,
  end to end), each with what it proves.

## Checks against the change request, the approved PRD and the approved HLD

- **Coverage:** Every HLD component and decision has a design, and every PRD requirement has a test.
- **Scope creep:** Nothing is built that the HLD and PRD don't call for, unless it is named.
- **Faithfulness:** The design keeps the HLD's components, boundaries and interfaces. A needed
  change to the HLD goes back to the HLD first.
- **Notes:** Each overlap decision in `NOTES.md` is respected.

## Checks against the project's LLD

- **Conflicts:** Nothing contradicts an existing component design or interface in the project's `docs/LLD.md`.
- **Silent changes:** Every change to settled behavior, an interface, a stored format or a decision
  is named, with the existing ID it changes.
- **Duplicates:** Nothing repeats an existing component design or interface under a new name. Reuse the existing one.
- **Consistency:** Names, IDs and terms match the project's documents, and new IDs don't clash.

## Checks against the code as it is today

The engineer (L4) makes these checks by reading the code.
- Every file, function, field, route and test the LLD names exists as described, or is marked new.
- Every claim about current behavior is true.
- The call sites and tests the change touches are all named.
- Every step can be built as written, in the order the pull request plan gives.
