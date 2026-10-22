---
title: Read and edit function code
description: Read bounded source ranges, search, patch, or replace Function code.
---

### Read code

`GET /functions/{functionId}/code` accepts `offset`, `limit`, and `numbered`. The response includes the file content, total lines, byte size, and current `sha256`.

### Search code

`GET /functions/{functionId}/code/search` accepts `query`, `mode` (`literal` or `regex`), optional `caseSensitive`, `wholeWord`, and `limit`. It returns file-style line matches.

### Patch code

`PATCH /functions/{functionId}/code` accepts `{ "patchText": "...", "expectedSha256": "..." }` with an exact single-file unified diff. The hash is optional but recommended.

### Replace code

`PUT /functions/{functionId}/code` accepts `{ "content": "...", "expectedSha256": "..." }`.

Both mutation endpoints validate the resulting source before activating it and return the new hash and runtime revision. A stale `expectedSha256` returns HTTP 409.
