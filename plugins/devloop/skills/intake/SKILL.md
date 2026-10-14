---
name: intake
description: Captures a new request as a change request in the requester's own words, classifies it, queues it, and resolves its overlaps with the other queued requests. It also captures bug reports. Use whenever the user gives a new request, change request or bug report ("capture this", "queue it", "new CR", "file this bug"), even mid-way through other work.
---

# Intake

Every request becomes a change request before any work on it starts.

Capture every request as a change request, in the requester's own words, and **queue** it. Use
`hoop cr create` (or `hoop_cr_create`). It writes `docs/changes/CR-<n>-<slug>/REQUEST.md` byte for
byte and adds the change to the tracker, as `/devloop:project-docs` describes.

Classify it as epic, story, task or bug, with a one-line reason. Read
`docs/changes/CLASSIFICATION.md` first. When the requester corrects a type, record it with
`hoop cr classify <CR> <type> --reason ... --why ...`, so later classifications learn from it.

A request that arrives while another change is in progress is queued, not folded in, unless the
requester says so.

Each time a request is queued, compare it with every other **queued** request. Look for the same
behavior, the same documents or files, conflicting goals, or one depending on another. Resolve each
overlap by merging, ordering, splitting or dropping a duplicate. Write the resolution into both
changes' notes and the tracker, and tell the requester what was decided, so they can change it.
In-progress changes aren't reopened. Note any dependency on them instead.

A bug report is captured the same way, with type bug. Its definition of done starts with a test
that reproduces the bug and fails before the fix.
