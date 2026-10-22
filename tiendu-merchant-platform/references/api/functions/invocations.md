---
title: Function invocations
description: Inspect recent Function executions.
---

`GET /functions/{functionId}/invocations` returns `{ "data": [...], "nextCursor": "..." }`. Pass `cursor` and `limit` (1–100) to continue through older records.

`GET /functions/{functionId}/invocations/{invocationId}` returns the captured request and response, including textual bodies as UTF-8 or binary bodies as base64. Retention is finite; an expired invocation is not found.
