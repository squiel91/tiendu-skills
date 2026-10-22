---
title: List support tickets
description: List a store's support tickets with optional status filtering and pagination.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/support-tickets
---

List support tickets for the store, ordered by most recently updated first and then by id descending.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/support-tickets?status=open&page=1&size=20' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: `1`. |
| `size` | Items per page, from 1 to 100. Default: `20`. |
| `status` | Optional exact status: `open`, `in_progress`, `waiting_on_merchant`, `resolved`, or `closed`. Omit to include every status. |

## Response

HTTP 200 returns a `data` array of [support ticket objects](object.md) without the `events` property, and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`.

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 422 | Invalid page, size, or status. |

See [Errors](../errors.md) for response examples and stable problem types.
