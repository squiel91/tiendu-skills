---
title: List subscribers
description: Browse subscribers with numbered pages and optional filters.
api:
  method: GET
  path: https://tiendu.uy/api/v3/stores/{storeHandle}/subscribers
---

List the store's subscribers, sorted by `subscribedAt` descending, then `id` descending.

## Request

```bash
curl 'https://tiendu.uy/api/v3/stores/my-store/subscribers?page=1&size=20&enabled=true' \
  -H "Authorization: Bearer $TIENDU_API_KEY"
```

## Query parameters

| Name | Description |
| --- | --- |
| `page` | Page number, starting at 1. Default: 1. |
| `size` | Items per page, from 1 to 100. Default: 20. |
| `email` | Exact match on `email` (trimmed). |
| `enabled` | Filter by `isEnabled`. Use `true` or `false`. Omit to include both. |

## Response

HTTP 200 returns `data`, an array of [subscriber objects](object.md), and `pagination` with `page`, `size`, `totalItems`, and `totalPages`. An out-of-range page has empty `data` and retains the actual `totalItems`. Empty results have `totalPages: 0`.

The JSON is an example of a response.

```json
{
  "data": [
    {
      "id": 12,
      "email": "ada@example.com",
      "isEnabled": true,
      "subscribedAt": "2026-09-20T12:00:00.000Z",
      "verifiedAt": null,
      "unsubscribedAt": null,
      "unsubscribedReason": null
    }
  ],
  "pagination": {
    "page": 1,
    "size": 20,
    "totalItems": 1,
    "totalPages": 1
  }
}
```

## Errors

| HTTP status | Cause |
| --- | --- |
| 401 | Missing or invalid store API key. |
| 404 | Store handle is unavailable to this key. |
| 412 | Store subscription does not permit access. |
| 422 | Invalid page, size, or filter value. |

See [Errors](../errors.md) for response examples and stable problem types.
