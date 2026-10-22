---
title: Function logs
description: Inspect captured console output and exceptions.
---

`GET /functions/{functionId}/logs` returns `{ "data": [...], "nextCursor": "..." }`. Use `cursor` and `limit` (1–100) for pagination, and optionally filter by `level` (`debug`, `log`, `info`, `warn`, `error`, or `exception`) or a text `query`.
