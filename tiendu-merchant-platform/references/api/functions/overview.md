---
title: Functions
description: Create, deploy, and observe store Functions through Merchant API v3.
---

Concepts and workflows: [Functions](../../functions/overview.md). For authentication, requests and errors, see [REST API](../overview.md).

## Operations

| Operation | Method | Path |
| --- | --- | --- |
| [List functions](list.md) | `GET` | `/functions` |
| [Create a function](create.md) | `POST` | `/functions` |
| [Get a function](get.md) | `GET` | `/functions/{functionId}` |
| [Update a function](update.md) | `PATCH` | `/functions/{functionId}` |
| [Delete a function](delete.md) | `DELETE` | `/functions/{functionId}` |

- [Function object](object.md)
- [Read and edit code](code.md)
- [Function secrets](secrets.md)
- [Function invocations](invocations.md)
- [Function logs](logs.md)

## API behavior

Secret values are write-only. Code mutations accept `expectedSha256` to prevent overwriting a concurrent edit.
