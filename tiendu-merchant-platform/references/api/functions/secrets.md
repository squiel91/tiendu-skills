---
title: Function secrets
description: Manage write-only secrets for a Function.
---

Use `/functions/{functionId}/secrets` to list secret metadata or create a secret. Use `/secrets/{secretId}` to rename, replace, or delete one.

```json
{ "name": "PARTNER_TOKEN", "value": "secret-value" }
```

Secret names use uppercase letters, numbers, and underscores and must start with a letter. List, create, and update responses return only `id`, `name`, `createdAt`, and `updatedAt`; the value is never returned. Updating or deleting a secret creates a new function runtime revision.

Secret creation returns HTTP 201 with a `Location` header. Secret updates and deletes return HTTP 200.
