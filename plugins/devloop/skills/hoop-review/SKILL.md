---
name: hoop-review
description: How to comment on a document under review in hoop, and how the owner answers those comments. It covers reading a review, posting anchored comments and replies, and answering, revising or recording a decision. Use when an agent reviews a document in hoop, or when the owner answers its comments.
---

# Comments in hoop

A document under review in hoop has a review ID and an address, by default
`http://localhost:4747/r/<review_id>`. Comments sit on the document's lines, and each comment
starts a thread.

## Read the review

- Fetch it with `curl -s http://localhost:${HOOP_PORT:-4747}/api/reviews/<review_id>`.
- Each item has an `id` and `lines`. A comment's `line` is the index in `lines` plus one.
- Line 0 is the item's heading. Item `DOC` line 1 is the title, and line 2 is the TL;DR.
- Earlier comments and their thread IDs are in `feedback`, and the owner's replies are in `replies`.

## Post comments as a reviewer

1. Write a JSON file that holds `{"verdict": "comment", "reviewer": "<your role> (agent)",
   "summary": "<one line>", "comments": [...]}`.
2. Each comment holds `item`, `line` and `body`. It may also hold a `range` (`start`, `end` and the
   exact `quote` at those offsets), or a `suggestion` with replacement text.
3. To reply in a thread, add the thread's `thread` ID, with its `item` and `line`.
4. Send the file with
   `curl -s -X POST http://localhost:${HOOP_PORT:-4747}/api/reviews/<review_id>/feedback -H 'content-type: application/json' --data @<file>`.
5. Always use the verdict "comment". Only the requester approves or requests changes.

## Answer comments as the owner

- Read them with `hoop feedback <review_id>`.
- Reply in a thread with `hoop reply <thread> "<role> (owner): <text>"`.
- Change the document with a new revision, `hoop submit <file> --review <review_id>`, or with a
  tracked change, `hoop propose <review_id> <thread> <edits.json>`.
- Record a final call as a reply that starts with "Decision:".
