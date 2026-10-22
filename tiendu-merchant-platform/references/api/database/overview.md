---
title: Store database
description: Query and write a store's SQLite database through Merchant API v3.
---

Concepts and workflows: [Store database](../../store-database/overview.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [Query](query.md) | `POST` | `/database/query` |
| [Schema](schema.md) | `POST` | `/database/schema` |
| [Execute](execute.md) | `POST` | `/database/execute` |

## API behavior

Send JSON with the same SQL input as the database tools; do not include a store id. Success returns `contentTrust`, `notice`, `results` and `durationMs`. SQL failures use `{ "code", "error" }`, plus `outcome` when relevant, rather than the shared Problem Details body. Authentication and JSON-parse errors still use Problem Details. See [SQL errors and limits](../../store-database/overview.md) before retrying an uncertain write.

| SQL error code | HTTP |
| --- | --- |
| `invalid-sql`, `not-authorized-statement` | 400 |
| `constraint`, `quota-exceeded` | 409 |
| `result-too-large` | 413 |
| `timeout` | 504 |
| `unavailable` | 503 |
